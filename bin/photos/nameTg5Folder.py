#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

from collections import namedtuple
import datetime
import os

PhotoInfo = namedtuple("PhotoInfo", ["src", "statbuf"])

def get_photo_files():
    """
    Generate photo filenames
    expect current directory to contain directories with JPG files - e.g., 119_PANA
    """
    folders = [folder for folder in os.listdir(".")]
    photos = [os.path.join(folder, fname) for folder in folders for fname in os.listdir(folder) if fname.endswith("ORF")]
    return photos

def build_photo_info(photos_files):

    def photo_info(fname):
        sb = os.stat(fname)
        return PhotoInfo(src=fname, statbuf=sb)

    return [photo_info(fname) for fname in photos_files]

def name_oly_folder():
    photo_info = build_photo_info(get_photo_files())
    ctime_list = [info.statbuf.st_mtime for info in photo_info]
    dt_start = datetime.datetime.fromtimestamp(min(ctime_list))
    dt_end = datetime.datetime.fromtimestamp(max(ctime_list))
    filenames = list(sorted(info.src for info in photo_info))

    year = dt_start.year

    infodict = {
        "prefix": "oly",
        "year": str(year),
        "mmdd_start": "{:02}{:02}".format(dt_start.month, dt_start.day),
        "mmdd_end":   "{:02}{:02}".format(dt_end.month, dt_end.day),
        "folder_num": filenames[0].split('/')[-2].split('_')[0],
        "min_num": filenames[0].split('.')[0][-4:],
        "max_num": filenames[-1].split('.')[0][-4:]
    }
    return "{prefix}-{year}-{mmdd_start}-{mmdd_end}-{folder_num}-{min_num}-{max_num}".format(**infodict)

print(name_oly_folder())
