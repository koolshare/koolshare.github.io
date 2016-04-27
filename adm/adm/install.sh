#! /bin/sh
cd /tmp
cp -rf /tmp/adm/adm /koolshare/
cp -rf /tmp/adm/scripts/* /koolshare/scripts/
cp -rf /tmp/adm/webs/* /koolshare/webs/
cp -rf /tmp/adm/init.d/* /koolshare/init.d/
cp -rf /tmp/adm/res/* /koolshare/res/
cd /
rm -rf /tmp/adm* >/dev/null 2>&1

if [ -L /koolshare/init.d/S60Adm.sh ];then
	rm -rf /koolshare/init.d/S60Adm.sh
fi

chmod 755 /koolshare/adm/*
chmod 755 /koolshare/bin/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/*

