#!/bin/bash

revert() {
    xset dpms 0 0 0
}
trap revert HUP INT TERM
xscreensaver-command -deactivate
xset +dpms dpms 30 30 30
i3lock -n -t -e -i /home/dpb/synced/i3/images/padlock.png
revert
