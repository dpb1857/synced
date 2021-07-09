from django.db import models

# Create your models here.


class BikeType(models.Model):

    id = models.IntegerField(primary_key=True)
    bike_type = models.CharField(max_length=16, unique=True)

    def __repr(self):
        return f'BikeType(id={self.id}, bike_type="{self.bike_type}"'


class Control(models.Model):

    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=32)
    distance = models.FloatField()

    def __repr__(self):
        return f'Control(id={self.id}, name="{self.name}", distance={self.distance:05.1f}'

class Rider(models.Model):

    id = models.IntegerField(primary_key=True) # Rider frame number
    first_name = models.CharField(max_length=32)
    last_name = models.CharField(max_length=32)
    country = models.CharField(max_length=2)
    bike_type = models.ForeignKey(BikeType, on_delete=models.DO_NOTHING)

    dnf = models.BooleanField(default=False)
    dns = models.BooleanField(default=False)

    def __repr__(self):
        return f'Rider(id={self.id}, first_name="{self.first_name}", last_name="{self.last_name}", country="{self.country}")'
