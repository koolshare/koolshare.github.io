#!/bin/sh

eval `dbus export ss`

if [ "$ss_basic_enable" == "1" ];then
	/koolshare/ss/ssconfig.sh restart
else
	/koolshare/ss/ssconfig.sh stop
fi 
