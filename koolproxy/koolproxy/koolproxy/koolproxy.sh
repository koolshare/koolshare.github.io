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
	perpctl A koolproxy >/dev/null 2>&1
}

stop_koolproxy(){
	perpctl X koolproxy >/dev/null 2>&1
	killall koolproxy
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
	echo $(date): "Apply nat rules!"
	[ "$koolproxy_policy" == "2" ] && ipset -N black_koolproxy iphash
	iptables -t nat -N koolproxy
	[ "$koolproxy_policy" == "2" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -m set --match-set black_koolproxy dst -j koolproxy
	[ "$koolproxy_policy" == "1" ] && iptables -t nat -A PREROUTING -p tcp --dport 80 -j koolproxy
	iptables -t nat -A SHADOWSOCKS -p tcp -m set $MATCH_SET gfwlist dst -j REDIRECT --to-ports 3333
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
	ipset -F black_koolproxy > /dev/null 2>&1
	ipset -X black_koolproxy > /dev/null 2>&1
	cd /tmp
	iptables -t nat -S | grep koolproxy | sed 's/-A/iptables -t nat -D/g'|sed 1d > clean.sh && chmod 700 clean.sh && ./clean.sh && rm clean.sh
	iptables -t nat -X koolproxy > /dev/null 2>&1
	iptables -t nat -X PREROUTING -p tcp --dport 80 -m --match-set black_koolproxy dst -j koolproxy > /dev/null 2>&1
}

creat_start_up(){
	rm -rf /koolshare/init.d/S93koolproxy.sh
	ln -sf /koolshare/koolproxy/koolproxy.sh /koolshare/init.d/S93koolproxy.sh
}

write_nat_start(){
	dbus set __event__onnatstart_koolproxy="/koolshare/koolproxy/nat_load.sh"
}

remove_nat_start(){
	dbus remove __event__onnatstart_koolproxy
}

add_ipset_conf(){
	[ "$koolproxy_policy" == "2" ] && ln -sf /koolshare/koolproxy/data/koolproxy_ipset.conf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
}

remove_ipset_conf(){
	[ "$koolproxy_policy" == "2" ] && rm -rf /jffs/configs/dnsmasq.d/koolproxy_ipset.conf
}

case $ACTION in
start)
	start_koolproxy
	add_ipset_conf
	service restart_dnsmasq
	load_nat
	creat_start_up
	write_nat_start
	;;
restart)
	stop_koolproxy
	remove_ipset_conf
	remove_nat_start
	flush_nat
	sleep 2
	start_koolproxy
	add_ipset_conf
	service restart_dnsmasq
	load_nat
	creat_start_up
	write_nat_start
	;;
restart_nat)
	if [ "$koolproxy_enable" == "1" ];then
		flush_nat
		sleep 2
		load_nat
	fi
	;;
stop)
	stop_koolproxy
	remove_ipset_conf
	service restart_dnsmasq
	remove_nat_start
	flush_nat
	rm -rf /koolshare/init.d/S93koolproxy.sh
	;;
esac
