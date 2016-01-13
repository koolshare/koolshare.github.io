#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh
ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
lan_ipaddr=$(nvram get lan_ipaddr)
server_ip=`resolvip $ss_basic_server`
nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
version_gfwlist=$(cat /koolshare/ss/cru/version | sed -n 1p | sed 's/ /\n/g'| sed -n 3p)
md5sum_gfwlist=$(md5sum /jffs/configs/dnsmasq.d/gfwlist.conf | sed 's/ /\n/g'| sed -n 1p)
i=120
nvram set ss_mode=1
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ----------------- Shadowsock gfwlist mode Starting-----------------------

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

# create shadowsocks config file...
echo $(date): create shadowsocks config file...
if [ "$ss_basic_use_rss" == "0" ];then
cat > /koolshare/ss/ipset/ss.json <<EOF
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
cat > /koolshare/ss/ipset/ss.json <<EOF
{
    "server":"$ss_basic_server",
    "server_port":$ss_basic_port,
    "local_port":3333,
    "password":"$ss_basic_password",
    "timeout":600,
    "protocol":"$ss_basic_rss_protocol",
    "obfs":"$ss_basic_rss_obfs",
    "method":"$ss_basic_method"
}

EOF
fi
echo $(date): done
echo $(date):
#---------------------------------------------------------------------------------------------------------
[ "$ss_ipset_cdn_dns" == "1" ] && [ ! -z "$ISP_DNS" ] && dns="$ISP_DNS"
[ "$ss_ipset_cdn_dns" == "1" ] && [ -z "$ISP_DNS" ] && dns="114.114.114.114"
[ "$ss_ipset_cdn_dns" == "2" ] && dns="223.5.5.5"
[ "$ss_ipset_cdn_dns" == "3" ] && dns="223.6.6.6"
[ "$ss_ipset_cdn_dns" == "4" ] && dns="114.114.114.114"
[ "$ss_ipset_cdn_dns" == "5" ] && dns="$ss_ipset_cdn_dns_user"
[ "$ss_ipset_cdn_dns" == "6" ] && dns="180.76.76.76"
[ "$ss_ipset_cdn_dns" == "7" ] && dns="1.2.4.8"
[ "$ss_ipset_cdn_dns" == "8" ] && dns="119.29.29.29"

# create dnsmasq.conf.add
if [ ! -d /jffs/configs/dnsmasq.d ]; then 
mkdir -p /jffs/configs/dnsmasq.d
fi

echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
no-resolv
server=$dns
conf-dir=/jffs/configs/dnsmasq.d
EOF
echo $(date): done
echo $(date):

# append router output chain rules for ss status check
echo $(date): append router output chain rules
cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):
# append gfwlist
	if [ "$version_gfwlist" != "$md5sum_gfwlist" ];then
		echo $(date): append gfwlist into dnsmasq.conf
		cp -rf /koolshare/ss/ipset/gfwlist.conf  /jffs/configs/dnsmasq.d/
		echo $(date): done
		echo $(date):
	fi
# append adblock rules
	if [ "1" == "$ss_basic_adblock" ];then
		echo $(date): enable adblock in gfwlist mode
		md5sum_adblock=$(md5sum /jffs/configs/dnsmasq.d/adblock.conf | sed 's/ /\n/g'| sed -n 1p)
		version_adblock=$(cat /koolshare/ss/cru/version | sed -n 3p | sed 's/ /\n/g'| sed -n 3p)
		if [ "$version_adblock" != "$md5sum_adblock" ];then
			cp -fr /koolshare/ss/ipset/adblock.conf  /jffs/configs/dnsmasq.d/
		fi
		echo $(date): done
		echo $(date):
	else
		if [ -f /jffs/configs/dnsmasq.d/adblock.conf ];then
			rm -rf /jffs/configs/dnsmasq.d/adblock.conf
		fi
	fi
# append custom input domain
	if [ ! -z "$ss_ipset_black_domain_web" ];then
		echo $(date): append custom black domain into dnsmasq.conf
		echo "$ss_ipset_black_domain_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/custom.conf
		echo "$ss_ipset_black_domain_web" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/gfwlist/g" >> /tmp/custom.conf
		echo $(date): done
		echo $(date):
	fi
