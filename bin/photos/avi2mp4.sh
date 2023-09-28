#!/bin/sh

for file in *.AVI; do
    outfile=`echo $file|sed -e 's/.AVI/.mp4/'`
    if [ ! -d MP4 ]; then
        mkdir MP4
    fi
    echo "convert $file to $outfile"
    ffmpeg -i $file -c:a aac -c:v copy MP4/$outfile
    touch -r $file MP4/$outfile
done
