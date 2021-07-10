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
echo "Create a few top-level files..."
echo "************************************************************"

cd $service

echo "Create .gitignore..."
cat > .gitignore <<EOF
db.sqlite3
pyenv
.mypy_cache
__pycache__
*~
*.pyc
*#
EOF

echo "Create Makefile..."
cat > Makefile <<EOF

default:
	@echo "no default target"

clean:
	git clean -f -d -x
EOF

echo "Create requirements.txt..."
cat > requirements.txt <<EOF
django
djangorestframework
django-cors-headers
django-filter
django_extensions
markdown
pygments
pylint
Werkzeug
EOF

set -x
python3 -m venv pyenv
. pyenv/bin/activate
pip install -r requirements.txt
set +x


echo "****************************************"
echo "Configure django project"
echo "****************************************"
sleep 2
set -x
django-admin startproject $service . # Note dot at eol
set +x

echo "****************************************"
echo "Create sample django app"
echo "****************************************"
sleep 2
set -x
django-admin startapp sample
set +x

echo "****************************************"
echo "Update INSTALLED_APPS"
echo "****************************************"
sleep 2
cat >> $service/settings.py <<EOF

### Added by setup script
INSTALLED_APPS.append('rest_framework')
INSTALLED_APPS.append('corsheaders')
INSTALLED_APPS.append('django_extensions')
INSTALLED_APPS.append('sample.apps.SampleConfig')

# See: https://pypi.org/project/django-cors-headers/
MIDDLEWARE.insert(2, "corsheaders.middleware.CorsMiddleware")
CORS_ALLOW_ALL_ORIGINS = True
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
git init
git add .
git commit -m "Initial commit"
set +x
