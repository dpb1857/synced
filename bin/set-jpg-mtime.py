#!/usr/bin/python

import os
import string
import time

def get_exif_time(file):
    cmd = "exif -t 0x9003 \"%s\"" % file
    fd = os.popen(cmd)
    info = fd.read()
    fd.close()

    time_str = string.strip(string.split(info, "\n")[-2])
    t_tup = time.strptime(time_str, "Value: %Y:%m:%d %H:%M:%S")
    t_sec = int(time.mktime(t_tup))

    return t_sec

# For some reason, on my current cygwin, the exif -t option doesn't work;
# So, print all of the tags and extract the correct line from the output;

def get_exif_time2(file):
    cmd = "exif -i \"%s\"" % file
    fd = os.popen(cmd)
    info = fd.read()
    fd.close()

    for line in info.split('\n'):
        line_parts = line.split('|')
        if line_parts[0] == "0x9003":
            time_str = line_parts[1].strip()
            t_tup = time.strptime(time_str, "%Y:%m:%d %H:%M:%S")
            t_sec = int(time.mktime(t_tup))
            return t_sec

for file in os.listdir("."):
    if file[-4:] != ".jpg" and file[-4:] != ".JPG":
        continue
    
    try:
        t = get_exif_time2(file)
        atime = t
        mtime = t
        os.utime(file, (atime, mtime))
    except:
        pass
