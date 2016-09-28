#! /bin/sh
#这个脚本是单独用于nat重新加载的脚本，由onnatstart触发，当iptables被flush掉的时候，由它重新加载nat

# 导入skipd数据
eval `dbus export koolproxy`

flush_nat(){
	echo $(date): 移除nat规则...

	cd /tmp
	iptables -t nat -S | grep koolproxy | sed 's/-A/iptables -t nat -D/g'|sed 1d > clean.sh && chmod 700 clean.sh && ./clean.sh && rm clean.sh
	iptables -t nat -X koolproxy > /dev/null 2>&1
	iptables -t nat -X PREROUTING -p tcp --dport 80 -m --match-set black_koolproxy dst -j koolproxy > /dev/null 2>&1

	ipset -F black_koolproxy > /dev/null 2>&1
	ipset -X black_koolproxy > /dev/null 2>&1
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

if [ "$koolproxy_enable" == "1" ];then
	flush_nat
	sleep 2
	load_nat
fi