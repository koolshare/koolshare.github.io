#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
#source /koolshare/configs/ss.sh
#source /koolshare/configs/redchn.sh
#source /koolshare/configs/ipset.sh
#source /koolshare/scripts/base.sh
ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
lan_ipaddr=$(nvram get lan_ipaddr)
server_ip=`resolvip $ss_server`
nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
i=120
nvram set ss_mode=2
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ------------------- Shadowsock CHN mode Starting-------------------------

if [ -z "$shadowsocks_server_ip" ];then
        if [ ! -z "$server_ip" ];then
                export shadowsocks_server_ip="$server_ip"
                ss_server="$server_ip"
                dbus save shadowsocks
        fi
else
        if [ "$shadowsocks_server_ip"x = "$server_ip"x ];then
                ss_server="$shadowsocks_server_ip"
        elif [ "$shadowsocks_server_ip"x != "$server_ip"x ] && [ ! -z "$server_ip" ];then
                ss_server="$server_ip"
                export shadowsocks_server_ip="$server_ip"
                dbus save shadowsocks
        else
                ss_server="$ss_server"
        fi
fi

# create shadowsocks config file...
echo $(date): create shadowsocks config file...
if [ "$ss_use_rss" == "0" ];then
cat > /koolshare/ss/redchn/ss.json <<EOF
{
    "server":"$ss_server",
    "server_port":$ss_port,
    "local_port":3333,
    "password":"$ss_password",
    "timeout":600,
    "method":"$ss_method"
}

EOF
elif [ "$ss_use_rss" == "1" ];then
cat > /koolshare/ss/redchn/ss.json <<EOF
{
    "server":"$ss_server",
    "server_port":$ss_port,
    "local_port":3333,
    "password":"$ss_password",
    "timeout":600,
    "protocol":"$ss_rss_protocol",
    "obfs":"$ss_rss_obfs",
    "method":"$ss_method"
}

EOF
fi
echo $(date): done
echo $(date):

# create redsocks2 config file...
echo $(date): Creating redsocks config file...

cat > /koolshare/ss/redchn/redsocks2.conf <<EOF
base {
  log_debug = off; 
  log_info = on;
  daemon = on;
  redirector= iptables;
}

redsocks {
 local_ip = 0.0.0.0;
 local_port = 1089;
 ip = $lan_ipaddr;
 port = 23456;
 type = socks5;
 timeout = 3;
 autoproxy = 0;
 //login = "$ss_method";
 //password = "$ss_password";
}

EOF
echo $(date): done
echo $(date):

# create dnsmasq.conf.add

