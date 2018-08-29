#!/bin/sh

if [ "`dbus get gdddns_enable`" == "1" ]; then
    dbus delay gdddns_timer `dbus get gdddns_interval` /koolshare/scripts/gdddns_update.sh
else
    dbus remove __delay__gdddns_timer
fi
