#!/bin/sh
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh
ss_basic_version_local=`cat /koolshare/ss/version`
dbus set ss_basic_version_local=$ss_basic_version_local

# set default vaule
set_default_value(){
if [ -z $ss_ipset_cdn_dns ];then
	dbus set ss_ipset_cdn_dns="1"
	dbus set ss_ipset_foreign_dns="2"
	dbus set ss_ipset_dns2socks_user="8.8.8.8:53"
	dbus set ss_ipset_opendns="opendns"
	dbus set ss_ipset_tunnel="2"
	dbus set ss_redchn_dns_china="1"
	dbus set ss_redchn_dns_foreign="4"
	dbus set ss_redchn_dns2socks_user="8.8.8.8:53"
	dbus set ss_redchn_opendns="opendns"
	dbus set ss_redchn_sstunnel="2"
	dbus set ss_redchn_chinadns_china="1"
	dbus set ss_redchn_chinadns_foreign="2"
	dbus set ss_game_dns_china="1"
	dbus set ss_game_dns_foreign="4"
	dbus set ss_game_dns2socks_user="8.8.8.8:53"
	dbus set ss_game_opendns="opendns"
	dbus set ss_game_sstunnel="2"
	dbus set ss_game_chinadns_china="1"
	dbus set ss_game_chinadns_foreign="2"
	dbus set ss_overall_mode="1"
	dbus set ss_overall_dns="0"
	dbus set ss_basic_adblock="0"
fi
if [ -z $ss_gameV2_dns2ss_user ];then
	dbus set ss_gameV2_dns2ss_user="8.8.8.8:53"
	dbus set ss_gameV2_dns_china="1"
fi
}

# creat dnsmasq.d folder
creat_folder(){
if [ ! -d /koolshare/configs/dnsmasq.d ];then
	mkdir /koolshare/configs/dnsmasq.d
fi
}

install_ss(){
	tar -zxf shadowsocks.tar.gz
	dbus set ss_basic_install_status="2"
	chmod a+x /tmp/shadowsocks/install.sh
	/tmp/shadowsocks/install.sh
	dbus set ss_basic_version_local=$ss_basic_version_web1
	sleep 2
	dbus set ss_basic_install_status="3"
	sleep 2
	dbus set ss_basic_install_status="0"
	rm -rf /tmp/shadowsocks* >/dev/null 2>&1
	exit
}


# update ss
update_ss(){
	# ss_basic_install_status=	#
	# ss_basic_install_status=0	#
	# ss_basic_install_status=1	#正在下载更新......
	# ss_basic_install_status=2	#正在安装更新...
	# ss_basic_install_status=3	#安装更新成功，5秒后刷新本页！
	# ss_basic_install_status=4	#下载文件校验不一致！
	# ss_basic_install_status=5	#然而并没有更新！
	# ss_basic_install_status=6	#正在检查是否有更新~
	# ss_basic_install_status=7	#检测更新错误！
	# ss_basic_install_status=8	#更换更新服务器
	
	dbus set ss_basic_install_status="6"
	ss_basic_version_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks_mips/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web1 ];then
		dbus set ss_basic_version_web=$ss_basic_version_web1
		if [ "$ss_basic_version_local" != "$ss_basic_version_web1" ];then
			dbus set ss_basic_install_status="1"
			cd /tmp
			md5_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks_mips/version | sed -n 2p`
			wget --no-check-certificate --timeout=15 https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks_mips/shadowsocks.tar.gz
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				dbus set ss_basic_install_status="4"
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 2
				dbus set ss_basic_install_status="8"
				sleep 2
				update_ss2
			else
				install_ss
			fi
		else
			dbus set ss_basic_install_status="5"
			sleep 2
			dbus set ss_basic_install_status="0"
			exit
		fi
	else
		dbus set ss_basic_install_status="7"
		sleep 2
		dbus set ss_basic_install_status="8"
		sleep 2
		update_ss2
	fi
	dbus save ssconf
}


update_ss2(){
	# ss_basic_install_status=	#
	# ss_basic_install_status=0	#
	# ss_basic_install_status=1	#正在下载更新......
	# ss_basic_install_status=2	#正在安装更新...
	# ss_basic_install_status=3	#安装更新成功，5秒后刷新本页！
	# ss_basic_install_status=4	#下载文件校验不一致！
	# ss_basic_install_status=5	#然而并没有更新！
	# ss_basic_install_status=6	#正在检查是否有更新~
	# ss_basic_install_status=7	#检测更新错误！
	# ss_basic_install_status=8	#更换奔涌更新服务器1
	
	dbus set ss_basic_install_status="6"
	ss_basic_version_web2=`curl -s http://file.mjy211.com/koolshare.github.io/shadowsocks_mips/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web2 ];then
		dbus set ss_basic_version_web=$ss_basic_version_web2
		if [ "$ss_basic_version_local" != "$ss_basic_version_web2" ];then
			dbus set ss_basic_install_status="1"
			cd /tmp
			md5_web2=`curl -s http://file.mjy211.com/koolshare.github.io/shadowsocks_mips/version | sed -n 2p`
			wget --no-check-certificate --timeout=15 http://file.mjy211.com/koolshare.github.io/shadowsocks_mips/shadowsocks.tar.gz
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web2" ]; then
				dbus set ss_basic_install_status="4"
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 5
				dbus set ss_basic_install_status="0"
				exit
			else
				install_ss
			fi
		else
			dbus set ss_basic_install_status="5"
			sleep 2
			dbus set ss_basic_install_status="0"
			exit
		fi
	else
		dbus set ss_basic_install_status="7"
		sleep 5
		dbus set ss_basic_install_status="0"
		exit
	fi
	dbus save ssconf
}


