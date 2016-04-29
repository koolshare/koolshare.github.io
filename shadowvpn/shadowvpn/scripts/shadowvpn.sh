#!/bin/sh
eval `dbus export shadowvpn`
source /koolshare/scripts/base.sh
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
shadowvpn=$(ps | grep "shadowvpn" | grep -v "grep")
startshadowvpn=$(cat /jffs/scripts/wan-start | grep "shadowvpn")
CONFIG=/tmp/shadowvpn.conf
# don't forget change this version when update shadowvpn
#time=$(cat /proc/uptime | sed 's/ /\n/g'|sed -n 1p)
start_vpn() {
	#mkdir -p $(dirname $CONFIG)
	cat <<-EOF >$CONFIG
		server=$shadowvpn_address
		port=$shadowvpn_port
		password=$shadowvpn_passwd
		mode=client
		#concurrency=1
		net=$shadowvpn_net
		mtu=$shadowvpn_mtu
		intf=$shadowvpn_tun
		up=/koolshare/scripts/shadowvpn_client_up.sh
		down=/koolshare/scripts/shadowvpn_client_down.sh
		pidfile=/var/run/shadowvpn.pid
		logfile=/var/log/shadowvpn.log
EOF
	if [ "$shadowvpn_token" != "" ]; then
		echo "user_token=$shadowvpn_token" >>$CONFIG
	fi
	shadowvpn -c $CONFIG -s start
}
start_dns() {
if [ ! -d /jffs/configs ]; then
mkdir -p /jffs/configs
fi
if [ ! -d /jffs/configs/game.d ]; then
mkdir -p /jffs/configs/game.d
fi
echo $(date): create dnsmasq.conf.add..
cat <<-EOF >/jffs/configs/dnsmasq.conf.add
no-resolv
server=127.0.0.1#7913
conf-dir=/jffs/configs/game.d
EOF
if [ -z "$Pcap_DNSProxy" ]; then
echo $(date): Start Pcap_DNSProxy..
sed -i '/^Listen Port/c Listen Port = 7913' /jffs/ss/dns/Config.conf
sed -i '/^Local Main/c Local Main = 1' /koolshare/ss/dns/Config.conf
/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
fi
echo $(date): restarting dnsmasq...
service restart_dnsmasq >/dev/null 2>&1
echo $(date): done
echo $(date):
}
auto_start(){
if [ "$shadowvpn_start" == "1" ]; then
if [ ! -f /jffs/scripts/wan-start ]; then
cat > /jffs/scripts/wan-start <<EOF
#!/bin/sh
dbus fire onwanstart

EOF
fi
echo $(date): Adding service to wan-start...
if [ -z "$startshadowvpn" ];then
   if [ ! -f /koolshare/scripts/shadowvpn.sh ]; then
      sed -i '2a sh /usr/bin/shadowvpn.sh' /jffs/scripts/wan-start
   else
      sed -i '2a sh /koolshare/scripts/shadowvpn.sh' /jffs/scripts/wan-start
   fi
fi
chmod +x /jffs/scripts/wan-start
fi
}
sleep_a_while(){
	if [ $shadowvpn_poweron = 1 ];then
		echo "do not sleep"
	else
		sleep $shadowvpn_time
	fi
}
stop_vpn() {
   if [ ! -z "$shadowvpn" ]; then
	 echo $(date): stop shadowvpn...
   /usr/bin/shadowvpn -c $CONFIG -s stop >/dev/null 2>&1
	 fi
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then
	echo $(date): kill Pcap_DNSProxy...
	killall dns.sh >/dev/null 2>&1
	killall Pcap_DNSProxy >/dev/null 2>&1
	echo $(date): done
	echo $(date):
	fi
#--------------------------------------------------------------------------
# restore dnsmasq conf file
	if [ -f /jffs/configs/dnsmasq.conf.add ]; then
		echo $(date): restore dnsmasq conf file
		rm -rf /jffs/configs/dnsmasq.conf.add
		echo $(date): done
		echo $(date):
	fi
 sed -i '/shadowvpn/d' /jffs/scripts/wan-start >/dev/null 2>&1
echo $(date): restarting dnsmasq...
service restart_dnsmasq >/dev/null 2>&1

}

}
if [ "$shadowvpn_enable" = "1" ];then
	if [ ! -c "/dev/net/tun" ]; then
		modprobe tun
		mkdir -p /dev/net
		mknod /dev/net/tun c 10 200
		chmod 0666 /dev/net/tun
	fi
   sleep_a_while
   start_vpn
   sleep 3
   start_dns
   auto_start
   dbus set shadowvpn_poweron=0
  else
   stop_vpn
   rm $CONFIG >/dev/null 2>&1
fi

