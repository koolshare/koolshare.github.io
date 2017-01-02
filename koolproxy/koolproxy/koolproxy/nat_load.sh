#! /bin/sh
#这个脚本是单独用于nat重新加载的脚本，由onnatstart触发，当iptables被flush掉的时候，由它重新加载nat

# 导入skipd数据
eval `dbus export koolproxy`

flush_nat(){
	echo $(date): 移除nat规则...
	iptables -t nat -F koolproxy > /dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp --dport 80 -m set --set black_koolproxy dst -j koolproxy > /dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp --dport 80 -j koolproxy > /dev/null 2>&1
	iptables -t nat -X koolproxy > /dev/null 2>&1
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

if [ "$koolproxy_enable" == "1" ];then
	flush_nat
	sleep 2
	load_nat
fi
