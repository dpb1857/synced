#!/bin/bash

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

subsystem_pyenv
