#!/bin/sh
eval `dbus export ss`
lan_ipaddr=$(nvram get lan_ipaddr)
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
game_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 3`
[ -n "$game_on" ] || [ "$ss_basic_mode" == "3" ] || [ "$ss_basic_mode" == "4" ] && mangle=1
	
load_tproxy(){
	MODULES="nf_tproxy_core xt_TPROXY xt_socket xt_comment"
	OS=$(uname -r)
	# load Kernel Modules
	echo_date 加载TPROXY模块，用于udp转发...
	checkmoduleisloaded(){
		if lsmod | grep $MODULE &> /dev/null; then return 0; else return 1; fi;
	}
	
	for MODULE in $MODULES; do
		if ! checkmoduleisloaded; then
			insmod /lib/modules/${OS}/kernel/net/netfilter/${MODULE}.ko
		fi
	done
	
	modules_loaded=0
	
	for MODULE in $MODULES; do
		if checkmoduleisloaded; then
			modules_loaded=$(( i++ )); 
		fi
	done
	
	if [ $modules_loaded -ne 3 ]; then
		echo "One or more modules are missing, only $(( modules_loaded+1 )) are loaded. Can't start.";
		exit 1;
	fi
}

flush_nat(){
	echo_date 尝试先清除已存在的iptables规则，防止重复添加
	# flush rules and set if any
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GFW > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GFW > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_CHN > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_CHN > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GLO > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GLO > /dev/null 2>&1
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}

flush_ipset(){
	echo_date 先清空已存在的ipset名单，防止重复添加
	ipset -F chnroute >/dev/null 2>&1 && ipset -X chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1 && ipset -X black_list >/dev/null 2>&1
	ipset -F gfwlist >/dev/null 2>&1 && ipset -X gfwlist >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1 && ipset -X router >/dev/null 2>&1
}

remove_redundant_rule(){
	ip_rule_exist=`/usr/sbin/ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 310`
	#ip_rule_exist=`ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 300`
	if [ ! -z "ip_rule_exist" ];then
		echo_date 清除重复的ip rule规则.
		until [ "$ip_rule_exist" = 0 ]
		do 
			#ip rule del fwmark 0x01/0x01 table 310
			/usr/sbin/ip rule del fwmark 0x01/0x01 table 310 pref 789
			ip_rule_exist=`expr $ip_rule_exist - 1`
		done
	fi
}

remove_route_table(){
	echo_date 删除ip route规则.
	/usr/sbin/ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

# creat ipset rules
creat_ipset(){
	echo_date 创建ipset名单
	ipset -! create white_list nethash && ipset flush white_list
	ipset -! create black_list nethash && ipset flush black_list
	ipset -! create gfwlist nethash && ipset flush gfwlist
	ipset -! create router nethash && ipset flush router
	ipset -! create chnroute nethash && ipset flush chnroute
	sed -e "s/^/add chnroute &/g" /koolshare/ss/rules/chnroute.txt | awk '{print $0} END{print "COMMIT"}' | ipset -R
}

add_white_black_ip(){
	# black ip/cidr
	ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24"
	for ip in $ip_tg
	do
		ipset -! add black_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_black_ip ];then
		ss_wan_black_ip=`dbus get ss_wan_black_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR黑名单
		for ip in $ss_wan_black_ip
		do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi
	
	# white ip/cidr
	ip1=$(nvram get wan0_ipaddr | cut -d"." -f1,2)
	[ ! -z "$ss_basic_server_ip" ] && SERVER_IP=$ss_basic_server_ip || SERVER_IP=""
	ISP_DNS1=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	ISP_DNS2=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p)
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 $ip1.0.0/16 $SERVER_IP 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115 1.2.4.8 210.2.4.8 112.124.47.27 114.215.126.16 180.76.76.76 119.29.29.29 $ISP_DNS1 $ISP_DNS2"
	for ip in $ip_lan
	do
		ipset -! add white_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_white_ip ];then
		ss_wan_white_ip=`echo $ss_wan_white_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR白名单
		for ip in $ss_wan_white_ip
		do
			ipset -! add white_list $ip >/dev/null 2>&1
		done
	fi
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "SHADOWSOCKS_GFW"
		;;
		2)
			echo "SHADOWSOCKS_CHN"
		;;
		3 | 4)
			echo "SHADOWSOCKS_GAM"
		;;
		5)
			echo "SHADOWSOCKS_GLO"
		;;
	esac
}

get_mode_name() {
	case "$1" in
		0)
			echo "不通过SS"
		;;
		1)
			echo "gfwlist模式"
		;;
		2)
			echo "大陆白名单模式"
		;;
		3)
			echo "游戏模式"
		;;
		4)
			echo "游戏模式V2"
		;;
		5)
			echo "全局模式"
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

get_jump_mode(){
	case "$1" in
		0)
			echo "j"
		;;
		*)
			echo "g"
		;;
	esac
}

lan_acess_control(){
	if [ "$ss_basic_mode" == "4" ];then
		# lan control
		black=$(echo $ss_game2_black_lan | base64_decode | sed "s/,/ /g")
		white=$(echo $ss_game2_white_lan | base64_decode | sed "s/,/ /g")
		if [ "$ss_game2_lan_control" == "1" ];then
			if [ ! -z $ss_game2_black_lan ];then
				echo_date 添加局域网黑名单IP，添加的IP地址将不会走游戏模式V2，其余的走游戏模式V2。
				for balck_ip in $black
				do
					iptables -t nat -A SHADOWSOCKS -p tcp -s $balck_ip -j RETURN
					iptables -t mangle -A SHADOWSOCKS -p udp -s $balck_ip -j RETURN
				done
			else
				echo_date 你开启了局域网黑名单，但是未填写任何内容，跳过！
			fi
			ss_acl_default_mode=$ss_basic_mode
		elif [ "$ss_game2_lan_control" == "2" ];then
			if [ ! -z $ss_game2_white_lan ];then
				echo_date 添加局域网白名单IP，添加的IP地址将会走游戏模式V2，其余的不走游戏模式V2。
				for white_ip in $white
				do
					iptables -t nat -A SHADOWSOCKS -p tcp -s $white_ip -j SHADOWSOCKS_GAM
					iptables -t mangle -A SHADOWSOCKS -p udp -s $white_ip -j SHADOWSOCKS_GAM
				done
			else
				echo_date 你开启了局域网白名单，但是未填写任何内容，跳过！
			fi
			ss_acl_default_mode=0
		else 
			echo_date 局域网控制功能未启用！
			ss_acl_default_mode=$ss_basic_mode
		fi
	else
		# lan access control
		acl_nu=`dbus list ss_acl_mode|sed 1d|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
		if [ -n "$acl_nu" ]; then
			for acl in $acl_nu
			do
				ipaddr=`dbus get ss_acl_ip_$acl`
				ports=`dbus get ss_acl_port_$acl`
				[ "$ports" == "all" ] && ports=""
				proxy_mode=`dbus get ss_acl_mode_$acl`
				proxy_name=`dbus get ss_acl_name_$acl`
				[ "$ports" == "" ] && echo_date 加载ACL规则：$ipaddr:all模式为：$(get_mode_name $proxy_mode) || echo_date 加载ACL规则：$ipaddr:$ports模式为：$(get_mode_name $proxy_mode)
				iptables -t nat -A SHADOWSOCKS $(factor $ipaddr "-s") -p tcp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
				[ "$proxy_mode" == "3" ] || [ "$proxy_mode" == "4" ] && \
				iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			done
			echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $ss_acl_default_mode)
		else
			ss_acl_default_mode=$ss_basic_mode
			echo_date 加载ACL规则：所有模式为：$(get_mode_name $ss_basic_mode)
		fi
	fi
}

