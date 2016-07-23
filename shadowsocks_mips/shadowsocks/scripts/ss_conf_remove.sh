#!/bin/sh

confs=`dbus list ss | cut -d "=" -f 1`

for conf in $confs
do
dbus remove $conf
done

dbus set ss_basic_enable="0"

sh /koolshare/ss/stop.sh
