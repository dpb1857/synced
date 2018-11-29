#!/bin/sh
set -x
BASE=/media/dpb/Backup
NAME=PhotoArchive

if [ ! -d $BASE/$NAME/current ]; then
    /bin/btrfs subvolume create $BASE/$NAME
    /bin/btrfs subvolume create $BASE/$NAME/current
    mkdir $BASE/$NAME/updates
fi

rsync -av -n --delete-after /media/dpb/PhotoArchive/ $BASE/$NAME/current > /tmp/filelist.$$
updates=`cat /tmp/filelist.$$ | sed '1d' | head -n -3 | grep -v '/$' | wc -l`

if [ $updates -gt 0 ]; then
    backup_name="`date +%Y-%m-%dT%H:%M`"
    /bin/btrfs subvolume snapshot -r $BASE/$NAME/current $BASE/$NAME/$backup_name
    cp /tmp/filelist.$$ $BASE/$NAME/updates/$backup_name
    cat /tmp/filelist.$$
fi

rm -f /tmp/filelist.$$
