
#!/bin/sh

VERSION=1.7.4

cd /tmp
curl https://storage.googleapis.com/golang/go${VERSION}.linux-amd64.tar.gz > golang.tar.gz
cd /opt && sudo tar xzf /tmp/golang.tar.gz

if [ ! -d $GOPATH ]; then
    echo "Making directory $GOPATH"
    mkdir $GOPATH
fi

export PATH="/opt/go/bin:$PATH"

# Build/install gorun;

## GOPATH is now set to $HOME/goprojects
go get -u github.com/erning/gorun

# Install additional tools to support emacs;
# from dpb-golang.el -

# godef:
go get -u github.com/rogpeppe/godef

# gocode:
go get -u github.com/nsf/gocode
