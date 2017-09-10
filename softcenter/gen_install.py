#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
import hashlib
import codecs
from shutil import copyfile
import sys

stage = "stage1"
if len(sys.argv) > 1:
    stage = sys.argv[1]

curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))

to_remove = None

def md5sum(full_path):
    with open(full_path, 'rb') as rf:
        return hashlib.md5(rf.read()).hexdigest()

def work_paths_by_walk():
    index = 0
    for root,subdirs,files in os.walk(parent_path):
        index += 1
        for filepath in files:
            print os.path.join(root,filepath)
        for sub in subdirs:
            print os.path.join(root,sub)

def work_parent():
    ignore_paths = frozenset(["maintain_files", "softcenter", "shadowsocks"])
    for fname in os.listdir(parent_path):

        if fname[0] == "." or fname in ignore_paths:
            continue

        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            #print fname
            #print path
            yield fname, path

def work_files(parent, ext):
    for fname in os.listdir(parent):
        path = os.path.join(parent, fname)
        if os.path.isfile(path):
            yield path

def check_subdir(module, path, name, ext, target_path):
    script_path = os.path.join(path, module, name)
    if os.path.isdir(script_path):
        for f in work_files(script_path, ext):
            target_file = os.path.join(target_path, os.path.basename(f))
            #print "copy", f, "-->", target_file
            copyfile(f, target_file)
            if not target_file.endswith(".png") and to_remove:
                to_remove.write(target_file+"\n")

def check_and_cp():
    for module, path in work_parent():
        #check_subdir(module, path, "scripts", ".sh", os.path.join(curr_path, "softcenter", "scripts"))
        #check_subdir(module, path, "webs", ".asp", os.path.join(curr_path, "softcenter", "webs"))
        #check_subdir(module, path, "scripts", ".sh", os.path.join(curr_path, "softcenter", "scripts"))
        check_subdir(module, path, "res", "*", os.path.join(curr_path, "softcenter", "res"))

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
            pass

        if not m:
            m = {"name":module, "title":module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

if stage == "stage1":
    to_remove = open(os.path.join(curr_path, "to_remove.txt"), "w")
    check_and_cp()
    to_remove.close()
else:
    check_and_cp()
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