# append custom host
	if [ ! -z "$ss_ipset_address" ];then
		echo $(date): append custom host into dnsmasq.conf
		echo "$ss_ipset_address" | sed "s/,/\n/g" | sort -u >> /tmp/custom.conf
		echo $(date): done
		echo $(date):
	fi

# append dnsmasq.conf
		if [ -f /tmp/custom.conf ];then
		echo $(date): append dnsmasq.conf.add..
		mv /tmp/custom.conf  /jffs/configs/dnsmasq.d
		echo $(date): done
		echo $(date):
		fi
# create dnsmasq.postconf
		echo $(date): create dnsmasq.postconf
		cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
		echo $(date): done
		echo $(date):
#---------------------------------------------------------------------------------------------------------
# creating iptables rules to nat-start
mkdir -p /jffs/scripts
if [ ! -f /jffs/scripts/nat-start ]; then
cat > /jffs/scripts/nat-start <<EOF
#!/bin/sh
dbus fire onnatstart

EOF
fi
writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
if [ -z "$writenat" ];then
	echo $(date): Creating iptables rules \for shadowsocks
	sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
	sed -i '3a sh /koolshare/ss/ipset/nat-start' /jffs/scripts/nat-start
	chmod +x /jffs/scripts/nat-start
fi
	echo $(date): done
	echo $(date):
#---------------------------------------------------------------------------------------------------------
# Add service to auto start
if [ ! -f /jffs/scripts/wan-start ]; then
cat > /jffs/scripts/wan-start <<EOF
#!/bin/sh
dbus fire onwanstart

EOF
fi
startss=$(cat /jffs/scripts/wan-start | grep "ssconfig")
if [ -z "$startss" ];then
echo $(date): Add service to wan-start...
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
sed -i '3a sh /usr/bin/ssconfig' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
echo $(date): done
echo $(date):
#=========================================================================================================
	# start setvice
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): add schedual update
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/ss/cru/update.sh"
		echo $(date): done
		echo $(date):
	else
		echo $(date): will not apply schedual update
		echo $(date): done
		echo $(date):
	fi
	# Start dnscrypt-proxy
	if [ "$ss_ipset_foreign_dns" == "0" ]; then
		echo $(date): Starting dnscrypt-proxy...
		dnscrypt-proxy --local-address=127.0.0.1:7913 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R opendns
		echo $(date): done
		echo $(date):
	fi
	[ "$ss_ipset_tunnel" == "1" ] && it="208.67.220.220:53"
	[ "$ss_ipset_tunnel" == "2" ] && it="8.8.8.8:53"
	[ "$ss_ipset_tunnel" == "3" ] && it="8.8.4.4:53"
	[ "$ss_ipset_tunnel" == "4" ] && it="$ss_ipset_tunnel_user"
	
	if [ "$ss_ipset_foreign_dns" == "1" ]; then
		echo $(date): Starting ss-tunnel...
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-tunnel -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -f /var/run/sstunnel.pid
			fi
		fi
		echo $(date): done
		echo $(date):
	fi

	# Start DNS2SOCKS
	if [ "$ss_ipset_foreign_dns" == "2" ]; then
		echo $(date): Sicks5 enable on port 23456 for DNS2SOCKS..
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid
			fi
		fi
			dns2socks 127.0.0.1:23456 "$ss_ipset_dns2socks_user" 127.0.0.1:7913 > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	fi

	# Start Pcap_DNSProxy
	if [ "$ss_ipset_foreign_dns" == "3" ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 7913' /koolshare/ss/dns/Config.conf
		sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	fi

	# Start ss-redir
	echo $(date): Starting ss-redir...
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-redir -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-redir -b 0.0.0.0 -A -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-redir -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid
		fi
	fi
	echo $(date): done
	echo $(date):

	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	        i=$(($i-1))
	        if [ "$i" -lt 1 ]
	        then
	            echo $(date): "Could not load nat rules!"
	            sh /koolshare/ss/stop.sh
	            exit
	        fi
	        sleep 2
	done
	echo $(date): "Apppy nat rules!"
	echo $(date):
	sh /koolshare/ss/ipset/nat-start

# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
	
echo $(date): ------------------ Shadowsock gfwlist mode Started-----------------------

