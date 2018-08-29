#!/bin/sh

if [ ! -d /koolshare/appledns ]; then
   mkdir -p /koolshare/appledns
fi

rm /koolshare/appledns/*
cp -rf /tmp/appledns/scripts/appledns.sh /koolshare/scripts/appledns.sh
cp -rf /tmp/appledns/webs/Module_appledns.asp /koolshare/webs/Module_appledns.asp
cp -rf /tmp/appledns/appledns/* /koolshare/appledns/
cp /tmp/appledns/res/* /koolshare/res/

rm -rf /tmp/appledns* >/dev/null 2>&1

chmod a+x /koolshare/scripts/appledns.sh
