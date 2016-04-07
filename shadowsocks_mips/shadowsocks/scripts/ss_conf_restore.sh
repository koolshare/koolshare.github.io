#!/bin/sh

confs=`cat /tmp/ss_conf_backup.txt`
while read conf
do
# echo $conf
dbus set $conf >/dev/null 2>&1
done </tmp/ss_conf_backup.txt

dbus remove ss_basic_state_china
dbus remove ss_basic_foreign_china

sleep 5
rm -rf /tmp/ss_conf_backup.txt
