#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
env http_proxy=socks5://localhost:23456 /usr/sbin/curl  http://www.facebook.com

if [ "$?" == "0" ]; then
	log='<font color='#fc0'>国外连接 - [ '$LOGTIME' ] ✓</font>'
else
	log='<font color='#FF5722'>国外连接 - [ '$LOGTIME' ] X</font>'
fi

nvram set ss_foreign_state="$log"
#dbus ram ss_basic_state_foreign="$log"
