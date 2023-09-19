#!/bin/bash

# Execute command on remote host
function remote() {
    user=$1
    cmd=$2
    msg=$3

    echo ${msg}
    ssh -t ${user}@${ip} aws-setup $cmd
}

# Install/Update script on remote host
function update_remote() {
    scriptname=$(basename ${scriptpath})
    echo "# Upload setup script & settings to remote"
    rsync -a ${scriptpath} ~/.awsdev_config ubuntu@${ip}:~
    ssh ubuntu@${ip} sudo mv ${scriptname} /usr/local/bin/aws-setup
}

# Install some base software on the remote host, configure
function machine_init() {
    echo "## Update system"
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

    echo "## Install additinal packages"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make mg postgresql-client jq nfs-common awscli

    # Set the locale
    echo "## Set system locale"
    sudo update-locale LANG=en_US.UTF-8

    # Install vault
    echo "## Install vault"
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo DEBIAN_FRONTEND=noninteractive apt update && sudo apt install -y vault
}

# Create a user on the remote host
function add_user() {
    USER=$1
    if [ -z "${USER}" ]; then
        echo "username unspecified."
        exit 1
    fi
    echo "## Creating user..."
    sudo adduser ${USER}
    echo "## Adding user to sudo group..."
    sudo adduser ${USER} sudo
    sudo bash -c "echo \"${USER} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/90-cloud-init-users"

    # Just in case we decide to use docker...
    echo "## Adding user to docker group..."
    sudo addgroup docker
    sudo adduser ${USER} docker

    # Copy the ubuntu user pub key into our new user
    echo "## Copy ubuntu authorized keys to ${USER}..."
    sudo mkdir /home/${USER}/.ssh
    sudo rsync -a /home/ubuntu/.ssh/authorized_keys /home/${USER}/.ssh
    sudo chown -R ${USER}:${USER} /home/${USER}/.ssh

    # Copy our awsdev_config to the new user
    echo "## Copy .awsdev_config to ${USER}..."
    sudo cp /home/ubuntu/.awsdev_config /home/${USER}/.awsdev_config
    sudo chown ${USER}:${USER} /home/${USER}/.awsdev_config
}

# As the new remote user, do some user setup
function setup_user() {
    # Logged in as the user, complete setup

    # Configure git user settings
    git config --global --add user.name "$gitusername"
    git config --global --add user.email "$gitemail"

    # Configure global gitignore
    echo "## Configure global gitignore for user..."
    mkdir -p ~/.config/git
    curl -s \
      https://raw.githubusercontent.com/github/gitignore/master/{Global/JetBrains,Global/Vim,Global/VisualStudioCode,Global/macOS,Python,Terraform}.gitignore \
      > ~/.config/git/ignore

    # Source gemfury tokens from .bashrc
    echo "## Add .bashrc line to source gemfury tokens"
    echo ". $HOME/.gemfury" >> $HOME/.bashrc

}

# Clone jormungand
function clone_jormungand() {
    # Checkout & configure jormungand
    # See https://synthego.atlassian.net/wiki/spaces/CS/pages/721617002/Coding+environment+setup#Vault

    if [ ! -d $HOME/code/jormungand ]; then
        echo "## Checkout jormungand"
        mkdir -p $HOME/code  # Or create a symlink to your favorite alternative location
        export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
        git clone git@github.com:Synthego/ansible-common.git $HOME/code/jormungand  # Rename in progress

        # run_commands_file="$HOME/.$(basename $(ps -p $$ -oargs= | sed s/-//))rc"
        run_commands_file=.bashrc
        echo >> $run_commands_file
        echo '. ~/code/jormungand/shell_includes.sh' >> $run_commands_file

        # Load them here the first time
        . ~/code/jormungand/shell_includes.sh
    fi
}

# Install pyenv
function subsystem_pyenv() {
    if [ -d ~/.pyenv ]; then
        echo "pyenv already installed"
        exit 1
    fi

    # Setup packages so pyenv can build python
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gcc \
        libbz2-dev zlib1g-dev liblzma-dev \
        libsqlite3-dev libgdbm-dev \
        libncurses-dev libreadline-dev uuid-dev libffi-dev libssl-dev

    # To be able to build the tkinter module
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tk-dev

    # install pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    (cd ~/.pyenv && src/configure && make -C src)

    export PATH="$HOME/.pyenv/bin:$PATH"
    pyenv install 3.11.5
}

# Install qcducks
function subsystem_qcducks() {
    . ~/.gemfury
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi
    if ! command -v pyenv >/dev/null; then
       echo "pyenv not found; re-source .bashrc?"
       exit 1
    fi

    git clone git@github.com:Synthego/qcducks.git code/qcducks
    (cd code/qcducks && git checkout -b requirements origin/don-update-requirements)
    (cd $HOME/code/qcducks && pyenv local 3.10.8)
    (cd $HOME/code/qcducks && python -m venv venv)
    (cd $HOME/code/qcducks && venv/bin/pip install --upgrade pip)
    (cd $HOME/code/qcducks && venv/bin/pip install wheel)

    # Support for modules in python requirements
    # sudo apt-get install libcurl4-openssl-dev libldap-dev libsasl2-dev
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pkgconf libpq-dev libcurl4-openssl-dev

    (cd $HOME/code/qcducks && venv/bin/pip install -r requirements.txt)
}

