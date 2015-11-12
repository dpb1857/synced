#!/bin/sh

cd $HOME
echo "Copying tar file from beta..."
rsync -av beta.quixey.com:~/python27-fastapi.tar.gz .

echo "installing..."
cd / 
sudo tar xvzf $HOME/python27-fastapi.tar.gz

echo "Cloning fastapi repo..."
cd $HOME
git clone git@github.com:quixey/fastapi

echo "Done."
