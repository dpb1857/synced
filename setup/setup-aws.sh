#!/bin/bash
#
##################################################
# SYSTEM:
##################################################

function init() {
    USER=$1
    echo CMD: init $USER
    return

    apt-get update
    apt-get upgrade -y
    apt-get install -y make mg postgresql-client jq nfs-common

    ##################################################
    # SYSTEM: generic user setup (as root)
    ##################################################

    adduser ${USER}
    adduser ${USER} sudo
    bash -c "echo \"${USER} ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/90-cloud-init-users"

    rsync -av /home/ubuntu/ /home/${USER}
    chown -R ${USER}:${USER} /home/${USER}

    # Setup packages so pyenv can build python
    apt-get install -y gcc
    apt-get install -y libbz2-dev zlib1g-dev liblzma-dev
    apt-get install -y libsqlite3-dev libgdbm-dev
    apt-get install -y libncurses-dev libreadline-dev uuid-dev libffi-dev libssl-dev
}

##################################################
# SYSTEM: generic user local python setup
##################################################

function pyenv() {
    # install pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    (cd ~/.pyenv && src/configure && make -C src)
    . .bashrc

    # install versions 3.6.8, 3.10.7
    # pyenv install 3.6.8 # 3.6.8 pyenv install fails!
    pyenv install 3.10.7
}

##################################################
# SYSTEM: don customizations (as ${USER})
##################################################

function dpb() {
    git clone git@github.com:dpb1857/synced
    if [ $? -ne 0 ]; then
      echo "You probably forgot to do 'ssh -A'"
      sleep 10
      exit 1
    fi

    ./synced/setup/02-LinkDotFilesSynth.sh
    . .bashrc

    git config --global user.email "don.bennett@synhtego.com"
    git config --global user.name "Don Bennett"

    sudo apt-get install -y emacs
}

##################################################
# Barb local setup
##################################################

function barb_local() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      sleep 10
      exit 1
    fi

    git clone git@github.com:Synthego/barb.git code/barb
    (cd $HOME/code/barb && pyenv local 3.10.7)
    (cd $HOME/code/barb && python -m venv venv)
    (cd $HOME/code/barb && venv/bin/pip install --upgrade pip)

    # Support for modules in python requirements
    sudo apt-get install -y libcurl4-openssl-dev libldap-dev libsasl2-dev

    (cd $HOME/code/barb && venv/bin/pip install -r requirements.txt)
}

##################################################
# QCDucks local setup
##################################################

function qcducks_local() {
    if [ "$GEMFURY_USERNAME" = "" ]; then
      echo "must have GEMFURY_USERNAME set"
      sleep 10
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
    sudo apt-get install -y pkgconf libpq-dev libcurl4-openssl-dev

    (cd $HOME/code/qcducks && venv/bin/pip install -r requirements.txt)
}

function help() {
    echo "Subcommands:"
    echo "  init <user>"
    echo "  pyenv"
    echo "  barb_local"
    echo "  qcducks_local"
}

command=$1
shift
case $command in
    init) user=$1
        ;;
    pyenv)
        pyenv
        ;;
    dpb) dpb
        ;;
    barb_local) barb_local
        ;;
    qcducks_local) qcducks_local
        ;;
    *) help
        ;;
esac
