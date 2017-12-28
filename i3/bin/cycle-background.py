#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

import os
import random
import subprocess
import time


BACKGROUNDS_DIR = "/home/dpb/Dropbox/Photos/Backgrounds"


def get_backgrounds():

    for dirpath, _dirnames, filenames in os.walk(BACKGROUNDS_DIR):
        for fname in filenames:
            yield os.path.join(dirpath, fname)

def set_background(backgrounds):

    background = backgrounds[random.randint(0, len(backgrounds)-1)]
    subprocess.check_call(["feh", "--bg-fill", background])

def cycle_backgrounds():

    backgrounds = list(get_backgrounds())
    set_background(backgrounds)
    while True:
        time.sleep(600)
        set_background(backgrounds)

cycle_backgrounds()
