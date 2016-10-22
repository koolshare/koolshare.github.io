#!/bin/sh

for line in $(dbus list __event__onssfstart_|cut -d"=" -f2)
do
	if [ `grep -o ss_prestart.sh $line` ];then
		#if [ `dbus get ss_lb_enable` == 1 ];then
		if [ `dbus get ss_basic_server | grep -o "127.0.0.1"` ];then
			sh /koolshare/scripts/ss_lb_config.sh
		fi
	fi
done
