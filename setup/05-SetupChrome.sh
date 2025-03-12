#!/bin/bash

# Install from chrome ppa;
# See: ubuntuupdates.org/ppa/google_chrome


# Login to chrome/chromium; (use dpb1857 gmail login) $<leadingcap,planetary><2digUltAns>
# Login to pinboard; (dpb:<planetary>pinboard)


# Command line: (deb 12, ubuntu 2024)
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > /tmp/linux_signing_key.pub
sudo install -D -o root -g root -m 644 /tmp/linux_signing_key.pub /etc/apt/keyrings/linux_signing_key.pub
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/linux_signing_key.pub] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

sudo apt update
sudo apt install google-chrome-stable
