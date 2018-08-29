#!/bin/sh

cp -r /tmp/aliddns/* /koolshare/
chmod a+x /koolshare/scripts/aliddns_*

rm -rf /koolshare/install.sh

# add icon into softerware center
# dbus set softcenter_module_aliddns_install=1
# dbus set softcenter_module_aliddns_version=0.4
# dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"
