#!/bin/bash

BASE=/media/dpb/Backup

function check_backup() {
    NAME=$1

    if [ ! -d $BASE/$NAME/current ]; then
        /bin/btrfs subvolume create $BASE/$NAME
        /bin/btrfs subvolume create $BASE/$NAME/current
        mkdir $BASE/$NAME/updates
    fi

    rsync -av -n --delete-after /space/$NAME/ $BASE/$NAME/current | sed '1d' | head -n -3 | grep -v '/$'
}

DIRS="digikam
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
    check_backup $dir
done
