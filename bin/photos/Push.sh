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
PushToSmugmug.sh $1
PushToPreview.sh $1
