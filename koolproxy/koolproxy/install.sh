#! /bin/sh
eval `dbus export koolproxy`

# stop first
dbus set koolproxy_enable=0
[ -f /koolshare/koolproxy/koolproxy.sh ] && sh /koolshare/koolproxy/koolproxy.sh stop
[ -f /koolshare/koolproxy/kp_config.sh ] && sh /koolshare/koolproxy/kp_config.sh stop

# remove old files
rm -rf /koolshare/bin/koolproxy >/dev/null 2>&1
rm -rf /koolshare/koolproxy/koolproxy.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/kp_config.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/nat_load.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/1.dat >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/koolproxy.txt >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/version >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /koolshare/koolproxy
mkdir -p /koolshare/koolproxy/data
cp -rf /tmp/koolproxy/bin/* /koolshare/bin/
cp -rf /tmp/koolproxy/scripts/* /koolshare/scripts/
cp -rf /tmp/koolproxy/webs/* /koolshare/webs/
cp -rf /tmp/koolproxy/res/* /koolshare/res/
cp -rf /tmp/koolproxy/koolproxy/kp_config.sh /koolshare/koolproxy/
cp -rf /tmp/koolproxy/koolproxy/data/1.dat /koolshare/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/koolproxy.txt /koolshare/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/koolproxy_ipset.conf /koolshare/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/gen_ca.sh /koolshare/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/openssl.cnf /koolshare/koolproxy/data/
cp -rf /tmp/koolproxy/koolproxy/data/version /koolshare/koolproxy/data/
if [ ! -f /koolshare/koolproxy/data/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
else
	mv /koolshare/koolproxy/data/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
	mv /tmp/user.txt.tmp /koolshare/koolproxy/data/user.txt
fi
if [ ! -d /koolshare/koolproxy/data/certs ];then
	cp -rf /tmp/koolproxy/koolproxy/data/certs /koolshare/koolproxy/data/
fi
if [ ! -d /koolshare/koolproxy/data/certs ];then
	cp -rf /tmp/koolproxy/koolproxy/data/private /koolshare/koolproxy/data/
fi

cp -f /tmp/koolproxy/uninstall.sh /koolshare/scripts/uninstall_koolproxy.sh


cd /

chmod 755 /koolshare/bin/koolproxy
chmod 755 /koolshare/koolproxy/*
chmod 755 /koolshare/koolproxy/data/*
chmod 755 /koolshare/scripts/*

rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_policy" ] && dbus set koolproxy_policy=1
[ -z $koolproxy_acl_default_mode ] && dbus set koolproxy_acl_default_mode=1


dbus set koolproxy_rule_info=`cat /koolshare/koolproxy/data/version | awk 'NR==2{print}'`
dbus set koolproxy_video_info=`cat /koolshare/koolproxy/data/version | awk 'NR==4{print}'`
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.2.2
dbus set koolproxy_version=3.2.2

