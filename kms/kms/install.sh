#!/bin/sh

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	restart=1
	dbus set kms_enable=0
	sh /koolshare/scripts/kms.sh
fi

# cp files
cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

chmod a+x /koolshare/scripts/kms.sh
chmod 0755 /koolshare/bin/vlmcsd

# re-enable kms
if [ "$restart" == "1" ];then
	dbus set kms_enable=1
	sh /koolshare/scripts/kms.sh
fi



