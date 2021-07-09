#!/bin/sh

PROJECT=$(basename `/bin/pwd`)

echo "****************************************"
echo " Create pbp2011 app"
echo "****************************************"

pyenv/bin/django-admin startapp pbp2011
d=$HOME/synced/templates/drf-pbp2011
cp $d/models.py pbp2011
cp $d/views.py pbp2011
cp $d/serializers.py pbp2011
cp -r $d/fixtures pbp2011/fixtures
cp -r $d/management pbp2011/management

echo "****************************************"
echo " Update INSTALLED_APPS"
echo "****************************************"
sleep 2
cat >> $PROJECT/settings.py <<EOF

### Added by setup script
INSTALLED_APPS.append('pbp2011.apps.Pbp2011Config')
EOF

echo "****************************************"
echo " Process migrations & import data"
echo "****************************************"
sleep 2
set -x
./manage.py makemigrations
./manage.py migrate
./manage.py importdata pbp2011/fixtures/pbp2011_us_lf.json.gz
set +x

echo "****************************************"
echo " Install routes"
echo "****************************************"
sleep 2
cat >> $PROJECT/urls.py <<EOF

### Added by setup script
from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from pbp2011 import views

router = routers.DefaultRouter()
router.register(r'biketype', views.BikeTypeViewSet)
router.register(r'controls', views.ControlViewSet)
router.register(r'rider', views.RiderViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
    path('admin/', admin.site.urls),
]
EOF

echo "****************************************"
echo " Checkpoint our work"
echo "****************************************"
sleep 2
set -x
git add .
git commit -m "Add pbp2011 sample app"
set +x
