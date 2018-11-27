#!/bin/sh

# Use the exiftool -
#
# http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=4596.0
#
# Do it all in exiftool.
#
echo exiftool "-FileModifyDate<DateTimeOriginal" FileOrDir
