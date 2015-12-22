#!/bin/sh

dbus set tmp_aria2_version=`dbus get aria2_version`

for r in `dbus list aria2|cut -d"=" -f 1`
do
dbus remove $r
done
dbus set aria2_enable=0
sh /jffs/scripts/aria2_run.sh
dbus set aria2_install_status=1
dbus set aria2_version=`dbus get tmp_aria2_version`
dbus remove tmp_aria2_version

