#!/bin/bash

BASE=/media/dpb/Backup/Backup
DIRS=$(cat $HOME/synced/conf/backup-directories.txt)
EXCLUDES="--exclude=.mypy_cache/ --exclude=.pytest_cache/ --exclude=__pycache__"

function check_backup() {
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

    rsync -av -n ${EXCLUDES} --delete-after --delete-excluded $SRCDIR/$NAME/ $BASE/$NAME/current | sed '1d' | head -n -3 | grep -v '/$'
}

if [ ! -d $BASE ]; then
    echo "Backup drive is not mounted" 1>&2
    exit 1
fi

for dir in $DIRS; do
    echo Backing up $dir
    check_backup $dir
done
