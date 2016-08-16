#!/bin/sh
#--------------------------------------------------------------------------
# Variable definitions
# source /koolshare/configs/ss.sh
eval `dbus export shadowsocks`
eval `dbus export ss`
redsocks2=$(ps | grep "redsocks2" | grep -v "grep")
dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
sokcs5=$(ps|grep ss-local|grep -vw rss-local|grep -v 23456|cut -d " " -f 1)
ssredir=$(ps | grep "ss-redir" | grep -v "grep" | grep -vw "rss-redir")
rssredir=$(ps | grep "rss-redir" | grep -v "grep" | grep -vw "ss-redir")
sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
chinadns=$(ps | grep "chinadns" | grep -v "grep")
DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
koolgame=$(ps | grep "koolgame" | grep -v "grep")
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
lan_ipaddr=$(nvram get lan_ipaddr)
ip_rule_exist=`ip rule show | grep "fwmark 0x1/0x1 lookup 300" | grep -c 300`
nvram set ss_mode=0
dbus set dns2socks=0
nvram commit

# Different routers got different iptables syntax
case $(uname -m) in
  armv7l)
    MATCH_SET='--match-set'
    ;;
  mips)
    MATCH_SET='--set'
    ;;
esac


#--------------------------------------------------------------------------

restore_conf(){
	# restore dnsmasq conf file
	if [ -f /jffs/configs/dnsmasq.conf.add ]; then
		echo $(date): restore dnsmasq conf file
		rm -f /jffs/configs/dnsmasq.conf.add
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# delete dnsmasq postconf file
	if [ -f /jffs/scripts/dnsmasq.postconf ]; then
		echo $(date): delete dnsmasq postconf file
		rm -f /jffs/scripts/dnsmasq.postconf
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# delete custom.conf
	if [ -f /jffs/configs/dnsmasq.d/custom.conf ];then
		echo $(date): delete custom.conf file
		rm -rf /jffs/configs/dnsmasq.d/custom.conf
		echo $(date): done
		echo $(date):
	fi	
}

bring_up_dnsmasq(){
	# Bring up dnsmasq
	echo $(date): Bring up dnsmasq service
	service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}

restore_nat(){
	# flush iptables and destory REDSOCKS2 chain
	echo $(date): flush iptables and destory chain...
	iptables -t nat -D PREROUTING -p tcp -m set $MATCH_SET gfwlist dst -j REDIRECT --to-port 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp -m set $MATCH_SET gfwlist dst -j REDIRECT --to-port 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j REDSOCKS2 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j REDSOCKS2 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set $MATCH_SET router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set $MATCH_SET router dst -j REDIRECT --to-ports 1089 >/dev/null 2>&1
	iptables -t nat -F OUTPUT  >/dev/null 2>&1
	iptables -t nat -D PREROUTING -s $lan_ipaddr/24 -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -F REDSOCKS2 >/dev/null 2>&1
	iptables -t nat -X REDSOCKS2 >/dev/null 2>&1
	ip route del local 0.0.0.0/0 dev lo table 300  >/dev/null 2>&1
	iptables -t mangle -D PREROUTING -j SHADOWSOCKS2 >/dev/null 2>&1
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS2 >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS2 >/dev/null 2>&1
	iptables -t mangle -X SHADOWSOCKS2 >/dev/null 2>&1
	
	if [ ! -z "ip_rule_exist" ];then
		until [ "$ip_rule_exist" = 0 ]
		do 
			ip rule del fwmark 0x01/0x01 table 300
			ip_rule_exist=`expr $ip_rule_exist - 1`
		done
	fi
	echo $(date): done
	echo $(date):
	
}

destory_ipset(){
	# flush and destory ipset
	echo $(date): flush and destory ipset
	ipset -F gfwlist >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1
	ipset -F chnroute >/dev/null 2>&1
	ipset -X gfwlist >/dev/null 2>&1
	ipset -X router >/dev/null 2>&1
	ipset -X chnroute >/dev/null 2>&1
	ipset -F white_domain >/dev/null 2>&1
	ipset -F black_domain >/dev/null 2>&1
	ipset -X white_domain >/dev/null 2>&1
	ipset -X black_domain >/dev/null 2>&1
	ipset -F white_ip >/dev/null 2>&1
	ipset -F black_ip >/dev/null 2>&1
	ipset -X white_ip >/dev/null 2>&1
	ipset -X black_ip >/dev/null 2>&1
	#flush and destory white_cidr in chnmode mode
	ipset -F white_cidr >/dev/null 2>&1
	ipset -X white_cidr >/dev/null 2>&1
	#flush and destory black_cidr in gfwlist mode
	ipset -F black_cidr >/dev/null 2>&1
	ipset -X black_cidr >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}

