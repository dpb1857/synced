#!/bin/sh

VERSION=1.21.1

cd /tmp
curl https://storage.googleapis.com/golang/go${VERSION}.linux-amd64.tar.gz > golang.tar.gz
cd /usr/local && sudo tar xzf /tmp/golang.tar.gz

if [ ! -d $GOPATH ]; then
    echo "Making directory $GOPATH"
    mkdir $GOPATH
fi

export PATH="/usr/local/go/bin:$PATH"

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
