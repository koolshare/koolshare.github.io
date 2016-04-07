#! /bin/sh
cd /tmp
cp -rf /tmp/shadowsocks/ss/* /koolshare/ss/
cp -rf /tmp/shadowsocks/webs/* /koolshare/webs/
cp -rf /tmp/shadowsocks/res/* /koolshare/res/
cp -rf /tmp/shadowsocks/scripts/* /koolshare/scripts/
cp -rf /tmp/shadowsocks/bin/* /koolshare/bin/
cp -rf /tmp/shadowsocks/init.d/* /koolshare/init.d/
rm -rf /tmp/shadowsocks* >/dev/null 2>&1


chmod 755 /koolshare/ss/ipset/*
chmod 755 /koolshare/ss/redchn/*
chmod 755 /koolshare/ss/overall/*
chmod 755 /koolshare/ss/cru/*
chmod 755 /koolshare/ss/dns/*
chmod 755 /koolshare/ss/socks5/*
chmod 755 /koolshare/ss/*.sh
chmod 755 /koolshare/scripts/*
chmod 755 /koolshare/bin/*

cd /

