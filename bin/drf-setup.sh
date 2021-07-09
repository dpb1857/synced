#!/bin/bash

function usage() {
    echo "Usage: $0 <project-dirname>"
    exit 1
}

# Create top-level directory, install requirements.txt & Makefile
if [ $# -ne 1 ]; then
  usage;
fi

service=$1
mkdir $service

echo "************************************************************"
echo "Create top-level directory and make virtualenv"
echo "************************************************************"
set -x
cp $HOME/synced/templates/drf-template/Makefile $service
cp $HOME/synced/templates/drf-template/requirements.txt $service
set +x

cd $service
set -x
python3 -m venv pyenv
pyenv/bin/pip install -r requirements.txt
set +x

echo "****************************************"
echo "Configure django project"
echo "****************************************"
sleep 2
set -x
pyenv/bin/django-admin startproject $service . # Note dot at eol
set +x

echo "****************************************"
echo "Create sample django app"
echo "****************************************"
sleep 2
set -x
pyenv/bin/django-admin startapp sample
set +x

echo "****************************************"
echo "Update INSTALLED_APPS"
echo "****************************************"
sleep 2
cat >> $service/settings.py <<EOF

### Added by setup script
INSTALLED_APPS.append('rest_framework')
INSTALLED_APPS.append('sample.apps.SampleConfig')
EOF

echo "****************************************"
echo "Run db migrations & add admin db user"
echo "****************************************"
sleep 2
set -x
./manage.py migrate
./manage.py createsuperuser --username admin --email admin@devnull.com
set +x

echo "****************************************"
echo "Setup git"
echo "****************************************"
sleep 2
set -x
cp $HOME/synced/templates/drf-template/dot-gitignore .gitignore
git init
git add .
git commit -m "Initial commit"
set +x
