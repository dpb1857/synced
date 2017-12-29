#!/usr/bin/env python3

# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods

from collections import defaultdict
import logging
import os
import random
import subprocess
import time


BACKGROUNDS_DIR = "/home/dpb/Dropbox/Photos/Backgrounds"


def get_background_files():

    for dirpath, _dirnames, filenames in os.walk(BACKGROUNDS_DIR):
        for fname in filenames:
            yield os.path.join(dirpath, fname)

def get_backgrounds():

    basenames = defaultdict(list)
    for file in list(get_background_files()):
        basenames[os.path.basename(file)].append(file)

    for basename, names in basenames.items():
        if len(names) > 1:
            logging.debug("%s, %s", basename, names)
        yield names[0]

def set_background(backgrounds):

    background = backgrounds[random.randint(0, len(backgrounds)-1)]
    subprocess.check_call(["feh", "--bg-fill", background])

def cycle_backgrounds():

    backgrounds = list(get_backgrounds())
    set_background(backgrounds)
    while True:
        time.sleep(600)
        set_background(backgrounds)


def main():
    "Main function body"
    import argparse

    parser = argparse.ArgumentParser(description="myscript")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--quiet", "-q", action="store_true")

    args = parser.parse_args()

    if args.quiet:
        log_level = logging.ERROR
    elif args.verbose:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO

    logging.basicConfig(level=log_level)
    logging.debug("args: %s", args)
    cycle_backgrounds()

if __name__ == "__main__":
    main()
