#! /bin/sh

eval `dbus export softether`

if [ "$softether_enable" == "1" ];then
	/koolshare/softether/softether.sh restart
else
	/koolshare/softether/softether.sh stop
fi
