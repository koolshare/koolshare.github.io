#! /bin/sh
cd /tmp
cp -rf /tmp/koolsocks/ss/* /koolshare/ss/
cp -rf /tmp/koolsocks/webs/* /koolshare/webs/
cp -rf /tmp/koolsocks/res/* /koolshare/res/
cp -rf /tmp/koolsocks/scripts/* /koolshare/scripts/
cp -rf /tmp/koolsocks/bin/* /koolshare/bin/
cp -rf /tmp/koolsocks/init.d/* /koolshare/init.d/
rm -rf /tmp/koolsocks* >/dev/null 2>&1

# no use since version 1.0.0
rm -rf /koolshare/ss/ssconfig
rm -rf /koolshare/ss/socks5config


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

rm -rf /tmp/koolsocks*

