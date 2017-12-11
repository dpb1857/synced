#!/bin/sh

# Convert a directory of avi files loaded from the cassette tape video
# camera to to mp4 files. Withough the flags options, we get really bad
# tearing between frames when something is moving.

set -x
for file in *.avi; do
    outfile=`echo $file|sed 's/.avi/.mp4/'`
    avconv -i "$file" -flags +ilme+ildct "$outfile"
done
