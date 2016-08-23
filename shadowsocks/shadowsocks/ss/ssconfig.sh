#!/bin/sh
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh
ss_basic_version_local=`cat /koolshare/ss/version`
dbus set ss_basic_version_local=$ss_basic_version_local
backup_url="http://koolshare.ngrok.wang:5000/shadowsocks"
main_url="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowsocks"

# creat dnsmasq.d folder
creat_folder(){
if [ ! -d /koolshare/configs/dnsmasq.d ];then
	mkdir /koolshare/configs/dnsmasq.d
fi
}

install_ss(){
	echo $(date): 开始解压压缩包... >> /tmp/syscmd.log
	tar -zxf shadowsocks.tar.gz
	dbus set ss_basic_install_status="2"
	chmod a+x /tmp/shadowsocks/install.sh
	echo $(date): 开始安装更新文件... >> /tmp/syscmd.log
	/tmp/shadowsocks/install.sh
	dbus set ss_basic_version_local=$ss_basic_version_web1
	sleep 2
	dbus set ss_basic_install_status="3"
	sleep 2
	dbus set ss_basic_install_status="0"
	echo $(date): 一点点清理工作... >> /tmp/syscmd.log
	rm -rf /tmp/shadowsocks* >/dev/null 2>&1
	echo $(date): 安装更新成功，你为什么这么屌？... >> /tmp/syscmd.log
	echo $(date): 请等待5秒，界面将自动重启... >> /tmp/syscmd.log
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
	echo $(date): 更新过程中请不要做奇怪的事，不然可能导致问题！ > /tmp/syscmd.log
	echo $(date): >> /tmp/syscmd.log
	dbus set ss_basic_install_status="6"
	echo $(date): 开启SS检查更新：正在检测主服务器在线版本号... >> /tmp/syscmd.log
	ss_basic_version_web1=`curl --connect-timeout 5 -s "$main_url"/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web1 ];then
		echo $(date): 检测到主服务器在线版本号：$ss_basic_version_web1 >> /tmp/syscmd.log
		dbus set ss_basic_version_web=$ss_basic_version_web1
		if [ "$ss_basic_version_local" != "$ss_basic_version_web1" ];then
		echo $(date): 主服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 不同！ >> /tmp/syscmd.log
			dbus set ss_basic_install_status="1"
			cd /tmp
			md5_web1=`curl -s "$main_url"/version | sed -n 2p`
			echo $(date): 开启下载进程，从主服务器上下载更新包... >> /tmp/syscmd.log
			wget --no-check-certificate --timeout=5 "$main_url"/shadowsocks.tar.gz >> /tmp/syscmd.log
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				echo $(date): 更新包md5校验不一致！估计是下载的时候除了什么状况，请等待一会儿再试... >> /tmp/syscmd.log
				dbus set ss_basic_install_status="4"
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 1
				echo $(date): 更换备用更新服务器1，请稍后... >> /tmp/syscmd.log
				dbus set ss_basic_install_status="8"
				sleep 1
				update_ss2
			else
				echo $(date): 更新包md5校验一致！ 开始安装！... >> /tmp/syscmd.log
				install_ss
			fi
		else
			echo $(date): 主服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 相同！ >> /tmp/syscmd.log
			dbus set ss_basic_install_status="5"
			sleep 1
			echo $(date): 那还更新个毛啊，关闭更新进程! >> /tmp/syscmd.log
			dbus set ss_basic_install_status="0"
			exit
		fi
	else
		echo $(date): 没有检测到主服务器在线版本号,访问github服务器有点问题哦~ >> /tmp/syscmd.log
		dbus set ss_basic_install_status="7"
		sleep 2
		echo $(date): 更换备用更新服务器1，请稍后... >> /tmp/syscmd.log
		dbus set ss_basic_install_status="8"
		sleep 1
		update_ss2
	fi
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
	# ss_basic_install_status=7	#检测更新错误1！
	# ss_basic_install_status=8	#更换奔涌更新服务器1
	# ss_basic_install_status=9	#检测更新错误2！

	dbus set ss_basic_install_status="6"
	echo $(date): 开启SS检查更新：正在检测备用服务器在线版本号... >> /tmp/syscmd.log
	ss_basic_version_web2=`curl --connect-timeout 5 -s "$backup_url"/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web2 ];then
	echo $(date): 检测到备用服务器在线版本号：$ss_basic_version_web1 >> /tmp/syscmd.log
		dbus set ss_basic_version_web=$ss_basic_version_web2
		if [ "$ss_basic_version_local" != "$ss_basic_version_web2" ];then
		echo $(date): 备用服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 不同！ >> /tmp/syscmd.log
			dbus set ss_basic_install_status="1"
			cd /tmp
			md5_web2=`curl -s "$backup_url"/version | sed -n 2p`
			echo $(date): 开启下载进程，从备用服务器上下载更新包... >> /tmp/syscmd.log
			wget "$backup_url"/shadowsocks.tar.gz
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web2" ]; then
				echo $(date): 更新包md5校验不一致！估计是下载的时候除了什么状况，请等待一会儿再试... >> /tmp/syscmd.log
				dbus set ss_basic_install_status="4"
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 2
				echo $(date): 然而只有这一台备用更更新服务器，请尝试离线手动安装... >> /tmp/syscmd.log
				dbus set ss_basic_install_status="0"
				exit
			else
				echo $(date): 更新包md5校验一致！ 开始安装！... >> /tmp/syscmd.log
				install_ss
			fi
		else
			echo $(date): 备用服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 相同！ >> /tmp/syscmd.log
			dbus set ss_basic_install_status="5"
			sleep 2
			echo $(date): 那还更新个毛啊，关闭更新进程! >> /tmp/syscmd.log
			dbus set ss_basic_install_status="0"
			exit
		fi
	else
		echo $(date): 没有检测到备用服务器在线版本号,访问备用服务器有点问题哦，你网络很差欸~ >> /tmp/syscmd.log
		dbus set ss_basic_install_status="7"
		sleep 2
		echo $(date): 然而只有这一台备用更更新服务器，请尝试离线手动安装... >> /tmp/syscmd.log
		dbus set ss_basic_install_status="0"
		exit
	fi
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
		if [ "1" == "$ss_basic_action" ]; then
			. /koolshare/ss/stop.sh stop_part
			. /koolshare/ss/ipset/start.sh start_all
		elif [ "2" == "$ss_basic_action" ]; then
			. /koolshare/ss/ipset/start.sh restart_dns
		elif [ "3" == "$ss_basic_action" ]; then
			. /koolshare/ss/ipset/start.sh restart_wb_list
		elif [ "4" == "$ss_basic_action" ]; then
			. /koolshare/ss/ipset/start.sh restart_addon
		fi
	elif [ "2" == "$ss_basic_mode" ]; then
		if [ "1" == "$ss_basic_action" ]; then
			. /koolshare/ss/stop.sh stop_part
			. /koolshare/ss/redchn/start.sh start_all
		elif [ "2" == "$ss_basic_action" ]; then
			. /koolshare/ss/redchn/start.sh restart_dns
		elif [ "3" == "$ss_basic_action" ]; then
			. /koolshare/ss/redchn/start.sh restart_wb_list
		elif [ "4" == "$ss_basic_action" ]; then
			. /koolshare/ss/redchn/start.sh restart_addon
		fi
	elif [ "3" == "$ss_basic_mode" ]; then
		if [ "1" == "$ss_basic_action" ]; then
			. /koolshare/ss/stop.sh stop_part
			. /koolshare/ss/game/start.sh start_all
		elif [ "2" == "$ss_basic_action" ]; then
			. /koolshare/ss/game/start.sh restart_dns
		elif [ "3" == "$ss_basic_action" ]; then
			. /koolshare/ss/game/start.sh restart_wb_list
		elif [ "4" == "$ss_basic_action" ]; then
			. /koolshare/ss/game/start.sh restart_addon
		fi
	elif [ "4" == "$ss_basic_mode" ]; then
		if [ "1" == "$ss_basic_action" ]; then
			. /koolshare/ss/stop.sh stop_part
			. /koolshare/ss/koolgame/start.sh start_all
		elif [ "2" == "$ss_basic_action" ]; then
			. /koolshare/ss/koolgame/start.sh restart_dns
		elif [ "3" == "$ss_basic_action" ]; then
			. /koolshare/ss/koolgame/start.sh restart_wb_list
		elif [ "4" == "$ss_basic_action" ]; then
			. /koolshare/ss/koolgame/start.sh restart_addon
		fi
	elif [ "5" == "$ss_basic_mode" ]; then
		if [ "1" == "$ss_basic_action" ]; then
			. /koolshare/ss/stop.sh stop_part
			. /koolshare/ss/overall/start.sh start_all
		elif [ "2" == "$ss_basic_action" ]; then
			. /koolshare/ss/overall/start.sh restart_dns
		elif [ "3" == "$ss_basic_action" ]; then
			. /koolshare/ss/overall/start.sh restart_wb_list
		elif [ "4" == "$ss_basic_action" ]; then
			. /koolshare/ss/overall/start.sh restart_addon
		fi
	fi
	dbus set ss_basic_action="1"
}

