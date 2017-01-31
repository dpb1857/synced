#!/bin/bash

BASE=/media/dpb/Backup

function do_backup() {
    NAME=$1

    if [ ! -d $BASE/$NAME/current ]; then
        /bin/btrfs subvolume create $BASE/$NAME
        /bin/btrfs subvolume create $BASE/$NAME/current
        mkdir $BASE/$NAME/updates
    fi

    rsync -av --delete-after /space/$NAME/ $BASE/$NAME/current > /tmp/filelist.$$

    updates=`cat /tmp/filelist.$$ | sed '1d' | head -n -3 | grep -v '/$' | wc -l`

    if [ $updates -gt 0 ]; then
        backup_name="`date +%Y-%m-%dT%H:%M`"
        /bin/btrfs subvolume snapshot -r $BASE/$NAME/current $BASE/$NAME/$backup_name
        cp /tmp/filelist.$$ $BASE/$NAME/updates/$backup_name
        cat /tmp/filelist.$$
    fi

    rm -f /tmp/filelist.$$
}

DIRS="digikam
      docker
      goprojects
      imports
      linked-dirs
      refile
      repos
      SanDisk32
      vc
"

if [ ! -d $BASE ]; then
    echo "Backup drive is not mounted" 1>&2
    exit 1
fi

for dir in $DIRS; do
    echo Backing up $dir
    do_backup $dir
done
