#!/bin/sh

usage() {
    echo "Usage: $0 <foldername>"
    exit 1
}

checkfolder() {
    if echo $1 | grep '/$' >/dev/null; then
        echo "Bad dirname; must not end with slash!"
        exit 1
    fi
}

if [ $# -ne 1 ]; then
    usage
fi

checkfolder $1
rsync -av --exclude=*.RW2 \
      --exclude=*.NEF \
      --exclude=*.CR2 \
      --exclude=*.MOV \
      --exclude=*.AVI \
      $1 /home/dpb/Dropbox/Photos/SmugmugExport
