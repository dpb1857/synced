#!/usr/bin/env python

from collections import namedtuple
import datetime
import json

from flask import Flask, request

app = Flask(__name__)


@app.route("/update", methods=["GET", "POST"])
def update():

    for k,v in request.headers:
        print("Header: {}: {}".format(k, v))
    print("Method: {}".format(request.method))
    print("Path: {}".format(request.path))
    print("Parameters: {}".format(request.args))

    if request.method == "POST":
        print("Post body: {}".format(request.get_data()))

    return json.dumps({"status": "ok"})

if __name__ == "__main__":
    app.run()
