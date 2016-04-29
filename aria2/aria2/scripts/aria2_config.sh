#!/bin/sh
eval `dbus export aria2`

if [ $aria2_enable = 1 ];then
	sh /koolshare/aria2/aria2_run.sh restart
else
	sh /koolshare/aria2/aria2_run.sh stop
fi
