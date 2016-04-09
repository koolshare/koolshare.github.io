#!/bin/sh

#dbus set softcenter_home_url="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui"
#dbus set softcenter_home_url="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui"
dbus set softcenter_home_url="http://koolshare.ngrok.wang:5000"


#test001, normal installing
dbus remove adm_version
dbus remove adm_md5

#export softcenter_installing_module
#export softcenter_installing_tick
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" != "1" ]; then
	echo "test001 failed"
	exit
fi

#test002, normal udpating
dbus set adm_version=0.4

#export softcenter_installing_module
#export softcenter_installing_tick
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" != "1" ]; then
	echo "test002 failed"
	exit
fi


#test003, prefix exists but timeout
dbus set adm_version=0.4

export softcenter_installing_module=shadowvpn
export softcenter_installing_tick=10000
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" != "1" ]; then
	echo "test003 failed"
	exit
fi


#test004, the newest version
dbus set adm_version=0.5

#export softcenter_installing_module=shadowvpn
#export softcenter_installing_tick=10000
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" == "1" ]; then
	echo "test004 failed"
	exit
fi


#test005, prefix installing exits and not timeout
dbus set adm_version=0.4

export softcenter_installing_module=shadowvpn
export softcenter_installing_tick=`date +%s`
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" == "1" ]; then
	echo "test005 failed"
	exit
fi


#test006, home_url timeout
dbus set softcenter_home_url="http://koolshare.ngrok.wang:50000"
dbus set adm_version=0.4

export softcenter_installing_module=
export softcenter_installing_tick=
export softcenter_installing_todo=adm
export softcenter_installing_version=0.5
export softcenter_installing_md5=a9148835ab402d8f1ba920aea40011a3
export softcenter_installing_tar_url="adm/adm.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
echo "result $rlt"
if [ "$rlt" == "1" ]; then
	echo "test006 failed"
	exit
fi
