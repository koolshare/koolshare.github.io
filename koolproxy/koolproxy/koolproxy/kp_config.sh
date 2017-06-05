#! /bin/sh
# 导入skipd数据
eval `dbus export koolproxy`

# 引用环境变量等
source /koolshare/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
flag1=1

write_user_txt(){
	if [ -n "$koolproxy_user_rule" ];then
		echo $koolproxy_user_rule | base64_decode > /koolshare/koolproxy/data/rules/user.txt
		#dbus remove koolproxy_user_rule
	fi
}

start_koolproxy(){
	rules_date_local=`cat /koolshare/koolproxy/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3}'`
	rules_nu_local=`grep -v "!x" /koolshare/koolproxy/data/rules/koolproxy.txt | wc -l`
	video_date_local=`cat /koolshare/koolproxy/data/rules/koolproxy.txt  | sed -n '4p'|awk '{print $3}'`
	echo_date 加载静态规则日期：$rules_date_local,条数：$rules_nu_local
	dbus set koolproxy_rule_info="更新日期：$rules_date_local / $rules_nu_local条"
	[ "$koolproxy_policy" != "3" ] && echo_date 加载视频规则日期：$video_date_local
	dbus set koolproxy_video_info="更新日期：$video_date_local"

	kp_version=`cd /koolshare/koolproxy && ./koolproxy -v`
	dbus set koolproxy_binary_version="koolproxy $kp_version "
	echo_date 开启koolproxy主进程！
	[ -f "/koolshare/bin/koolproxy" ] && rm -rf /koolshare/bin/koolproxy
	[ ! -L "/koolshare/bin/koolproxy" ] && ln -sf /koolshare/koolproxy/koolproxy /koolshare/bin/koolproxy
	[ "$koolproxy_policy" == "3" ] && EXT_ARG="-e" || EXT_ARG=""
	cd /koolshare/koolproxy && koolproxy $EXT_ARG -d
}



stop_koolproxy(){
	echo_date 关闭koolproxy主进程...
	kill -9 `pidof koolproxy` >/dev/null 2>&1
	killall koolproxy >/dev/null 2>&1
}

creat_start_up(){
	echo_date 加入开机自动启动...
	rm -rf /koolshare/init.d/S93koolproxy.sh
	ln -sf /koolshare/scripts/koolproxy_config.sh /koolshare/init.d/S93koolproxy.sh
}

del_start_up(){
	rm -rf /koolshare/init.d/S93koolproxy.sh
}

write_nat_start(){
	echo_date 添加nat-start触发事件...
	dbus set __event__onnatstart_koolproxy="/koolshare/koolproxy/kp_config.sh"
}

remove_nat_start(){
	echo_date 删除nat-start触发...
	dbus remove __event__onnatstart_koolproxy
}

add_ipset_conf(){
	if [ "$koolproxy_policy" == "2" ];then
		echo_date 添加黑名单软连接...
		rm -rf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
		ln -sf /koolshare/koolproxy/data/koolproxy_ipset.conf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
		dnsmasq_restart=1
	fi
}

remove_ipset_conf(){
	if [ -L "/jffs/configs/dnsmasq.d/koolproxy_ipset.conf" ];then
		echo_date 移除黑名单软连接...
		rm -rf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
	fi
}

restart_dnsmasq(){
	if [ "$dnsmasq_restart" == "1" ];then
		echo_date 重启dnsmasq进程...
		service restart_dnsmasq > /dev/null 2>&1
	fi
}

add_ss_event(){
	start=`dbus list __event__onssstart_|grep koolproxy`
	if [ -z "$start" ];then
	echo_date 添加ss事件触发：当ss启用或者重启，重新加载koolproxy的nat规则.
	dbus event onssstart_koolproxy /koolshare/koolproxy/koolproxy.sh
	fi
}

remove_ss_event(){
	dbus remove __event__onssstart_koolproxy
}

