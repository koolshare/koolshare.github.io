#!/bin/sh

#dbus set softcenter_home_url="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui"
#dbus set softcenter_home_url="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui"
dbus set softcenter_home_url="http://koolshare.ngrok.wang:5000"


#test001, normal installing
#dbus remove adm_version
#dbus remove adm_md5

#export softcenter_installing_module
#export softcenter_installing_tick
export softcenter_installing_todo=softcenter
export softcenter_installing_version=0.5
export softcenter_installing_md5=bece216cff0dd25702d49e7b5d093f73
export softcenter_installing_tar_url="softcenter/softcenter.tar.gz"
dbus save softcenter_installing

sh /koolshare/scripts/app_install.sh

rlt=`dbus get softcenter_installing_status`
if [ "$rlt" != "1" ]; then
	echo "test001 failed"
	exit
fi
