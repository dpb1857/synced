#!/bin/sh

# Download package;
# https://go.dev/doc/install

rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# Build/install gorun;
# go get -u github.com/erning/gorun

# Install additional tools to support emacs;
# from dpb-golang.el -

# godef:
# go get -u github.com/rogpeppe/godef

# gocode:
# go get -u github.com/nsf/gocode

# delve (debugger)
# go get github.com/go-delve/delve/cmd/dlv

# guru
# go get -u golang.org/x/tools/cmd/guru

# hugo - from http://gohugo.io/installation/linux; install from source
# CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest

# Install GoLand;
Install package lives in: Dropbox/SavedDownloads/goland-yyyy.<ver>.tar.gz

# Configure emacs as an external tool -
# Settings -> Tools -> External Tools -> emacs
#   Program: emacs
#   Arguments: +$LineNumber$:$ColumnNumber$ $FilePath$
#   Working dir: $FileDir$
#
# TODO: maybe chanage this to emacsclient??

sudo -c /opt tar xvzf Goland-xxxx.tar.gz
