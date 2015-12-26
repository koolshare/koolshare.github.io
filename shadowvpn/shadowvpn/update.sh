#!/bin/sh

if [ ! -d /jffs/webs ]; then 
    mkdir -p /jffs/webs
fi
if [ ! -d /jffs/scripts ]; then 
   mkdir -p /jffs/scripts
fi
if [ ! -d /jffs/configs/game.d ]; then 
   mkdir -p /jffs/configs/game.d
fi
chmod a+x /tmp/shadowvpn/scripts/*
chmod a+x /tmp/shadowvpn/webs/*
cp -rf /tmp/shadowvpn/scripts/* /jffs/scripts/
cp -rf /tmp/shadowvpn/webs/* /jffs/webs/
cp -rf /tmp/shadowvpn/game.d/* /jffs/configs/game.d/
rm -rf /tmp/shadowvpn >/dev/null 2>&1
