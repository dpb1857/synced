#!/bin/sh

# Remove orphan rw2 files;

dir=100OLYMP
    for file in $dir/*.ORF; do
        jpgFile=`echo $file|sed -e 's/ORF/jpg/' -e 's/100OLYMP/jpg/'`
        if [ ! -f $jpgFile ]; then
            echo "Removing orphaned ORF file $file"
            # rm -f $file
        fi
    done
