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
nvram set ss_mode=4
nvram commit
#--------------------------------------------------------------------------------------
echo $(date): ------------------- Shadowsock GAME mode V2 Starting---------------------

#ulimit -s 4096                                   
                    
SERVICE_DEBUG=1
PROCS=/koolshare/ss/koolgame/koolgame
SERVICE_DAEMONIZE=1                  
SERVICE_WRITE_PID=1
SERVICE_PID_FILE=/tmp/var/koolgame.pid
ARGS="-c /koolshare/ss/koolgame/ss.json"

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
cat > /koolshare/ss/koolgame/ss.json <<EOF
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

# append custom dnsmasq
if [ ! -z "$ss_gameV2_dnsmasq" ];then
echo $(date): append custom dnsmasq
echo "$ss_gameV2_dnsmasq" | sed "s/,/\n/g" | sort >> /jffs/configs/dnsmasq.conf.add
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
sed -i '3a sh /koolshare/ss/koolgame/nat-start' /jffs/scripts/nat-start
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
startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
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

# Start koolgame
	echo $(date): Starting koolgame...
	#kservice_start $PROCS $ARGS
	pdu=`ps|grep pdu|grep -v grep`
	if [ -z $pdu ]; then
		/koolshare/ss/koolgame/pdu br0 /tmp/var/pdu.pid
		sleep 1
	fi
	start-stop-daemon -S -q -b -m -p $SERVICE_PID_FILE -x $PROCS -- -c /koolshare/ss/koolgame/ss.json
	start-stop-daemon -S -q -b -m -p $SERVICE_PID_FILE -x $PROCS -- -c /koolshare/ss/koolgame/ss.json
	#/koolshare/ss/koolgame/koolgame -c /koolshare/ss/koolgame/ss.json >/dev/null 2>&1 &
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
	echo $(date): "Apply nat rules!"
	sh /koolshare/ss/koolgame/nat-start
	echo $(date): done
	echo $(date):

echo $(date): -------------------- Shadowsock GAME mode Started------------------------