apply_nat_rules(){
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建SHADOWSOCKS nat rule
	iptables -t nat -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set white_list dst -j RETURN
	#-----------------------FOR GLOABLE---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GLO
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GLO -p tcp -j REDIRECT --to-ports 3333
	#-----------------------FOR GFWLIST---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GFW
	# IP/CIDR/黑域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	#-----------------------FOR CHNMODE---------------------
	# 创建大陆白名单模式nat rule
	iptables -t nat -N SHADOWSOCKS_CHN
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	#-----------------------FOR GAMEMODE---------------------
	# 创建大陆白名单模式nat rule
	iptables -t nat -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333

	[ "$mangle" == "1" ] && load_tproxy
	[ "$mangle" == "1" ] && /usr/sbin/ip rule add fwmark 0x01/0x01 table 310 pref 789
	[ "$mangle" == "1" ] && /usr/sbin/ip route add local 0.0.0.0/0 dev lo table 310
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS -p udp -m set --match-set white_list dst -j RETURN
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set --match-set black_list dst -j TPROXY --on-port 3333 --tproxy-mark 0x01/0x01
	# cidr黑名单控制-chnroute（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01/0x01
	#-----------------------FOR ROUTER---------------------
	# router itself
	iptables -t nat -A OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333
	#-------------------------------------------------------
	# 局域网黑名单（不走ss）/局域网黑名单（走ss）
	lan_acess_control
	# 把最后剩余流量重定向到相应模式的nat表中对对应的主模式的链
	[ "$ss_acl_default_port" == "all" ] && ss_acl_default_port=""
	iptables -t nat -A SHADOWSOCKS -p tcp $(factor $ss_acl_default_port "-m multiport --dport") -j $(get_action_chain $ss_acl_default_mode)
	# 如果是主模式游戏模式，则把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM链
	# 如果主模式不是游戏模式，则不需要把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM，不然会造成其他模式主机的udp也走游戏模式
	[ "$mangle" == "1" ] && ss_acl_default_mode=3
	[ "$ss_basic_mode" == "3" ] || [ "$ss_basic_mode" == "4" ] && iptables -t mangle -A SHADOWSOCKS -p udp -j $(get_action_chain $ss_acl_default_mode)
	# 重定所有流量到 SHADOWSOCKS
	iptables -t nat -I PREROUTING 1 -p tcp -j SHADOWSOCKS
	[ "$mangle" == "1" ] && iptables -t mangle -I PREROUTING 1 -p udp -j SHADOWSOCKS
}

chromecast(){
	LOG1=开启chromecast功能（DNS劫持功能）
	LOG2=chromecast功能未开启，建议开启~
	if [ "$ss_basic_chromecast" == "1" ];then
		IPT_ACTION="-A"
		echo_date $LOG1
	else
		IPT_ACTION="-D"
		echo_date $LOG2
	fi
	iptables -t nat $IPT_ACTION PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}


case $1 in
start_all)
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
	;;
add_new_ip)
	add_white_black_ip
	;;
start_part_for_addon)
	#ss_basic_action=4
	flush_nat
	chromecast
	apply_nat_rules
	;;
*)
	echo "Usage: $0 (start_all|restart_wb_list)"
	exit 1
	;;
esac
