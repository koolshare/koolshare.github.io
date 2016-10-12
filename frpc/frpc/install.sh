#!/bin/sh

MODULE=frpc
VERSION="1.9.1"
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
dbus set ${MODULE}_version="${VERSION}"
#dbus set __event__onwanstart_frpc=/koolshare/scripts/config-frpc.sh
rm -f /koolshare/init.d/S98frpc.sh
ln -s /koolshare/scripts/config-frpc.sh /koolshare/init.d/S98frpc.sh
dbus set frpc_client_version=`/koolshare/bin/frpc --version`
dbus set frpc_common_cron_hour_min="min"
dbus set frpc_common_cron_time="30"
dbus set softcenter_module_frpc_install=1
en=`dbus get ${MODULE}_enable`
if [ "$en" == "1" ]; then
    /koolshare/scripts/config-frpc.sh
fi
