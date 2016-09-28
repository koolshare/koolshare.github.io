#! /bin/sh
# 导入skipd数据
eval `dbus export koolproxy`

# 引用环境变量等
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp


start_koolproxy(){
	perp=`ps | grep perpd |grep -v grep`
	if [ -z "$perp" ];then
		sh /koolshare/perp/perp.sh stop
		sh /koolshare/perp/perp.sh start
	fi
	echo $(date): 开启koolproxy主进程！
	perpctl A koolproxy >/dev/null 2>&1

	
	rules_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==2{print}'`
	rules_nu_local=`cat /koolshare/koolproxy/data/koolproxy.txt | grep -v ! | wc -l`
	video_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==4{print}'`
	
	echo $(date): 加载静态规则日期：$rules_date_local
	echo $(date): 加载静态规则条数：$rules_nu_local
	dbus set koolproxy_rule_info="更新日期：$rules_date_local / $rules_nu_local条"
	echo $(date): 加载视频规则日期：$video_date_local
	dbus set koolproxy_video_info="更新日期：$rules_date_local"
}

stop_koolproxy(){
	echo $(date): 关闭koolproxy主进程和守护进程...
	perpctl X koolproxy >/dev/null 2>&1
	killall koolproxy > /dev/null 2>&1
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
	[ "$koolproxy_policy" == "2" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -m set --match-set black_koolproxy dst -j koolproxy
	[ "$koolproxy_policy" == "1" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -j koolproxy
	iptables -t nat -A koolproxy -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 10.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 127.0.0.0/8 -j RETURN
	iptables -t nat -A koolproxy -d 169.254.0.0/16 -j RETURN
	iptables -t nat -A koolproxy -d 172.16.0.0/12 -j RETURN
	iptables -t nat -A koolproxy -d 192.168.0.0/16 -j RETURN
	iptables -t nat -A koolproxy -d 224.0.0.0/4 -j RETURN
	iptables -t nat -A koolproxy -d 240.0.0.0/4 -j RETURN
	iptables -t nat -A koolproxy -p tcp -j REDIRECT --to-ports 3000
}

flush_nat(){
	echo $(date): 移除nat规则...

	cd /tmp
	iptables -t nat -S | grep koolproxy | sed 's/-A/iptables -t nat -D/g'|sed 1d > clean.sh && chmod 700 clean.sh && ./clean.sh && rm clean.sh
	iptables -t nat -X koolproxy > /dev/null 2>&1
	iptables -t nat -X PREROUTING -p tcp --dport 80 -m --match-set black_koolproxy dst -j koolproxy > /dev/null 2>&1

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
		echo $(date): 开启规则定时更新，每"$koolproxy_update_time"个小时检查在线规则更新...
		cru a koolproxy_update "0 */"$koolproxy_update_time" * * * /bin/sh /koolshare/koolproxy/rule_update.sh"
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

case $ACTION in
start)
	start_koolproxy
	add_ipset_conf
	service restart_dnsmasq > /dev/null 2>&1
	load_nat
	creat_start_up
	write_nat_start
	write_cron_job
	;;
restart)
	remove_ipset_conf
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	sleep 2
	start_koolproxy
	add_ipset_conf
	echo $(date): 重启dnsmasq进程...
	service restart_dnsmasq > /dev/null 2>&1
	load_nat
	creat_start_up
	write_nat_start
	write_cron_job
	;;
restart_nat)
	if [ "$koolproxy_enable" == "1" ];then
		flush_nat
		sleep 2
		load_nat
	fi
	;;
stop)
	remove_ipset_conf
	service restart_dnsmasq > /dev/null 2>&1
	remove_nat_start
	flush_nat
	stop_koolproxy
	kill_cron_job
	rm -rf /koolshare/init.d/S93koolproxy.sh
	;;
esac
