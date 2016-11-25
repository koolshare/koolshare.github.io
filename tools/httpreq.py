#!/usr/bin/env python
# _*_ coding:utf-8 _*_

#https://docs.python.org/2.4/lib/httplib-examples.html

import urlparse
import httplib

def http_request(url, depth=0):
    if depth > 10:
        raise Exception("Redirected "+depth+" times, giving up.")
    o = urlparse.urlparse(url, allow_fragments=True)
    if o.scheme == 'https':
        conn = httplib.HTTPSConnection(o.netloc)
    else:
        conn = httplib.HTTPConnection(o.netloc)
    path = o.path
    if o.query:
        path +='?'+o.query
    conn.request("GET", path)
    response = conn.getresponse()
    print response.status, response.reason

    if response.status > 300 and response.status < 400:
        headers = dict(response.getheaders())
        if headers.has_key('location') and headers['location'] != url:
            print headers['location']
            return http_request(headers['location'], depth + 1)

    data = response.read()
    return data

print http_request("https://github.com/koolshare/merlin_tunnel/raw/master/config.json.js")
#TODO git clone http://codereview.stackexchange.com/questions/75432/clone-github-repository-using-python
