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
            btop \
            nmap \
	    usb-creator-gtk \
            sysstat \
            traceroute \
            net-tools \
            ripgrep
    }

function chrome {
    if [ ! -f /etc/apt/sources.list.d/google.list ]; then
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > /tmp/linux_signing_key.pub
        sudo install -D -o root -g root -m 644 /tmp/linux_signing_key.pub /etc/apt/keyrings/google.asc
        sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google.asc] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'

        sudo apt update
        sudo apt install google-chrome-stable
    fi
}

function python {
    sudo apt install -y python3-tk
}

function clojure {
    cd /tmp
    curl -O https://download.clojure.org/install/linux-install.sh
    chmod +x linux-install.sh
    sudo ./linux-install.sh

    # Install clj-kondo (for code checking with flycheck)
    # https://github.com/clj-kondo/clj-kondo/blob/master/doc/install.md
    cd /tmp
    curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo
    chmod +x install-clj-kondo
    sudo ./install-clj-kondo
}

function babashka {
   cd /tmp
   curl -O https://raw.githubusercontent.com/babashka/babashka/master/install
   chmod +x install
   sudo ./install
}

# Will need to install nvm if we need a newer version of node
function javascript {
    apt-get -y install \
            nodejs \
            npm
}

function dell_printer {
   sudo dpkg --add-architecture i386
   sudo apt update
   sudo apt-get install libcupsimage2:i386 lib32z1 lib32stdc++6
   sudo dpkg -i ~/synced/packages/xerox-phaser-6000-6010_1.0-1_i386.deb
   sudo apt-get install -f
}

function misc {
    dpkg -i zoom_amd64.deb \
         virtualbox-7.1_7.1.6-167084~Ubuntu~noble_amd64.deb
    apt-get install -f
}

common
filesystems
media
systemutils
chrome

# Not needed for minimal setup
devtools
office
python
clojure
babashka
javascript
dell_printer
misc
