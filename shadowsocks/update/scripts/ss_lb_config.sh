#! /bin/sh
# 导入skipd数据
eval `dbus export ss`

# 引用环境变量等
source /koolshare/scripts/base.sh
username=`nvram get http_username`

write_haproxy_cfg(){
	echo $(date): 生成haproxy配置文件到/koolshare/configs目录.
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
		    timeout connect         3s                                   
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
		resolvers mydns
		    nameserver dns1 119.29.29.29:53
		    nameserver dns2 114.114.114.114:53
		    resolve_retries       3
		    timeout retry         2s
		    hold valid           10s
		listen shadowscoks_balance_load
		    bind 0.0.0.0:$ss_lb_port
		    mode tcp
		    balance roundrobin
	EOF
if [ "$ss_lb_heartbeat" == "1" ];then
	echo $(date): 启用故障转移心跳...
	lb_node=`dbus list ssconf_basic_use_lb_|sed 's/ssconf_basic_use_lb_//g' |cut -d "=" -f 1 | sort -n`
	for node in $lb_node
	do
		#server_ip=`nslookup "$server" 119.29.29.29 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		nick_name=`dbus get ssconf_basic_name_$node`
		kcp=`dbus get ssconf_basic_use_kcp_$node`
		if [ "$kcp" == 1 ];then
			port="1091"
			name=`dbus get ssconf_basic_server_$node`:kcp
			server="127.0.0.1"
		else
			port=`dbus get ssconf_basic_port_$node`
			name=`dbus get ssconf_basic_server_$node`
			server=`dbus get ssconf_basic_server_$node`
			IFIP=`echo $server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
			if [ -z "$IFIP" ];then
				echo $(date): 检测到【"$nick_name"】节点域名格式，将尝试进行解析...
				if [ "$ss_basic_dnslookup" == "1" ];then
					echo $(date): 使用nslookup方式解析SS服务器的ip地址，解析dns：$ss_basic_dnslookup_server
					server=`nslookup "$server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
				else
					echo $(date): 使用resolveip方式解析SS服务器的ip地址.
					server=`resolveip -4 -t 2 $server|awk 'NR==1{print}'`
				fi

				if [ ! -z "$server" ];then
					echo $(date): 【"$nick_name"】节点ip地址解析成功：$server
				else
					echo $(date):【警告】：【"$nick_name"】节点ip解析失败，将由haproxy自己尝试解析.
					server=`dbus get ssconf_basic_server_$node`
				fi
			else
				echo $(date): 检测到【"$nick_name"】节点已经是IP格式，跳过解析... 
			fi
		fi
		weight=`dbus get ssconf_basic_weight_$node`
		up=`dbus get ss_lb_up`
		down=`dbus get ss_lb_down`
		interval=`dbus get ss_lb_interval`
		mode=`dbus get ssconf_basic_lbmode_$node`
		if [ "$mode" == "3" ];then
			echo $(date): 载入【"$nick_name"】作为备用节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server:$port weight $weight rise $up fall $down check inter $interval resolvers mydns backup
			EOF
		elif [ "$mode" == "2" ];then
			echo $(date): 载入【"$nick_name"】作为主用节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server:$port weight $weight rise $up fall $down check inter $interval resolvers mydns
			EOF
		else
			echo $(date): 载入【"$nick_name"】作为负载均衡节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server:$port weight $weight rise $up fall $down check inter $interval resolvers mydns
			EOF
		fi
	done

else
	echo $(date): 不启用故障转移心跳...
	lb_node=`dbus list ssconf_basic_use_lb_|sed 's/ssconf_basic_use_lb_//g' |cut -d "=" -f 1 | sort -n`
	for node in $lb_node
	do
		kcp=`dbus get ssconf_basic_use_kcp_$node`
		if [ "$kcp" == 1 ];then
			port="1091"
			name=`dbus get ssconf_basic_server_$node`:kcp
			server="127.0.0.1"
		else
			port=`dbus get ssconf_basic_port_$node`
			name=`dbus get ssconf_basic_server_$node`
			server=`dbus get ssconf_basic_server_$node`
			IFIP=`echo $server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
			if [ -z "$IFIP" ];then
				echo $(date): 检测到【"$nick_name"】节点域名格式，将尝试进行解析...
				if [ "$ss_basic_dnslookup" == "1" ];then
					echo $(date): 使用nslookup方式解析SS服务器的ip地址，解析dns：$ss_basic_dnslookup_server
					server=`nslookup "$server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
				else
					echo $(date): 使用resolveip方式解析SS服务器的ip地址.
					server=`resolveip -4 -t 2 $server|awk 'NR==1{print}'`
				fi

				if [ ! -z "$server" ];then
					echo $(date): 【"$nick_name"】节点ip地址解析成功：$server
				else
					echo $(date): 【"$nick_name"】节点ip解析失败，将由haproxy自己尝试解析...
					server=`dbus get ssconf_basic_server_$node`
				fi
			else
				echo $(date): 检测到【"$nick_name"】节点已经是IP格式，跳过解析... 
			fi
		fi
		port=`dbus get ssconf_basic_port_$node`
		weight=`dbus get ssconf_basic_weight_$node`
		mode=`dbus get ssconf_basic_lbmode_$node`
		nick_name=`dbus get ssconf_basic_name_$node`
		if [ "$mode" == "3" ];then
			echo $(date): 载入节点："$nick_name"，作为备用节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server_ip:$port weight $weight resolvers mydns backup
			EOF
		elif [ "$mode" == "2" ];then
			echo $(date): 载入节点："$nick_name"，作为主节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server_ip:$port weight $weight resolvers mydns
			EOF
		else
			echo $(date): 载入节点："$nick_name"，作为负载均衡节点...
			cat >> /koolshare/configs/haproxy.cfg <<-EOF
			    server $name $server_ip:$port weight $weight resolvers mydns
			EOF
		fi
	done
fi
}

start_haproxy(){
	pid=`pidof haproxy`
	if [ -z "$pid" ];then
		echo $(date): ┏启动haproxy主进程...
		echo $(date): ┣如果此处等待过久，可能服务器域名解析失败造成的！可以刷新页面后关闭一次SS!
		echo $(date): ┣然后进入附加设置-SS服务器地址解析，更改解析dns或者更换解析方式！
		echo $(date): ┗启动haproxy主进程...
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
	killall haproxy >/dev/null 2>&1
	write_haproxy_cfg
	start_haproxy
else
	killall haproxy >/dev/null 2>&1
fi
