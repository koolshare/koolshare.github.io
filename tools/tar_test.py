#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import tarfile
tar = tarfile.open("sample.tar.gz", "w:gz")
for name in ["../softether/Changelog.txt", "../softether/config.json.js", "../softether/build.sh"]:
    tar.add(name)
tar.close()
