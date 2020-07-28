#!/bin/sh

# Use ffmpeg to convert whatever video input files into high-quality mp4 files.

# YouTube bitrate ranges:
# 1080p: 1920 x 1080: 3M - 6M
# 720p: 1280x720: 1.5M - 4M

BASE=`echo $1 | sed 's/\..*//'`
set -x
ffmpeg -i "$1" -vf scale=-1:720 -c:v libx264 -preset veryfast -crf 21 -tune fastdecode -b:v 3M -maxrate 4M -bufsize 1M -strict -2 -c:a copy "${BASE}-stream.mp4"
