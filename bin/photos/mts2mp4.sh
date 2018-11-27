#!/bin/sh

for file in STREAM/*; do
    outfile=`echo $file|sed -e 's/STREAM/MP4/' -e 's/MTS/MP4/'`
    if [ ! -d MP4 ]; then
        mkdir MP4
    fi
    echo "convert $file to $outfile"
    ffmpeg -i $file -c:a aac -c:v copy $outfile
    touch -r $file $outfile
done
