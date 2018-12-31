#!/bin/sh

PREVIEW_DIR="/home/dpb/Dropbox/Photos/Preview"

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
for dir in `find $1 -type d -print`; do
    mkdir $PREVIEW_DIR/$dir 2>/dev/null
done

# Downsize photos
for file in `find $1 \( -name \*.JPG -o -name \*.jpg \) -print`; do
    echo $file
    convert $file -quality 80 $PREVIEW_DIR/$file
    exiftool "-FileModifyDate<DateTimeOriginal" $PREVIEW_DIR/$file > /dev/null
done

# Clip movies to 20s
for file in `find $1 \( -name \*.MP4 -o -name \*.mp4 \) -print`; do
    echo $file
    ffmpeg -i $file -t 00:00:20 -codec copy $PREVIEW_DIR/$file
    touch -r $file $PREVIEW_DIR/$file
done
