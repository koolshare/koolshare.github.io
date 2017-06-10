#!/bin/sh

rm /koolshare/res/icon-gdddns.png > /dev/null 2>&1
rm /koolshare/webs/Module_gdddns.asp > /dev/null 2>&1
rm /koolshare/scripts/gdddns_config.sh > /dev/null 2>&1
rm /koolshare/scripts/gdddns_update.sh > /dev/null 2>&1
rm /koolshare/scripts/uninstall_gdddns.sh > /dev/null 2>&1

dbus remove __delay__gdddns_timer
dbus remove softcenter_module_gdddns_install
dbus remove softcenter_module_gdddns_version
dbus remove softcenter_module_gdddns_description