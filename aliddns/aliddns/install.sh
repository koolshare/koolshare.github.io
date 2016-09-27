#!/bin/sh

cp -r /tmp/aliddns/* /koolshare/
chmod a+x /koolshare/scripts/aliddns_*

# add icon into softerware center
# dbus set softcenter_module_aliddns_install=1
# dbus set softcenter_module_aliddns_version=0.1
# dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"
