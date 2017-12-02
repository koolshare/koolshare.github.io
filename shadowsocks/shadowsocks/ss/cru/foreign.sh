#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
/usr/sbin/wget -4 --spider --quiet --timeout=4 www.google.com.tw

if [ "$?" == "0" ]; then
	log='<font color='#fc0'>国外连接 - [ '$LOGTIME' ] ✓</font>'
else
	log='<font color='#FF5722'>国外连接 - [ '$LOGTIME' ] X</font>'
fi

nvram set ss_foreign_state="$log"
#dbus ram ss_basic_state_foreign="$log"
