#!/usr/bin/env python

import argparse
import logging
import os

CONFIG = """

daemon off;
error_log stderr;
pid /tmp/nginx-pid;

events  {{
   worker_connections 1024;
   use epoll;
}}

http {{
  access_log /dev/stdout;
  server {{
    listen {port};

    location / {{
        root {cwd}/www;
        try_files $uri $uri.html =404;
    }}

    location /scripts/ {{
        root {cwd};
    }}

    location /Images/ {{
        root {cwd};
    }}

    location /Download/ {{
        root {cwd};
    }}

    location /cgi-bin/ {{
        include /etc/nginx/uwsgi_params;
        uwsgi_modifier1 9;
        uwsgi_pass 127.0.0.1:{cgi_port};
    }}
  }}
}}
"""


def run_nginx():

    port = 8000

    parser = argparse.ArgumentParser(description="nginx launcher")
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    parser.add_argument("-p", "--port", action="store", type=int, default=8080)
    parser.add_argument("--cgi-port", action="store", type=int, default=9000)
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG if args.verbose else logging.INFO)
    logging.info("Starting nginx on port {}, using cgi port {}".format(args.port, args.cgi_port))

    cwd = os.getcwd()
    config = CONFIG.format(cwd=cwd, port=args.port, cgi_port=args.cgi_port)
    file("nginx.conf", "w").write(config)
    os.system("/usr/sbin/nginx -c {cwd}/nginx.conf".format(cwd=cwd))

if __name__ == "__main__":
    run_nginx()
