#!/bin/bash

APP_TEMPLATE=/mnt/space/repos/drf-app-template

function usage() {
    echo "Usage: $0 <project-dirname> <app-name>"
    exit 1
}

if [ $# -ne 2 ]; then
  usage;
fi

PROJECT=$1
APPNAME=$2

mkdir $PROJECT

echo "************************************************************"
echo "Create a few top-level files..."
echo "************************************************************"

cd $PROJECT

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
django-debug-toolbar
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
django-admin startproject $PROJECT . # Note dot at eol
set +x

echo "****************************************"
echo "Setup git"
echo "****************************************"
sleep 2
set -x
git init
git add .
git commit -m "Initial commit: created django project & app"
set +x

echo "****************************************"
echo "Update SETTINGS"
echo "****************************************"
sleep 2
cat >> $PROJECT/settings.py <<EOF

### Added by drf setup script
INSTALLED_APPS.append('rest_framework')
INSTALLED_APPS.append('corsheaders')
INSTALLED_APPS.append('django_extensions')

# See: https://pypi.org/project/django-cors-headers/
MIDDLEWARE.insert(2, "corsheaders.middleware.CorsMiddleware")
CORS_ALLOW_ALL_ORIGINS = True

# Configure django-debug-toolbar
INSTALLED_APPS.append('debug_toolbar')
MIDDLEWARE.insert(0, 'debug_toolbar.middleware.DebugToolbarMiddleware')

INTERNAL_IPS = [
    '127.0.0.1',
]
EOF

echo "****************************************"
echo "Update $PROJECT/urls.py"
echo "****************************************"
sleep 2
cat >> $PROJECT/urls.py <<EOF

### Added by drf setup script
from django.urls import include
import debug_toolbar
urlpatterns.append(path('__debug__/', include(debug_toolbar.urls)))
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
echo "Checkin customizations"
echo "****************************************"
sleep 2
set -x
git add .
git commit -m "drf-setup script customizations"
set +x

echo "****************************************"
echo "Create django app ${APPNAME}"
echo "****************************************"
sleep 2
set -x
django-admin startapp ${APPNAME} --template ${APP_TEMPLATE}
set +x

echo "****************************************"
echo "Checkin app ${APPNAME}"
echo "****************************************"
sleep 2
set -x
git add .
git commit -m "added ${APPNAME} app from template ${APP_TEMPLATE}"
set +x

cat >> $PROJECT/settings.py <<EOF

### Added by drf setup script, customizations for ${APPNAME}
INSTALLED_APPS.append('${APPNAME}.apps.${APPNAME^}Config')
EOF

echo "****************************************"
echo "Update $PROJECT/urls.py"
echo "****************************************"
sleep 2
cat >> $PROJECT/urls.py <<EOF

### Added by drf setup script, customizations for ${APPNAME}
from rest_framework import routers
import ${APPNAME}.views as ${APPNAME}_views

${APPNAME}router = routers.DefaultRouter()
${APPNAME}router.register('sample', ${APPNAME}_views.SampleViewSet)

urlpatterns.append(path('api/', include(${APPNAME}router.urls)))
EOF

echo "****************************************"
echo "Update migrations"
echo "****************************************"
sleep 2
set -x
./manage.py makemigrations
./manage.py migrate
set +x

echo "****************************************"
echo "Checkin ${APPNAME} customizations"
echo "****************************************"
sleep 2
set -x
git add .
git commit -m "drf-setup ${APPNAME} customizations"
set +x
