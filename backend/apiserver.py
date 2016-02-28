#!/usr/bin/python
#**************************************************************************************************
# RESTful Flask API
# Eugene Kolo | eugenekolo.com
# 
# `GET /api/{}`
# `POST /api/{}`
#
# TODO: Install a session manager
# TODO: Write a setup.py
#**************************************************************************************************

import traceback, os, posixpath
import argparse, sqlite3, pprint

from flask import Flask, request, json
from flask.ext.cors import CORS
from flask_limiter import Limiter


#**********************************************************
# Server setup
#**********************************************************
DELAY = True

app = Flask(__name__)

# Can add pre(before) or post(after) hooks here...
# def exposer_headers(response):
#    response.headers.add('Access-Control-Expose-Headers', 'Content-Dispositions, Content-Length')
# apps.after_request(expose_headers)
# TODO(eugenek): https://github.com/maxcountryman/flask-login

cors = CORS(app)

# Can add rate limiting here...
# limiter = Limiter(app)
# if (DELAY):
#    limit = limiter.shared_limit("...")
#    pass


@app.route('/api/login', methods=['POST'])
# @limit
def post_login():
    try:
        payload = json.loads(request.get_data())
        pprint.pprint(payload)
        return json_dump({'hello': 'from post_login'})
    except Exception:
        print(traceback.format_exc())
        return "Error", 500

@app.route('/api/message/<int:idx>', methods=['GET'])
# @limit
def get_message(idx):
    try:
        return json_dump({'hello': 'from get_message'})
    except Exception:
        print(traceback.format_exc())
        return "Error", 500


@app.route('/api/account', methods=['POST'])
# @limit
def post_account():
    try:
        payload = json.loads(request.get_data())
        pprint.pprint(payload)
        return json_dump({'hello': 'from post_account'})
    except Exception:
        print(traceback.format_exc())
        return "Error", 500

def json_dump(d):
    return json.dumps(d, indent=4, separators=(',',': '))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--debug', action='store_true', default=False,
        help='Enable debugging, default=False')
    parser.add_argument('-x', '--host', default='127.0.0.1', 
        help='The host to bind to, default=127.0.0.1')
    parser.add_argument('-p', '--port', type=int, default=5000,
        help='The port of the host to bind to, default=5000')
    args = parser.parse_args()

    app.run(debug=args.debug, host=args.host, port=args.port, threaded=True)