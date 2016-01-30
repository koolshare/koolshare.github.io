#!/bin/sh

if [ ! -d /jffs/configs/game.d ]; then 
   mkdir -p /jffs/configs/game.d
fi

cp -rf /tmp/shadowvpn/scripts/* /koolshare/scripts/
cp -rf /tmp/shadowvpn/webs/* /koolshare/webs/
cp -rf /tmp/shadowvpn/game.d/* /jffs/configs/game.d/
rm -rf /tmp/shadowvpn >/dev/null 2>&1

chmod a+x /tmp/shadowvpn/scripts/*
chmod a+x /tmp/shadowvpn/webs/*
