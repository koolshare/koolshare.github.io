#! /bin/sh
cd /tmp
cp -rf /tmp/ssid/ssid /koolshare/
cp -rf /tmp/ssid/scripts/* /koolshare/scripts/
cp -rf /tmp/ssid/webs/* /koolshare/webs/
cp -rf /tmp/ssid/res/* /koolshare/res/
cp -rf /tmp/ssid/init.d/* /koolshare/init.d/
cd /
rm -rf /tmp/ssid* >/dev/null 2>&1


chmod 755 /koolshare/ssid/*
chmod 755 /koolshare/scripts/ssid*
chmod 755 /koolshare/init.d/ssid*

