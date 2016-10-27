#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh

#--------------------------------------------------------------------------------------

resolv_server_ip(){
	IFIP=`echo $ss_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
	if [ -z "$IFIP" ];then
		echo $(date): 检测到你的SS服务器为域名格式，将尝试进行解析...
		if [ "$ss_basic_dnslookup" == "1" ];then
			echo $(date): 使用nslookup方式解析SS服务器的ip地址,解析dns：$ss_basic_dnslookup_server
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
		echo $(date): 检测到你的SS服务器已经是IP格式：$ss_basic_server,跳过解析... 
	fi
}

creat_ss_json(){
# create shadowsocks config file...
	echo $(date): 创建SS配置文件到/koolshare/ss/koolgame/ss.json
	cat > /koolshare/ss/koolgame/ss.json <<-EOF
		{
		    "server":"$ss_basic_server",
		    "server_port":$ss_basic_port,
		    "local_port":3333,
		    "sock5_port":23456,
		    "dns2ss":1053,
		    "adblock_addr":"",
		    "adblock_path":"/koolshare/ss/koolgame/xwhycadblock.txt",
		    "dns_server":"$ss_gameV2_dns2ss_user",
		    "password":"$ss_basic_password",
		    "timeout":600,
		    "method":"$ss_basic_method",
		    "use_tcp":$ss_basic_koolgame_udp
		}
	EOF
}
#--------------------------------------------------------------------------------------

creat_dnsmasq_basic_conf(){
	ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	[ "$ss_gameV2_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
	[ "$ss_gameV2_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
	[ "$ss_gameV2_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$ss_gameV2_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$ss_gameV2_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$ss_gameV2_dns_china" == "5" ] && CDN="$ss_gameV2_dns_china_user"
	[ "$ss_gameV2_dns_china" == "6" ] && CDN="180.76.76.76"
	[ "$ss_gameV2_dns_china" == "7" ] && CDN="1.2.4.8"
	[ "$ss_gameV2_dns_china" == "8" ] && CDN="119.29.29.29"

	# make directory if not exist
	mkdir -p /jffs/configs/dnsmasq.d

	# append dnsmasq basic conf
	echo $(date): 创建dnsmasq基础配置到/jffs/configs/dnsmasq.conf.add
	cat > /jffs/configs/dnsmasq.conf.add <<-EOF
		no-resolv
		server=127.0.0.1#1053
		EOF

	# append router output chain rules
	echo $(date): 创建路由内部走代理的规则，用于SS状态检测.
	cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add

	# append china site
	echo $(date): 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
		rm -rf /tmp/sscdn.conf
		echo "#for china site CDN acclerate" > /tmp/sscdn.conf
		cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >/tmp/sscdn.conf

	# create dnsmasq postconf
	echo $(date): 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
		#cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		ln -sf /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
}

custom_dnsmasq(){
	# append coustom dnsmasq settings
	custom_dnsmasq=$(echo $ss_gameV2_dnsmasq | sed "s/,/\n/g")
	if [ ! -z $ss_gameV2_dnsmasq ];then
		echo $(date): 添加自定义dnsmasq设置到/jffs/configs/dnsmasq.conf.add
		echo "#for coustom dnsmasq settings" >> /jffs/configs/dnsmasq.conf.add
		for line in $custom_dnsmasq
		do 
			echo "$line" >> /jffs/configs/dnsmasq.conf.add
		done
	fi
}

ln_conf(){
	rm -rf /jffs/configs/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
		echo $(date): 创建cdn加速列表软链接/jffs/configs/dnsmasq.d/cdn.conf
		ln -sf /tmp/sscdn.conf /jffs/configs/dnsmasq.d/cdn.conf
	fi
}
#--------------------------------------------------------------------------------------
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
		sed -i '3a sh /koolshare/ss/koolgame/nat-start start_all' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
}
#--------------------------------------------------------------------------------------
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

start_koolgame(){
	# Start koolgame
	pdu=`ps|grep pdu|grep -v grep`
	if [ -z "$pdu" ]; then
	echo $(date): 开启pdu进程，用于优化mtu...
		/koolshare/ss/koolgame/pdu br0 /tmp/var/pdu.pid >/dev/null 2>&1
		sleep 1
	fi
	echo $(date): 开启koolgame主进程...
	start-stop-daemon -S -q -b -m -p /tmp/var/koolgame.pid -x /koolshare/ss/koolgame/koolgame -- -c /koolshare/ss/koolgame/ss.json
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "错误：不能正确加载nat规则!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 2
	done
	echo $(date): "加载nat规则!"
	sh /koolshare/ss/koolgame/nat-start start_all
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

detect_qos(){
	echo $(date): 检测是否符合游戏模式启动条件...
	QOSO=`iptables -t mangle -S | grep -o QOSO`
	if [ ! -z "$QOSO" ];then
		echo $(date): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		echo $(date): !!!发现你开启了 Adaptive Qos - 传统带宽管理,该Qos模式和游戏模式V2冲突!!!
		echo $(date): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		echo $(date): 如果你仍然希望在游戏模式下使用Qos，可以使用Adaptive QoS网络监控家模式，
		echo $(date): 但是该模式下走ss的流量不会有Qos效果！
		echo $(date): 退出应用游戏模式，关闭ss！请等待10秒！
		dbus set ss_basic_enable=0
		sleep 10
		exit
	else
		echo $(date): 未检测到系统设置冲突，符合启动条件！
	fi
}
	
case $1 in
start_all)
	#ss_basic_action=1 应用所有设置
	echo $(date): -------------------- 梅林固件 shadowsocks 游戏模式V2 ----------------------
	detect_qos
	resolv_server_ip
	creat_ss_json
	#creat_redsocks2_conf
	creat_dnsmasq_basic_conf
	#user_cdn_site
	custom_dnsmasq
	#append_white_black_conf
	ln_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	start_koolgame
	load_nat
	restart_dnsmasq
	remove_status
	nvram set ss_mode=4
	nvram commit
	echo $(date): --------------------- shadowsocks 游戏模式V2启动完毕 ----------------------
	;;
restart_dns)
	#ss_basic_action=2 应用DNS设置
	echo $(date): ------------------------ 游戏模式V2-重启dns服务 ---------------------------
	detect_qos
	stop_dns
	creat_dnsmasq_basic_conf
	#user_cdn_site
	killall koolgame
	start_koolgame
	custom_dnsmasq
	ln_conf
	#load_nat
	restart_dnsmasq
	remove_status
	echo $(date): ----------------------- 游戏模式V2-dns服务重启完毕 -------------------------
	;;
restart_addon)
	#ss_basic_action=4 应用附加设置
	echo $(date): ------------------------ 游戏模式V2-重启附加功能 ---------------------------
	detect_qos
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo $(date): 开机延迟时间未改变，仍然是"$ss_basic_sleep"秒.
	else
		echo $(date): 设置"$ss_basic_sleep"秒开机延迟...
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
	sh /koolshare/ss/koolgame/nat-start start_part_for_addon
	
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

	echo $(date): ---------------------- 游戏模式V2-附加功能重启完毕！ -----------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_dns|restart_addon)"
	exit 1
	;;
esac
