#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh

#--------------------------------------------------------------------------------------
resolv_server_ip(){
	IFIP=`echo $ss_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
	if [ -z "$IFIP" ];then
		echo $(date): 检测到你的SS服务器为域名格式，将尝试进行解析...
		if [ "$ss_basic_dnslookup" == "1" ];then
			echo $(date): 使用nslookup方式解析SS服务器的ip地址.
			server_ip=`nslookup "$ss_basic_server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		else
			echo $(date): 使用resolveip方式解析SS服务器的ip地址.
			server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
		fi

		if [ ! -z "$server_ip" ];then
			echo $(date): SS服务器的ip地址解析成功：$server_ip.
			ss_basic_server="$server_ip"
			dbus set ss_basic_server_ip="$server_ip"
			dbus set ss_basic_dns_success="1"
		else
			echo $(date): SS服务器的ip地址解析失败，将由ss-redir自己解析.
			dbus set ss_basic_dns_success="0"
		fi
	else
		echo $(date): 检测到你的SS服务器已经是IP格式，跳过解析... 
	fi
}
# create shadowsocks config file...
creat_ss_json(){
	echo $(date): 创建SS配置文件到/koolshare/ss/overall/ss.json
	if [ "$ss_basic_use_kcp" == "1" ];then
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > /koolshare/ss/overall/ss.json <<-EOF
				{
				    "server":"127.0.0.1",
				    "server_port":1091,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "method":"$ss_basic_method"
				}
			EOF
		elif [ "$ss_basic_use_rss" == "1" ];then
			cat > /koolshare/ss/overall/ss.json <<-EOF
				{
				    "server":"127.0.0.1",
				    "server_port":1091,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "protocol":"$ss_basic_rss_protocol",
				    "obfs":"$ss_basic_rss_obfs",
				    "obfs_param":"$ss_basic_rss_obfs_param",
				    "method":"$ss_basic_method"
				}
			EOF
		fi
	else
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > /koolshare/ss/overall/ss.json <<-EOF
				{
				    "server":"$ss_basic_server",
				    "server_port":$ss_basic_port,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "method":"$ss_basic_method"
				}
			EOF
		elif [ "$ss_basic_use_rss" == "1" ];then
			cat > /koolshare/ss/overall/ss.json <<-EOF
				{
				    "server":"$ss_basic_server",
				    "server_port":$ss_basic_port,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "protocol":"$ss_basic_rss_protocol",
				    "obfs":"$ss_basic_rss_obfs",
				    "obfs_param":"$ss_basic_rss_obfs_param",
				    "method":"$ss_basic_method"
				}
			EOF
		fi
	fi
}
#---------------------------------------------------------------------------------------------------------
creat_dnsmasq_basic_conf(){
	# make directory if not exist
	mkdir -p /jffs/configs/dnsmasq.d
	rm -rf /jffs/configs/dnsmasq.conf.add
	
	# create dnsmasq.conf.add
	echo $(date): 创建dnsmasq基础配置到/jffs/configs/dnsmasq.conf.add
	touch /jffs/configs/dnsmasq.conf.add
	echo no-resolv >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "0" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "1" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "all-servers" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "server=127.0.0.1#1054" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "3" ] && echo "server=127.0.0.1#7913" >> /jffs/configs/dnsmasq.conf.add
	
	# append router output chain rules
	echo $(date): 创建路由内部走代理的规则，用于SS状态检测.
	cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add

	# create dnsmasq postconf
	echo $(date): 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
		#cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		ln -sf /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
}
#---------------------------------------------------------------------------------------------------------
nat_auto_start(){
	mkdir -p /jffs/scripts
	# creating iptables rules to nat-start
	if [ ! -f /jffs/scripts/nat-start ]; then
	cat > /jffs/scripts/nat-start <<-EOF
		#!/bin/sh
		dbus fire onnatstart
		
		EOF
	fi
	writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
	if [ -z "$writenat" ];then
		echo $(date): 添加nat-start触发事件...用于ss的nat规则重启后或网络恢复后的加载.
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		sed -i '3a sh /koolshare/ss/overall/nat-start start_all' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
}

