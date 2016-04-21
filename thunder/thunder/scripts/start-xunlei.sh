#!/bin/sh
eval `dbus export xunlei`
xunleiPath=/koolshare/xunlei
if [ ! -z "$xunleiPath" ];then
	sleep 10
	$xunleiPath/portal &
fi
