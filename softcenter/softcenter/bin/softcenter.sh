#!/bin/sh

eval `dbus export softcenter`
source /koolshare/scripts/base.sh

VER=1.0.1

UPDATE_VERSION_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/softcenter/version"
UPDATE_TAR_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/softcenter/softcenter.tar.gz"

module_tunnel_set() {
	#0: release, 1: beta, 2: devel
	export softcenter_module_tunnel=0

	#User can hidden some app by this flag
	#export softcenter_module_tunnel_visible=1

	#TODO update script for all modules
	export softcenter_module_tunnel_ver=1.0.0
	export softcenter_module_tunnel_ver_url=
	export softcenter_module_tunnel_tar_url=

	#TODO preinstall scripts, do we need it???
	#export softcenter_module_tunnel_preinstall=
}

module_shadowvpn_set() {
	export softcenter_module_shadowvpn=0
}

module_koolnet_set() {
	export softcenter_module_koolnet=0
}

module_kuainiao_set() {
	export softcenter_module_kuainiao=0
}

module_xunlei_set() {
	export softcenter_module_xunlei=0
}

module_v2ray_set() {
	export softcenter_module_v2ray=0
}

module_aria2_set() {
	export softcenter_module_aria2=0
}

module_policy_set() {
	export softcenter_module_policy=0
}

module_check_and_set() {
	if [ -z $softcenter_curr_version ]; then
		export softcenter_curr_version=0.0.1
	fi
	cmp=`versioncmp $VER $softcenter_curr_version`
	if [ "$cmp" = "-1" ]; then
	module_tunnel_set
	module_koolnet_set
	module_shadowvpn_set
	module_kuainiao_set
	module_xunlei_set
	module_v2ray_set
	module_aria2_set
	module_policy_set
	export softcenter_curr_version=$VER
	dbus save softcenter
	fi
}

update_softcenter() {
	version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $version_web1 ]; then
		cmp=`versioncmp $version_web1 $VER`
		dbus set softcenter_install_status=0
		if [ "$cmp" = "-1" ];then
			cd /tmp
			md5_web1=`curl -s $UPDATE_VERSION_URL | sed -n 2p`
			wget --no-check-certificate --tries=1 --timeout=15 $UPDATE_TAR_URL
			md5sum_gz=`md5sum /tmp/softcenter.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				dbus set softcenter_install_status=4
			else
				tar -zxf softcenter.tar.gz 
				dbus set softcenter_install_status=5
				cp /tmp/softcenter/bin/softcenter.sh /koolshare/bin/
				chmod 755 /koolshare/bin/softcenter.sh
				/koolshare/bin/softcenter.sh install
			fi
		fi
	fi
}

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* /koolshare/webs
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		rm -rf /tmp/softcenter
		if [ ! -f "/koolshare/init.d/S10Softcenter.sh" ]; then
		ln -sf /koolshare/bin/softcenter.sh /koolshare/init.d/S10Softcenter.sh
		fi
	fi
}

case $ACTION in
start)
	module_check_and_set
	;;
update)
	update_softcenter
	;;
install)
	softcenter_install
	;;
*)
        echo "Usage: $0 (start|update|install)" 
        exit 1                                                                                                   
        ;;                                                                                                       
esac  