write_reboot_job(){
	# start setvice
	if [ "1" == "$koolproxy_reboot" ]; then
		echo_date 开启插件定时重启，每天"$koolproxy_reboot_hour"时"$koolproxy_reboot_min"分，自动重启插件...
		cru a koolproxy_reboot "$koolproxy_reboot_min $koolproxy_reboot_hour * * * /bin/sh /koolshare/koolproxy/koolproxy.sh restart"
	elif [ "2" == "$koolproxy_reboot" ]; then
		cru a koolproxy_reboot "*/$koolproxy_reboot_inter_min */$koolproxy_reboot_inter_hour * * * /bin/sh /koolshare/koolproxy/koolproxy.sh restart"
		echo_date 开启插件间隔重启，每隔"$koolproxy_reboot_inter_hour"时"$koolproxy_reboot_inter_min"分，自动重启插件...
	fi
}

remove_reboot_job(){
	jobexist=`cru l|grep koolproxy_reboot`
	# kill crontab job
	if [ -n "$jobexist" ];then
		echo_date 关闭插件定时重启...
		sed -i '/koolproxy_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

load_module(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -f /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko ] && [ -z "$xt" ];then
		echo_date "加载xt_set.ko内核模块！"
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko
	fi
}

creat_ipset(){
	echo_date 创建ipset名单
	ipset -N white_kp_list nethash
	ipset -N black_koolproxy iphash
}

add_white_black_ip(){
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4"
	for ip in $ip_lan
	do
		ipset -A white_kp_list $ip >/dev/null 2>&1

	done
	ipset -A black_koolproxy 110.110.110.110 >/dev/null 2>&1
}

get_mode_name() {
	case "$1" in
		0)
			echo "不过滤"
		;;
		1)
			echo "http模式"
		;;
		2)
			echo "http + https"
		;;
	esac
}

get_jump_mode(){
	case "$1" in
		0)
			echo "-j"
		;;
		*)
			echo "-g"
		;;
	esac
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "KOOLPROXY_HTTP"
		;;
		2)
			echo "KOOLPROXY_HTTPS"
		;;
	esac
}

