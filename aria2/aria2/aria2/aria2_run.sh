#!/bin/sh

# define variables
eval `dbus export aria2`
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
#old_token=$(cat /koolshare/aria2/aria2.conf|grep rpc-secret|cut -d "=" -f2)
token=$(head -200 /dev/urandom | md5sum | cut -d " " -f 1)
ddns=$(nvram get ddns_hostname_x)
usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
usb_disk2=`/bin/mount | grep -E 'mnt' | sed -n 2p | cut -d" " -f3`
dbus set aria2_warning=""

echo ""
echo "#############################################################"
printf "%0s%50s%10s\n" "#" "Aria2c Auto config Script for Merlin ARM" "#"
printf "%0s%37s%23s\n" "#" "Website: http://koolshare.cn" "#"
printf "%0s%46s%14s\n" "#" "Author: sadoneli <sadoneli@gmail.com>" "#"
echo "#############################################################"
echo ""

# start aria2c
creat_conf(){
cat > /koolshare/aria2/aria2.conf <<EOF
`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_binary| grep -vw aria2_binary_custom | grep -vw aria2_check | grep -vw aria2_check_time | grep -vw aria2_sleep | grep -vw aria2_update_enable| grep -vw aria2_update_sel | grep -vw aria2_version | grep -vw aria2_cpulimit_enable | grep -vw aria2_cpulimit_value| grep -vw aria2_version_web | grep -vw aria2_warning | grep -vw aria2_custom | grep -vw aria2_install_status|grep -vw aria2_restart |grep -vw aria2_dir| sed 's/aria2_//g' | sed 's/_/-/g'`
`dbus list aria2|grep -w aria2_dir|sed 's/aria2_//g'`
EOF

cat >> /koolshare/aria2/aria2.conf <<EOF
`dbus list aria2|grep -w aria2_custom|sed 's/aria2_custom=//g'|sed 's/,/\n/g'`

EOF

# if [ "$aria2_enable_rpc" = "false" ];then
# sed -i '/rpc/d' /koolshare/aria2/aria2.conf
# fi
}

start_aria2(){
	#/koolshare/aria2/aria2c --conf-path=/koolshare/aria2/aria2.conf -D >/dev/null 2>&1 &
	perpctl A aria2
}

# generate token
generate_token(){
	if [ -z $aria2_rpc_secret ];then
		sed -i "s/rpc-secret=/rpc-secret=$token/g" "/koolshare/aria2/aria2.conf"
		dbus set aria2_rpc_secret="$token"
	fi
}

# open firewall port
open_port(){
	echo open firewall port $aria2_rpc_listen_port and 8088
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 52413 -j ACCEPT >/dev/null 2>&1
	echo done
}

# close firewall port
close_port(){
	echo close firewall port $aria2_rpc_listen_port and 8088
	iptables -D INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 52413 -j ACCEPT >/dev/null 2>&1
	echo done
}


# kill aria2
kill_aria2(){
    perpctl X aria2
    killall aria2c >/dev/null 2>&1
}


del_process_check(){
	cru d aria2_guard >/dev/null 2>&1
}

add_cpulimit(){
	if [ "$aria2_cpulimit_enable" = "true" ];then
		limit=`expr $aria2_cpulimit_value \* 2`
		cpulimit -e aria2c -l 20  >/dev/null 2>&1 &
	fi
}


load_default(){
	del_version_check
	kill_aria2
	close_port
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

case $ACTION in
start)
	if [ $aria2_enable = 1 ];then
	creat_conf
	generate_token
	start_aria2
	open_port
	add_cpulimit
	fi
	;;
stop | kill )
	kill_aria2
	killall cpulimit
	close_port
	dbus remove aria2_custom
	;;
restart)
	del_process_check
	killall cpulimit
	kill_aria2
	close_port
	sleep 1
	creat_conf
	generate_token
	start_aria2
	open_port
	add_cpulimit
	;;
default)
	load_default
	;;
*)
	echo "Usage: $0 (start|stop|restart|check|kill)"
	exit 1
	;;
esac
