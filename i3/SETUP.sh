#!/bin/bash

mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/mpv
ln -s $HOME/synced/i3/config $HOME/.config/i3/config
ln -s $HOME/synced/i3/i3status.conf $HOME/.i3status.conf
ln -s $HOME/synced/i3/mpv-config $HOME/.config/mpv/config

cp dot-xscreensaver $HOME/.xscreensaver
