#!/bin/sh

eval `dbus export adm`

if [ -f "/koolshare/adm/adm.sh" ]; then
	sh /koolshare/adm/adm.sh uninstall
else
	for value in `dbus list adm|cut -d "=" -f 1`
	do
		dbus remove $value
	done
fi
