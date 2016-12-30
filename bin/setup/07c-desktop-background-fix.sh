#!/bin/sh
# https://bugs.launchpad.net/ubuntu/+source/cinnamon/+bug/1581263

# Don't change background to default when plugging in a drive;
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
