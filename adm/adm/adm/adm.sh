#!/bin/sh

# ====================================变量定义====================================
# 版本号定义
version="0.1"

# 导入skipd数据
eval `dbus export adm`
eval `dbus export ss_basic`

# 引用环境变量等
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp

# ss模式判断
ssmode=`nvram get ss_mode`

# 相关链接定义
UPDATE_VERSION_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/version"
UPDATE_TAR_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/adm.tar.gz"

# ====================================函数定义====================================
# 添加随ss启动（兼容SS）
add_ss_event(){
	start=$(dbus list __event__onssstart_)
	if [ -z "$start" ];then
	dbus event onssstart_adm /koolshare/scripts/adm_config.sh
	fi
}

# 去除随ss启动，停用ADM时
remove_ss_event(){
	dbus remove __event__onssstart_adm
}

# 启动ADM主程序
start_adm(){
#	/koolshare/adm/ADM >/dev/null 2>&1 &
	perpctl A adm
}

# 停止ADM主程序
stop_adm(){
	perpctl X adm
#	killall ADM >/dev/null 2>&1 &
#	kill -9 `pidof ADM` >/dev/null 2>&1 &
}

# 添加进程守护
add_process_protect(){
	sh /koolshare/perp/perp.sh start
}

# 删除进程守护
del_process_protect(){
	sh /koolshare/perp/perp.sh stop
}

# 更新nat规则（兼容SS）
update_nat_rules(){
	if [ "$ssmode" == "1" ] || [ "$ssmode" == "3" ] || [ "$ssmode" == "4" ] || [ "$ssmode" == "5" ] ;then
		# 当ss模式为gfwlist模式，游戏模式，游戏模式V2，全局模式时，应用此规则
		iptables -t nat -A SHADOWSOCKS -p tcp --dport 80 -j REDIRECT --to-ports 18309
	elif [ "$ssmode" == "2" ];then
		# 当ss模式为大陆白名单模式时，应用此规则
    	iptables -t nat -A REDSOCKS2 -p tcp --dport 80 -j REDIRECT --to-ports 18309
    else
    	# 不启用ss时，新建ADM规则
		# Create a new chain named ADM
		iptables -t nat -N ADM
		# Ignore LANs IP address
		iptables -t nat -A ADM -p tcp --dport 80 -d 0.0.0.0/8 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 127.0.0.0/8 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 10.0.0.0/8 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 172.16.0.0/12 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 192.168.0.0/16 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 224.0.0.0/4 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 240.0.0.0/4 -j RETURN
		iptables -t nat -A ADM -p tcp --dport 80 -d 169.254.0.0/16 -j RETURN
		# Anything else should be redirected to ADM local port
		iptables -t nat -A ADM -p tcp --dport 80 -j REDIRECT --to-ports 18309
		# Apply the rules
		iptables -t nat -A PREROUTING -p tcp -j ADM
	fi
}

# 去除去广告nat规则
remove_nat_rules(){
		iptables -t nat -D SHADOWSOCKS -p tcp --dport 80 -j REDIRECT --to-ports 18309 >/dev/null 2>&1
    	iptables -t nat -D REDSOCKS2 -p tcp --dport 80 -j REDIRECT --to-ports 18309 >/dev/null 2>&1
		iptables -t nat -D PREROUTING -p tcp -j ADM >/dev/null 2>&1
		iptables -t nat -F ADM >/dev/null 2>&1
		iptables -t nat -X ADM >/dev/null 2>&1
}

# 用户自定义规则
add_user_rule(){
	user_rule=$(echo $adm_user | sed "s/,/ /g")
	for line in $user_rule
	do echo $line >> /koolshare/adm/user.txt
	done
}

del_user_rule(){
	sed -i '29,$d' /koolshare/adm/user.txt
}


