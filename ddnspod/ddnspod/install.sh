#!/bin/sh

if [ ! -d /koolshare/ddnspod ]; then
   mkdir -p /koolshare/ddnspod
fi

cp -rf /tmp/ddnspod/scripts/* /koolshare/scripts/
cp -rf /tmp/ddnspod/webs/* /koolshare/webs/
cp -rf /tmp/ddnspod/res/* /koolshare/res/
cp -rf /tmp/ddnspod/init.d/* /koolshare/init.d/
cp -rf /tmp/ddnspod/ddnspod/ddnspod.sh /koolshare/ddnspod/
rm -rf /tmp/ddnspod* >/dev/null 2>&1

chmod a+x /koolshare/scripts/ddnspod_config.sh
chmod a+x /koolshare/ddnspod/ddnspod.sh
chmod a+x /koolshare/init.d/S99ddnspod.sh
