#!/bin/sh

BASE=/media/dpb/Backup
NAME=PhotoArchive

if [ ! -d $BASE ]; then
    echo "Backup drive not mounted." 1>&2
    exit 1
fi

if [ ! -d /media/dpb/PhotoArchive ]; then
    echo "PhotoArchive drive not mounted." 1>&2
    exit 1
fi

start=`date`

if [ ! -d $BASE/$NAME/current ]; then
    /bin/btrfs subvolume create $BASE/$NAME
    /bin/btrfs subvolume create $BASE/$NAME/current
    mkdir $BASE/$NAME/updates
fi

echo "rsync started:" `date`
rsync -av --delete-after /media/dpb/PhotoArchive/ $BASE/$NAME/current > /tmp/filelist.$$
echo "rsync complete:" `date`
updates=`cat /tmp/filelist.$$ | sed '1d' | head -n -3 | grep -v '/$' | wc -l`

if [ $updates -gt 0 ]; then
    backup_name="`date +%Y-%m-%dT%H:%M`"
    /bin/btrfs subvolume snapshot -r $BASE/$NAME/current $BASE/$NAME/$backup_name
    echo "subvolume creation complete:" `date`
    cp /tmp/filelist.$$ $BASE/$NAME/updates/$backup_name
    cat /tmp/filelist.$$
fi

rm -f /tmp/filelist.$$

echo "Backup started:" $start
echo "Backup finished:" `date`
