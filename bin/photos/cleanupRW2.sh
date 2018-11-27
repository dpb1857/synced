#!/bin/sh

for dir in *_PANA; do
    for file in $dir/*.RW2; do
        jpgFile=`echo $file|sed 's/RW2/JPG/'`
        if [ ! -f $jpgFile ]; then
            echo "Removing orphaned rw2 file $file"
            rm -f $file
        fi
    done
done