# Decteting if jffs partion is enabled
enable_jffs2(){
	if [ ! -d /jffs/scripts ]
	then
	  nvram set jffs2_on=1
	  nvram set jffs2_format=1
	  nvram set jffs2_scripts=1
	  nvram commit
	  echo You have to reboot the router and try again. Exiting...
	  exit 1
	fi
	
	jffs2_script=`nvram get jffs2_scripts`
	if [ "$jffs2_script" != "1" ]
	then
	  nvram set jffs2_on=1
	  nvram set jffs2_scripts=1
	  nvram commit
	  echo "auto enable jffs2 scripts"
	fi
}

# Enable service by user choose
apply_ss(){
	if [ "1" == "$ss_basic_mode" ]; then
		. /koolshare/ss/stop.sh
		. /koolshare/ss/ipset/start.sh
	elif [ "2" == "$ss_basic_mode" ]; then
		. /koolshare/ss/stop.sh
		. /koolshare/ss/redchn/start.sh
	elif [ "5" == "$ss_basic_mode" ]; then
		. /koolshare/ss/stop.sh
		. /koolshare/ss/overall/start.sh
	fi
}

disable_ss(){
	. /koolshare/ss/stop.sh
}


# write number into nvram with no commit
write_numbers(){
	nvram set update_ipset="$(cat /koolshare/ss/cru/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_chnroute="$(cat /koolshare/ss/cru/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_adblock="$(cat /koolshare/ss/cru/version | sed -n 3p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_cdn="$(cat /koolshare/ss/cru/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set ipset_numbers=$(cat /koolshare/ss/ipset/gfwlist.conf | grep -c ipset)
	nvram set chnroute_numbers=$(cat /koolshare/ss/redchn/chnroute.txt | grep -c .)
	nvram set adblock_numbers=$(cat /koolshare/ss/ipset/adblock.conf | grep -c address)
	nvram set cdn_numbers=$(cat /koolshare/ss/redchn/cdn.txt | grep -c .)
}

fire_ss_depend_scripts(){
	#sh /koolshare/scripts/onssstart.sh
	dbus fire onssstart
}


print_success_info(){
	if [ "$ss_basic_mode" == "0" ];then
		echo $(date): 
		echo $(date): You have disabled the shadowsocks service
		echo $(date): See you again!
		echo $(date): 
		echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	else
		echo $(date): 
		echo $(date): Congratulation!
		echo $(date): Enjoy surfing internet without "Great Fire Wall"!
		echo $(date): 
		echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	fi
}


# detect ss version after ss service applied.
detect_ss_version(){
	ss_basic_version_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web1 ];then
		dbus set ss_basic_version_web=$ss_basic_version_web1
	else
		ss_basic_version_web2=`curl -s http://file.mjy211.com/koolshare.github.io/shadowsocks_mips/version | sed -n 1p`
		if [ ! -z $ss_basic_version_web2 ];then
			dbus set ss_basic_version_web=$ss_basic_version_web2
		fi
	fi
}


set_ulimit(){
	ulimit -n 8192
}


case $ACTION in
start)
	if [ "$ss_basic_enable" == "1" ];then
	creat_folder
	set_default_value
	set_ulimit
    	apply_ss
    	write_numbers
	else
    	echo ss not enabled
	fi
	;;
stop | kill )
	disable_ss
	;;
restart)
	#disable_ss
	creat_folder
	set_default_value
	set_ulimit
	apply_ss
	write_numbers
	print_success_info
	fire_ss_depend_scripts
	detect_ss_version
	;;
check)
	detect_ss_version
	;;
update)
	set_default_value
	update_ss
	;;
*)
	echo "Usage: $0 (start|stop|restart|check|kill|reconfigure)"
	exit 1
	;;
esac