disable_ss(){
	. /koolshare/ss/stop.sh stop_all
	dbus set ss_basic_action="1"
}


# write number into nvram with no commit
write_numbers(){
	nvram set update_ipset="$(cat /koolshare/ss/cru/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_chnroute="$(cat /koolshare/ss/cru/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_cdn="$(cat /koolshare/ss/cru/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set ipset_numbers=$(cat /koolshare/ss/ipset/gfwlist.conf | grep -c ipset)
	nvram set chnroute_numbers=$(cat /koolshare/ss/redchn/chnroute.txt | grep -c .)
	nvram set cdn_numbers=$(cat /koolshare/ss/redchn/cdn.txt | grep -c .)
}

fire_ss_depend_scripts(){
	#sh /koolshare/scripts/onssstart.sh
	dbus fire onssstart
}


# detect ss version after ss service applied.
detect_ss_version(){
	ss_basic_version_web1=`curl -s http://koolshare.ngrok.wang:5000/shadowsocks/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web1 ];then
		dbus set ss_basic_version_web=$ss_basic_version_web1
	else
		ss_basic_version_web2=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowsocks/version | sed -n 1p`
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
		set_ulimit
		apply_ss
    		write_numbers
	else
		echo ss not enabled
	fi
	;;
stop | kill )
	disable_ss
	echo $(date):
	echo $(date): You have disabled the shadowsocks service
	echo $(date): See you again!
	echo $(date):
	echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	;;
restart)
	#disable_ss
	creat_folder
	set_ulimit
	apply_ss
	write_numbers
	echo $(date):
	echo $(date): Enjoy surfing internet without "Great Fire Wall"!
	echo $(date):
	echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	fire_ss_depend_scripts
	dbus set ss_basic_install_status="0"
	;;
check)
	detect_ss_version
	;;
update)
	update_ss
	;;
*)
	echo "Usage: $0 (start|stop|restart|check|kill|reconfigure)"
	exit 1
	;;
esac