install_adm(){
eval `dbus export adm`
	HOME_URL=https://koolshare.github.io
	#md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/version | sed -n 2p)
	#md5_web2=$(curl http://file.mjy211.com/adm/version | sed -n 2p)
	#md5_web3=$(curl http://file.fancyss.com/adm/version | sed -n 2p)
	#md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
	
	# adm_install_status=		#adm尚未安装
	# adm_install_status=0	#adm尚未安装
	# adm_install_status=1	#adm已安装***
	# adm_install_status=2	#adm将被安装到jffs分区...
	# adm_install_status=3	#正在下载adm中...请耐心等待...
	# adm_install_status=4	#正在安装adm中...
	# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
	# adm_install_status=6	#adm卸载中......
	# adm_install_status=7	#adm卸载成功！
	# adm_install_status=8	#adm下载文件校验不一致！
	
	kill all admc  >/dev/null 2>&1
	killall lighttpd >/dev/null 2>&1
	
	case $(uname -m) in
	  armv7l)
	    echo your router is suitable \for adm install 
	    ;;
	  mips)
	    echo "This is unsupported platform, sorry."
	    exit
	    ;;
	  *)
	    echo "This is unsupported platform, sorry."
	    exit
	    ;;
	esac
	
	
	# adm将被安装到jffs分区...
	cd /tmp
	dbus set adm_install_status="2"
	dbus save adm
	sleep 2
	# 正在下载adm中...请耐心等待...
	dbus set adm_install_status="3"
	dbus save adm
	md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/version | sed -n 2p)
	wget --no-check-certificate --tries=1 --timeout=15 https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/adm.tar.gz
	md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
	if [ "$md5sum_gz"x != "$md5_web1"x ]; then
		rm -rf /tmp/aria*
		md5_web2=$(curl http://file.mjy211.com/adm/version | sed -n 2p)
		wget --no-check-certificate --tries=1 --timeout=15 http://file.mjy211.com/adm/adm.tar.gz
		md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		if [ "$md5sum_gz"x != "$md5_web2"x ]; then
			rm -rf /tmp/aria*
			md5_web3=$(curl http://file.fancyss.com/adm/version | sed -n 2p)
			wget --no-check-certificate --tries=1 --timeout=15 http://file.fancyss.com/adm/adm.tar.gz
			md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gz"x != "$md5_web3"x ]; then
				dbus set adm_install_status="8"
				dbus save adm
				rm -rf /tmp/aria*
				sleep 5
				dbus set adm_install_status="0"
				dbus save adm
				exit
			fi
		fi
	fi
	
	# 正在安装adm中...
	dbus set adm_install_status="4"
	dbus save adm
	tar -zxvf adm.tar.gz
	mkdir -p /jffs/scripts
	mkdir -p /jffs/webs
	echo moving files
	mv -f /tmp/adm/adm /jffs/
	mv -f /tmp/adm/www /jffs/
	mv -f /tmp/adm/scripts/* /jffs/scripts/
	mv -f /tmp/adm/webs/* /jffs/webs/
	mv -f /tmp/adm.session /jffs/adm/ >/dev/null 2>&1
	cd /jffs
	chmod +x /jffs/adm/*
	chmod +x /jffs/www/php-cgi
	chmod +x /jffs/scripts/*
	chmod 777 /jffs/www/_h5ai/cache
	rm -rf /tmp/adm
	rm -rf /tmp/adm.tar.gz
	sleep 2
	dbus set adm_install_status="5"
	dbus save adm
	version=`cat /jffs/adm/version`
	dbus set adm_version=$version
	dbus set set adm_version_web=$version
	dbus save adm
	sleep 2
	dbus set adm_install_status="1"
	dbus save adm
	sleep 10
	if [ $adm_install_status != "0" ] && [ $adm_install_status != "1" ] ;then
		dbus set adm_install_status="0"
		dbus save adm
	fi
}


#安装插件模块
install_adm(){
	# adm_install_status=	#adm尚未安装
	# adm_install_status=0	#adm尚未安装
	# adm_install_status=1	#adm已安装
	# adm_install_status=2	#adm将被安装到jffs分区...
	# adm_install_status=3	#正在下载adm中...请耐心等待...
	# adm_install_status=4	#正在安装adm中...
	# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
	# adm_install_status=6	#adm卸载中......
	# adm_install_status=7	#adm卸载成功！
	# adm_install_status=8	#没有检测到在线版本号！

	# adm_install_status=9	#正在下载adm更新......
	# adm_install_status=10	#正在安装adm更新...
	# adm_install_status=11	#安装更新成功，5秒后刷新本页！
	# adm_install_status=12	#下载文件校验不一致！
	# adm_install_status=13	#然而并没有更新！
	# adm_install_status=14	#正在检查是否有更新~
	# adm_install_status=15	#检测更新错误！

	# adm_install_status=2	#adm将被安装到jffs分区...
	dbus set adm_install_status="2"
	adm_version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $adm_version_web1 ];then
		dbus set adm_version_web=$adm_version_web1
		# adm_install_status=3	#正在下载adm中...请耐心等待...
		dbus set adm_install_status="3"
		cd /tmp
		md5_web1=$(curl $UPDATE_VERSION_URL | sed -n 2p)
		wget --no-check-certificate --tries=1 --timeout=15 $UPDATE_TAR_URL
		md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		if [ "$md5sum_gz"x != "$md5_web1"x ]; then
			# adm_install_status=12	#下载文件校验不一致！
			dbus set adm_install_status="12"
			rm -rf /tmp/adm*
			sleep 3
			# adm_install_status=0	#adm尚未安装
			dbus set adm_install_status="0"
			exit
		else
			tar -zxf adm.tar.gz
			dbus set adm_enable="0"
			# adm_install_status=4	#正在安装adm中...
			dbus set adm_install_status="4"
			chmod a+x /tmp/adm/install.sh
			sh /tmp/adm/install.sh
			sleep 2
			# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
			dbus set adm_install_status="5"
			dbus set adm_version=$adm_version_web1
			sleep 2
			# adm_install_status=1	#adm已安装
			dbus set adm_install_status="1"
		fi
	else
		dbus set adm_install_status="8"
		sleep 3
		# adm_install_status=0	#adm尚未安装
		dbus set adm_install_status="0"
		exit
	fi
}

# 更新插件模块
update_adm(){
	# adm_install_status=	#adm尚未安装
	# adm_install_status=0	#adm尚未安装
	# adm_install_status=1	#adm已安装
	# adm_install_status=2	#adm将被安装到jffs分区...
	# adm_install_status=3	#正在下载adm中...请耐心等待...
	# adm_install_status=4	#正在安装adm中...
	# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
	# adm_install_status=6	#adm卸载中......
	# adm_install_status=7	#adm卸载成功！
	# adm_install_status=8	#没有检测到在线版本号！

	# adm_install_status=9	#正在下载adm更新......
	# adm_install_status=10	#正在安装adm更新...
	# adm_install_status=11	#安装更新成功，5秒后刷新本页！
	# adm_install_status=12	#下载文件校验不一致！
	# adm_install_status=13	#然而并没有更新！
	# adm_install_status=14	#正在检查是否有更新~
	# adm_install_status=15	#检测更新错误！

	# adm_install_status=14	#正在检查是否有更新~
	dbus set adm_install_status="14"
	adm_version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $adm_version_web1 ];then
		dbus set adm_version_web=$adm_version_web1
		cmp=`versioncmp $adm_version_web1 $version`
		if [ "$cmp" = "-1" ];then
			dbus set adm_install_status="9"
			cd /tmp
			md5_web1=`curl -s $UPDATE_VERSION_URL | sed -n 2p`
			wget --no-check-certificate --tries=1 --timeout=15 $UPDATE_TAR_URL
			md5sum_gz=`md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				dbus set adm_install_status="12"
				rm -rf /tmp/adm* >/dev/null 2>&1
				sleep 5
				dbus set adm_install_status="0"
			else
				tar -zxf adm.tar.gz
				dbus set adm_enable="0"
				dbus set adm_install_status="10"
				chmod a+x /tmp/adm/update.sh
				sh /tmp/adm/update.sh
				sleep 2
				dbus set adm_install_status="11"
				dbus set adm_version=$adm_version_web1
				sleep 2
				dbus set adm_install_status="0"
			fi
		else
			dbus set adm_install_status="13"
			sleep 2
			dbus set adm_install_status="0"
		fi
	else
		dbus set adm_install_status="15"
		sleep 5
		dbus set adm_install_status="0"
	fi
	exit 0
}

uninstall_adm(){
	rm -rf /koolshare/adm
	rm -rf /koolshare/perp
	rm -rf /koolshare/adm_config
	rm -rf /koolshare/adm_update
	for value in `dbus list adm|cut -d "=" -f 1`
	do
		dbus remove $value
	done
}
	

# 检查是否有更新，每次网页开启后10s后检测
detect_adm_version(){
	adm_version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $adm_version_web1 ];then
		dbus set adm_version_web="$adm_version_web1"
	fi
}

# 没有版本号时
write_adm_version(){
	if [ -z $adm_version ];then
		dbus set adm_version="$version"
	fi
}

# 为ADM进程设置更多的连接数
set_ulimit(){
	ulimit -n 8192
}

case $ACTION in
start)
	#此处为开机自启动设计，只有adm开启，ss不开启才会启动adm
	#当ss开启时，adm不通过此处启动，而是通过ss内dbus fire启动adm
	if [ "$adm_enable" == "1" ] && [ "$ss_basic_enable" == "0" ];then
	set_ulimit
	add_process_protect
	start_adm
	update_nat_rules
	add_ss_event
	fi
	;;
stop | kill )
	remove_nat_rules
	del_process_protect
	stop_adm
	remove_ss_event
	del_user_rule
	;;
restart)
	remove_nat_rules
	del_user_rule
	del_process_protect
	stop_adm
	remove_ss_event
	sleep 1
	set_ulimit
	add_user_rule
	add_process_protect
	start_adm
	update_nat_rules
	add_ss_event
	write_adm_version
	;;
check)
	detect_adm_version
	;;
update)
	update_adm
	;;
install)
	install_adm
	;;
uninstall)
	remove_nat_rules
	del_process_protect
	stop_adm
	remove_ss_event
	del_user_rule
	uninstall_adm
	;;
*)
	echo "Usage: $0 (start|stop|restart|check|kill|update)"
	exit 1
	;;
esac
