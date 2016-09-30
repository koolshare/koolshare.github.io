#!/bin/sh

MODULE=frpc

cd /
cp -f /tmp/$MODULE/bin/* /koolshare/bin/
cp -f /tmp/$MODULE/scripts/* /koolshare/scripts/
cp -f /tmp/$MODULE/res/* /koolshare/res/
cp -f /tmp/$MODULE/webs/* /koolshare/webs/
rm -fr /tmp/frp* >/dev/null 2>&1
killall ${MODULE}
chmod 755 /koolshare/bin/frpc
chmod 755 /koolshare/scripts/*
sleep 1
dbus set ${MODULE}_version="1.1"
dbus set __event__onwanstart_frpc=/koolshare/scripts/config-frpc.sh
dbus set frpc_client_version=`/koolshare/bin/frpc --version`
dbus set softcenter_module_frpc_install=1
