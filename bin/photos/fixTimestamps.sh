#!/bin/sh

# Use the exiftool -
#
# http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=4596.0
#
# Do it all in exiftool.
#
# exiftool "-FileModifyDate<DateTimeOriginal" <file-or-directory>
exiftool "-FileModifyDate<DateTimeOriginal" $1
