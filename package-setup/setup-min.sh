#!/bin/bash

function common() {
    apt-get -y install \
            emacs \
            mg \
            ntp \
            ntpdate \
	    git
}

function filesystems() {
    apt-get -y install \
            ecryptfs-utils \
            cryptsetup \
            btrfs-progs \
            exfat-fuse \
            exfatprogs
}

function media {
    apt-get -y install \
            ubuntu-restricted-extras
    }

function systemutils {
    apt-get -y install \
            baobab \
            curl \
            httpie \
            dconf-editor \
            gparted \
            iotop \
            sysstat \
            traceroute \
            net-tools \
            ripgrep
    }

common
filesystems
media
systemutils