# docker
function subsystem_docker() {
    if [ -f /etc/apt/keyrings/docker.gpg ]; then
        echo "Docker already installed"
        return
    fi

    # from https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
    # Add official GPG key
    # sudo mkdir -p /etc/apt/keyrings  # needed on 20.04
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Setup repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update and install
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Barb docker dev needs vault command line tool
    # wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
    # echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    # sudo apt update && sudo apt install vault
}

function subsystem_barb_docker() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi

    if [ ! -d $HOME/.envs ]; then
        mkdir $HOME/.envs
    fi
    if [ ! -d $HOME/code/barb ]; then
        echo "## Clone barb repo..."
        git clone git@github.com:Synthego/barb.git code/barb
    fi
    echo "## Vault login..."
    vault login -method=aws role=developer  # vlogin
    echo "## Barb 'make build'..."
    (cd $HOME/code/barb && make build)

    echo "*** Need a database? This takes a long time to setup... ***"
    read -p "Restore db snapshot? (y/N) " response
    if [ "$response" = "y" -o "$response" = "Y" ]; then
       (cd $HOME/code/barb && make dbsync)
    fi
}

function subsystem_barb_bare() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi
    if ! command -v pyenv >/dev/null; then
       echo "pyenv not found; re-source .bashrc?"
       exit 1
    fi

    if [ ! -d $HOME/code/barb ]; then
        echo "## Clone barb repo..."
        git clone git@github.com:Synthego/barb.git $HOME/code/barb
    fi
    (cd $HOME/code/barb && pyenv local 3.10.8)
    (cd $HOME/code/barb && python -m venv venv)
    (cd $HOME/code/barb && venv/bin/pip install --upgrade pip)
    (cd $HOME/code/barb && venv/bin/pip install wheel)

    # Support for modules in python requirements
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libcurl4-openssl-dev libldap-dev libsasl2-dev
    (cd $HOME/code/barb && venv/bin/pip install -r requirements.txt)
}

