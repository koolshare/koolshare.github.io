#!/bin/sh
dbus set kms_version="0.1"
dbus set softcenter_module_kms_version="0.1"
dbus set softcenter_module_kms_description="Office自动激活工具"

cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/

rm -rf /tmp/kms* >/dev/null 2>&1

chmod a+x /koolshare/scripts/kms.sh
