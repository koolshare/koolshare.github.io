#!/bin/sh

confs=`cat /tmp/ss_conf_backup.txt`

for conf in $confs
do
dbus set $conf >/dev/null 2>&1
done

sleep 5
rm -rf /tmp/ss_conf_backup.txt
