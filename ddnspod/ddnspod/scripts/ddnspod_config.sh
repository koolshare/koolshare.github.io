#!/bin/sh


eval `dbus export ddnspod`

if [ "$ddnspod_enable" == "1" ];then
	/koolshare/ddnspod/ddnspod.sh restart
else
	/koolshare/ddnspod/ddnspod.sh stop
fi 
