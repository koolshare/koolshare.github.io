#!/bin/sh
eval `dbus export xunlei`
xunleiPath=$xunlei_basic_usb/Merlin_software/xunlei
if [ ! -z "$xunleiPath" ];then
	sleep 10
	$xunleiPath/portal &
fi
