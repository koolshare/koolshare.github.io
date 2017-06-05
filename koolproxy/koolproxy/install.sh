#! /bin/sh
eval `dbus export koolproxy`

# stop first
dbus set koolproxy_enable=0
[ -f /koolshare/koolproxy/koolproxy.sh ] && sh /koolshare/koolproxy/koolproxy.sh stop
[ -f /koolshare/koolproxy/kp_config.sh ] && sh /koolshare/koolproxy/kp_config.sh stop
# remove old files
rm -rf /koolshare/bin/koolproxy >/dev/null 2>&1
rm -rf /koolshare/koolproxy/koolproxy.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/nat_load.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/*.dat >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/*.txt >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/*.conf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/version >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/serial >/dev/null 2>&1
rm -rf /koolshare/koolproxy/rule_store >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/1.dat >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /koolshare/koolproxy
mkdir -p /koolshare/koolproxy/data
cp -rf /tmp/koolproxy/scripts/* /koolshare/scripts/
cp -rf /tmp/koolproxy/webs/* /koolshare/webs/
cp -rf /tmp/koolproxy/res/* /koolshare/res/
if [ ! -f /koolshare/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
else
	mv /koolshare/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
	mv /tmp/user.txt.tmp /koolshare/koolproxy/data/rules/user.txt
fi

cp -f /tmp/koolproxy/uninstall.sh /koolshare/scripts/uninstall_koolproxy.sh


cd /

chmod 755 /koolshare/koolproxy/koolproxy
chmod 755 /koolshare/koolproxy/*
chmod 755 /koolshare/koolproxy/data/*
chmod 755 /koolshare/scripts/*
[ ! -L "/koolshare/bin/koolproxy" ] && ln -sf /koolshare/koolproxy/koolproxy /koolshare/bin/koolproxy

rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_policy" ] && dbus set koolproxy_policy=1
[ -z "$koolproxy_acl_default_mode" ] && dbus set koolproxy_acl_default_mode=1

dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.3.7
dbus set koolproxy_version=3.3.7

