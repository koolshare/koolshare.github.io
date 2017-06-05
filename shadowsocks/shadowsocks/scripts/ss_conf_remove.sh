#!/bin/sh

confs=`dbus list ss | cut -d "=" -f 1 | grep -v "version" | grep -v "ss_basic_state_china" | grep -v "ss_basic_state_foreign"`

for conf in $confs
do
dbus remove $conf
done

dbus set ss_basic_enable="0"
dbus set ss_basic_version_local=`cat /koolshare/ss/version` 
sh /koolshare/ss/stop.sh stop_all
