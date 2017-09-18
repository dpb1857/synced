#!/usr/bin/env python

from collections import namedtuple
import datetime
import json

from flask import Flask, request

app = Flask(__name__)

@app.route('/', defaults={'path': ''},methods=["GET", "POST"])
@app.route('/<path:path>',methods=["GET", "POST"])
def update(path):

    headers = {k:v for k,v in request.headers.items()}

    resp = {
        "Headers": headers,
        "Method": request.method,
        "Path": request.path,
        "Parameters": request.args
        }

    if request.method == "POST":
        resp["Body"] = request.get_data()

    return json.dumps(resp, indent=2)

if __name__ == "__main__":
    app.run()
