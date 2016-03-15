#!/bin/bash

BASE=/srv
DIRS="castle_home
      Documents-dad
      media-audio
      media-downloads
      media-recordings
      media-video
"

for dir in $DIRS; do
    echo "Backing up $dir"
    rsync -av --delete-after $BASE/$dir /backup/$dir
done
