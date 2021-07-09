
import gzip
import json

from django.core.management.base import BaseCommand, CommandError
from pbp2011 import models

class Command(BaseCommand):
    help = "Import data from dumped json file."

    def add_arguments(self, parser):
        parser.add_argument('fixture', metavar="fixture_name", nargs=1)

    def handle(self, *args, **kwargs):
        fixture = kwargs["fixture"][0]

        if fixture.endswith(".gz"):
            opener = gzip.open
        else:
            opener = open

        count = 0
        with opener(fixture, "r") as fixture_file:
            for line in fixture_file:
                count += 1
                line = line.strip()
                data = json.loads(line)
                if data["model"] == "pbp2011.control":
                    control = models.Control(
                        id=data["pk"],
                        name=data["fields"]["name"],
                        distance=data["fields"]["distance"])
                    control.save()

                elif data["model"] == "pbp2011.biketype":
                    biketype = models.BikeType(
                        id=data["pk"],
                        bike_type=data["fields"]["bike_type"])
                    biketype.save()

                elif data["model"] == "pbp2011.rider":
                    rider = models.Rider(
                        id=data["pk"],
                        first_name = data["fields"]["first_name"],
                        last_name = data["fields"]["last_name"],
                        country = data["fields"]["country"],
                        bike_type = models.BikeType(id=data["fields"]["bike_type"]))

                    rider.save()

        print(f"Loaded {count} records")
        print("That's all, folks!\n")