wan_auto_start(){
	# Add service to auto start
	if [ ! -f /jffs/scripts/wan-start ]; then
		cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			dbus fire onwanstart
			
			EOF
	fi
	startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
	if [ -z "$startss" ];then
		echo $(date): 添加wan-start触发事件...用于ss的各种程序的开机启动，启动延迟$ss_basic_sleep
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
		sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
}
#=========================================================================================================
write_cron_job(){
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): 添加ss规则定时更新任务，每天"$ss_basic_rule_update_time"自动检测更新规则.
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/scripts/ss_rule_update.sh"
	else
		echo $(date): ss规则定时更新任务未启用！
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep ssupdate`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): 删除ss规则定时更新任务.
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

start_dns(){
	# Start dnscrypt-proxy
	if [ "$ss_overall_dns" == "0" ]; then
		echo $(date): 开启 dnscrypt-proxy，你选择了"$ss_redchn_opendns"节点.
		dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "cisco(opendns)"
	fi
	
	if [ "$ss_overall_dns" == "1" ]; then
		ss-tunnel -d 127.0.0.1 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
		if [ "$ss_basic_use_rss" == "1" ];then
			echo $(date): 开启ssr-tunnel...
			rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			echo $(date): 开启ss-tunnel...
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
			fi
		fi
	fi
	
	if [ "$ss_overall_dns" == "2" ]; then
		echo $(date): 开启 dnscrypt-proxy，你选择了"$ss_redchn_opendns"节点.
		dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "cisco(opendns)"
		if [ "$ss_basic_use_rss" == "1" ];then
			echo $(date): 开启ssr-tunnel...
			rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			echo $(date): 开启ss-tunnel...
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
			fi
		fi
	fi								
	
	# Start Pcap_DNSProxy
	if [ "$ss_overall_dns" == "3" ]; then
			echo $(date): 开启Pcap_DNSProxy..
			sed -i '/^Listen Port/c Listen Port = 7913' /koolshare/ss/dns/Config.conf
	      	sed -i '/^Local Main/c Local Main = 1' /koolshare/ss/dns/Config.conf
			/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
	fi
}

stop_dns(){
	dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
	Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
	sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
	rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
	
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): 关闭dnscrypt-proxy进程...
		killall dnscrypt-proxy
	fi

	# kill ss-tunnel
	if [ ! -z "$sstunnel" ]; then 
		echo $(date): 关闭ss-tunnel进程...
		killall ss-tunnel >/dev/null 2>&1
	fi
	
	if [ ! -z "$rsstunnel" ]; then 
		echo $(date): 关闭rss-tunnel进程...
		killall rss-tunnel >/dev/null 2>&1
	fi
	
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then 
		echo $(date): 关闭Pcap_DNSProxy进程...
		killall dns.sh >/dev/null 2>&1
		killall Pcap_DNSProxy >/dev/null 2>&1
	fi

}

start_kcp(){
	# Start ss-redir
	if [ "$ss_basic_use_kcp" == "1" ];then
		echo $(date): 启动KCP协议进程，为了更好的体验，建议在路由器上创建虚拟内存.
		export GOGC=40
		start-stop-daemon -S -q -b -m -p /tmp/var/kcp.pid -x /koolshare/bin/client_linux_arm5 -- -l 127.0.0.1:1091 -r $ss_basic_server:$ss_basic_kcp_port $ss_basic_kcp_parameter
	fi
}

start_ss_redir(){
	# Start ss-redir
	if [ "$ss_basic_use_rss" == "1" ];then
		echo $(date): 开启ssr-redir进程，用于透明代理.
		rss-redir -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		echo $(date): 开启ss-redir进程，用于透明代理.
		if [ "$ss_basic_onetime_auth" == "1" ];then
			echo $(date): 你开启了ss-redir的一次性验证，请确保你的ss服务器是否支持.
			ss-redir -b 0.0.0.0 -A -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-redir -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid
		fi
	fi
}

	
load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "错误：不能正确加载nat规则!"
	        echo $(date): "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 2
	done
	echo $(date): "加载nat规则!"
	sh /koolshare/ss/overall/nat-start start_all
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): 重启dnsmasq服务...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
}

remove_status(){
	nvram set ss_foreign_state=""
	nvram set ss_china_state=""
}

main_portal(){
	if [ "$ss_main_portal" == "1" ];then
		nvram set enable_ss=1
		nvram commit
	else
		nvram set enable_ss=0
		nvram commit
	fi
}

case $1 in
start_all)
	#ss_basic_action=1 应用所有设置
	echo $(date): --------------------- 梅林固件 shadowsocks 全局模式 -----------------------
	resolv_server_ip
	creat_ss_json
	creat_dnsmasq_basic_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	start_dns
	start_ss_redir
	start_kcp
	load_nat
	restart_dnsmasq
	remove_status
	nvram set ss_mode=5
	nvram commit
	echo $(date): ---------------------- shadowsocks 全局模式启动完毕 -----------------------
	;;
restart_dns)
	#ss_basic_action=2 应用DNS设置
	echo $(date): ------------------------- 全局模式-重启dns服务 ----------------------------
	resolv_server_ip
	creat_dnsmasq_basic_conf
	restart_dnsmasq
	remove_status
	echo $(date): ------------------------ 全局模式-dns服务重启完毕 --------------------------
	;;
restart_addon)
	#ss_basic_action=4 应用黑白名单设置
	echo $(date): ------------------------- 全局模式-重启附加功能 ----------------------------
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo $(date): boot delay time not changing, still "$ss_basic_sleep" seconds
	else
		echo $(date): set boot delay to "$ss_basic_sleep" seconds before starting kcptun service
		# delete boot delay in nat-start and wan-start
		sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
		# re add delay in nat-start and wan-start
		nat_auto_start >/dev/null 2>&1
		wan_auto_start >/dev/null 2>&1
	fi
	
	# for chromecast surpport
	# also for chromecast
	sh /koolshare/ss/game/nat-start start_part_for_addon
	
	# for list update
	kill_cron_job
	write_cron_job
	#remove_status
	remove_status
	main_portal

	if [ "$ss_basic_dnslookup" == "1" ];then
		echo $(date): 设置使用nslookup方式解析SS服务器的ip地址.
	else
		echo $(date): 设置使用resolveip方式解析SS服务器的ip地址.
	fi

	echo $(date): ----------------------- 全局模式-附加功能重启完毕！ -------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_dns|restart_addon)"
	exit 1
	;;
esac
