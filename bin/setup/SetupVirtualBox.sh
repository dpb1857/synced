#!/bin/sh

if [ -h $HOME/.VirtualBox -a -h $HOME/VirtualBox\ VMs ]; then
    exit 0
fi

if [ ! -d /home/vbox/dot-VirtualBox ]; then
    echo "cannot find /home/vbox/dot-VirtualBox directory." 1>&2
    exit 1
fi

if [ ! -d /home/scratch/VirtualBox\ VMs ]; then
    echo "cannot find /home/vbox/dot-VirtualBox directory." 1>&2
    exit 1
fi

set -x
cd $HOME
rm -rf .VirtualBox
ln -s /home/vbox/dot-VirtualBox .VirtualBox
rm -rf 'VirtualBox VMs'
ln -s '/home/scratch/VirtualBox VMs' 'VirtualBox VMs'
set +x