factor(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

flush_nat(){
	echo_date 移除nat规则...
	cd /tmp
	iptables -t nat -S | grep -E "KOOLPROXY|KOOLPROXY_HTTP|KOOLPROXY_HTTPS" | sed 's/-A/iptables -t nat -D/g'|sed 1,3d > clean.sh && chmod 777 clean.sh && ./clean.sh && rm clean.sh
	iptables -t nat -X KOOLPROXY > /dev/null 2>&1
	iptables -t nat -X KOOLPROXY_HTTP > /dev/null 2>&1
	iptables -t nat -X KOOLPROXY_HTTPS > /dev/null 2>&1
	ipset -F black_koolproxy > /dev/null 2>&1 && ipset -X black_koolproxy > /dev/null 2>&1
	ipset -F white_kp_list > /dev/null 2>&1 && ipset -X white_kp_list > /dev/null 2>&1
}

lan_acess_control(){
	# lan access control
	[ -z "$koolproxy_acl_default_mode" ] && koolproxy_acl_default_mode=1
	acl_nu=`dbus list koolproxy_acl_mode|sed 1d|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	if [ -n "$acl_nu" ]; then
		for acl in $acl_nu
		do
			ipaddr=`dbus get koolproxy_acl_ip_$acl`
			mac=`dbus get koolproxy_acl_mac_$acl`
			proxy_name=`dbus get koolproxy_acl_name_$acl`
			proxy_mode=`dbus get koolproxy_acl_mode_$acl`
			[ "$koolproxy_acl_method" == "1" ] && echo_date 加载ACL规则：【$ipaddr】【$mac】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxy_acl_method" == "2" ] && mac="" && echo_date 加载ACL规则：【$ipaddr】模式为：$(get_mode_name $proxy_mode)
			[ "$koolproxy_acl_method" == "3" ] && ipaddr="" && echo_date 加载ACL规则：【$mac】模式为：$(get_mode_name $proxy_mode)
			iptables -t nat -A KOOLPROXY $(factor $ipaddr "-s") $(factor $mac "-m mac --mac-source") -p tcp $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		done
		echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $koolproxy_acl_default_mode)
		
	else
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $koolproxy_acl_default_mode)
	fi

}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 1
	done
	
	echo_date 加载nat规则！
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建KOOLPROXY nat rule
	iptables -t nat -N KOOLPROXY
	# 局域网地址不走KP
	iptables -t nat -A KOOLPROXY -m set --set white_kp_list dst -j RETURN
	#  生成对应CHAIN
	iptables -t nat -N KOOLPROXY_HTTP
	iptables -t nat -A KOOLPROXY_HTTP -p tcp -m multiport --dport 80,$koolproxy_ext_ports -j REDIRECT --to-ports 3000
	iptables -t nat -N KOOLPROXY_HTTPS
	iptables -t nat -A KOOLPROXY_HTTPS -p tcp -m multiport --dport 80,443,$koolproxy_ext_ports -j REDIRECT --to-ports 3000
	# 局域网控制
	lan_acess_control
	# 剩余流量转发到缺省规则定义的链中
	iptables -t nat -A KOOLPROXY -p tcp -j $(get_action_chain $koolproxy_acl_default_mode)
	# 重定所有流量到 KOOLPROXY
	# 全局模式和视频模式
	[ "$koolproxy_policy" == "1" ] || [ "$koolproxy_policy" == "3" ] && iptables -t nat -I PREROUTING 2 -p tcp -j KOOLPROXY
	# ipset 黑名单模式
	[ "$koolproxy_policy" == "2" ] && iptables -t nat -I PREROUTING 2 -p tcp -m set --set black_koolproxy dst -j KOOLPROXY
}

dns_takeover(){
	ss_chromecast=`dbus get ss_basic_chromecast`
	lan_ipaddr=`nvram get lan_ipaddr`
	#chromecast=`iptables -t nat -L PREROUTING -v -n|grep "dpt:53"`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ "$koolproxy_policy" == "2" ]; then
		if [ -z "$chromecast_nu" ]; then
			echo_date 黑名单模式开启DNS劫持
			iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		else
			echo_date DNS劫持规则已经添加，跳过~
		fi
	else
		if [ "$ss_chromecast" != "1" ]; then
			if [ ! -z "$chromecast_nu" ]; then
				echo_date 全局过滤模式下删除DNS劫持
				iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
				echo_date done
				echo_date
			fi
		fi
	fi
}

detect_cert(){
	if [ ! -f /koolshare/koolproxy/data/private/ca.key.pem ]; then
		echo_date 检测到首次运行，开始生成koolproxy证书，用于https过滤！
		cd /koolshare/koolproxy/data && sh gen_ca.sh
	fi
}

case $ACTION in
start)
	echo_date ================== koolproxy启用 =================
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	load_module
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_reboot_job
	add_ss_event
	rm -rf /tmp/user.txt && ln -sf /koolshare/koolproxy/data/rules/user.txt /tmp/user.txt
	echo_date =================================================
	;;
restart)
	# now stop
	echo_date ================== 关闭 =================
	rm -rf /tmp/user.txt && ln -sf /koolshare/koolproxy/data/rules/user.txt /tmp/user.txt
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf
	remove_nat_start
	flush_nat
	stop_koolproxy
	# now start
	echo_date ================== koolproxy启用 =================
	detect_cert
	start_koolproxy
	add_ipset_conf && restart_dnsmasq
	load_module
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_reboot_job
	add_ss_event
	echo_date koolproxy启用成功，请等待日志窗口自动关闭，页面会自动刷新...
	echo_date =================================================
	;;
stop)
	rm -rf /tmp/user.txt
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf && restart_dnsmasq
	remove_nat_start
	flush_nat
	stop_koolproxy
	del_start_up
	;;
*)
	flush_nat
	creat_ipset
	add_white_black_ip
	load_nat
	dns_takeover
	;;
esac
