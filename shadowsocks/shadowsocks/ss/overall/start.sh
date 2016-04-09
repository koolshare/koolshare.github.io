#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh
lan_ipaddr=$(nvram get lan_ipaddr)
ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
server_ip=`resolvip $ss_basic_server`
nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
i=120
nvram set ss_mode=5
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ------------------ Shadowsock Overall mode Starting----------------------

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
cat > /koolshare/ss/overall/ss.json <<EOF
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
cat > /koolshare/ss/overall/ss.json <<EOF
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
mkdir -p /jffs/configs
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
chmod 755 /jffs/scripts/nat-start
fi
writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
if [ -z "$writenat" ];then
	echo $(date): Creating iptables rules \for shadowsocks
	sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
	sed -i '3a sh /koolshare/ss/overall/nat-start' /jffs/scripts/nat-start
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

startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
if [ -z "$startss" ];then
echo $(date): Adding service to wan-start...
sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
echo $(date): done
echo $(date):
#=========================================================================================================
if [ "1" == "$ss_basic_rule_update" ]; then
	echo $(date): add schedual update
	cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/ss/cru/update.sh"
	echo $(date): done
	echo $(date):
else
	echo will not apply schedual update
	echo $(date): done
	echo $(date):
fi

# Start dnscrypt-proxy
if [ "$ss_overall_dns" == "0" ]; then
echo $(date): Starting dnscrypt-proxy...
dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R cisco(opendns)
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
	dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R cisco(opendns)
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

# Start Pcap_DNSProxy
if [ "$ss_overall_dns" == "3" ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 7913' /koolshare/ss/dns/Config.conf
      	sed -i '/^Local Main/c Local Main = 1' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
fi

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
sh /koolshare/ss/overall/nat-start
echo $(date): done
echo $(date):

# Restart dnsmasq
echo $(date): restarting dnsmasq...
/sbin/service restart_dnsmasq >/dev/null 2>&1
echo $(date): done
echo $(date):

echo $(date): ------------------ Shadowsock Overall mode Starting----------------------

