#! /bin/sh
eval `dbus export adbyby`


if [ "$adbyby_enable" == "1" ];then
	/koolshare/adbyby/adbyby.sh restart
else
	/koolshare/adbyby/adbyby.sh stop
fi
