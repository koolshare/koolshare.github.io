#!/bin/sh
eval `dbus export shadowvpn`
Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
shadowvpn=$(ps | grep "shadowvpn" | grep -v "grep")
startshadowvpn=$(cat /jffs/scripts/wan-start | grep "shadowvpn")
CONFIG=/tmp/shadowvpn.conf
# don't forget change this version when update shadowvpn
version="2.02"
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
if [ ! -d /jffs/configs/game.d ]; then 
mkdir -p /jffs/configs/game.d
fi
echo $(date): create dnsmasq.conf.add..
cat > /jffs/configs/dnsmasq.conf.add <<EOF
#min-cache-ttl=86400
no-resolv
server=127.0.0.1#7913
conf-dir=/jffs/configs/game.d
EOF
if [ -z "$Pcap_DNSProxy" ]; then 
echo $(date): Start Pcap_DNSProxy..
sed -i '/^Listen Port/c Listen Port = 7913' /jffs/ss/dns/Config.conf
sed -i '/^Local Main/c Local Main = 1' /jffs/ss/dns/Config.conf
/jffs/ss/dns/dns.sh > /dev/null 2>&1 &
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
   if [ ! -f /jffs/scripts/shadowvpn.sh ]; then
      sed -i '2a sh /usr/bin/shadowvpn.sh' /jffs/scripts/wan-start
   else
      sed -i '2a sh /jffs/scripts/shadowvpn.sh' /jffs/scripts/wan-start
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
		rm -f /jffs/configs/dnsmasq.conf.add
		echo $(date): done
		echo $(date):
	fi
 sed -i '/shadowvpn/d' /jffs/scripts/wan-start >/dev/null 2>&1
echo $(date): restarting dnsmasq...
service restart_dnsmasq >/dev/null 2>&1

}

check_version() {
shadowvpn_version_web1=$(curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 1p)

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
   start_vpn
   sleep 3
   start_dns
   auto_start
   check_version
   dbus set shadowvpn_version=$version
   dbus set shadowvpn_poweron=0
  else
   stop_vpn
   rm $CONFIG >/dev/null 2>&1
fi

if [ "$shadowvpn_update_check" = "1" ];then

	# shadowvpn_install_status=	#
	# shadowvpn_install_status=0	#
	# shadowvpn_install_status=1	#正在下载更新......
	# shadowvpn_install_status=2	#正在安装更新...
	# shadowvpn_install_status=3	#安装更新成功，5秒后刷新本页！
	# shadowvpn_install_status=4	#下载文件校验不一致！
	# shadowvpn_install_status=5	#然而并没有更新！
	# shadowvpn_install_status=6	#正在检查是否有更新~
	# shadowvpn_install_status=7	#检测更新错误！
	
	dbus set shadowvpn_install_status="6"
	shadowvpn_version_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 1p)`
	if [ ! -z $shadowvpn_version_web1 ];then
		dbus set shadowvpn_version_web=$shadowvpn_version_web1
		if [ "$version" != "$shadowvpn_version_web1" ];then
			dbus set shadowvpn_install_status="1"
			cd /tmp
			md5_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowvpn/version | sed -n 2p)`
			wget --no-check-certificate --tries=1 --timeout=15 https://koolshare.github.io/shadowvpn/shadowvpn.tar.gz
			md5sum_gz=`md5sum /tmp/shadowvpn.tar.gz | sed 's/ /\n/g'| sed -n 1p)`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				dbus set shadowvpn_install_status="4"
				rm -rf /tmp/shadowvpn* >/dev/null 2>&1
				sleep 5
				dbus set shadowvpn_install_status="0"
			else
				stop_vpn
				tar -zxf shadowvpn.tar.gz
				dbus set shadowvpn_enable="0"
				dbus set shadowvpn_install_status="2"
        chmod a+x /tmp/shadowvpn/update.sh
        /tmp/shadowvpn/update.sh
				sleep 2
				dbus set shadowvpn_install_status="3"
				dbus set shadowvpn_version=$shadowvpn_version_web1
				sleep 2
				dbus set shadowvpn_install_status="0"
			fi
		else
			dbus set shadowvpn_install_status="5"
			sleep 2
			dbus set shadowvpn_install_status="0"
		fi
	else
		dbus set shadowvpn_install_status="7"
		sleep 5
		dbus set shadowvpn_install_status="0"
	fi
	dbus set shadowvpn_update_check="0"
fi