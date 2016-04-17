#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
import hashlib
import codecs

curr_path = os.path.dirname(os.path.realpath(__file__))

with codecs.open(os.path.join(curr_path, "config.json.js"), "r", "utf-8") as fc:
    conf = json.loads(fc.read())
    fw = codecs.open(os.path.join(curr_path, "app.json.js"), "r", "utf-8")
    modules = json.loads(fw.read())
    modules["version"] = conf["version"]
    modules["md5"] = conf["md5"]
    fw.close()

    fw = codecs.open(os.path.join(curr_path, "app.json.js"), "w", "utf-8")
    json.dump(modules, fw, sort_keys = True, indent = 4, ensure_ascii=False, encoding='utf8')
