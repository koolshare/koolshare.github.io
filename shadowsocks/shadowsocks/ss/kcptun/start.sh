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
wanwhitedomain=$(echo $ss_kcptun_wan_white_domain | sed 's/,/\n/g')
wanblackdomain=$(echo $ss_kcptun_wan_black_domain | sed "s/,/\n/g")
custom_dnsmasq=$(echo $ss_kcptun_dnsmasq | sed "s/,/\n/g")
i=120
nvram set ss_mode=6
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ------------------- Shadowsock kcptun mode Starting-------------------------

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
echo $(date): create kcptun config file...
cat > /koolshare/ss/kcptun/kcptun_config.json <<EOF
{
    "server":"$ss_basic_kcptun_server",
    "server_port":$ss_basic_kcptun_port,
    "password":"$ss_basic_kcptun_password",
    "socks5_port":23456,
    "redir_port":1089,
    "tuncrypt":0,
    "sndwnd":128,
    "rcvwnd":1024,
    "mtu":$ss_basic_kcptun_mtu,
    "mode":"fast"
}

EOF

echo $(date): done
echo $(date):


# create dnsmasq.conf.add

[ "$ss_kcptun_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
[ "$ss_kcptun_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
[ "$ss_kcptun_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$ss_kcptun_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$ss_kcptun_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$ss_kcptun_dns_china" == "5" ] && CDN="$ss_kcptun_dns_china_user"
[ "$ss_kcptun_dns_china" == "6" ] && CDN="180.76.76.76"
[ "$ss_kcptun_dns_china" == "7" ] && CDN="1.2.4.8"
[ "$ss_kcptun_dns_china" == "8" ] && CDN="119.29.29.29"

mkdir -p /jffs/configs
echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
no-resolv
server=127.0.0.1#1053
EOF
echo $(date): done
echo $(date):

# append domain white list
if [ ! -z $ss_kcptun_wan_white_domain ];then
	echo $(date): append white_domain
	echo "#for white_domain" >> /jffs/configs/dnsmasq.conf.add
	for wan_white_domain in $wanwhitedomain
	do 
		echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /jffs/configs/dnsmasq.conf.add
		echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_domain/g" >> /jffs/configs/dnsmasq.conf.add
	done
	echo $(date): done
	echo $(date):
fi

# append domain black list
if [ ! -z $ss_kcptun_wan_black_domain ];then
	echo $(date): append black_domain
	echo "#for black_domain" >> /jffs/configs/dnsmasq.conf.add
	for wan_black_domain in $wanblackdomain
	do 
		echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /jffs/configs/dnsmasq.conf.add
		echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_domain/g" >> /jffs/configs/dnsmasq.conf.add
	done
	echo $(date): done
	echo $(date):
fi

# append coustom dnsmasq settings
if [ ! -z $ss_kcptun_dnsmasq ];then
	echo $(date): append coustom dnsmasq settings
	echo "#for coustom dnsmasq settings" >> /jffs/configs/dnsmasq.conf.add
	for line in $custom_dnsmasq
	do 
		echo "$line" >> /jffs/configs/dnsmasq.conf.add
	done
	echo $(date): done
	echo $(date):
fi

# append router output chain rules
echo $(date): append router output chain rules
cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):

# append china site
echo $(date): append CDN list into dnsmasq conf \file
echo "#for china site CDN acclerate" >> /jffs/configs/dnsmasq.conf.add
cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):

# append user defined china site
if [ ! -z "$ss_kcptun_isp_website_web" ];then
echo $(date): append user defined domian
echo "#for user defined china site CDN acclerate" >> /jffs/configs/dnsmasq.conf.add
echo "$ss_kcptun_isp_website_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /jffs/configs/dnsmasq.conf.add
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
echo $(date): Creating iptables rules \for REDSOCKS2
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
sed -i '3a sh /koolshare/ss/kcptun/nat-start' /jffs/scripts/nat-start
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
startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
if [ -z "$startss" ];then
echo $(date): Adding service to wan-start...
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
echo $(date): done
echo $(date):
#=======================================================================================
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

if [ "1" == "$ss_kcptun_dns_foreign" ];then
	echo $(date): Starting dnscrypt-proxy...
	dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_kcptun_opendns"
	echo $(date): done
	echo $(date):
fi

