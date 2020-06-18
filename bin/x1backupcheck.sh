#!/bin/bash

BASE=/media/dpb/Backup/Backup
DIRS=$(cat $HOME/synced/conf/backup-directories.txt)
EXCLUDES="--exclude=.mypy_cache/ --exclude=.pytest_cache/ --exclude=__pycache__"

function check_backup() {
    NAME=$1
    rsync -av -n ${EXCLUDES} --delete-after --delete-excluded /space/$NAME/ $BASE/$NAME/current | sed '1d' | head -n -3 | grep -v '/$'
}

if [ ! -d $BASE ]; then
    echo "Backup drive is not mounted" 1>&2
    exit 1
fi

for dir in $DIRS; do
    echo Backing up $dir
    check_backup $dir
done
