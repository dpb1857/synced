#!/bin/sh

# Convert a directory of avi files loaded from the cassette tape video
# camera to to mp4 files. Withough the flags options, we get really bad
# tearing between frames when something is moving.

set -x
for file in *.TIF; do
    outfile=`echo $file|sed 's/.TIF/.jpg/'`
    convert "$file" -quality 100 "$outfile"
done
