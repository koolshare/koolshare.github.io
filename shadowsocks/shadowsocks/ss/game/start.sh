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
i=120
nvram set ss_mode=3
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ------------------- Shadowsock GAME mode Starting------------------------

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
cat > /koolshare/ss/game/ss.json <<EOF
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
cat > /koolshare/ss/game/ss.json <<EOF
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
#--------------------------------------------------------------------------------------
# configure dnsmasq
mkdir -p /jffs/configs

# create dnsmasq.conf.add
echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
no-resolv
server=127.0.0.1#1053
EOF
echo $(date): done
echo $(date):

[ "$ss_game_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
[ "$ss_game_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
[ "$ss_game_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$ss_game_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$ss_game_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$ss_game_dns_china" == "5" ] && CDN="$ss_game_dns_china_user"
[ "$ss_game_dns_china" == "6" ] && CDN="180.76.76.76"
[ "$ss_game_dns_china" == "7" ] && CDN="1.2.4.8"
[ "$ss_game_dns_china" == "8" ] && CDN="119.29.29.29"

# append router output chain rules
echo $(date): append router output chain rules
cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):

# china site
echo $(date): append CDN list into dnsmasq conf \file
cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):

# append custom host
if [ ! -z "$ss_game_host" ];then
echo $(date): append custom host
echo "$ss_game_host" | sed "s/,/\n/g" | sort >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):
fi

# append adblock rules
	if [ "1" == "$ss_basic_adblock" ];then
		echo $(date): enable adblock in gfwlist mode
		cat /koolshare/ss/ipset/adblock.conf >> /jffs/configs/dnsmasq.conf.add
		echo $(date): done
		echo $(date):
	fi
# create dnsmasq postconf
echo $(date): create dnsmasq.postconf
cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
chmod +x /jffs/scripts/dnsmasq.postconf
echo $(date): done
echo $(date):
#--------------------------------------------------------------------------------------
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
echo $(date): Creating iptables rules \for game mode
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
sed -i '3a sh /koolshare/ss/game/nat-start' /jffs/scripts/nat-start
chmod +x /jffs/scripts/nat-start
fi
echo $(date): done
echo $(date):
#--------------------------------------------------------------------------------------
# Add service to auto start
if [ ! -f /jffs/scripts/wan-start ]; then
cat > /jffs/scripts/wan-start <<EOF
#!/bin/sh
dbus fire onwanstart

EOF
fi
echo $(date): Adding service to wan-start...
startss=$(cat /jffs/scripts/wan-start | grep "/usr/bin/ssconfig")
if [ -z "$startss" ];then
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
echo $(date): done
echo $(date):
#======================================================================================
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

if [ "1" == "$ss_game_dns_foreign" ];then
	echo $(date): Starting dnscrypt-proxy...
	dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_game_opendns"
	echo $(date): done
	echo $(date):
fi

[ "$ss_game_sstunnel" == "1" ] && gs="208.67.220.220:53"
[ "$ss_game_sstunnel" == "2" ] && gs="8.8.8.8:53"
[ "$ss_game_sstunnel" == "3" ] && gs="8.8.4.4:53"
[ "$ss_game_sstunnel" == "4" ] && gs="$ss_game_sstunnel_user"


if [ "2" == "$ss_game_dns_foreign" ];then
	echo $(date): Starting ss-tunnel...
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-tunnel -b 0.0.0.0 -c /koolshare/ss/game/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-tunnel -b 0.0.0.0 -c /koolshare/ss/game/ss.json -l 1053 -L "$gs" -u -A -f /var/run/sstunnel.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-tunnel -b 0.0.0.0 -c /koolshare/ss/game/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
		fi
	fi
	echo $(date): done
	echo $(date):
fi

[ "$ss_game_chinadns_china" == "1" ] && gcc="223.5.5.5"
[ "$ss_game_chinadns_china" == "2" ] && gcc="223.6.6.6"
[ "$ss_game_chinadns_china" == "3" ] && gcc="114.114.114.114"
[ "$ss_game_chinadns_china" == "4" ] && gcc="$ss_game_chinadns_china_user"
[ "$ss_game_chinadns_foreign" == "1" ] && cdf="208.67.220.220:53"
[ "$ss_game_chinadns_foreign" == "2" ] && cdf="8.8.8.8:53"
[ "$ss_game_chinadns_foreign" == "3" ] && cdf="8.8.4.4:53"
[ "$ss_game_chinadns_foreign" == "4" ] && cdf="$ss_game_chinadns_foreign_user"

if [ "3" == "$ss_game_dns_foreign" ];then
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-tunnel -b 127.0.0.1 -c /koolshare/ss/game/ss.json -l 1055 -L "$cdf" -u -f /var/run/sstunnel.pid
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-tunnel -b 127.0.0.1 -c /koolshare/ss/game/ss.json -l 1055 -L "$cdf" -u -A -f /var/run/sstunnel.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-tunnel -b 127.0.0.1 -c /koolshare/ss/game/ss.json -l 1055 -L "$cdf" -u -f /var/run/sstunnel.pid
		fi
	fi
	echo $(date): Starting chinadns
	chinadns -p 1053 -s "$gcc",127.0.0.1:1055 -m -d -c /koolshare/ss/redchn/chnroute.txt &
	echo $(date): done
	echo $(date):
fi

if [ "4" == "$ss_game_dns_foreign" ]; then
	echo $(date): You have enabled DNS2SOCKS, Sicks5 will enable \for DNS2SOCKS

	if [ "$ss_basic_use_rss" == "1" ];then
		rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/game/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/game/ss.json -u -f /var/run/sslocal1.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/game/ss.json -u -f /var/run/sslocal1.pid
		fi
	fi
	dns2socks 127.0.0.1:23456 "$ss_game_dns2socks_user" 127.0.0.1:1053 > /dev/null 2>&1 &
	echo $(date): done
	echo $(date):
fi

# Start Pcap_DNSProxy
if [ "5" == "$ss_game_dns_foreign" ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 1053' /koolshare/ss/dns/Config.conf
      	sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
fi

# Start ss-redir
	echo $(date): Starting ss-redir...
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-redir -b 0.0.0.0 -u -c /koolshare/ss/game/ss.json -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-redir -b 0.0.0.0 -u -A -c /koolshare/ss/game/ss.json -f /var/run/shadowsocks.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-redir -b 0.0.0.0 -u -c /koolshare/ss/game/ss.json -f /var/run/shadowsocks.pid
		fi
	fi
	echo $(date): done
	echo $(date):

	# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq  >/dev/null 2>&1
	echo $(date): done
	echo $(date):
	
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
	sh /koolshare/ss/game/nat-start

echo $(date): -------------------- Shadowsock GAME mode Started------------------------

