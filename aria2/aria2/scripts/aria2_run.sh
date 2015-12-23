#!/bin/sh

# define variables
eval `dbus export aria2`
#old_token=$(cat /jffs/aria2/aria2.conf|grep rpc-secret|cut -d "=" -f2)
token=$(head -200 /dev/urandom | md5sum | cut -d " " -f 1)
ddns=$(nvram get ddns_hostname_x)
usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
usb_disk2=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3`
dbus set aria2_warning=""
echo ""
echo "#############################################################"
printf "%0s%50s%10s\n" "#" "Aria2c Auto Install Script for Merlin ARM" "#"
printf "%0s%37s%23s\n" "#" "Website: http://koolshare.cn" "#"
printf "%0s%46s%14s\n" "#" "Author: sadoneli <sadoneli@gmail.com>" "#"
echo "#############################################################"
echo ""

# start aria2c
creat_conf(){
cat > /jffs/aria2/aria2.conf <<EOF
`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_binary| grep -vw aria2_binary_custom | grep -vw aria2_check | grep -vw aria2_check_time | grep -vw aria2_sleep | grep -vw aria2_update_enable| grep -vw aria2_update_sel | grep -vw aria2_version | grep -vw aria2_cpulimit_enable | grep -vw aria2_cpulimit_value| grep -vw aria2_version_web | grep -vw aria2_warning | grep -vw aria2_custom | grep -vw aria2_install_status|grep -vw aria2_restart | sed 's/aria2_//g' | sed 's/_/-/g'`
EOF

cat >> /jffs/aria2/aria2.conf <<EOF
`dbus list aria2|grep -w aria2_custom|sed 's/aria2_custom=//g'|sed 's/,/\n/g'`

EOF

# if [ "$aria2_enable_rpc" = "false" ];then
# sed -i '/rpc/d' /jffs/aria2/aria2.conf
# fi
}

start_aria2(){
	if [ "$aria2_dir" = "download" ];then
		if [ ! -z "$usb_disk1" ];then
			export aria2_dir="$usb_disk1"
			export aria2_warning="没有定义下载文件夹，默认使用$usb_disk1"
			if [ "$aria2_binary" = "entware" ];then
				/opt/bin/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
			elif [ "$aria2_binary" = "custom" ];then
				if [ ! -z "$aria2_binary_custom" ];then
					"$aria2_binary_custom"/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
				else 
					export aria2_warning="当前目录没有找到aria2可执行文件"
				fi
			elif [ "$aria2_binary" = internal ];then
				/jffs/aria2/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
			fi
		else
			export aria2_warning="没有找到可用的USB磁盘"
		fi
	else
		if [ "$aria2_binary" = entware ];then
			/opt/bin/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
		elif [ "$aria2_binary" = custom ];then
			if [ ! -z "$aria2_binary_custom" ];then
				$aria2_binary_custom/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
			else 
				dbus set aria2_warning="当前目录没有找到aria2可执行文件"
			fi
		elif [ "$aria2_binary" = internal ];then
			/jffs/aria2/aria2c --conf-path=/jffs/aria2/aria2.conf -D >/dev/null 2>&1 &
		fi
	fi


	
	aria2_run=$(ps|grep aria2c|grep -v grep)
	if [ ! -z "$aria2_run" ];then
		echo aria2c start success!
	else
		echo aria2c start failure！
	fi
}

# start lighttpd
start_lighttpd(){
	# create tmp folder for lighttpd
	mkdir -p /tmp/lighttpd
	/usr/sbin/lighttpd -f /jffs/www/lighttpd.conf
	lighttpd_run=$(ps|grep lighttpd|grep -v grep)
	if [ ! -z "$lighttpd_run" ];then
		echo lighttpd start success!
	else
		echo lighttpd start failure！
	fi
}

# generate token
generate_token(){
	if [ -z $aria2_rpc_secret ];then
		sed -i "s/rpc-secret=/rpc-secret=$token/g" "/jffs/aria2/aria2.conf"
		export aria2_rpc_secret=$token
	fi
}

# open firewall port
open_port(){
	echo open firewall port $aria2_rpc_listen_port and 8088
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	echo done
}

# close firewall port
close_port(){
	echo close firewall port $aria2_rpc_listen_port and 8088
	iptables -D INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	echo done
}

# for auto start with wan
auto_start(){
if [ ! -f /jffs/scripts/wan-start ]; then
cat > /jffs/scripts/wan-start <<EOF
#!/bin/sh
dbus fire onwanstart

EOF
fi
echo $(date): Adding service to wan-start...
startaria2=$(cat /jffs/scripts/wan-start | grep "aria2")
if [ -z "$startstart" ];then
# sed -i "2a sleep $aria2_sleep" /jffs/scripts/wan-start
sed -i '2a sh /jffs/scripts/aria2_run.sh' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
}

# for auto start with wan
stop_auto_start(){	
# sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/aria2_run/d' /jffs/scripts/wan-start >/dev/null 2>&1
}


# kill aria2
kill_aria2(){
    killall aria2c >/dev/null 2>&1
    sleep 2
    aria2_run1=$(ps|grep aria2c|grep -v grep|grep -v killall)
    
	if [ -z "$aria2_run1" ];then
		echo aria2c stoped!
	else
		echo aria2c stop failure!
	fi
}

# kill lighttpd
kill_lighttpd(){
	killall lighttpd >/dev/null 2>&1
	sleep 2
	lighttpd_run1=$(ps|grep lighttpd|grep -v grep|grep -v killall)
	if [ -z "$lighttpd_run1" ];then
		echo lighttpd stoped!
	else
		echo lighttpd stop failure!
	fi
}

sleep_a_while(){
	if [ $aria2_restart = 1 ];then
		echo \do not \sleep
	else
		sleep $aria2_sleep
	fi
}

version_check(){
if [ "1" == "$aria2_update_enable" ]; then
	/bin/sh /jffs/scripts/aria2_version_check.sh
	cru a aria2_version_check "0 $aria2_update_sel * * * /bin/sh /jffs/scripts/aria2_version_check.sh"
else
cru d aria2_version_check >/dev/null 2>&1

version=`cat /jffs/aria2/version`
export aria2_version=$version


fi
}
del_version_check(){
	cru d aria2_version_check >/dev/null 2>&1
}

add_process_check(){
	if [ "$aria2_check" = "true" ];then
		echo add_process_check
		cru a aria2_process_check "*/$aria2_check_time * * * * /bin/sh /jffs/scripts/aria2_pros_check.sh"
	fi
}

del_process_check(){
	cru d aria2_process_check >/dev/null 2>&1
}

add_shortcut(){
	usb1_name=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3 |cut -d "/" -f 4`
	usb2_name=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3 |cut -d "/" -f 4`
	if [ ! -z $usb1_name ];then
		mkdir -p /jffs/www/$usb1_name
		ln -nsf /tmp/mnt/$usb1_name/ /jffs/www/$usb1_name
	fi
	if [ ! -z $usb2_name ];then
		mkdir -p /jffs/www/$usb2_name
		ln -nsf /tmp/mnt/$usb2_name/ /jffs/www/$usb2_name
	fi
}
rm_shortcut(){
	usb1_name=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3 |cut -d "/" -f 4`
	usb2_name=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3 |cut -d "/" -f 4`
	if [ ! -z $usb1_name ];then
	rm -rf /jffs/www/$usb1_name
	fi
	if [ ! -z $usb2_name ];then
	rm -rf /jffs/www/$usb2_name
	fi
}

add_cpulimit(){
	if [ "$aria2_cpulimit_enable" = "true" ];then
		limit=`expr $aria2_cpulimit_value \* 2`
		cpulimit -e aria2c -l 20  >/dev/null 2>&1 &
	fi
}

install_aria2(){
eval `dbus export aria2`
	HOME_URL=https://koolshare.github.io
	#md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/version | sed -n 2p)
	#md5_web2=$(curl http://file.mjy211.com/aria2/version | sed -n 2p)
	#md5_web3=$(curl http://file.fancyss.com/aria2/version | sed -n 2p)
	#md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
	
	# aria2_install_status=		#Aria2尚未安装
	# aria2_install_status=0	#Aria2尚未安装
	# aria2_install_status=1	#Aria2已安装***
	# aria2_install_status=2	#Aria2将被安装到jffs分区...
	# aria2_install_status=3	#正在下载Aria2中...请耐心等待...
	# aria2_install_status=4	#正在安装Aria2中...
	# aria2_install_status=5	#Aria2安装成功！请5秒后刷新本页面！...
	# aria2_install_status=6	#Aria2卸载中......
	# aria2_install_status=7	#Aria2卸载成功！
	# aria2_install_status=8	#Aria2下载文件校验不一致！
	
	kill all aria2c  >/dev/null 2>&1
	killall lighttpd >/dev/null 2>&1
	
	case $(uname -m) in
	  armv7l)
	    echo your router is suitable \for aria2 install 
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
	
	
	# Aria2将被安装到jffs分区...
	cd /tmp
	export aria2_install_status="2"
	dbus save aria2
	sleep 2
	# 正在下载Aria2中...请耐心等待...
	export aria2_install_status="3"
	dbus save aria2
	md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/version | sed -n 2p)
	wget --no-check-certificate --tries=1 --timeout=15 https://koolshare.github.io/aria2/aria2.tar.gz
	md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
	if [ "$md5sum_gz"x != "$md5_web1"x ]; then
		rm -rf /tmp/aria*
		md5_web2=$(curl http://file.mjy211.com/aria2/version | sed -n 2p)
		wget --no-check-certificate --tries=1 --timeout=15 http://file.mjy211.com/aria2/aria2.tar.gz
		md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		if [ "$md5sum_gz"x != "$md5_web2"x ]; then
			rm -rf /tmp/aria*
			md5_web3=$(curl http://file.fancyss.com/aria2/version | sed -n 2p)
			wget --no-check-certificate --tries=1 --timeout=15 http://file.fancyss.com/aria2/aria2.tar.gz
			md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gz"x != "$md5_web3"x ]; then
				export aria2_install_status="8"
				dbus save aria2
				rm -rf /tmp/aria*
				sleep 5
				export aria2_install_status="0"
				dbus save aria2
				exit
			fi
		fi
	fi
	
	# 正在安装Aria2中...
	export aria2_install_status="4"
	dbus save aria2
	tar -zxvf aria2.tar.gz
	mkdir -p /jffs/scripts
	mkdir -p /jffs/webs
	echo moving files
	mv -f /tmp/aria2/aria2 /jffs/
	mv -f /tmp/aria2/www /jffs/
	mv -f /tmp/aria2/scripts/* /jffs/scripts/
	mv -f /tmp/aria2/webs/* /jffs/webs/
	mv -f /tmp/aria2.session /jffs/aria2/ >/dev/null 2>&1
	cd /jffs
	chmod +x /jffs/aria2/*
	chmod +x /jffs/www/php-cgi
	chmod +x /jffs/scripts/*
	chmod 777 /jffs/www/_h5ai/cache
	rm -rf /tmp/aria2
	rm -rf /tmp/aria2.tar.gz
	sleep 2
	export aria2_install_status="5"
	dbus save aria2
	version=`cat /jffs/aria2/version`
	export aria2_version=$version
	export set aria2_version_web=$version
	dbus save aria2
	sleep 2
	export aria2_install_status="1"
	dbus save aria2
	sleep 10
	if [ $aria2_install_status != "0" ] && [ $aria2_install_status != "1" ] ;then
		export aria2_install_status="0"
		dbus save aria2
	fi
}

uninstall_aria2(){
	eval `dbus export aria2`
	
	# aria2_install_status=		#Aria2尚未安装
	# aria2_install_status=0	#Aria2尚未安装
	# aria2_install_status=1	#Aria2已安装***
	# aria2_install_status=2	#Aria2将被安装到jffs分区...
	# aria2_install_status=3	#正在下载Aria2中...请耐心等待...
	# aria2_install_status=4	#正在安装Aria2中...
	# aria2_install_status=5	#Aria2安装成功！请5秒后刷新本页面！...
	# aria2_install_status=6	#Aria2卸载中......
	# aria2_install_status=7	#Aria2卸载成功！
	# aria2_install_status=8	#Aria2下载文件校验不一致！
	
	export aria2_install_status="6"
	dbus save aria2
	del_version_check
	rm_shortcut
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
	rm -rf /jffs/www
	cp -r /jffs/aria2.session /tmp/
	rm -rf /jffs/aria2
	sleep 2
	export aria2_install_status="0"
	dbus save aria2
	for r in `dbus list aria2|cut -d"=" -f 1`
	do
		dbus remove $r
	done
	dbus remove tmp_aria2_version
	}
load_default(){
	del_version_check
	rm_shortcut
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
	dbus set tmp_aria2_version=`dbus get aria2_version`
	dbus set tmp_aria2_version_web=`dbus get aria2_version_web`
	for r in `dbus list aria2|cut -d"=" -f 1`
	do
	dbus remove $r
	done
	dbus set aria2_enable=0
	dbus set aria2_install_status=1
	dbus set aria2_version=`dbus get tmp_aria2_version`
	dbus set aria2_version_web=`dbus get tmp_aria2_version_web`
	dbus remove tmp_aria2_version
}
# ============================================
if [ $aria2_enable = 0 ];then
	del_version_check
	rm_shortcut
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
	dbus remove aria2_custom
	dbus save aria2
	dbus set aria2_restart=0
	version=`cat /jffs/aria2/version`
	dbus set aria2_version=$version
fi

if [ $aria2_enable = 1 ];then
	sleep_a_while
	del_process_check
	del_version_check
	rm_shortcut
	killall cpulimit
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
	creat_conf
	generate_token
	start_aria2
	start_lighttpd
	add_process_check
	add_shortcut
	open_port
	auto_start
	add_cpulimit
	version_check
	dbus save aria2
	dbus set aria2_restart=0
	version=`cat /jffs/aria2/version`
	dbus set aria2_version=$version
fi

if [ $aria2_enable = 2 ];then
	install_aria2
fi

if [ $aria2_enable = 3 ];then
	uninstall_aria2
fi

if [ $aria2_enable = 4 ];then
	uninstall_aria2
	install_aria2
fi

if [ $aria2_enable = 5 ];then
	load_default
fi


