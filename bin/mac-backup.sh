#!/bin/bash
set -x
cd $HOME
tar cvzf mac-secret.tar.gz secret
mcrypt mac-secret.tar.gz # creates secret.tar.gz.mc
rsync -av mac-secret.tar.gz.nc linode.donbennett.org:~dpb
rm -f mac-secret.tar.gz mac-secret.tar.gz.nc

tar cvzf mac-documents.tar.gz Documents
rsync -av mac-documents.tar.gz linode.donbennett.org:~dpb
rm -f mac-documents.tar.gz
