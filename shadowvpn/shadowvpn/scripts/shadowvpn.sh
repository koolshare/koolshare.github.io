#!/bin/sh
eval `dbus export shadowvpn`
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
shadowvpn=$(ps | grep "shadowvpn" | grep -v "grep")
startshadowvpn=$(cat /jffs/scripts/wan-start | grep "shadowvpn")
CONFIG=/tmp/shadowvpn.conf
# don't forget change this version when update shadowvpn
version="1.2"
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
		up=/jffs/scripts/shadowvpn_client_up.sh
		down=/jffs/scripts/shadowvpn_client_down.sh
		pidfile=/var/run/shadowvpn.pid
		logfile=/var/log/shadowvpn.log
EOF
	if [ "$shadowvpn_token" != "" ]; then
		echo "user_token=$shadowvpn_token" >>$CONFIG
	fi
	/usr/bin/shadowvpn -c $CONFIG -s start
}
start_dns() {
if [ ! -d /jffs/configs ]; then 
mkdir -p /jffs/configs
fi
if [ ! -d /etc/dnsmasq.d ]; then 
mkdir -p /etc/dnsmasq.d
fi
echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
no-resolv
server=127.0.0.1#7913
conf-dir=/etc/dnsmasq.d
EOF
if [ -z "$Pcap_DNSProxy" ]; then 
echo $(date): Start Pcap_DNSProxy..
/jffs/ss/dns/dns.sh > /dev/null 2>&1 &
fi
echo $(date): restarting dnsmasq...
service restart_dnsmasq >/dev/null 2>&1
echo $(date): done
echo $(date):
}
auto_start(){
if [ ! -f /jffs/scripts/wan-start ]; then
cat > /jffs/scripts/wan-start <<EOF
#!/bin/sh
dbus fire onwanstart

EOF
fi
echo $(date): Adding service to wan-start...
if [ -z "$startshadowvpn" ];then
sed -i '2a sh shadowvpn.sh' /jffs/scripts/wan-start
fi
chmod +x /jffs/scripts/wan-start
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
		rm -f /jffs/configs/dnsmasq.conf.add
		echo $(date): done
		echo $(date):
	fi
 sed -i '/shadowvpn/d' /jffs/scripts/wan-start >/dev/null 2>&1
echo $(date): restarting dnsmasq...
service restart_dnsmasq >/dev/null 2>&1

}

check_version() {
shadowvpn_version_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 1p)

if [ ! -z $shadowvpn_version_web1 ];then
	dbus set shadowvpn_version_web=$shadowvpn_version_web1
fi
}
if [ "$shadowvpn_enable" = "1" ];then
	if [ ! -c "/dev/net/tun" ]; then
		modprobe tun
		mkdir -p /dev/net
		mknod /dev/net/tun c 10 200
		chmod 0666 /dev/net/tun
	fi
   sleep_a_while
   start_dns
   sleep 2
   start_vpn
   check_version
  else
   stop_vpn
   rm $CONFIG >/dev/null 2>&1
fi

if [ "$shadowvpn_update_check" = "1" ];then

	# shadowvpn_install_status=	#
	# shadowvpn_install_status=0	#
	# shadowvpn_install_status=1	#姝ｅ湪涓嬭浇鏇存柊...
	# shadowvpn_install_status=2	#姝ｅ湪瀹夎鏇存柊...
	# shadowvpn_install_status=3	#瀹夎鏇存柊鎴愬姛锛?绉掑悗鍒锋柊鏈〉锛?
	# shadowvpn_install_status=4	#涓嬭浇鏂囦欢鏍￠獙涓嶄竴鑷达紒
	# shadowvpn_install_status=5	#鐒惰€屽苟娌℃湁鏇存柊锛?
	# shadowvpn_install_status=6	#姝ｅ湪妫€鏌ユ槸鍚︽湁鏇存柊~
	# shadowvpn_install_status=7	#妫€娴嬫洿鏂伴敊璇紒
	
	export shadowvpn_install_status="6"
	dbus save shadowvpn
	shadowvpn_version_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 1p)
	if [ ! -z $shadowvpn_version_web1 ];then
		dbus set shadowvpn_version_web=$shadowvpn_version_web1
		export shadowvpn_install_status="6"
		dbus save shadowvpn
		sleep 1
		if [ "$version" != "$shadowvpn_version_web1" ] && [ ! -z "$shadowvpn_version_web1" ];then
			export shadowvpn_install_status="1"
			dbus save shadowvpn
			cd /tmp
			md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 2p)
			wget --no-check-certificate --tries=1 --timeout=15 https://koolshare.github.io/shadowvpn/shadowvpn.tar.gz
			md5sum_gz=$(md5sum /tmp/shadowvpn.tar.gz | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				export shadowvpn_install_status="4"
				dbus save shadowvpn
				rm -rf /tmp/shadowvpn* >/dev/null 2>&1
				sleep 5
				export shadowvpn_install_status="0"
				dbus save shadowvpn
				exit
			fi
			stop_vpn
			tar -zxf shadowvpn.tar.gz
			export shadowvpn_enable="0"
			export shadowvpn_install_status="2"
			dbus save shadowvpn
			cp -rf /tmp/shadowvpn/scripts/* /jffs/scripts/
			cp -rf /tmp/shadowvpn/webs/* /jffs/webs/
			rm -rf /tmp/shadowvpn* >/dev/null 2>&1
			sleep 2
			export shadowvpn_install_status="3"
			dbus save shadowvpn
			dbus set shadowvpn_version=$shadowvpn_version_web1
			sleep 2
			export shadowvpn_install_status="0"
			dbus save shadowvpn
		else
			export shadowvpn_install_status="5"
			dbus save shadowvpn
			sleep 2
			export shadowvpn_install_status="0"
			dbus save shadowvpn
		fi
	else
		export shadowvpn_install_status="7"
		dbus save shadowvpn
		sleep 5
		export shadowvpn_install_status="0"
		dbus save shadowvpn
	fi
	export shadowvpn_update_check="0"
	dbus save shadowvpn_update_check
fi


dbus save shadowvpn
dbus set shadowvpn_version=$version




