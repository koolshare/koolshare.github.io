#!/bin/sh

if [ "`dbus get aliddns_enable`" = "1" ]; then
    dbus delay aliddns_timer `dbus get aliddns_interval` /koolshare/scripts/aliddns_update.sh
    # run once after submit
	sleep 2
	sh /koolshare/scripts/aliddns_update.sh
else
    dbus remove __delay__aliddns_timer
    nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
fi
