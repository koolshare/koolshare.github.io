#!/bin/sh

# ====================================变量定义====================================
# 版本号定义
version="1.2"

# 导入skipd数据
eval `dbus export ssserver`

# 引用环境变量等
source /koolshare/scripts/base.sh

# var define
num=$(iptables -t filter -L INPUT -v -n --line-numbers | grep dpt:$ss_server_port | cut -d " " -f 1 | sort -nr)

# kill first
stop_ssserver(){
	killall ss-server >/dev/null 2>&1
	iptables -t filter -D INPUT $num  >/dev/null 2>&1
}

# start ssserver
start_ssserver(){
mkdir -p /jffs/ss/ssserver
cat > /jffs/ss/ssserver/ss.json <<EOF
{
    "server":["[::0]", "0.0.0.0"],
    "server_port":$ss_server_port,
    "local_address":"127.0.0.1",
    "local_port":1079,
    "password":"$ss_server_password",
    "timeout":$ss_server_time,
    "method":"$ss_server_method",
    "fast_open":false
}

EOF
	if [ "$ssserver_udp" == "1" ];then
		if [ "ssserver_ota" == 1 ];then
			ss-server -c /jffs/ss/ssserver/ss.json -u -A -f /tmp/ssserver.pid
		else
			ss-server -c /jffs/ss/ssserver/ss.json -u -f /tmp/ssserver.pid
		fi
	else
		if [ "ssserver_ota" == 1 ];then
			ss-server -c /jffs/ss/ssserver/ss.json -A -f /tmp/ssserver.pid
		else
			ss-server -c /jffs/ss/ssserver/ss.json -f /tmp/ssserver.pid
		fi
	fi

	iptables -t filter -I INPUT -p tcp --dport $ssserver_port -j ACCEPT
}



case $ACTION in
start)
	if [ "$ssserver_enable" == "1" ];then
	start_ssserver
	fi
	;;
stop | kill )
	stop_ssserver
	;;
restart)
	stop_ssserver
	start_ssserver
	;;
*)
	echo "Usage: $0 (start|stop|restart)"
	exit 1
	;;
esac
