#!/bin/sh

eval `dbus export ss`

if [ "$ss_basic_enable" == "1" ];then
	sh /koolshare/ss/ssconfig.sh restart
else
	sh /koolshare/ss/ssconfig.sh stop
fi

#echo 'XU6J03M6' >> /tmp/syscmd.log
