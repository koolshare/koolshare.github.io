#!/bin/sh

# define variables
eval `dbus export aria2`
lan_ipaddr=$(nvram get lan_ipaddr)
old_token=$(cat /jffs/aria2/aria2.conf|grep rpc-secret|cut -d "=" -f2)
token=$(head -200 /dev/urandom | md5sum | cut -d " " -f 1)
ddns=$(nvram get ddns_hostname_x)
usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
usb_disk2=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3`
version=`cat /jffs/aria2/version`

echo ""
echo "#############################################################"
printf "%0s%50s%10s\n" "#" "Aria2c Auto Install Script for Merlin ARM" "#"
printf "%0s%37s%23s\n" "#" "Website: http://koolshare.cn" "#"
printf "%0s%46s%14s\n" "#" "Author: sadoneli <sadoneli@gmail.com>" "#"
echo "#############################################################"
echo ""

# create tmp folder for lighttpd
mkdir -p /tmp/lighttpd
dbus set aria2_warning=""
# start aria2c
creat_conf(){
	cat > /jffs/aria2/aria21.conf <<EOF
`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_binary| grep -vw aria2_binary_custom | grep -vw aria2_check | grep -vw aria2_check_time | grep -vw aria2_sleep | grep -vw aria2_update_enable| grep -vw aria2_update_sel | grep -vw aria2_version | grep -vw aria2_version_web| grep -vw aria2_warning | grep -vw aria2_custom |grep -vw aria2_install_status|grep -vw aria2_restart| sed 's/aria2_//g' |sed 's/_/-/g'`
EOF

cat >> /jffs/aria2/aria21.conf <<EOF
`dbus list aria2|grep -w aria2_custom|sed 's/aria2_custom=//g'|sed 's/,/\n/g'`

EOF

if [ "$aria2_enable_rpc" = "false" ];then
sed -i '/rpc/d' /jffs/aria2/aria21.conf
fi
}

start_aria2(){
	if [ "$aria2_dir" = "download" ];then
		if [ ! -z "$$usb_disk1" ];then
			export aria2_dir="$usb_disk1"
			export aria2_warning="没有定义下载文件夹，默认使用$usb_disk1"
			if [ "$aria2_binary" = "entware" ];then
				/opt/bin/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
			elif [ "$aria2_binary" = "custom" ];then
				if [ ! -z "$aria2_binary_custom" ];then
					"$aria2_binary_custom"/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
				else 
					export aria2_warning="当前目录没有找到aria2可执行文件"
				fi
			elif [ "$aria2_binary" = internal ];then
				/jffs/aria2/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
			fi
		else
			export aria2_warning="没有找到可用的USB磁盘"
		fi
	else
		if [ "$aria2_binary" = entware ];then
			/opt/bin/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
		elif [ "$aria2_binary" = custom ];then
			if [ ! -z "$aria2_binary_custom" ];then
				$aria2_binary_custom/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
			else 
				dbus set aria2_warning="当前目录没有找到aria2可执行文件"
			fi
		elif [ "$aria2_binary" = internal ];then
			/jffs/aria2/aria2c --conf-path=/jffs/aria2/aria21.conf -D >/dev/null 2>&1 &
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
		# dbus set aria2_token="$token"
		echo -e Please visit"\033[42;4m" $lan_ipaddr:8088/aria2 "\033[0m" to acess Aria2 webui in lan
		echo -e You can also visit "\033[42;4m" $lan_ipaddr:8088/yaaw "\033[0m" to manage download
		if [ ! -z "$ddns" ];then
			echo -e For remote control visit"\033[42;4m" $ddns:8088/aria2 "\033[0m" or "\033[42;4m" $ddns:8088/yaaw "\033[0m"to acess Aria2 webui
		fi
		echo -e Your aria2 \host is "\033[42;4m" $lan_ipaddr "\033[0m"
		echo -e Your aria2 rpc port is "\033[42;4m" 6800 "\033[0m"
	if [ "$old_token" = "koolshare" ];then
		sed -i "s/koolshare/$token/g" "/jffs/aria2/aria2.conf"
		echo -e Your aria2 token is "\033[42;4m" $token "\033[0m"
		dbus set aria2_rpc_secret="$token"
	else
		echo -e Your aria2 token is "\033[42;4m" $old_token "\033[0m"
		dbus set aria2_rpc_secret="$old_token"
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
fi
}
del_version_check(){
	cru d aria2_version_check >/dev/null 2>&1
}
add_shortcut(){
	usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	usb_disk2=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3`
	if [ ! -z $usb_disk1 ];then
		mkdir -p /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3 |cut -d "/" -f 4`
		ln -nsf "$usb_disk1"/ /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3 |cut -d "/" -f 4`
	fi
	if [ ! -z $usb_disk2 ];then
		mkdir -p /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3 |cut -d "/" -f 4`
		ln -nsf "$usb_disk2"/ /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3 |cut -d "/" -f 4`
	fi
}
rm_shortcut(){
	if [ ! -z $usb_disk1 ];then
		rm -rf /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3 |cut -d "/" -f 4`
	fi
	if [ ! -z $usb_disk2 ];then
		rm -rf /jffs/www/`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3 |cut -d "/" -f 4`
	fi
}

if [ $aria2_enable = 1 ];then
	sleep_a_while
	del_version_check
	rm_shortcut
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
	creat_conf
	generate_token
	start_aria2
	start_lighttpd
	add_shortcut
	open_port
	auto_start
	version_check
else
	del_version_check
	rm_shortcut
	kill_aria2
	kill_lighttpd
	close_port
	stop_auto_start
fi

dbus save aria2
dbus set aria2_restart=0
dbus set aria2_version=$version

