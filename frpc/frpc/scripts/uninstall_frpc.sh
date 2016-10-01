#!/bin/sh

MODULE=frpc

rm -f /koolshare/bin/frpc
rm -f /koolshare/res/frpc-menu.js
rm -f /koolshare/res/icon-frpc.png
rm -f /koolshare/scripts/config-frpc.sh
rm -f /koolshare/webs/Module_frpc.asp
rm -f /koolshare/configs/frpc.ini
rm -fr /tmp/frpc*
values=`dbus list frpc | cut -d "=" -f 1`
   
for value in $values
do                   
dbus remove $value 
done
dbus remove __event__onwanstart_frpc
cru d frpc_monitor
rm -f /koolshare/scripts/uninstall_frpc.sh
