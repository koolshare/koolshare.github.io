#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
from shutil import copyfile

curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))

to_remove = open(os.path.join(curr_path, "to_remove.txt"), "w")

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
            print "copy", f, "-->", target_file
            copyfile(f, target_file)
            to_remove.write(target_file+"\n")

def check_and_cp():
    for module, path in work_parent():
        check_subdir(module, path, "scripts", ".sh", os.path.join(curr_path, "softcenter", "scripts"))
        check_subdir(module, path, "webs", ".asp", os.path.join(curr_path, "softcenter", "webs"))


check_and_cp()
to_remove.close()

#class unicode(unicode):
#    def __repr__(self):
#        return __builtins__.unicode.__repr__(self).lstrip("u")

#s = {u'F_PARTCODE': u'01b6d356d352d6586l746d056f08', u'F_MRID': u'bcd1841d-6bc2-42d1-a525-d23507dee745', u'F_MR_WARNING': [{u'F_BFGUID': u'b50813cf-4eeb-409e-a09c-076ac754f0fb', u'F_BF_WARNING': [{u'F_DEALWAY': u'3', u'F_RESULT': u'-600.0', u'F_STATUS': u'2', u'F_DATACORRECTION': u'600.0', u'F_WARNINGDESC': u'', u'F_DEALTIME': u'2016-03-26 09:01:25', u'F_STANDARD': u'0.0', u'F_DEALDESC': u'\u7834\u574f\u91cd\u57cb\uff0c\u6dfb\u52a0\u4fee\u6b63\u503c600.0\u6beb\u7c73%yxyx', u'F_WARNINGID': u'013132e1-0700-4cd1-82b2-629fe3eb27e1', u'F_DATAIDS': u'aa48f840-817c-4ef4-aeff-b8098fc0b41e', u'F_WARNTYPE': u'601', u'F_LEVEL': u'01', u'F_DEALER': u'\u6d4b\u8bd5\u6d4b\u91cf\u5458', u'F_WARNINGTIME': u'2016-03-26 09:00:25'}, {u'F_DEALWAY': u'2', u'F_RESULT': u'-700.0', u'F_STATUS': u'2', u'F_DATACORRECTION': u'0.0', u'F_WARNINGDESC': u'', u'F_DEALTIME': u'2016-03-26 09:01:31', u'F_STANDARD': u'0.0', u'F_DEALDESC': u'\u6362\u62f1\uff0c\u6dfb\u52a0\u4fee\u6b63\u503c700.0\u6beb\u7c73%yxyx', u'F_WARNINGID': u'2fb5d8a7-19fa-4788-a26c-5543e0af7f2f', u'F_DATAIDS': u'235f4d46-f2dc-45c6-8af4-f325ff8aa0aa', u'F_WARNTYPE': u'601', u'F_LEVEL': u'01', u'F_DEALER': u'\u6d4b\u8bd5\u6d4b\u91cf\u5458', u'F_WARNINGTIME': u'2016-03-26 09:00:34'}]}]}

#print unicode(s)
#json.dump([s])
#print repr(unicode(s).encode('utf-8'))
#print unicode(s).replace("u'", "'").replace("'",'"')