# Install desktop
function subsystem_desktop() {
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y cinnamon # cinnamon-desktop-environment
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fonts-dejavu-core # don uses in emacs

    # Disable lightdm, install nx (from nomachine)
    sudo systemctl stop lightdm
    sudo systemctl disable lightdm
    file=nomachine_8.8.1_1_amd64.deb
    (cd /tmp && wget https://download.nomachine.com/download/8.1/Linux/$file)
    sudo dpkg -i /tmp/$file

    # Install Chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install google-chrome-stable

    echo "*** Need to reboot to enable remote desktop login with nx ***"
    read -p "Reboot now? (Y/n) " response
    if [ -z "$response" -o "$response" = "Y" ]; then
        echo "rebooting now"
        sudo reboot
    fi
}

######################################################################
# Functions to query for info we need to setup the remove machine
######################################################################

function load_awsdev_config() {
    if [ -f $HOME/.awsdev_config ]; then
        . $HOME/.awsdev_config
    fi
}

function save_awsdev_config() {
    echo "ip=\"${ip}\"" > $HOME/.awsdev_config
    echo "username=\"${username}\"" >> $HOME/.awsdev_config
    echo "sshkeys=\"${sshkeys}\"" >> $HOME/.awsdev_config
    echo "gemfury_tokens=\"${gemfury_tokens}\"" >> $HOME/.awsdev_config
    echo "gitusername=\"${gitusername}\"" >> $HOME/.awsdev_config
    echo "gitemail=\"${gitemail}\"" >> $HOME/.awsdev_config
}

function get_ip() {
    read -p "IP address of remote host? (${ip}) " new_ip
    if [ ! -z ${new_ip} ]; then
        ip=${new_ip}
    fi

    echo "checking for ssh listener at ${ip}..."
    if command -v nc >/dev/null && ! nc ${ip} 22 -z -w 2; then
        echo "No ssh listener at ip address ${ip}" 1>&2
        exit 1
    fi

    echo "checking our ssh login at ${ip}..."
    homedir=$(ssh $ip -l ubuntu pwd)
    if [ $? -ne 0 -o "${homedir}" != "/home/ubuntu" ]; then
        echo "could not connect to remote host at ${ip}" 1>&2
        exit 1
    fi

    save_awsdev_config
}

function get_username() {
    if [ -z "${username}" ]; then
        username=`whoami`
    fi
    read -p "Username to create on remote host? (${username}) " new_username
    if [ ! -z ${new_username} ]; then
        username=${new_username}
    fi

    save_awsdev_config
}

function get_sshkeys_dir() {
    if [ -z "$sshkeys" ]; then
        sshkeys="$HOME/.ssh"
    fi
    read -p "dirname with id_rsa, id_rsa.pub to push to remote host? (${sshkeys}) " new_sshkeys
    if [ ! -z ${new_sshkeys} ]; then
        sshkeys=${new_sshkeys}
    fi

    if [ ! -d ${sshkeys} -o ! -f ${sshkeys}/id_rsa ]; then
        echo "sshkeys directory ${sshkeys} not found" 1>&2
        exit 2
    fi

    save_awsdev_config
}

function get_gemfury_tokens() {
    if [ -z "${gemfury_tokens}" ]; then
        gemfury_tokens="$HOME/.gemfury"
    fi
    read -p "Gemfury tokens file? (${gemfury_tokens}) " new_gemfury_tokens
    if [ ! -z ${new_gemfury_tokens} ]; then
        gemfury_tokens=${new_gemfury_tokens}
    fi

    if [ ! -f ${gemfury_tokens} ]; then
        echo "Gemfury tokens file \"${gemfury_tokens}\" not found" 1>&2
        exit 3
    fi

    save_awsdev_config
}

function get_gitusername() {
    if [ -z "${gitusername}" ]; then
        gitusername=$(git config --get user.name)
    fi

    read -p "Git user fullname to create on remote host? (${gitusername}) " new_gitusername
    if [ ! -z "${new_gitusername}" ]; then
        gitusername="${new_gitusername}"
    fi

    save_awsdev_config
}

function get_gitemail() {
    if [ -z "${gitemail}" ]; then
        gitemail=$(git config --get user.email)
    fi
    read -p "Git email to create on remote host? (${gitemail}) " new_gitemail
    if [ ! -z ${new_gitemail} ]; then
        gitemail=${new_gitemail}
    fi

    save_awsdev_config
}

function confirm() {
    echo "### Confirm creation parameters ###"
    echo "Host: ${ip}"
    echo "Username: ${username}"
    echo "ssh keys copied from ${sshkeys}"
    echo "gemfury tokens in file ${gemfury_tokens}"
    echo "git user name: ${gitusername}"
    echo "git email: ${gitemail}"
    read -p "Continue? (Y/n) " confirm
    if [ "$confirm" = "n" -o "$confirm" = "no" ]; then
        exit 4
    fi
}

function main() {
    load_awsdev_config
    get_ip
    get_username
    get_sshkeys_dir
    get_gemfury_tokens
    get_gitusername
    get_gitemail
    confirm

    update_remote
    remote ubuntu machine_init '# Running machine_init on remote host:'
    remote ubuntu add_user '# Running adduser on remote host:'
    echo '# Pushing credentials & setup script to remote user:'
    set -x
    rsync -a $HOME/.aws/ ${username}@${ip}:~/.aws
    rsync -a ${sshkeys}/ ${username}@${ip}:~/.ssh
    rsync -a ${gemfury_tokens} ${username}@${ip}:~/.gemfury
    set +x

    remote ${username} setup_user '# Run setup user command:'
    remote ${username} clone_jormungand '# Cloning jormungand on remote host:'
    remote ${username} docker '# Installing docker on remote host:'
    remote ${username} barb-docker '# Installing barb docker environment:'
    remote ${username} pyenv '# Installing pyenv:'
    remote ${username} barb-bare '# Installing local pyenv for barb:'

    echo '# Finished inital setup, login and run "aws-setup help" for more options'
}

scriptpath=$(readlink -f -- "$0")

if [ $# -eq 0 -a ! -f /var/log/cloud-init.log ]; then
    # on the local dev machine
    main
    exit 0
fi

# On the target aws host

# bashrc settings that don't get set in a non-interactive shell
. ~/.gemfury
export VAULT_ADDR=https://vault.synthego.at
export PATH="$HOME/.pyenv/bin:$PATH"


help() {
    echo "Subcommands:"
    echo "  pyenv"
    echo "  qcducks"
    echo "  desktop"
    echo "  docker"
    echo "  barb-bare"
    echo "  barb-docker"
}

case $1 in
    update)
        load_awsdev_config
        update_remote
        ;;
    machine_init)
        machine_init
        ;;
    add_user)
        load_awsdev_config
        add_user ${username}
        setup_user
        ;;
    setup_user)
        load_awsdev_config
        setup_user
        ;;
    clone_jormungand)
        clone_jormungand
        ;;
    pyenv)
        subsystem_pyenv
        ;;
    qcducks)
        subsystem_qcducks
        ;;
    desktop)
        subsystem_desktop
        ;;
    docker)
        subsystem_docker
        ;;
    barb-bare)
        subsystem_barb_bare
        ;;
    barb-docker)
        subsystem_barb_docker
        ;;
    *)
        help
        ;;
esac
