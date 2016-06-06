#!/bin/sh

cd /tmp

cp -rf /tmp/phddns/init.d/*  /koolshare/init.d/
cp -rf /tmp/phddns/phddns/  /koolshare/
cp -rf /tmp/phddns/res/* /koolshare/res/
cp -rf /tmp/phddns/scripts/* /koolshare/scripts/
cp -rf /tmp/phddns/webs/*  /koolshare/webs/

cd /
rm -rf /tmp/phddns*  >/dev/null 2>&1


if [ -f /koolshare/init.d/S60Phddns.sh ]; then
	rm -rf /koolshare/init.d/S60Phddns.sh
fi

if [ -L /koolshare/init.d/S60Phddns.sh ]; then
	rm -rf /koolshare/init.d/S60Phddns.sh
fi


chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/phddns/*
chmod 755 /koolshare/scripts/*
