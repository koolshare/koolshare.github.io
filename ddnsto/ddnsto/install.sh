#!/bin/sh

if [ ! -d /koolshare/ddnsto ]; then
   mkdir -p /koolshare/ddnsto
fi

cp -rf /tmp/ddnsto/bin/* /koolshare/bin/
cp -rf /tmp/ddnsto/scripts/* /koolshare/scripts/
cp -rf /tmp/ddnsto/webs/* /koolshare/webs/
cp -rf /tmp/ddnsto/res/* /koolshare/res/
cp -rf /tmp/ddnsto/init.d/* /koolshare/init.d/
cp -rf /tmp/ddnsto/uninstall.sh /koolshare/scripts/uninstall_ddnsto.sh

chmod +x /koolshare/bin/ddnsto
chmod +x /koolshare/scripts/ddnsto_config.sh

[ ! -L "/koolshare/init.d/S70ddnsto.sh" ] && ln -sf /koolshare/scripts/ddnsto_config.sh /koolshare/init.d/S70ddnsto.sh
cp 

# for offline insall
dbus set softcenter_module_ddnsto_install=1
dbus set softcenter_module_ddnsto_name=ddnsto
dbus set softcenter_module_ddnsto_version=1.1
dbus set softcenter_module_ddnsto_title="ddnsto内网穿透"
dbus set softcenter_module_ddnsto_description="ddnsto：koolshare小宝开发的基于http2的快速穿透。"
