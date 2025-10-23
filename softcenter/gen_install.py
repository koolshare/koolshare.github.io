#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import json
import hashlib
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
    for root, subdirs, files in os.walk(parent_path):
        index += 1
        for filepath in files:
            print(os.path.join(root, filepath))  # 已添加括号
        for sub in subdirs:
            print(os.path.join(root, sub))  # 已添加括号

def work_parent():
    ignore_paths = frozenset(["koolcenter", "softcenter", "speedtest", "dualwan", "kcptun", "koolnet", "kuainiao", "shadowvpn", "tunnel", "ssid", "ssserver", "qiaodao", "uamas"])
    fnames = os.listdir(parent_path)
    fnames.sort()
    for fname in fnames:
        if fname[0] == "." or fname in ignore_paths:
            continue
        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            yield fname, path

def work_parent_ext():
    contain_paths = frozenset(["cfetool"])
    fnames = os.listdir(parent_path)
    fnames.sort()
    for fname in fnames:
        if fname[0] == "." or fname not in contain_paths:
            continue
        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            print(fname)  # 已添加括号
            print(path)   # 已添加括号
            yield fname, path

def work_files(parent, ext):
    fnames = os.listdir(parent)
    fnames.sort()
    for fname in fnames:
        path = os.path.join(parent, fname)
        if os.path.isfile(path):
            yield path

def check_subdir(module, path, name, ext, target_path):
    script_path = os.path.join(path, module, name)
    if os.path.isdir(script_path):
        for f in work_files(script_path, ext):
            target_file = os.path.join(target_path, os.path.basename(f))
            copyfile(f, target_file)
            if not target_file.endswith(".png") and to_remove:
                to_remove.write(target_file + "\n")

def check_and_cp():
    for module, path in work_parent():
        #check_subdir(module, path, "scripts", ".sh", os.path.join(curr_path, "softcenter", "scripts"))
        #check_subdir(module, path, "webs", ".asp", os.path.join(curr_path, "softcenter", "webs"))
        #check_subdir(module, path, "scripts", ".sh", os.path.join(curr_path, "softcenter", "scripts"))
        check_subdir(module, path, "res/icon*.png", "*", os.path.join(curr_path, "softcenter", "res"))

def gen_modules(modules):
    for module, path in work_parent():
        conf = os.path.join(path, "config.json.js")
        m = None
        try:
            with open(conf, "r", encoding="utf-8") as fc:
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
            m = {"name": module, "title": module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

def gen_modules_ext(modules):
    for module, path in work_parent_ext():
        conf = os.path.join(path, "config.json.js")
        m = None
        try:
            with open(conf, "r", encoding="utf-8") as fc:
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
            m = {"name": module, "title": module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

if stage == "stage1":
    to_remove = open(os.path.join(curr_path, "to_remove.txt"), "w", encoding="utf-8")
    check_and_cp()
    to_remove.close()
elif stage == "stage2":
    gmodules = None
    with open(os.path.join(curr_path, "app.template.json.js"), "r", encoding="utf-8") as fg:
        gmodules = json.loads(fg.read())
        gmodules["apps"] = []
        #gmodules["apps1"] = []
    gen_modules(gmodules["apps"])
    #gen_modules_ext(gmodules["apps1"])

    with open(os.path.join(curr_path, "config.json.js"), "r", encoding="utf-8") as fc:
        conf = json.loads(fc.read())
        gmodules["version"] = conf["version"]
        gmodules["md5"] = conf["md5"]

        with open(os.path.join(curr_path, "app.json.js"), "w", encoding="utf-8") as fw:
            json.dump(gmodules, fw, sort_keys=True, indent=4, ensure_ascii=False)