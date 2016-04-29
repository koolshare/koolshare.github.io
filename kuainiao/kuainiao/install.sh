#!/bin/sh

if [ ! -d /koolshare/kuainiao ]; then
   mkdir -p /koolshare/kuainiao
fi

cp -rf /tmp/kuainiao/scripts/* /koolshare/scripts/
cp -rf /tmp/kuainiao/webs/* /koolshare/webs/
cp -rf /tmp/kuainiao/res/* /koolshare/res/
cp -rf /tmp/kuainiao/scripts/kuainiao.sh /koolshare/kuainiao/
rm -rf /tmp/kuainiao* >/dev/null 2>&1

chmod a+x /koolshare/scripts/config-kuainiao.sh
chmod a+x /koolshare/kuainiao/kuainiao.sh
