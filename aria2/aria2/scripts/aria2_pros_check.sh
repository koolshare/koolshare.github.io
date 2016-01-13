#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
lighttpd_run=$(ps|grep lighttpd|grep -v grep)
if [ ! -z "$lighttpd_run" ];then
	echo lighttpd is running!
	logger [ '$LOGTIME' ] lighttpd is running!
else
	logger [ '$LOGTIME' ] start aria2c...
	/koolshare/aria2/aria2c --conf-path=/koolshare/aria2/aria2.conf -D
fi

aria2_run=$(ps|grep aria2c|grep -v grep)
if [ ! -z "$aria2_run" ];then
	echo aria2c is running!
	logger [ '$LOGTIME' ] aria2c is running!
else
	logger [ '$LOGTIME' ] start aria2c...
	/usr/sbin/lighttpd -f /jffs/www/aria2c.conf
fi

