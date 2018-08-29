#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
import codecs
import hashlib
from string import Template 

parent_path = os.path.dirname(os.path.realpath(__file__))

def md5sum(full_path):
    with open(full_path, 'rb') as rf:
        return hashlib.md5(rf.read()).hexdigest()

def get_or_create():
    conf_path = os.path.join(parent_path, "config.json.js")
    conf = {}
    if not os.path.isfile(conf_path):
        print u"config.json.js 文件找不到，build.py 一定得放插件根目录。自动为您生成一个config.json.js，其它信息请您自己修改。"
        module_name = os.path.basename(parent_path)
        conf["module"] = module_name
        conf["version"] = "0.0.1"
        conf["home_url"] = ("Module_%s.asp" % module_name)
        conf["title"] = "title of " + module_name
        conf["description"] = "description of " + module_name
    else:
        with codecs.open(conf_path, "r", "utf-8") as fc:
            conf = json.loads(fc.read())
    return conf

def build_module():
    try:
        conf = get_or_create()
    except:
        print u"config.json.js 文件格式错误"
        traceback.print_exc()
    if "module" not in conf:
        print u"没有 module 在 config.json.js 里"
        return
    module_path = os.path.join(parent_path, conf["module"])
    if not os.path.isdir(module_path):
        print u"找不到对应的 %s 文件夹，config.json.js 里面的 module 值不对？" % module_path
        return
    install_path = os.path.join(parent_path, conf["module"], "install.sh")
    if not os.path.isfile(install_path):
        print u"找不到对应的 %s 文件，插件确实 install.sh 文件"
        return
    print u"生成中..."
    t = Template("cd $parent_path && rm -f $module.tar.gz && tar -zcf $module.tar.gz $module")
    os.system(t.substitute({"parent_path": parent_path, "module": conf["module"]}))
    conf["md5"] = md5sum(os.path.join(parent_path, conf["module"] + ".tar.gz"))
    conf_path = os.path.join(parent_path, "config.json.js")
    with codecs.open(conf_path, "w", "utf-8") as fw:
        json.dump(conf, fw, sort_keys = True, indent = 4, ensure_ascii=False, encoding='utf8')
    print u"生成完成", conf["module"] + ".tar.gz"
    hook_path = os.path.join(parent_path, "backup.sh")
    if os.path.isfile(hook_path):
        os.system(hook_path)

build_module()
