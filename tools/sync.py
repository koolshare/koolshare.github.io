#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import urlparse
import httplib
import json
import hashlib
import codecs
from shutil import copyfile
import sys

#https://docs.python.org/2.4/lib/httplib-examples.html

curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))

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
    conn.request("GET", path, "", {"Cache-Control": "max-age=0"})
    response = conn.getresponse()
    #print response.status, response.reason

    if response.status > 300 and response.status < 400:
        headers = dict(response.getheaders())
        if headers.has_key('location') and headers['location'] != url:
            #print headers['location']
            return http_request(headers['location'], depth + 1)

    data = response.read()
    return data

def work_modules():
    module_path = os.path.join(curr_path, "modules.json")
    with codecs.open(module_path, "r", "utf-8") as fc:
        modules = json.loads(fc.read())
        if modules:
            for m in modules:
                if "module" in m:
                    sync_module(m["module"], m["git_source"])

def sync_module(module, git_path):
    module_path = os.path.join(parent_path, module)
    conf_path = os.path.join(module_path, "config.json.js")
    rconf = get_remote_js(git_path)
    lconf = get_local_js(conf_path)
    print rconf
    print lconf

def get_config_js(git_path):
    #https://github.com/koolshare/merlin_tunnel.git
    #git@github.com:koolshare/merlin_tunnel.git

    if git_path.startswith("https://"):
        return git_path[0:-4] + "/raw/master/config.json.js"
    else:
        index = git_path.find(":")
        return "https://github.com/" + git_path[index+1:-4] + "/raw/master/config.json.js"

def get_remote_js(git_path):
    data = http_request(get_config_js(git_path))
    conf = json.loads(data)
    return conf

def get_local_js(conf_path):
    if os.path.isfile(conf_path):
        with codecs.open(conf_path, "r", "utf-8") as fc:
            conf = json.loads(fc.read())
            return conf
    return None

print http_request("https://raw.githubusercontent.com/koolshare/merlin_tunnel/master/config.json.js")
#print get_config_js("https://github.com/koolshare/merlin_tunnel.git")
#print get_config_js("git@github.com:koolshare/merlin_tunnel.git")
#TODO git clone http://codereview.stackexchange.com/questions/75432/clone-github-repository-using-python

work_modules()
