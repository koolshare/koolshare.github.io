#! /bin/sh
cd /tmp
cp -rf /tmp/swap/swap /koolshare/
cp -rf /tmp/swap/scripts/* /koolshare/scripts/
cp -rf /tmp/swap/webs/* /koolshare/webs/
cp -rf /tmp/swap/res/* /koolshare/res/
cd /
rm -rf /tmp/swap* >/dev/null 2>&1


chmod 755 /koolshare/swap/*
chmod 755 /koolshare/scripts/swap*

