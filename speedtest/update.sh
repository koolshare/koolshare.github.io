#!/bin/sh

cp -rf /tmp/speedtest/speedtest.sh /koolshare/scripts/
cp -rf /tmp/speedtest/speedtest /koolshare/bin/
cp -rf /tmp/speedtest/Module_speedtest.asp /koolshare/webs/
rm -rf /tmp/speedtest* >/dev/null 2>&1

chmod a+x /koolshare/scripts/speedtest.sh
chmod a+x /koolshare/bin/speedtest