[ "$ss_kcptun_sstunnel" == "1" ] && gs="208.67.220.220:53"
[ "$ss_kcptun_sstunnel" == "2" ] && gs="8.8.8.8:53"
[ "$ss_kcptun_sstunnel" == "3" ] && gs="8.8.4.4:53"
[ "$ss_kcptun_sstunnel" == "4" ] && gs="$ss_kcptun_sstunnel_user"

if [ "4" == "$ss_kcptun_dns_foreign" ]; then
	echo $(date): Starting DNS2SOCKS..
	dns2socks 127.0.0.1:23456 "$ss_kcptun_dns2socks_user" 127.0.0.1:1053 > /dev/null 2>&1 &
	echo $(date): done
	echo $(date):
fi
# Start Pcap_DNSProxy
if [ "5" == "$ss_kcptun_dns_foreign"  ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 1053' /koolshare/ss/dns/Config.conf
		sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
fi

# Start pdnsd
if [ "6" == "$ss_kcptun_dns_foreign"  ]; then
		echo $(date): Start pdnsd..
mkdir -p /koolshare/ss/pdnsd
if [ "$ss_kcptun_pdnsd_method" == "1" ];then
cat > /koolshare/ss/pdnsd/pdnsd.conf <<EOF
global {
	perm_cache=2048;
	cache_dir="/koolshare/ss/pdnsd/";
	run_as="nobody";
	server_port = 1053;
	server_ip = 127.0.0.1;
	status_ctl = on;
	query_method=udp_only;
	min_ttl=$ss_kcptun_pdnsd_server_cache_min;
	max_ttl=$ss_kcptun_pdnsd_server_cache_max;
	timeout=10;
}

server {
	label= "RT-AC68U"; 
	ip = 127.0.0.1;
	port = 1099;
	root_server = on;   
	uptest = none;    
}
EOF
	if [ "$ss_kcptun_pdnsd_udp_server" == "1" ];then
		echo $(date): Starting DNS2SOCKS \for pdnsd..
		dns2socks 127.0.0.1:23456 "$ss_kcptun_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	elif [ "$ss_kcptun_pdnsd_udp_server" == "2" ];then
		echo $(date): Starting dnscrypt-proxy \for pdnsd...
		dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_kcptun_pdnsd_udp_server_dnscrypt"
		echo $(date): done
		echo $(date):
	fi
elif [ "$ss_kcptun_pdnsd_method" == "2" ];then
cat > /koolshare/ss/pdnsd/pdnsd.conf <<EOF
global {
	perm_cache=2048;
	cache_dir="/koolshare/ss/pdnsd/";
	run_as="nobody";
	server_port = 1053;
	server_ip = 127.0.0.1;
	status_ctl = on;
	query_method=$ss_kcptun_pdnsd_method;
	min_ttl=$ss_kcptun_pdnsd_server_cache_min;
	max_ttl=$ss_kcptun_pdnsd_server_cache_max;
	timeout=10;
}

server {
	label= "RT-AC68U"; 
	ip = $ss_kcptun_pdnsd_server_ip;
	port = $ss_kcptun_pdnsd_server_port;
	root_server = on;   
	uptest = none;    
}
EOF

fi

chmod 644 /koolshare/ss/pdnsd/pdnsd.conf
CACHEDIR=/koolshare/ss/pdnsd
CACHE=/koolshare/ss/pdnsd/pdnsd.cache
USER=nobody
GROUP=nogroup

if ! test -f "$CACHE"; then
        dd if=/dev/zero of=/koolshare/ss/pdnsd/pdnsd.cache bs=1 count=4 2> /dev/null
        chown -R $USER.$GROUP $CACHEDIR 2> /dev/null
fi

	pdnsd --daemon -c /koolshare/ss/pdnsd/pdnsd.conf -p /var/run/pdnsd.pid
	echo $(date): done
	echo $(date):
fi


#---------------------------------------------------------------------------------------------------------

# Start kcptun
echo $(date): starting kcptun...
start-stop-daemon -S -q -b -m -p /tmp/var/kcptun.pid -x /koolshare/bin/kcp_router -- -c /koolshare/ss/kcptun/kcptun_config.json
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
echo $(date): "Apply nat rules!"
sh /koolshare/ss/kcptun/nat-start
echo $(date): done
echo $(date):


# Restart dnsmasq
echo $(date): restarting dnsmasq...
/sbin/service restart_dnsmasq >/dev/null 2>&1
echo $(date): done
echo $(date):

echo $(date): -------------------- Shadowsock kcptun mode Started-------------------------


