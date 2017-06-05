#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh

#--------------------------------------------------------------------------------------

resolv_server_ip(){
	#server_ip=`resolvip $ss_basic_server`
	server_ip=`nslookup "$ss_basic_server" 114.114.114.114 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
	if [ -z "$shadowsocks_server_ip" ];then
	        if [ ! -z "$server_ip" ];then
	                export shadowsocks_server_ip="$server_ip"
	                ss_basic_server="$server_ip"
	                dbus save shadowsocks
	        fi
	else
	        if [ "$shadowsocks_server_ip"x = "$server_ip"x ];then
	                ss_basic_server="$shadowsocks_server_ip"
	        elif [ "$shadowsocks_server_ip"x != "$server_ip"x ] && [ ! -z "$server_ip" ];then
	                ss_basic_server="$server_ip"
	                export shadowsocks_server_ip="$server_ip"
	                dbus save shadowsocks
	        else
	                ss_basic_server="$ss_basic_server"
	        fi
	fi
}

# create shadowsocks config file...
creat_ss_json(){
	echo $(date): create shadowsocks config file...
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
	echo $(date): done
	echo $(date):
}
#---------------------------------------------------------------------------------------------------------
creat_dnsmasq_basic_conf(){
	# make directory if not exist
	mkdir -p /jffs/configs/dnsmasq.d
	rm -rf /jffs/configs/dnsmasq.conf.add
	
	# create dnsmasq.conf.add
	echo $(date): create dnsmasq.conf.add..
	touch /jffs/configs/dnsmasq.conf.add
	echo no-resolv >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "0" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "1" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "all-servers" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "server=127.0.0.1#1053" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "2" ] && echo "server=127.0.0.1#1054" >> /jffs/configs/dnsmasq.conf.add
	[ "$ss_overall_dns" == "3" ] && echo "server=127.0.0.1#7913" >> /jffs/configs/dnsmasq.conf.add
	echo $(date): done
	echo $(date):
	
	# append router output chain rules
	echo $(date): append router output chain rules
	cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add
	echo $(date): done
	echo $(date):

	# create dnsmasq postconf
	echo $(date): create dnsmasq.postconf
		#cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		ln -sf /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
	echo $(date): done
	echo $(date):
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
	echo $(date): Add service to nat-start...
	writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
	if [ -z "$writenat" ];then
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		sed -i '3a sh /koolshare/ss/overall/nat-start start_all' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
	echo $(date): done
	echo $(date):
}

wan_auto_start(){
	# Add service to auto start
	if [ ! -f /jffs/scripts/wan-start ]; then
		cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			dbus fire onwanstart
			
			EOF
	fi
	echo $(date): Add service to wan-start...
	startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
	if [ -z "$startss" ];then
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
		sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
	echo $(date): done
	echo $(date):
}
#=========================================================================================================
write_cron_job(){
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): ss rule schedual update enabled
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/ss/cru/update.sh"
		echo $(date): done
		echo $(date):
	else
		echo $(date): ss rule schedual update not enabled
		echo $(date): done
		echo $(date):
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep ssupdate`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): kill crontab job
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
}
start_dns(){
	# Start dnscrypt-proxy
	if [ "$ss_overall_dns" == "0" ]; then
	echo $(date): Starting dnscrypt-proxy...
	dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "cisco(opendns)"
	echo $(date): done
	echo $(date):
	fi
	
	if [ "$ss_overall_dns" == "1" ]; then
	echo $(date): Starting ss-tunnel...
	ss-tunnel -d 127.0.0.1 -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1053 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
			fi
		fi
	echo $(date): done
	echo $(date):
	fi
	
	if [ "$ss_overall_dns" == "2" ]; then
		echo $(date): Starting ss-tunnel...
		dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "cisco(opendns)"
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -l 1054 -L 8.8.8.8:53 -u -f /var/run/sstunnel.pid
			fi
		fi
		echo $(date): done
		echo $(date):
	fi
}

stop_dns(){
	dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
	sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
	rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
	
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): kill dnscrypt-proxy...
		killall dnscrypt-proxy
		echo $(date): done
		echo $(date):
	fi

	# kill ss-tunnel
	if [ ! -z "$sstunnel" ]; then 
		echo $(date): kill ss-tunnel...
		killall ss-tunnel >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
	
	if [ ! -z "$rsstunnel" ]; then 
		echo $(date): kill rss-tunnel...
		killall rss-tunnel >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
}


start_ss_redir(){
	# Start ss-redir
	echo $(date): starting ss-redir...
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-redir -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-redir -b 0.0.0.0 -A -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-redir -b 0.0.0.0 -c /koolshare/ss/overall/ss.json -f /var/run/shadowsocks.pid
		fi
	fi
	echo $(date): done
	echo $(date):
}

	
load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 2
	done
	echo $(date): "Apply nat rules!"
	sh /koolshare/ss/overall/nat-start start_all
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}

remove_status(){
	dbus ram ss_basic_state_china="Waiting for first refresh..."
	dbus ram ss_basic_state_foreign="Waiting for first refresh..."
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
	echo $(date): ------------------ Shadowsock overall mode Starting -----------------------
	resolv_server_ip
	creat_ss_json
	creat_dnsmasq_basic_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	start_dns
	start_ss_redir
	load_nat
	restart_dnsmasq
	remove_status
	nvram set ss_mode=5
	nvram commit
	echo $(date): ------------------- Shadowsock overall mode Started ---------------------
	;;
restart_dns)
	#ss_basic_action=2 应用DNS设置
	echo $(date): --------------------------- Restart DNS ---------------------------------
	creat_dnsmasq_basic_conf
	restart_dnsmasq
	remove_status
	echo $(date): -------------------------- DNS Restarted --------------------------------
	;;
restart_addon)
	#ss_basic_action=4 应用黑白名单设置
	echo $(date): -------------------------- Restart addon --------------------------------
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo $(date): boot delay time not changing, still "$ss_basic_sleep" seconds
		echo $(date): done
		echo $(date):
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
		echo $(date): done
		echo $(date):
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

	echo $(date): -------------------------- addon applied --------------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_kcptun|restart_wb_list|restart_dns)"
	exit 1
	;;
esac
