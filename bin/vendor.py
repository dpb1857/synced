#!/usr/bin/env python3 -i

# pylint: disable=invalid-name
# pylint: disable=missing-docstring

import argparse
import datetime
import json

from flask import Flask, request

Products = {}
Orders = {}

app = Flask(__name__)

def logit(handler):
    def wrapped(*args, **kwargs):
        headers = {k:v for k, v in request.headers.items()}

        request_info = {
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
            request_info["Body"] = body

        print("Request:", json.dumps(request_info, indent=2))
        return handler(*args, **kwargs)

    return wrapped


@app.route('/hello', endpoint="hello")
@logit
def hello():
    return "Hello, world.\n"


# Products

@app.route("/vendor/v1/products", methods=["POST"], endpoint="create_products")
def create_product():
    body = request.get_json(force=True)
    id = "epprod-" + body["barcode"]
    body["id"] = id

    Products[id] = body
    print("SUCCESSFULLY ADDED PRODUCT", id)
    # print(json.dumps(body, indent=2))
    return json.dumps(body)

@app.route("/vendor/v1/products/<id>", methods=["PATCH"], endpoint="patch_products")
def patch_product(id):
    body = request.get_json(force=True)
    print("(noop) PATCHED PRODUCT", id)
    return "OK", 200

@app.route("/vendor/v1/products/<id>", methods=["GET"], endpoint="get_products")
def product(id):
    prod = Products.get(id, None)
    if prod is None:
        return "Product not Found", 404

    return json.dumps(prod, indent=2)

@app.route("/vendor/v1/products/<id>/inventories", methods=["GET"], endpoint="get_product_inventory")
def product_inventory(id):
    inventory = {
        "warehouse_1": 1000
    }

    return json.dumps(inventory, indent=2)

# Orders

@app.route("/vendor/v1/orders", methods=["POST"], endpoint="create_orders")
@logit
def create_order():
    body = request.get_json(force=True)
    id = "order-" + datetime.datetime.now().isoformat()
    body["id"] = id
    Orders[id] = body

    print ("SUCCESSFULLY ADDED ORDER", id)
    return json.dumps(body)

@app.route("/vendor/v1/orders/<id>", methods=["DELETE"], endpoint="delete_orders")
@logit
def delete_order(id):
    if not id in Orders:
        return "Order not found", 404

    del Orders[id]
    print ("SUCCESSFULLY DELETED ORDER", id)
    return "OK"

@app.route('/', defaults={'path': ''}, methods=["GET", "POST", "PATCH", "DELETE"])
@app.route('/<path:path>', methods=["GET", "POST", "PATCH", "DELETE"])
@logit
def update(path): # pylint: disable=unused-argument
    return "OK\n"


def main():
    parser = argparse.ArgumentParser(description="echo")
    parser.add_argument("--port", "-p", type=int, default=3000)

    args = parser.parse_args()
    app.run(port=args.port)

import threading
th = threading.Thread(target=main)
th.start()
