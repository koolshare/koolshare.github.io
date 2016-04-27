#!/bin/sh
eval `dbus export speedtest`
source /koolshare/scripts/base.sh
version="0.2.2"
dbus set speedtest_version=$version

#定义更新相关地址
UPDATE_VERSION_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/speedtest/version"
UPDATE_TAR_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/speedtest/speedtest.tar.gz"

#检查版本
check_version(){
	speedtest_version_web1=$(curl -s $UPDATE_VERSION_URL | sed -n 1p)

	if [ ! -z $speedtest_version_web1 ];then
		dbus set speedtest_version_web=$speedtest_version_web1
	fi
}


##测速主逻辑开始

#检查是否在运行
speedtest_is_run=$(ps | grep "/koolshare/bin/speedtest" | grep -v grep)

#判断测速是否正在进行，确保只有一个测速进程
if [ ! -z "$speedtest_is_run" ]; then
	exit 0
fi

#定义测速变量(1、正在测速；0、测速完成)
dbus set speedtest_status=1
dbus ram speedtest_download=0
dbus ram speedtest_upload=0

check_version

#定义测速脚本
SPEEDTEST_CLI=`/koolshare/bin/speedtest 1 2 1 2 2>/dev/null`

echo "$SPEEDTEST_CLI" | while
#/koolshare/bin/speedtest 1 2 1 2 2>/dev/null | while
read line
do
	download=$(echo $line | awk -F 'Download = ' '{print $2}' | grep -oE "[0-9]{1,5}[\.][0-9]{1,2}" | head -n 1)
	upload=$(echo $line | awk -F 'Upload = ' '{print $2}' | grep -oE "[0-9]{1,5}[\.][0-9]{1,2}" | head -n 1)
	if [[ ! -z $download ]]; then
		#echo "download : "$download
		dbus ram speedtest_download=$download
	fi
	if [[ ! -z $upload ]]; then
		#echo "upload : "$upload
		dbus ram speedtest_upload=$upload
	fi
done;

#完成测速
dbus set speedtest_status=0
