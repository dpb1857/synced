#!/bin/sh

if [ -d $HOME/.config/google-chrome ]; then
    echo "kill running chrome processes"
    killall chrome
    sleep 5
    echo moving ~/.config/google-chrome to $HOME/Private and symlinking...
    set -x
    mv $HOME/.config/google-chrome $HOME/Private
    ln -s $HOME/Private/google-chrome $HOME/.config/google-chrome
fi
