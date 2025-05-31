#!/bin/bash

function common() {
    apt-get -y install \
            emacs \
            make \
            mg \
            ntp \
            ntpdate \
            rename \
            git
}

function filesystems() {
    apt-get -y install \
            ecryptfs-utils \
            cryptsetup \
            sshfs \
            nfs-common \
            btrfs-progs \
            exfat-fuse \
            exfatprogs
}

function devtools() {
    apt-get -y install \
            jq
    }

function media {
    apt-get -y install \
            ubuntu-restricted-extras \
            digikam \
            dcraw \
            exfat-fuse \
            exiftool \
            ffmpeg \
            gimp \
            gimp-help-en \
            gscan2pdf \
            imagemagick \
            vlc
    }

function office {
    apt-get -y install \
            xournal
    }

function systemutils {
    apt-get -y install \
            baobab \
            curl \
            httpie \
            dconf-editor \
            gparted \
            iotop \
            nmap \
	    usb-creator-gtk \
            sysstat \
            traceroute \
            net-tools \
            ripgrep
    }

function chrome {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > /tmp/linux_signing_key.pub
    sudo install -D -o root -g root -m 644 /tmp/linux_signing_key.pub /etc/apt/keyrings/google.asc
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google.asc] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'

    sudo apt update
    sudo apt install google-chrome-stable
}

common
filesystems
devtools
media
office
systemutils
chrome
