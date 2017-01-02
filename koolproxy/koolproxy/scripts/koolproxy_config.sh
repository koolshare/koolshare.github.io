#! /bin/sh
eval `dbus export koolproxy`


if [ "$koolproxy_enable" == "1" ];then
	sh /koolshare/koolproxy/koolproxy.sh restart
else
	sh /koolshare/koolproxy/koolproxy.sh stop
fi
