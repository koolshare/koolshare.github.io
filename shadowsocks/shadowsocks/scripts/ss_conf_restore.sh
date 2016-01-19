#!/bin/sh

confs=`cat /tmp/ss_conf_backup.txt`

for conf in $confs
do
dbus set $conf >/dev/null 2>&1
done

dbus remove ss_basic_state_china
dbus remove ss_basic_foreign_china

sleep 5
rm -rf /tmp/ss_conf_backup.txt
