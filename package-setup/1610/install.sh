#!/bin/sh

name=`hostname`
if [ ! -f nodes/$name ]; then
    echo "Could not find package file for host $name." 1>&2
    exit 1
fi

sets=`cat nodes/$name|grep -v '^#'`
echo "Installing the following package sets:"
fnames=""
for set in $sets; do
    echo $set
    fnames="$fnames modules/$set"
done

missing=0
for fname in $fnames; do
    if [ ! -f $fname ]; then
        echo "Module $fname is missing." 1>&2
        missing=1
        continue
    fi
done

if [ $missing -eq 1 ]; then
    echo "Exiting." 2>&1
    exit 2
fi
sleep 10

debs=`cat $fnames|grep -v '^#'`
echo
echo "installing the following debs:"
for deb in $debs; do
    echo $deb
done
sleep 10

sudo apt-get install $debs
