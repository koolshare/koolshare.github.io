#! /bin/sh
cd /tmp
cp -rf /tmp/thunder/thunder /koolshare/
cp -rf /tmp/thunder/scripts/* /koolshare/scripts/
cp -rf /tmp/thunder/webs/* /koolshare/webs/
cp -rf /tmp/thunder/init.d/* /koolshare/init.d/
cp -rf /tmp/thunder/res/* /koolshare/res/
cd /
rm -rf /tmp/thunder* >/dev/null 2>&1

if [ -f /koolshare/init.d/S70Thunder.sh ];then
	rm -rf /koolshare/init.d/S70Thunder.sh
fi

if [ -L /koolshare/init.d/S70Thunder.sh ];then
	rm -rf /koolshare/init.d/S70Thunder.sh
fi

rm -rf /koolshare/init.d/S91thunder.sh
dbus remove __event__onwanstart_wan-start

chmod 755 /koolshare/thunder/*
chmod 755 /koolshare/scripts/*

