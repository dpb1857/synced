#!/bin/bash

BASE=/media/dpb/Backup/Backup
DIRS=$(cat $HOME/synced/conf/backup-directories.txt)
EXCLUDES="--exclude=.mypy_cache/ --exclude=.pytest_cache/ --exclude=__pycache__"

function do_backup() {
    NAME=$1
    for dir in /mnt /mnt/space; do
        if [ -d $dir/$NAME ]; then
            SRCDIR=$dir
        fi
    done

    if [ "$SRCDIR" = "" ]; then
        echo "Cannot find backup target $NAME" 1>&2
        exit 1
    fi

    echo $NAME located in $SRCDIR/$NAME

    if [ ! -d $BASE/$NAME/current ]; then
        /bin/btrfs subvolume create $BASE/$NAME
        /bin/btrfs subvolume create $BASE/$NAME/current
        mkdir $BASE/$NAME/updates
    fi

    rsync -av ${EXCLUDES} --delete-after --delete-excluded $SRCDIR/$NAME/ $BASE/$NAME/current > /tmp/filelist.$$

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

start=`date`
for dir in $DIRS; do
    echo Backing up $dir
    do_backup $dir
done

echo "Backup started:" $start
echo "Backup finished:" `date`
