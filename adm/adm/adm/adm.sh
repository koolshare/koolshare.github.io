#!/bin/sh

# ====================================变量定义====================================
# 版本号定义
version="0.9"

# 导入skipd数据
eval `dbus export adm`
eval `dbus export ss_basic`

# 引用环境变量等
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp

# ss模式判断
ssmode=`nvram get ss_mode`

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
	perpctl A adm  >/dev/null 2>&1
}

# 停止ADM主程序
stop_adm(){
	perpctl X adm  >/dev/null 2>&1
    killall ADM >/dev/null 2>&1 &
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
	ipset -N adblock iphash
	ln -sf /koolshare/adm/adblock.conf /jffs/configs/dnsmasq.d/adblock.conf
	if [ "$ssmode" == "1" ] || [ "$ssmode" == "3" ] || [ "$ssmode" == "4" ] || [ "$ssmode" == "5" ] ;then
		# 当ss模式为gfwlist模式，游戏模式，游戏模式V2，全局模式时，应用此规则
		# iptables -t nat -A SHADOWSOCKS -p tcp --dport 80 -j REDIRECT --to-ports 18309
		iptables -t nat -A SHADOWSOCKS -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309
	elif [ "$ssmode" == "2" ];then
		# 当ss模式为大陆白名单模式时，应用此规则
    	# iptables -t nat -A REDSOCKS2 -p tcp --dport 80 -j REDIRECT --to-ports 18309
    	iptables -t nat -A REDSOCKS2 -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309
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
		# iptables -t nat -A ADM -p tcp --dport 80 -j REDIRECT --to-ports 18309
		iptables -t nat -A ADM -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309
		# Apply the rules
		iptables -t nat -A PREROUTING -p tcp -j ADM
	fi
}

# 去除去广告nat规则
remove_nat_rules(){
		rm -rf /jffs/configs/dnsmasq.d/adblock.conf
		# iptables -t nat -D SHADOWSOCKS -p tcp --dport 80 -j REDIRECT --to-ports 18309 >/dev/null 2>&1
    	# iptables -t nat -D REDSOCKS2 -p tcp --dport 80 -j REDIRECT --to-ports 18309 >/dev/null 2>&1
		# iptables -t nat -D PREROUTING -p tcp -j ADM >/dev/null 2>&1
		iptables -t nat -D SHADOWSOCKS -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309 >/dev/null 2>&1
		iptables -t nat -D REDSOCKS2 -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309 >/dev/null 2>&1
		iptables -t nat -D ADM -p tcp --dport 80 -m set --match-set adblock dst -j REDIRECT --to-ports 18309 >/dev/null 2>&1
		iptables -t nat -F ADM >/dev/null 2>&1
		iptables -t nat -X ADM >/dev/null 2>&1
		ipset -F adblock >/dev/null 2>&1
		ipset -X adblock >/dev/null 2>&1
}

# 用户自定义规则
add_user_rule(){
	user_rule=$(echo $adm_user | sed "s/,/ /g")
	for line in $user_rule
	do echo $line >> /koolshare/adm/user.txt
	done
}

# 删除用户自定义规则
del_user_rule(){
	sed -i '29,$d' /koolshare/adm/user.txt
}

# 没有版本号时
write_adm_version(){
	if [ -z $adm_version ];then
		dbus set adm_version="$version"
	fi
}

# 为ADM进程设置更多的连接数
set_ulimit(){
	ulimit -n 16384
}

# 每天凌晨删除adm的日志文件
add_remove_log(){
	cru a adm_log_remove "0 3 * * * /bin/sh /koolshare/adm/remove_adm_log.sh" >/dev/null 2>&1
}

# 每天凌晨删除adm的日志文件
remove_log(){
	sed -i '/adm_log_remove/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
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
	add_remove_log
	service dnsmasq_restart
	fi
	;;
stop | kill )
	remove_nat_rules
	del_process_protect
	stop_adm
	remove_ss_event
	del_user_rule
	rm -rf /koolshare/adm/*.log
	;;
restart)
	remove_nat_rules
	del_user_rule
	del_process_protect
	stop_adm
	remove_ss_event
	remove_log
	killall dnsmasq
	sleep 1
	set_ulimit
	add_user_rule
	add_process_protect
	start_adm
	update_nat_rules
	service dnsmasq_start
	add_ss_event
	write_adm_version
	add_remove_log
	;;
*)
	echo "Usage: $0 (start|stop|restart|check|kill|update)"
	exit 1
	;;
esac

