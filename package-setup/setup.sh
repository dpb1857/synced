#!/bin/bash

function common() {
    apt-get -y install \
            emacs \
            make \
            mg \
            ntp \
            ntpdate \
            rename
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

common
filesystems
devtools
media
office
systemutils
