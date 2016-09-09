#! /bin/sh
eval `dbus export koolproxy`


if [ "$koolproxy_enable" == "1" ];then
	/koolshare/koolproxy/koolproxy.sh restart
else
	/koolshare/koolproxy/koolproxy.sh stop
fi
