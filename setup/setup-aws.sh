#!/bin/bash
#

# Let's use a git command that doesn't do host key checking to remove the user prompt
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

##################################################
# Base packages, dev user setup
##################################################

function init() {
    USER=$1
    apt-get update
    apt-get upgrade -y
    apt-get install -y make mg postgresql-client jq nfs-common awscli

    adduser ${USER}
    adduser ${USER} sudo
    bash -c "echo \"${USER} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/90-cloud-init-users"

    addgroup docker
    adduser ${USER} docker

    rsync -av /home/ubuntu/ /home/${USER}
    chown -R ${USER}:${USER} /home/${USER}

    # Setup packages so pyenv can build python
    apt-get install -y gcc
    apt-get install -y libbz2-dev zlib1g-dev liblzma-dev
    apt-get install -y libsqlite3-dev libgdbm-dev
    apt-get install -y libncurses-dev libreadline-dev uuid-dev libffi-dev libssl-dev
}

##################################################
# Docker setup
##################################################

function setup_docker() {
    if [ -f /etc/apt/keyrings/docker.gpg ]; then
        echo "Docker already installed"
        return
    fi
    # from https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
    # Add official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    # Setup repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Update and install
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

##################################################
# Pyenv for user
##################################################

function setup_pyenv() {
    if [ -d ~/.pyenv ]; then
        echo "pyenv already installed"
        return
    fi

    # install pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    (cd ~/.pyenv && src/configure && make -C src)

    # install versions 3.6.8, 3.10.7
    # pyenv install 3.6.8 # 3.6.8 pyenv install fails!
    export PATH="$HOME/.pyenv/bin:$PATH"
    pyenv install 3.10.7
}

##################################################
# Barb builds
##################################################

function barb_checkout() {
    if [ -d code/barb ]; then
        echo "barb already checked out"
        return
    fi
    git clone git@github.com:Synthego/barb.git code/barb
}

function barb_local() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi
    if ! command -v pyenv >/dev/null; then
       echo "pyenv not found; re-source .bashrc?"
       exit 1
    fi

    barb_checkout
    (cd $HOME/code/barb && pyenv local 3.10.7)
    (cd $HOME/code/barb && python -m venv venv)
    (cd $HOME/code/barb && venv/bin/pip install --upgrade pip)
    (cd $HOME/code/barb && venv/bin/pip install wheel)

    # Support for modules in python requirements
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libcurl4-openssl-dev libldap-dev libsasl2-dev

    (cd $HOME/code/barb && venv/bin/pip install -r requirements.txt)
}

##################################################
# Barb docker setup
##################################################

function barb_docker() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi

    barb_checkout
    (cd $HOME/code/barb && make build)
    (cd $HOME/code/barb && make dbrestore)
}

##################################################
# QCDucks local setup
##################################################

function qcducks_local() {
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
    (cd $HOME/code/qcducks && pyenv local 3.10.7)
    (cd $HOME/code/qcducks && python -m venv venv)
    (cd $HOME/code/qcducks && venv/bin/pip install --upgrade pip)
    (cd $HOME/code/qcducks && venv/bin/pip install wheel)

    # Support for modules in python requirements
    # sudo apt-get install libcurl4-openssl-dev libldap-dev libsasl2-dev
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pkgconf libpq-dev libcurl4-openssl-dev

    (cd $HOME/code/qcducks && venv/bin/pip install -r requirements.txt)
}

##################################################
# Special: don customizations
##################################################

function setup_dpb() {
    git clone git@github.com:dpb1857/synced
    if [ $? -ne 0 ]; then
      echo "You probably forgot to do 'ssh -A'"
      exit 1
    fi

    ./synced/setup/02-LinkDotFilesSynth.sh
    . .bashrc

    git config --global user.email "don.bennett@synhtego.com"
    git config --global user.name "Don Bennett"

    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y emacs
}

function setup_dpb_all() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      exit 1
    fi

    setup_docker
    setup_pyenv
    export PATH="$HOME/.pyenv/bin:$PATH"
    barb_local
    qcducks_local
    setup_dpb
}

function help() {
    echo "Subcommands:"
    echo "  docker"
    echo "  pyenv"
    echo "  barb_local"
    echo "  qcducks_local"
}

command=$1
shift
case $command in
    init) user=$1
        init $user
        ;;
    docker) setup_docker
        ;;
    pyenv) setup_pyenv
        ;;
    dpb) setup_dpb
        ;;
    dpb_all) setup_dpb_all
        ;;
    barb_local) barb_local
        ;;
    qcducks_local) qcducks_local
        ;;
    *) help
        ;;
esac
