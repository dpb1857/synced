#!/bin/bash

BASE=/media/dpb/Backup/Backup
EXCLUDES="--exclude=OneDrive/"

function do_backup_windows() {
    DIR=$1
    NAME=$2

    if [ ! -d $BASE/$NAME/current ]; then
        /bin/btrfs subvolume create $BASE/$NAME
        /bin/btrfs subvolume create $BASE/$NAME/current
        mkdir $BASE/$NAME/updates
    fi

    rsync -av ${EXCLUDES} --delete-after --delete-excluded $DIR/ $BASE/$NAME/current > /tmp/filelist.$$

    updates=`cat /tmp/filelist.$$ | sed '1d' | head -n -3 | grep -v '/$' | wc -l`

    if [ $updates -gt 0 ]; then
        backup_name="`date +%Y-%m-%dT%H:%M`"
        /bin/btrfs subvolume snapshot -r $BASE/$NAME/current $BASE/$NAME/$backup_name
        cp /tmp/filelist.$$ $BASE/$NAME/updates/$backup_name
        cat /tmp/filelist.$$
    fi

    rm -f /tmp/filelist.$$
}

echo $DIRS

if [ ! -d $BASE ]; then
    echo "Backup drive is not mounted" 1>&2
    exit 1
fi

if [ ! -d /media/dpb/WindowsC ]; then
    echo "WindowsC is not mounted" 1>&2
    exit 1
fi

if [ ! -d /media/dpb/WindowsD ]; then
    echo "WindowsD is not mounted" 1>&2
    exit 1
fi

start=`date`
do_backup_windows /media/dpb/WindowsC/Users/dpb windows
do_backup_windows /media/dpb/WindowsD/VideoProd videoprod

echo "Backup started:" $start
echo "Backup finished:" `date`
