#! /bin/sh
cd /tmp
cp -rf /tmp/koolproxy/koolproxy /koolshare/
cp -rf /tmp/koolproxy/scripts/* /koolshare/scripts/
cp -rf /tmp/koolproxy/webs/* /koolshare/webs/
cp -rf /tmp/koolproxy/res/* /koolshare/res/
cp -rf /tmp/koolproxy/perp/koolproxy /koolshare/perp/
cd /
rm -rf /tmp/koolproxy* >/dev/null 2>&1


chmod 755 /koolshare/koolproxy/*
chmod 755 /koolshare/scripts/*
chmod 755 /koolshare/perp//koolproxy/*


