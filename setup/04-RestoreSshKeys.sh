#!/bin/bash

host=`hostname -s`
user=`whoami`

if [ $host = "nas" -o $host = "castle" ]; then
    echo "Server warning:" 1>&2
    echo "Don't install ssh keys on a server." 1>&2
    echo "We can't have .ssh be a symlink into Private, else passwordless login can't work!" 1>&2
    SERVER=1
else
    SERVER=0
fi

if [ ! -d $HOME/Private -a $SERVER -eq 0 ]; then
    echo "Must create ~/Private directory before restoring ssh keys." 1>&2
    exit 1
fi

if [ ! -w $HOME/Private -a $SERVER -eq 0 ]; then
    echo "$HOME/Private is not writable, try logging out and logging back in." 1>&2
    exit 1
fi

if [ ! -d $HOME/enc ]; then
    echo "Must mount enc directory to restore ssh keys." 1>&2
    exit 1
fi

if [ -d $HOME/enc/ssh/$host-$user ]; then
    keydir="$HOME/enc/ssh/$host-$user"
elif [ -d $HOME/enc/ssh/$host ]; then
    keydir="$HOME/enc/ssh/$host"
else
    keydir="$HOME/enc/ssh/unknown"
    echo "No saved ssh keys for machine $host with user $user..." 1>&2
fi

if [ $SERVER -eq 0 ]; then

    # If ~/.ssh is a symlink, remove it to simplify things;
    if [ -h $HOME/.ssh ]; then
        echo "Removing old ~/.ssh symlink..." 1>&2
        rm $HOME/.ssh
    fi

    # Move ~/.ssh to ~/Private and restore user ssh keys.
    if [ -d $HOME/.ssh -a -d $HOME/Private/dot-ssh ]; then
        echo "Confusion: Both ~/.ssh and ~/Private/dot-ssh exist. Please resolve." 1>&2
        exit 1
    fi

    # if ~/Private/dot-ssh does not exist, create it;
    if [ ! -d $HOME/Private/dot-ssh ]; then
        echo "Creating ~/Private/dot-ssh..." 1>&2
        rm -f $HOME/Private/dot-ssh
        mkdir $HOME/Private/dot-ssh
    fi

    # If ~/.ssh exists, move its contents to into ~/Private/dot-ssh and remove.
    if [ -d $HOME/.ssh ]; then
        echo "Saving contents of ~/.ssh..." 1>&2
        mv $HOME/.ssh/* $HOME/Private/dot-ssh 2>/dev/null
        rmdir $HOME/.ssh
    fi

    # Make ~/.ssh a symlink to ~/Private/dot-ssh
    echo "Making ~/.ssh a symlink to ~/Private/dot-ssh" 1>&2
    ln -s $HOME/Private/dot-ssh $HOME/.ssh

    if [ -d $keydir/dot-ssh ]; then
        echo "Restoring saved ssh user keys from $keydir..." 1>&2
        cp -p $keydir/dot-ssh/* $HOME/Private/dot-ssh
        chmod 600 $HOME/Private/dot-ssh/id_rsa
    fi
fi

if [ $SERVER -eq 1 ]; then
    echo "Restoring authorized_keys..." 1>&2
    cp -p $keydir/dot-ssh/authorized* $HOME/.ssh
    chmod 600 $HOME/.ssh/authorized*
fi

if [ -d $keydir/etc-ssh ]; then
    echo "Restoring system ssh host keys..." 1>&2
    sudo cp -p $HOME/enc/ssh/$host/etc-ssh/* /etc/ssh
    sudo chmod 600 /etc/ssh/*key
fi

if [ -d $keydir/dot-ssh-root ]; then
    echo "Restoring root ssh user keys..." 1>&2
    if [ ! -d /root/.ssh ]; then
        sudo mkdir /root/.ssh
    fi
    sudo cp -p $keydir/dot-ssh-root/* /root/.ssh
    sudo sh -c 'chown root:root /root/.ssh/*'
    sudo sh -c 'chmod 600 /root/.ssh/id_*'
fi
