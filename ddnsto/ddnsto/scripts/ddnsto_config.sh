#!/bin/sh
eval `dbus export ddnsto`
source /koolshare/scripts/base.sh

case $ACTION in
start)
	if [ "$ddnsto_enable" == "1" ];then
		ddnsto -u $ddnsto_name -p $ddnsto_password -d
	fi
	;;
*)
	if [ "$ddnsto_enable" == "1" ];then
		killall ddnsto
		ddnsto -u $ddnsto_name -p $ddnsto_password -d
	else
		killall ddnsto
	fi
	;;
esac