#!/bin/sh
eval `dbus export koolproxy`

# 引用环境变量等
source /koolshare/scripts/base.sh


start_koolproxy(){
	perp=`ps | grep perpd |grep -v grep`
	echo $(date): 开启koolproxy主进程！
	cd /koolshare/koolproxy
  	if [ "$koolproxy_enable" == "1" ];then
  		if [ "$koolproxy_debug" == "1" ];then
			/koolshare/bin/koolproxy -d -b /koolshare/koolproxy/data -d -l 2 >/dev/null 2>&1 &
		else
			/koolshare/bin/koolproxy -d -b /koolshare/koolproxy/data >/dev/null 2>&1 &
		fi
  	fi
	rules_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==2{print}'`
	rules_nu_local=`grep -v !x /koolshare/koolproxy/data/koolproxy.txt | wc -l`
	video_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==4{print}'`
	
	echo $(date): 加载静态规则日期：$rules_date_local
	echo $(date): 加载静态规则条数：$rules_nu_local
	dbus set koolproxy_rule_info="更新日期：$rules_date_local / $rules_nu_local条"
	echo $(date): 加载视频规则日期：$video_date_local
	dbus set koolproxy_video_info="更新日期：$video_date_local"
}

stop_koolproxy(){
	echo $(date): 关闭koolproxy主进程和守护进程...
	killall koolproxy
	#kill -9 `pidof koolproxy` >/dev/null 2>&1
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 1
	done
	echo $(date): 加载nat规则！
	[ "$koolproxy_policy" == "2" ] && ipset -N black_koolproxy iphash
	iptables -t nat -N koolproxy
	[ "$koolproxy_policy" == "2" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -m set --set black_koolproxy dst -j koolproxy
	[ "$koolproxy_policy" == "1" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -j koolproxy
	iptables -t nat -A koolproxy -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 10.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 127.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 169.254.0.0/16 -j RETURN
	iptables -t nat -A koolproxy -d 172.16.0.0/12 -j RETURN
	iptables -t nat -A koolproxy -d 192.168.0.0/16 -j RETURN
	iptables -t nat -A koolproxy -d 224.0.0.0/4 -j RETURN
	iptables -t nat -A koolproxy -d 240.0.0.0/4 -j RETURN

	# lan control
	# 不需要走koolproxy的局域网ip地址：白名单
	white=$(echo $koolproxy_white_lan | sed "s/,/ /g")
	if [ "$koolproxy_lan_control" == "2" ] && [ ! -z "$koolproxy_white_lan" ];then
		for white_ip in $white
		do
			iptables -t nat -A koolproxy -s $white_ip -j RETURN
		done
		iptables -t nat -A koolproxy -p tcp -j REDIRECT --to-ports 3000
	fi

	# 需要走koolproxy的局域网ip地址：黑名单
	black=$(echo $koolproxy_black_lan | sed "s/,/ /g")
	if [ "$koolproxy_lan_control" == "1" ] && [ ! -z "$koolproxy_black_lan" ];then
		for balck_ip in $black
		do
			iptables -t nat -A koolproxy -p tcp -s $balck_ip -j REDIRECT --to-ports 3000
		done
	elif [ "$koolproxy_lan_control" == "1" ] && [ -z "$koolproxy_black_lan" ];then
		iptables -t nat -A koolproxy -p tcp -j REDIRECT --to-ports 3000
	fi

	#所有客户端都走koolproxy
	if [ "$koolproxy_lan_control" == "0" ];then
		iptables -t nat -A koolproxy -p tcp -j REDIRECT --to-ports 3000
	fi
	
}

dns_takeover(){
	ss_chromecast=`dbus get ss_basic_chromecast`
	lan_ipaddr=`nvram get lan_ipaddr`
	#chromecast=`iptables -t nat -L PREROUTING -v -n|grep "dpt:53"`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ "$koolproxy_policy" == "2" ]; then
		if [ -z "$chromecast_nu" ]; then
			echo $(date): 黑名单模式开启DNS劫持
			iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
		else
			echo $(date): DNS劫持规则已经添加，跳过~
		fi
	else
		if [ "$ss_chromecast" != "1" ]; then
			if [ ! -z "$chromecast_nu" ]; then
				echo $(date): 全局过滤模式下删除DNS劫持
				iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
				echo $(date): done
				echo $(date):
			fi
		fi
	fi
}


flush_nat(){
	echo $(date): 移除nat规则...
	iptables -t nat -F koolproxy > /dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp --dport 80 -m set --set black_koolproxy dst -j koolproxy > /dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp --dport 80 -j koolproxy > /dev/null 2>&1
	iptables -t nat -X koolproxy > /dev/null 2>&1
	ipset -F black_koolproxy > /dev/null 2>&1
	ipset -X black_koolproxy > /dev/null 2>&1
}

creat_start_up(){
	echo $(date): 加入开机自动启动...
	rm -rf /koolshare/init.d/S93koolproxy.sh
	ln -sf /koolshare/koolproxy/koolproxy.sh /koolshare/init.d/S93koolproxy.sh
}

write_nat_start(){
	echo $(date): 添加nat-start触发事件...
	dbus set __event__onnatstart_koolproxy="/koolshare/koolproxy/nat_load.sh"
}

remove_nat_start(){
	echo $(date): 删除nat-start触发事件...
	dbus remove __event__onnatstart_koolproxy
}

add_ipset_conf(){
	if [ "$koolproxy_policy" == "2" ];then
		echo $(date): 添加黑名单软连接...
		rm -rf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
		ln -sf /koolshare/koolproxy/data/koolproxy_ipset.conf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
	fi
}

remove_ipset_conf(){
	if [ -L /jffs/configs/dnsmasq.d/koolproxy_ipset.conf ];then
		echo $(date): 移除黑名单软连接...
		rm -rf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
	fi
}

write_cron_job(){
	# start setvice
	if [ "1" == "$koolproxy_update" ]; then
		echo $(date): 开启规则定时更新，每天"$koolproxy_update_hour"时"$koolproxy_update_min"分，检查在线规则更新...
		cru a koolproxy_update "$koolproxy_update_min $koolproxy_update_hour * * * /bin/sh /koolshare/scripts/koolproxy_rule_update.sh"
	elif [ "2" == "$koolproxy_update" ]; then
		echo $(date): 开启规则定时更新，每隔"$koolproxy_update_inter_hour"时"$koolproxy_update_inter_min"分，检查在线规则更新...
		cru a koolproxy_update "*/$koolproxy_update_inter_min */$koolproxy_update_inter_hour * * * /bin/sh /koolshare/scripts/koolproxy_rule_update.sh"
	else
		echo $(date): 规则自动更新关闭状态，不启用自动更新...
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep koolproxy_update`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): 关闭定时更新...
		sed -i '/koolproxy_update/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

add_ss_event(){
	start=`dbus list __event__onssstart_|grep koolproxy`
	if [ -z "$start" ];then
	echo $(date): 添加ss事件触发：当ss启用或者重启，重新加载koolproxy的nat规则.
	dbus event onssstart_koolproxy /koolshare/koolproxy/nat_load.sh
	fi
}

remove_ss_event(){
	dbus remove __event__onssstart_koolproxy
}

write_reboot_job(){
	# start setvice
	if [ "1" == "$koolproxy_reboot" ]; then
		echo $(date): 开启插件定时重启，每天"$koolproxy_reboot_hour"时"$koolproxy_reboot_min"分，自动重启插件...
		cru a koolproxy_reboot "$koolproxy_reboot_min $koolproxy_reboot_hour * * * /bin/sh /koolshare/koolproxy/koolproxy.sh restart"
	elif [ "2" == "$koolproxy_reboot" ]; then
		cru a koolproxy_reboot "*/$koolproxy_reboot_inter_min */$koolproxy_reboot_inter_hour * * * /bin/sh /koolshare/koolproxy/koolproxy.sh restart"
		echo $(date): 开启插件间隔重启，每隔"$koolproxy_reboot_inter_hour"时"$koolproxy_reboot_inter_min"分，自动重启插件...
	fi
}

remove_reboot_job(){
	jobexist=`cru l|grep koolproxy_reboot`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): 关闭插件定时重启...
		sed -i '/koolproxy_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

load_module(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -f /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko ] && [ -z "$xt" ];then
		echo $(date): "加载xt_set.ko内核模块！"
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko
	fi
}

case $ACTION in
start)
	start_koolproxy
	nvram set koolproxy_uptime=1
	add_ipset_conf
	service restart_dnsmasq > /dev/null 2>&1
	load_module
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_cron_job
	write_reboot_job
	add_ss_event
	;;
restart)
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	sleep 2
	start_koolproxy
	nvram set koolproxy_uptime=1
	add_ipset_conf
	echo $(date): 重启dnsmasq进程...
	service restart_dnsmasq > /dev/null 2>&1
	load_module
	load_nat
	dns_takeover
	creat_start_up
	write_nat_start
	write_cron_job
	write_reboot_job
	add_ss_event
	echo $(date): koolproxy启用成功，请等待日志窗口自动关闭，页面会自动刷新...
	;;
restart_nat)
	if [ "$koolproxy_enable" == "1" ];then
		flush_nat
		sleep 2
		load_nat
	fi
	;;
stop)
	remove_ss_event
	remove_reboot_job
	remove_ipset_conf
	service restart_dnsmasq > /dev/null 2>&1
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	rm -rf /koolshare/init.d/S93koolproxy.sh
	;;
esac
