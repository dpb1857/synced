#!/bin/sh

NAME=$1

if [ ! -d /backup/$NAME/current ]; then
    btrfs subvolume create /backup/$NAME
    btrfs subvolume create /backup/$NAME/current
fi

rsync -av --delete-after /srv/$NAME/ /backup/$NAME/current > /tmp/filelist.$$

updates=`cat /tmp/filelist.$$ | sed '1d' | head -n -3 | grep -v '/$' | wc -l`

if [ $updates -gt 0 ]; then
    backup_name="/backup/$NAME/`date +%Y-%m-%dT%H:%M`"
    btrfs subvolume snapshot -r /backup/$NAME/current $backup_name
fi

rm -f /tmp/filelist.$$
