#!/bin/sh

#for aria2 version check
aria2_version_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/version | sed -n 1p)

if [ ! -z $aria2_version_web1 ];then
	dbus set aria2_version_web=$aria2_version_web1
else
	aria2_version_web2=$(curl http://file.mjy211.com/aria2/version | sed -n 1p)
	if [ ! -z $aria2_version_web2 ];then
		dbus set aria2_version_web=$aria2_version_web2
	else
		aria2_version_web3=$(curl http://file.fancyss.com/aria2/version | sed -n 1p)
		if [ ! -z $aria2_version_web3 ];then
			dbus set aria2_version_web=$aria2_version_web3
		else
			dbus set aria2_version_web="check failed"
		fi
	fi
fi
