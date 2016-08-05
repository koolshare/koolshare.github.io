#!/bin/sh

# remove all files
rm -rf /koolshare/bin/kcp_router
rm -rf /koolshare/kcptun
rm -rf /koolshare/webs/Module_kcptun.asp
rm -rf /koolshare/perp/kcptun
rm -rf /koolshare/res/icon-kcp.png
rm -rf /koolshare/scripts/kcp_config.sh
rm -rf /koolshare/scripts/uninstall_kcptun.sh

# remvoe all values
values=`dbus list KCP | cut -d "=" -f 1`
   
for value in $values
do                   
dbus remove $value 
done

