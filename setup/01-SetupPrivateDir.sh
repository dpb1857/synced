#!/bin/bash

if [ ! -d $HOME/Private -a ! -d $HOME/.Private ]; then
    ecryptfs-setup-private
    echo "You will need to logout and re-login for your Private directory to be mounted..."
else
    echo 'It looks like you have already created $HOME/Private and/or $HOME/.Private.' 1>&2
fi
