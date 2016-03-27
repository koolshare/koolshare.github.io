#!/bin/sh

eval `dbus export adm`

if [ -f "/koolshare/adm/adm.sh" ]; then
sh /koolshare/adm/adm.sh update
else
sh /koolshare/adm/adm_install.sh
fi