[ "$ss_redchn_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
[ "$ss_redchn_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
[ "$ss_redchn_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$ss_redchn_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$ss_redchn_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$ss_redchn_dns_china" == "5" ] && CDN="$ss_redchn_dns_china_user"
[ "$ss_redchn_dns_china" == "6" ] && CDN="180.76.76.76"
[ "$ss_redchn_dns_china" == "7" ] && CDN="1.2.4.8"
[ "$ss_redchn_dns_china" == "8" ] && CDN="119.29.29.29"

mkdir -p /jffs/configs
echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
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
cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):

# append user defined china site
if [ ! -z "$ss_redchn_isp_website_web" ];then
echo $(date): append user defined domian
echo "$ss_redchn_isp_website_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /jffs/configs/dnsmasq.conf.add
echo $(date): done
echo $(date):
fi

# append adblock rules
	if [ "1" == "$ss_adblock" ];then
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
echo $(date): Creating iptables rules \for REDSOCKS2
sed -i "2a sleep $ss_sleep" /jffs/scripts/nat-start
sed -i '3a sh /koolshare/ss/redchn/nat-start' /jffs/scripts/nat-start
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
startss=$(cat /jffs/scripts/wan-start | grep "ssconfig")
if [ -z "$startss" ];then
echo $(date): Adding service to wan-start...
sed -i "2a sleep $ss_sleep" /jffs/scripts/wan-start
sed -i '3a sh /usr/bin/ssconfig' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
echo $(date): done
echo $(date):
#=======================================================================================
# start setvice

# start ss-local on port 23456
echo $(date): Sicks5 enable on port 23456 for DNS2SOCKS..
if [ "$ss_use_rss" == "1" ];then
	rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
elif  [ "$ss_use_rss" == "0" ];then
	if [ "$ss_onetime_auth" == "1" ];then
		ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid
	elif [ "$ss_onetime_auth" == "0" ];then
		ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid
	fi
fi
echo $(date): done
echo $(date):

if [ "1" == "$ss_rule_update" ]; then
	echo $(date): add schedual update
	cru a ssupdate "0 $ss_rule_update_time * * * /bin/sh /koolshare/ss/cru/update.sh"
	echo $(date): done
	echo $(date):
else
	echo $(date): will not apply schedual update
	echo $(date): done
	echo $(date):
fi

if [ "1" == "$ss_redchn_dns_foreign" ];then
	echo $(date): Starting dnscrypt-proxy...
	dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_redchn_opendns"
	echo $(date): done
	echo $(date):
fi

[ "$ss_redchn_sstunnel" == "1" ] && gs="208.67.220.220:53"
[ "$ss_redchn_sstunnel" == "2" ] && gs="8.8.8.8:53"
[ "$ss_redchn_sstunnel" == "3" ] && gs="8.8.4.4:53"
[ "$ss_redchn_sstunnel" == "4" ] && gs="$ss_redchn_sstunnel_user"


if [ "2" == "$ss_redchn_dns_foreign" ];then
	echo $(date): Starting ss-tunnel...
	if [ "$ss_use_rss" == "1" ];then
		rss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
	elif  [ "$ss_use_rss" == "0" ];then
		if [ "$ss_onetime_auth" == "1" ];then
			ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -A -f /var/run/sstunnel.pid
		elif [ "$ss_onetime_auth" == "0" ];then
			ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
		fi
	fi
	echo $(date): done
	echo $(date):
fi

[ "$ss_redchn_chinadns_china" == "1" ] && rcc="223.5.5.5"
[ "$ss_redchn_chinadns_china" == "2" ] && rcc="223.6.6.6"
[ "$ss_redchn_chinadns_china" == "3" ] && rcc="114.114.114.114"
[ "$ss_redchn_chinadns_china" == "4" ] && rcc="$ss_redchn_chinadns_china_user"
[ "$ss_redchn_chinadns_foreign" == "1" ] && rdf="208.67.220.220:53"
[ "$ss_redchn_chinadns_foreign" == "2" ] && rdf="8.8.8.8:53"
[ "$ss_redchn_chinadns_foreign" == "3" ] && rdf="8.8.4.4:53"
[ "$ss_redchn_chinadns_foreign" == "4" ] && rdf="$ss_redchn_chinadns_foreign_user"

if [ "3" == "$ss_redchn_dns_foreign" ];then
	echo $(date): Starting chinadns
	if [ "$ss_use_rss" == "1" ];then
		rss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -f /var/run/sstunnel.pid
	elif  [ "$ss_use_rss" == "0" ];then
		if [ "$ss_onetime_auth" == "1" ];then
			ss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -A -f /var/run/sstunnel.pid
		elif [ "$ss_onetime_auth" == "0" ];then
			ss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -f /var/run/sstunnel.pid
		fi
	fi
	chinadns -p 1053 -s "$rcc",127.0.0.1:1055 -m -d -c /koolshare/ss/redchn/chnroute.txt  >/dev/null 2>&1 &
	echo $(date): done
	echo $(date):
fi

if [ "4" == "$ss_redchn_dns_foreign" ]; then
	echo $(date): Starting DNS2SOCKS..
	dns2socks 127.0.0.1:23456 "$ss_redchn_dns2socks_user" 127.0.0.1:1053 > /dev/null 2>&1 &
	echo $(date): done
	echo $(date):
fi
# Start Pcap_DNSProxy
if [ "5" == "$ss_redchn_dns_foreign"  ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 1053' /koolshare/ss/dns/Config.conf
		sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
fi

#---------------------------------------------------------------------------------------------------------

# Start REDSOCKS2
echo $(date): starting REDSOCKS2...
redsocks2 -c /koolshare/ss/redchn/redsocks2.conf -p /var/run/redsocks2.pid
echo $(date): done
echo $(date):

	if [ "$sslocal_enable" == "1" ]; then
		echo $(date): enable sslocal...
		ss-local -b 0.0.0.0 -s "$sslocal_server" -p "$sslocal_port" -l "$sslocal_proxyport" -k "$sslocal_password" -m "$sslocal_method" -u -f /var/run/sslocal.pid
		echo $(date): done
		echo $(date):
	fi

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
sh /koolshare/ss/redchn/nat-start


# Restart dnsmasq
echo $(date): restarting dnsmasq...
/sbin/service restart_dnsmasq >/dev/null 2>&1
echo $(date): done
echo $(date):

echo $(date): -------------------- Shadowsock CHN mode Started-------------------------


