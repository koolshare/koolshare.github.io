#!/bin/sh

cp -r /tmp/gdddns/res/* /koolshare/res
cp -r /tmp/gdddns/scripts/* /koolshare/scripts
cp -r /tmp/gdddns/webs/* /koolshare/webs

chmod a+x /koolshare/scripts/gdddns_*

# add icon into softerware center
dbus set softcenter_module_gdddns_install=1
dbus set softcenter_module_gdddns_version=1.0.0
dbus set softcenter_module_gdddns_description="Godaddy DDNS"
