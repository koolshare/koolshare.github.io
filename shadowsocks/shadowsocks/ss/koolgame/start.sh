#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh

#--------------------------------------------------------------------------------------

resolv_server_ip(){
	#server_ip=`nslookup "$ss_basic_server" 114.114.114.114 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
	server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`

	if [ ! -z "$server_ip" ];then
		ss_basic_server="$server_ip"
		dbus set ss_basic_server_ip="$server_ip"
		dbus set ss_basic_dns_success="1"
	else
		dbus set ss_basic_dns_success="0"
	fi
}

creat_ss_json(){
# create shadowsocks config file...
	echo $(date): create shadowsocks config file...
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
	echo $(date): done
	echo $(date):
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
	echo $(date): create dnsmasq.conf.add..
	cat > /jffs/configs/dnsmasq.conf.add <<-EOF
		no-resolv
		server=127.0.0.1#1053
		EOF
	echo $(date): done
	echo $(date):

	# append router output chain rules
	echo $(date): append router output chain rules
	cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add
	echo $(date): done
	echo $(date):

	# append china site
	echo $(date): append CDN list into dnsmasq conf \file
		rm -rf /tmp/sscdn.conf
		echo "#for china site CDN acclerate" > /tmp/sscdn.conf
		cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >/tmp/sscdn.conf
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

custom_dnsmasq(){
	# append coustom dnsmasq settings
	custom_dnsmasq=$(echo $ss_gameV2_dnsmasq | sed "s/,/\n/g")
	if [ ! -z $ss_gameV2_dnsmasq ];then
		echo $(date): append coustom dnsmasq settings
		echo "#for coustom dnsmasq settings" >> /jffs/configs/dnsmasq.conf.add
		for line in $custom_dnsmasq
		do 
			echo "$line" >> /jffs/configs/dnsmasq.conf.add
		done
		echo $(date): done
		echo $(date):
	fi
}

ln_conf(){
	rm -rf /jffs/configs/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
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
	echo $(date): Add service to nat-start...
	writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
	if [ -z "$writenat" ];then
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		sed -i '3a sh /koolshare/ss/koolgame/nat-start start_all' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
	echo $(date): done
	echo $(date):
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

write_cron_job(){
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): ss rule schedual update enabled
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/scripts/ss_rule_update.sh"
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

start_koolgame(){
	# Start koolgame
	echo $(date): Starting koolgame...
	pdu=`ps|grep pdu|grep -v grep`
	if [ -z "$pdu" ]; then
		/koolshare/ss/koolgame/pdu br0 /tmp/var/pdu.pid >/dev/null 2>&1
		sleep 1
	fi
	start-stop-daemon -S -q -b -m -p /tmp/var/koolgame.pid -x /koolshare/ss/koolgame/koolgame -- -c /koolshare/ss/koolgame/ss.json
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
	sh /koolshare/ss/koolgame/nat-start start_all
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}

remove_status(){
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
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
	echo $(date): ------------------ Shadowsock GAME V2 mode Starting ---------------------
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
	echo $(date): ------------------ Shadowsock GAME V2 mode Started ----------------------
	;;
restart_dns)
	#ss_basic_action=2 应用DNS设置
	echo $(date): --------------------------- Restart DNS ---------------------------------
	stop_dns
	creat_dnsmasq_basic_conf
	#user_cdn_site
	custom_dnsmasq
	ln_conf
	#load_nat
	restart_dnsmasq
	remove_status
	echo $(date): -------------------------- DNS Restarted --------------------------------
	;;
restart_addon)
	#ss_basic_action=4 应用附加设置
	echo $(date): -------------------------- Restart addon  -------------------------------
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
	sh /koolshare/ss/koolgame/nat-start start_part_for_addon
	
	# for list update
	kill_cron_job
	write_cron_job
	#remove_status
	remove_status
	main_portal

	echo $(date): --------------------------- addon applied -------------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_kcptun|restart_wb_list|restart_dns)"
	exit 1
	;;
esac
