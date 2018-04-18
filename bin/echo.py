#!/usr/bin/env python3

# pylint: disable=invalid-name
# pylint: disable=missing-docstring

import argparse
import json

from flask import Flask, request

app = Flask(__name__)

@app.route('/', defaults={'path': ''}, methods=["GET", "POST", "PATCH", "DELETE"])
@app.route('/<path:path>', methods=["GET", "POST", "PATCH", "DELETE"])
def update(path): # pylint: disable=unused-argument

    headers = {k:v for k, v in request.headers.items()}

    resp = {
        "Headers": headers,
        "Method": request.method,
        "Path": request.path,
        "Parameters": request.args
        }

    if request.method in ("POST", "PATCH"):
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
    parser = argparse.ArgumentParser(description="echo")
    parser.add_argument("--port", "-p", type=int)

    args = parser.parse_args()
    app.run(port=args.port)
