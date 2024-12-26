#!/bin/bash


if [ ! -d $HOME/enc ]; then
    echo "Must mount enc directory to restore ssh keys." 1>&2
    exit 1
fi

host=`hostname -s`
user=`whoami`

if [ -d $HOME/enc/ssh/$host-$user ]; then
    keydir="$HOME/enc/ssh/$host-$user"
elif [ -d $HOME/enc/ssh/$host ]; then
    keydir="$HOME/enc/ssh/$host"
else
    keydir="$HOME/enc/ssh/unknown"
    echo "No directory of authorized keys for machine $host with user $user..." 1>&2
fi

if [ -d $keydir/dot-ssh ]; then
    if [ ! -d $HOME/.ssh ]; then
        mkdir $HOME/.ssh
    fi
    echo "Restoring saved ssh user keys from $keydir..." 1>&2
    cp -p $keydir/dot-ssh/* $HOME/.ssh
fi
