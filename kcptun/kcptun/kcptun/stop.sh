#!/bin/sh
#--------------------------------------------------------------------------
# Variable definitions
eval `dbus export KCP`
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
chinadns=$(ps | grep "chinadns" | grep -v "grep")
DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
lan_ipaddr=$(nvram get lan_ipaddr)
nvram set KCP_mode=0
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
echo $(date): ----------------------Stopping kcptun service----------------------------
#--------------------------------------------------------------------------
# restore dnsmasq conf file
	if [ -f /jffs/configs/dnsmasq.conf.add ]; then
		echo $(date): restore dnsmasq conf file
		rm -f /jffs/configs/dnsmasq.conf.add
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
# Bring up dnsmasq
	echo $(date): Bring up dnsmasq service
	service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
#--------------------------------------------------------------------------
# flush iptables and destory KCPTUN chain
	echo $(date): flush iptables and destory chain...
	iptables -t nat -D PREROUTING -p tcp -j KCPTUN >/dev/null 2>&1
	iptables -t nat -D PREROUTING -i br0 -p tcp -j KCPTUN >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set $MATCH_SET router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -D KCPTUN -p tcp -m set --match-set gfw_cidr dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	
	iptables -t nat -F OUTPUT  >/dev/null 2>&1
	iptables -t nat -D PREROUTING -s $lan_ipaddr/24 -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
	iptables -t nat -F KCPTUN >/dev/null 2>&1
	iptables -t nat -X KCPTUN >/dev/null 2>&1
	echo $(date): done
	echo $(date):
	
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
#--------------------------------------------------------------------------
# restore nat-start file if any
sed -i '/source/,/warning/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/nat-start/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1
#--------------------------------------------------------------------------
# clear start up command line in wan-start
sed -i '/start.sh/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/ssconfig/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
#--------------------------------------------------------------------------
# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): kill dnscrypt-proxy...
		killall dnscrypt-proxy
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
# kill all kcptun
	kcptun=$(ps | grep "kcp_router" | grep -v "grep")
	if [ "$KCP_basic_guardian" == "1" ];then
		echo $(date): kill kcptun and guardian...
		perpctl X kcptun >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
	if [ ! -z "$kcptun" ]; then 
		echo $(date): kill kcptun...
		#kill -9 `pidof kcp_router` >/dev/null 2>&1 &
		killall kcp_router >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
#--------------------------------------------------------------------------

# remove conf under /jffs/configs/dnsmasq.d
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/configs/dnsmasq.d/cdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/cdn.conf
	rm -rf /jffs/configs/dnsmasq.conf.add
	

# remove ss state
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign


