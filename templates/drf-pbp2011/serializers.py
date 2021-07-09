
from rest_framework import serializers

from pbp2011.models import BikeType, Control, Rider

class BikeTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = BikeType
        fields= ['id', 'bike_type']

class ControlSerializer(serializers.ModelSerializer):
    class Meta:
        model = Control
        fields = ['id', 'name', 'distance']

class RiderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rider
        fields = ['id', 'first_name', 'last_name', 'country', 'bike_type']
