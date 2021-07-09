from django.shortcuts import render

from rest_framework import viewsets
from pbp2011.models import BikeType, Control, Rider
from pbp2011.serializers import BikeTypeSerializer, ControlSerializer, RiderSerializer

# Create your views here.

class BikeTypeViewSet(viewsets.ModelViewSet):
    queryset = BikeType.objects.all()
    serializer_class = BikeTypeSerializer

class ControlViewSet(viewsets.ModelViewSet):
    queryset = Control.objects.all()
    serializer_class = ControlSerializer

class RiderViewSet(viewsets.ModelViewSet):
    queryset = Rider.objects.all()
    serializer_class = RiderSerializer
