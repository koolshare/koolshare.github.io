#!/bin/sh

eval `dbus export ssserver`

if [ "$ssserver_enable" == "1" ];then
	/koolshare/ssserver/ssserver.sh restart
fi
