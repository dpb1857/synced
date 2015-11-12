#!/bin/bash

if [ ! -d $HOME/Private ]; then
    echo "Must create ~/Private directory before restoring boto keys." 1>&2
    exit 1
fi

if [ ! -w $HOME/Private ]; then
    echo "$HOME/Private is not writable, try logging out and logging back in." 1>&2
    exit 1
fi

if [ ! -d $HOME/enc ]; then
    echo "Must mount enc directory to restore boto keys." 1>&2
    exit 1
fi

host=`hostname -s`
user=`whoami`

if [ -d $HOME/enc/aws ]; then
    keydir="$HOME/enc/aws"
else
    keydir="$HOME/enc/ssh/unknown"
    echo "No saved aws keyinfo..." 1>&2
fi

# if ~/Private/dot-boto does not exist, create it;
if [ ! -f $HOME/Private/dot-boto ]; then
    echo "Creating ~/Private/dot-boto..." 1>&2
    cp $keydir/dot-boto $HOME/Private/dot-boto
fi

# Make ~/.boto a symlink to ~/Private/dot-boto
echo "Making ~/.boto a symlink to ~/Private/dot-boto" 1>&2
ln -s $HOME/Private/dot-boto $HOME/.boto
