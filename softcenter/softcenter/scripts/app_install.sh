#!/bin/sh

#From dbus to local variable
eval `dbus export softcenter_installing_`

#softcenter_installing_module 	#正在安装的模块
#softcenter_installing_todo 	#希望安装的模块
#softcenter_installing_tick 	#上次安装开始的时间
#softcenter_installing_version 	#正在安装的版本
#softcenter_installing_md5 	#正在安装的版本的md5值
#softcenter_installing_tar_url 	#模块对应的下载地址

#softcenter_installing_status=		#尚未安装
#softcenter_installing_status=0		#尚未安装
#softcenter_installing_status=1		#已安装
#softcenter_installing_status=2		#将被安装到jffs分区...
#softcenter_installing_status=3		#正在下载中...请耐心等待...
#softcenter_installing_status=4		#正在安装中...
#softcenter_installing_status=5		#安装成功！请5秒后刷新本页面！...
#softcenter_installing_status=6		#卸载中......
#softcenter_installing_status=7		#卸载成功！
#softcenter_installing_status=8		#没有检测到在线版本号！
#softcenter_installing_status=9		#正在下载更新......
#softcenter_installing_status=10	#正在安装更新...
#softcenter_installing_status=11	#安装更新成功，5秒后刷新本页！
#softcenter_installing_status=12	#下载文件校验不一致！
#softcenter_installing_status=13	#然而并没有更新！
#softcenter_installing_status=14	#正在检查是否有更新~
#softcenter_installing_status=15	#检测更新错误！

softcenter_home_url=`dbus get softcenter_home_url`
CURR_TICK=`date +%s`

LOGGER() {
	echo $1
#	logger $1
}

if [ "$softcenter_home_url" = "" -o "$softcenter_installing_md5" = "" -o "$softcenter_installing_version" = "" ]; then
	LOGGER "input error, something not found"
	exit 1
fi

if [ "$softcenter_installing_tick" = "" ]; then
	export softcenter_installing_tick=0
fi
LAST_TICK=`expr $softcenter_installing_tick + 20`
if [ "$LAST_TICK" -ge "$CURR_TICK" -a "$softcenter_installing_module" != "" ]; then
	LOGGER "module $softcenter_installing_module is installing"
	exit 2
fi

if [ "$softcenter_installing_todo" = "" ]; then
	#curr module name not found
	LOGGER "module name not found"
	exit 3
fi

# Just ignore the old installing_module
export softcenter_installing_module=$softcenter_installing_todo
export softcenter_installing_tick=`date +%s`

VER_SUFFIX=_version
MD5_SUFFIX=_md5
URL_SPLIT="/"
OLD_MD5=`dbus get $softcenter_installing_module$MD5_SUFFIX`
OLD_VERSION=`dbus get $softcenter_installing_module$VER_SUFFIX`
HOME_URL=`dbus get softcenter_home_url`
TAR_URL=$HOME_URL$URL_SPLIT$softcenter_installing_tar_url
FNAME=`basename $softcenter_installing_tar_url`

#if ["$OLD_MD5" = "$softcenter_installing_md5"]; then
#	LOGGER "md5 not changed $OLD_MD5"
#	exit 0
#fi

if [ "$OLD_VERSION" = "" ]; then
	OLD_VERSION=0
fi

CMP=`versioncmp $softcenter_installing_version $OLD_VERSION`
if [ "$CMP" = "-1" ]; then

#save state
export softcenter_installing_status="2"
dbus save softcenter_installing_

cd /tmp
rm -f $FNAME
rm -rf "/tmp/$softcenter_installing_module"
wget --no-check-certificate --tries=1 --timeout=15 $TAR_URL
md5sum_gz=$(md5sum /tmp/$FNAME | sed 's/ /\n/g'| sed -n 1p)
if [ "$md5sum_gz"x != "$softcenter_installing_md5"x ]; then
	LOGGER "md5 not equal"
	dbus ram softcenter_installing_status="12"
	rm -f $FNAME
	sleep 2
	dbus ram softcenter_installing_status="0"
	dbus set softcenter_installing_module=""
	exit
else
	tar -zxf $FNAME
	dbus ram softcenter_installing_status="4"

	if [ ! -f /tmp/$softcenter_installing_module/install.sh ]; then
		dbus ram softcenter_installing_status="0"
		dbus ram softcenter_installing_module=""
		LOGGER "package hasn't install.sh"
		exit 4
	fi

	chmod a+x /tmp/$softcenter_installing_module/install.sh
	sh /tmp/$softcenter_installing_module/install.sh
	sleep 2

	dbus set softcenter_installing_module=""
	dbus set softcenter_installing_status="1"
	dbus set "$softcenter_installing_module$MD5_SUFFIX=$softcenter_installing_md5"
	dbus set "$softcenter_installing_module$VER_SUFFIX=$softcenter_installing_version"
fi

else
	LOGGER "current version is newest version"
	dbus ram softcenter_installing_status="0"
	dbus ram softcenter_installing_module=""
fi

