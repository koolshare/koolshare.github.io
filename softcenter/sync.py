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
import traceback
from distutils.version import LooseVersion
from string import Template 

#https://docs.python.org/2.4/lib/httplib-examples.html

curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))
git_bin = "git"

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
    updated = False
    with codecs.open(module_path, "r", "utf-8") as fc:
        modules = json.loads(fc.read())
        if modules:
            for m in modules:
                if "module" in m:
                    try:
                        up = sync_module(m["module"], m["git_source"])
                        if not updated:
                            updated = up
                    except Exception, e:
                        traceback.print_exc()
    return updated

def sync_module(module, git_path):
    module_path = os.path.join(parent_path, module)
    conf_path = os.path.join(module_path, "config.json.js")
    rconf = get_remote_js(git_path)
    lconf = get_local_js(conf_path)
    update = False
    if not rconf:
        return
    print rconf
    if not lconf:
        update = True
    else:
        if LooseVersion(rconf["version"]) > LooseVersion(lconf["version"]):
            update = True
    if update:
        print "updating", git_path
        cmd = ""
        tar_path = os.path.join(module_path, "%s.tar.gz" % module);
        if os.path.isdir(module_path):
            cmd = "cd $module_path && git reset --hard && $git_bin pull && rm -f $module.tar.gz && tar -zcf $module.tar.gz $module" 
        else:
            cmd = "cd $parent_path && $git_bin clone $git_path $module_path && cd $module_path && tar -zcf $module.tar.gz $module"
        t = Template(cmd)
        params = {"parent_path": parent_path, "git_path": git_path, "module_path": module_path, "module": module, "git_bin": git_bin}
        s = t.substitute(params)
        os.system(s)
        rconf["md5"] = md5sum(tar_path)
        with codecs.open(conf_path, "w", "utf-8") as fw:
            json.dump(rconf, fw, sort_keys = True, indent = 4, ensure_ascii=False, encoding='utf8')
        os.system("cd %s && chown -R www:www ." % module_path)
    return update

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

def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))

def md5sum(full_path):
    with open(full_path, 'rb') as rf:
        return hashlib.md5(rf.read()).hexdigest()

def work_parent():
    ignore_paths = frozenset(["maintain_files", "softcenter", "v2ray"])
    for fname in os.listdir(parent_path):
        if fname[0] == "." or fname in ignore_paths:
            continue
        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            yield fname, path

def gen_modules(modules):
    for module, path in work_parent():
        conf = os.path.join(path, "config.json.js")
        m = None
        try:
            with codecs.open(conf, "r", "utf-8") as fc:
                m = json.loads(fc.read())
                if m:
                    m["name"] = module
                    if "tar_url" not in m:
                        m["tar_url"] = module + "/" + module + ".tar.gz"
                    if "home_url" not in m:
                        m["home_url"] = "Module_" + module + ".asp"
        except:
            traceback.print_exc()

        if not m:
            m = {"name":module, "title":module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

def refresh_gmodules():
    gmodules = None
    with codecs.open(os.path.join(curr_path, "app.template.json.js"), "r", "utf-8") as fg:
        gmodules = json.loads(fg.read())
        gmodules["apps"] = []
    gen_modules(gmodules["apps"])

    with codecs.open(os.path.join(curr_path, "config.json.js"), "r", "utf-8") as fc:
        conf = json.loads(fc.read())
        gmodules["version"] = conf["version"]
        gmodules["md5"] = conf["md5"]

        with codecs.open(os.path.join(curr_path, "app.json.js"), "w", "utf-8") as fw:
            json.dump(gmodules, fw, sort_keys = True, indent = 4, ensure_ascii=False, encoding='utf8')

updated = work_modules()
if updated:
    refresh_gmodules()
    os.system("chown -R www:www %s/softcenter/app.json.js" % parent_path)
    os.system("sh %s/softcenter/build.sh" % parent_path)
