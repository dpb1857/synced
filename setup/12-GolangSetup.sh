#!/bin/sh

# Install using snap;
snap install go --classic

# https://askubuntu.com/questions/1400653/how-to-install-specific-version-of-go-in-ubuntu-using-snap# Or install a specific version;
# snap info go
# snap install go ==channel=1.16/stable --classic

# Or upgrade / downgrade:
# snap refresh go --channel=1.16/stable --classic

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
CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest

# Install GoLand;
Install package lives in: Dropbox/SavedDownloads/goland-yyyy.<ver>.tar.gz

sudo -c /opt tar xvzf Goland-xxxx.tar.gz
