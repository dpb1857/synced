#!/usr/bin/env python

from collections import namedtuple
import datetime
import json

from flask import Flask, request

app = Flask(__name__)

@app.route('/', defaults={'path': ''},methods=["GET", "POST", "DELETE"])
@app.route('/<path:path>',methods=["GET", "POST", "DELETE"])
def update(path): # pylint: disable=unused-argument

    headers = {k:v for k, v in request.headers.items()}

    resp = {
        "Headers": headers,
        "Method": request.method,
        "Path": request.path,
        "Parameters": request.args
        }

    if request.method == "POST":
        body = request.get_data(as_text=True)
        try:
            body = json.loads(body)
        except Exception: # pylint: disable=broad-except
            pass
        resp["Body"] = body

    resp = json.dumps(resp, indent=2)
    print("Request:", resp)
    return resp

if __name__ == "__main__":
    app.run()
