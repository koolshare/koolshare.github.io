#!/bin/sh


eval `dbus export adm`

if [ "$adm_enable" == "1" ];then
	/koolshare/adm/adm.sh restart
else
	/koolshare/adm/adm.sh stop
fi 