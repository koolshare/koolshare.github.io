#! /bin/sh
cd /tmp
cp -rf /tmp/ssserver/ssserver /koolshare/
cp -rf /tmp/ssserver/scripts/* /koolshare/scripts/
cp -rf /tmp/ssserver/webs/* /koolshare/webs/
cp -rf /tmp/ssserver/init.d/* /koolshare/init.d/
cp -rf /tmp/ssserver/res/* /koolshare/res/
cd /
rm -rf /tmp/ssserver* >/dev/null 2>&1



chmod 755 /koolshare/ssserver/*
chmod 755 /koolshare/bin/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/*