restore_start_file(){
	# restore nat-start file if any
	sed -i '/source/,/warning/d' /jffs/scripts/nat-start >/dev/null 2>&1
	sed -i '/nat-start/d' /jffs/scripts/nat-start >/dev/null 2>&1
	sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
	sed -i '/sleep 5/d' /jffs/scripts/nat-start >/dev/null 2>&1
	
	# clear start up command line in wan-start
	sed -i '/start.sh/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/ssconfig/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1	
}

kill_process(){
	#--------------------------------------------------------------------------
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): kill dnscrypt-proxy...
		killall dnscrypt-proxy
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill redsocks2
	if [ ! -z "$redsocks2" ]; then 
		echo $(date): kill redsocks2...
		killall redsocks2
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill ss-redir
	if [ ! -z "$ssredir" ]; then 
		echo $(date): kill ss-redir...
		killall ss-redir
		echo $(date): done
		echo $(date):
	fi


	if [ ! -z "$rssredir" ]; then 
		echo $(date): kill rss-redir...
		killall rss-redir
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill ss-local

	kill `ps | grep ss-local | grep -v "grep" | grep -w "23456"|awk '{print $1}'`  >/dev/null 2>&1
	kill `ps | grep rss-local | grep -v "grep" | grep -w "23456"|awk '{print $1}'`  >/dev/null 2>&1
	#--------------------------------------------------------------------------
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
	
	#--------------------------------------------------------------------------
	# kill pdnsd
	if [ ! -z "$pdnsd" ]; then 
	echo $(date): kill pdnsd...
	killall pdnsd
	echo $(date): done
	echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then 
	echo $(date): kill Pcap_DNSProxy...
	killall dns.sh >/dev/null 2>&1
	killall Pcap_DNSProxy >/dev/null 2>&1
	echo $(date): done
	echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill chinadns
	if [ ! -z "$chinadns" ]; then 
		echo $(date): kill chinadns...
		killall chinadns
		echo $(date): done
		echo $(date):
	fi
	#--------------------------------------------------------------------------
	# kill dns2socks
	if [ ! -z "$DNS2SOCK" ]; then 
		echo $(date): kill dns2socks...
		killall dns2socks
		echo $(date): done
		echo $(date):
	fi
	# kill all koolgame
	if [ ! -z "$koolgame" ]; then 
		echo $(date): kill koolgame...
		killall koolgame >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi

}

kill_cron_job(){
	# kill crontab job
	echo $(date): kill crontab job
	sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	echo $(date): done
	echo $(date): -------------------- Shadowsock service Stopped--------------------------
	echo $(date):
}


remove_conf_and_settings(){
	# remove conf under /jffs/configs/dnsmasq.d
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/configs/dnsmasq.d/cdn.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/cdn.conf
	rm -rf /jffs/configs/dnsmasq.conf.add
	

	# remove ss state
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
}

case $1 in
stop_all)
	#KCP_basic_action=0 应用所有设置
	echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	echo $(date):
	echo $(date): --------------------Stopping Shadowsock service--------------------------
	restore_conf
	bring_up_dnsmasq
	restore_nat
	destory_ipset
	restore_start_file
	kill_process
	kill_cron_job
	remove_conf_and_settings
	echo $(date): ----------------------- Shadowsocks stopped  ----------------------------
	;;
stop_part)
	#KCP_basic_action=1 应用DNS设置
	echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
	echo $(date):
	echo $(date): ------------------------ Stopping last mode -----------------------------
	restore_conf
	#bring_up_dnsmasq
	restore_nat
	destory_ipset
	restore_start_file
	kill_process
	#kill_cron_job
	remove_conf_and_settings
	echo $(date):
	;;
*)
	echo "Usage: $0 (start_all|restart_kcptun|restart_wb_list|restart_dns)"
	exit 1
	;;
esac