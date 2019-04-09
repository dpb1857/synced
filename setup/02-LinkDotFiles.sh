#!/bin/bash

if [ -f $HOME/synced/dot-files/dot-emacs -a ! -h $HOME/.emacs ]; then
    set -x
    ln -s $HOME/synced/dot-files/dot-emacs $HOME/.emacs
    set +x
fi

if [ ! -f $HOME/.gitconfig -a -f $HOME/synced/dot-files/dot-gitconfig ]; then
    set -x
    ln -s $HOME/synced/dot-files/dot-gitconfig $HOME/.gitconfig
    set +x
fi

if [ ! -f $HOME/.lein/profiles.clj -a -f $HOME/synced/dot-files/dot-lein-profiles.clj ]; then
    set -x
    mkdir -p $HOME/.lein
    ln -s $HOME/synced/dot-files/dot-lein-profiles.clj $HOME/.lein/profiles.clj
    set +x
fi

if [ -f $HOME/synced/dot-files/dot-bashrc-dpb ] && ! grep dot-bashrc $HOME/.bashrc>/dev/null 2>&1; then
    echo "Hooking dot-bashrc-dpb into .bashrc..." 1>&2
    echo ". $HOME/synced/dot-files/dot-bashrc-dpb" >> $HOME/.bashrc
fi

if [ -f $HOME/synced/dot-files/dot-profile-dpb ] && ! grep dot-profile-dpb $HOME/.profile>/dev/null 2>&1; then
    echo "Hooking dot-profile-dpb into .profile..." 1>&2
    echo ". $HOME/synced/dot-files/dot-profile-dpb" >> $HOME/.profile
fi
