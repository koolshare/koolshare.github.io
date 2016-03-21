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

echo $(date): ================= Shell by sadoneli, Web by Xiaobao =====================
echo $(date):
echo $(date): --------------------Stopping Shadowsock service--------------------------
#--------------------------------------------------------------------------		
# dectect disable or switching mode
    if [ "$ss_mode" == "0" ];then
    	echo $(date): Shadowsocks service will be disabled !!
    else
    	echo $(date): Stopping last mode !
    fi
    	echo $(date):
#--------------------------------------------------------------------------
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
# Bring up dnsmasq
	echo $(date): Bring up dnsmasq service
	service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
#--------------------------------------------------------------------------
# flush iptables and destory REDSOCKS2 chain
	echo $(date): flush iptables and destory chain...
	iptables -t nat -D PREROUTING -p tcp -m set $MATCH_SET gfwlist dst -j REDIRECT --to-port 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp -m set $MATCH_SET gfwlist dst -j REDIRECT --to-port 3333 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -i br0 -p tcp -j REDSOCKS2 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -i br0 -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -i br0 -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j REDSOCKS2 >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D PREROUTING -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set $MATCH_SET router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set $MATCH_SET router dst -j REDIRECT --to-ports 1089 >/dev/null 2>&1
	iptables -t nat -F OUTPUT  >/dev/null 2>&1
	iptables -t nat -D PREROUTING -s $lan_ipaddr/24 -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
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
	
#--------------------------------------------------------------------------
	# reset ipset list number
	# nvram set ipset_numbers=0
#--------------------------------------------------------------------------
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
	echo $(date): done
	echo $(date):
#--------------------------------------------------------------------------
# restore nat-start file if any
sed -i '/source/,/warning/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/nat-start/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/sleep 5/d' /jffs/scripts/nat-start >/dev/null 2>&1
#--------------------------------------------------------------------------
# clear start up command line in wan-start
sed -i '/start.sh/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/ss_config/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1
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
#--------------------------------------------------------------------------
# kill crontab job
	echo $(date): kill crontab job
	sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	echo $(date): done
	echo $(date): -------------------- Shadowsock service Stopped--------------------------
	echo $(date):
