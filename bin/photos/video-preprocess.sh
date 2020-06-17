#!/bin/sh

# Use ffmpeg to convert whatever video input files into high-quality mp4 files.

# YouTube bitrate ranges:
# 1080p: 1920 x 1080: 3M - 6M
# 720p: 1280x720: 1.5M - 4M

PRESET=medium
BASE=`echo $1 | sed 's/\..*//'`
set -x
ffmpeg -i "$1" -c:v libx264 -crf 18 -preset ${PRESET} -c:a copy "${BASE}-${PRESET}.mp4"
