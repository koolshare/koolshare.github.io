#! /bin/sh
# 导入skipd数据
eval `dbus export ss`

# 引用环境变量等
source /koolshare/scripts/base.sh
username=`nvram get http_username`

write_haproxy_cfg(){
	cat > /koolshare/configs/haproxy.cfg <<-EOF
		global
		    log         127.0.0.1 local2
		    chroot      /usr/bin
		    pidfile     /var/run/haproxy.pid
		    maxconn     4000
		    user        nobody
		    daemon
		defaults
		    mode                    tcp
		    log                     global
		    option                  tcplog
		    option                  dontlognull
		    option http-server-close
		    #option forwardfor      except 127.0.0.0/8
		    option                  redispatch
		    retries                 2
		    timeout http-request    10s
		    timeout queue           1m
		    timeout connect         2s                                   
		    timeout client          1m
		    timeout server          1m
		    timeout http-keep-alive 10s
		    timeout check           10s
		    maxconn                 3000
	
		listen admin_status
		    bind 0.0.0.0:1188
		    mode http                
		    stats refresh 30s    
		    stats uri  /
		    stats auth $username:$ss_lb_passwd
		    #stats hide-version  
		    stats admin if TRUE

		listen shadowscoks_balance_load
		    bind 0.0.0.0:$ss_lb_port
		    mode tcp
		    balance roundrobin	
	EOF
		    ##server hk hk.mjy211.com:33211 weight 50 rise 2 fall 3 check inter 2000
		    #server ss01 jp1.h2ss.cc:10030 rise 2 fall 3 check inter 2000
if [ "$ss_lb_heartbeat" == "1" ];then
	lb_node=`dbus list ssconf_basic_use_lb_|sed 's/ssconf_basic_use_lb_//g' |cut -d "=" -f 1 | sort -n`
	for node in $lb_node
	do
		server=`dbus get ssconf_basic_server_$node`
		#server_ip=`nslookup "$server" 119.29.29.29 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		port=`dbus get ssconf_basic_port_$node`
		weight=`dbus get ssconf_basic_weight_$node`
		up=`dbus get ss_lb_up`
		down=`dbus get ss_lb_down`
		interval=`dbus get ss_lb_interval`
		mode=`dbus get ssconf_basic_lbmode_$node`
		if [ "$mode" == "3" ];then
cat >> /koolshare/configs/haproxy.cfg <<EOF
	server $server $server:$port weight $weight rise 2 fall 3 check inter 2000 backup
EOF
		else
cat >> /koolshare/configs/haproxy.cfg <<EOF
	server $server $server:$port weight $weight rise 2 fall 3 check inter 2000
EOF
		fi

	done

else

	lb_node=`dbus list ssconf_basic_use_lb_|sed 's/ssconf_basic_use_lb_//g' |cut -d "=" -f 1 | sort -n`
	for node in $lb_node
	do
		server=`dbus get ssconf_basic_server_$node`
		server_ip=`nslookup "$server" 119.29.29.29 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		port=`dbus get ssconf_basic_port_$node`
		weight=`dbus get ssconf_basic_weight_$node`
		mode=`dbus get ssconf_basic_lbmode_$node`
		if [ "$mode" == "3" ];then
cat >> /koolshare/configs/haproxy.cfg <<EOF
	server $server $server_ip:$port weight $weight backup
EOF
		else
cat >> /koolshare/configs/haproxy.cfg <<EOF
	server $server $server_ip:$port weight $weight
EOF
		fi
	done
fi
}

start_haproxy(){
	pid=`pidof haproxy`
	if [ -z "$pid" ];then
		haproxy -f /koolshare/configs/haproxy.cfg
	fi
}

add_ssf_event(){
	start=`dbus list __event__onssfstart_|grep haproxy`
	if [ -z "$start" ];then
		dbus event onssfstart_haproxy /koolshare/scripts/ss_prestart.sh
	fi
}

remove_ss_event(){
	dbus remove __event__onssfstart_haproxy
}

if [ "$ss_lb_enable" == "1" ];then
	killall haproxy
	write_haproxy_cfg
	start_haproxy
	add_ssf_event
else
	killall haproxy
	remove_ss_event
fi
