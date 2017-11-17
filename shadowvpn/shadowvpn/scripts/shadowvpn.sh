#!/bin/sh
eval `dbus export shadowvpn`
source /koolshare/scripts/base.sh
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
shadowvpn=$(ps | grep "shadowvpn" | grep -v "grep")
startshadowvpn=$(cat /jffs/scripts/wan-start | grep "shadowvpn")
CONFIG=/tmp/shadowvpn.conf
# don't forget change this version when update shadowvpn
#time=$(cat /proc/uptime | sed 's/ /\n/g'|sed -n 1p)

start_speeder(){
	if [ "$shadowvpn_udp_boost_enable" == "1" ];then
		[ "$shadowvpn_udpv2_disableobscure" == "1" ] && disable_obscure="--disable-obscure" || disable_obscure=""
		[ -n "$shadowvpn_udpv2_timeout" ] && timeout="--timeout $shadowvpn_udpv2_timeout" || timeout=""
		[ -n "$shadowvpn_udpv2_mode" ] && mode="--mode $shadowvpn_udpv2_mode" || mode=""
		[ -n "$shadowvpn_udpv2_report" ] && report="--report $shadowvpn_udpv2_report" || report=""
		[ -n "$shadowvpn_udpv2_mtu" ] && mtu="--mtu $shadowvpn_udpv2_mtu" || mtu=""
		[ -n "$shadowvpn_udpv2_jitter" ] && jitter="--jitter $shadowvpn_udpv2_jitter" || jitter=""
		[ -n "$shadowvpn_udpv2_interval" ] && interval="-interval $shadowvpn_udpv2_interval" || interval=""
		[ -n "$shadowvpn_udpv2_drop" ] && drop="-random-drop $shadowvpn_udpv2_drop" || drop=""
		speederv2 -c -l 0.0.0.0:1092 -r $shadowvpn_udpv2_rserver:$shadowvpn_udpv2_rport -k $shadowvpn_udpv2_password -f $shadowvpn_udpv2_fec $timeout $mode $report $mtu $jitter $interval $drop $disable_obscure $shadowvpn_udpv2_other --fifo /tmp/fifo.file >/dev/null 2>&1 &
	fi
}

start_vpn() {
	if [ "$shadowvpn_udp_boost_enable" == "1" ];then
		shadowvpn_address=127.0.0.1
		shadowvpn_port=1092
	fi
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
	start_speeder
	/koolshare/bin/shadowvpn -c $CONFIG -s start
}

start_dns() {
	mkdir -p /jffs/configs
	mkdir -p /jffs/configs/dnsmasq.d
	echo $(date): create dnsmasq.conf.add..
	cat <<-EOF >/jffs/configs/dnsmasq.conf.add
		no-resolv
		server=127.0.0.1#7913
		conf-dir=/jffs/configs/dnsmasq.d
	EOF
	if [ -z "$Pcap_DNSProxy" ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 7913' /koolshare/ss/dns/Config.ini
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
		cat > /jffs/scripts/wan-start <<-EOF
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
		/koolshare/bin/shadowvpn -c $CONFIG -s stop >/dev/null 2>&1
	fi
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then
		echo $(date): kill Pcap_DNSProxy...
		killall dns.sh >/dev/null 2>&1
		killall Pcap_DNSProxy >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
	speederv2=$(pidof speederv2)
	if [ -n "$speederv2" ];then 
		echo_date 关闭speederv2进程...
		killall speederv2 >/dev/null 2>&1
	fi
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

if [ "$shadowvpn_enable" = "1" ];then
	stop_vpn
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

