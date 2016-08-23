#! /bin/sh
cd /tmp
cp -rf /tmp/shadowsocks/ss/* /koolshare/ss/
cp -rf /tmp/shadowsocks/webs/* /koolshare/webs/
cp -rf /tmp/shadowsocks/res/* /koolshare/res/
cp -rf /tmp/shadowsocks/scripts/* /koolshare/scripts/
cp -rf /tmp/shadowsocks/bin/* /koolshare/bin/
cp -rf /tmp/shadowsocks/init.d/* /koolshare/init.d/
rm -rf /tmp/shadowsocks* >/dev/null 2>&1

# no use since version 1.0.0
rm -rf /koolshare/ss/ssconfig
rm -rf /koolshare/ss/socks5config

# no use sice version 2.0
rm -rf /koolshare/ss/kcptun

chmod 755 /koolshare/ss/game/*
chmod 755 /koolshare/ss/koolgame/*
chmod 755 /koolshare/ss/ipset/*
chmod 755 /koolshare/ss/redchn/*
chmod 755 /koolshare/ss/overall/*
chmod 755 /koolshare/ss/cru/*
chmod 755 /koolshare/ss/dns/*
chmod 755 /koolshare/ss/socks5/*
chmod 755 /koolshare/ss/*.sh
chmod 755 /koolshare/scripts/*
chmod 755 /koolshare/bin/*

# add icon into softerware center
dbus set softcenter_module_koolsocks_install=1

dbus set softcenter_module_koolsocks_version=1.3
