#! /bin/sh
# 导入skipd数据
eval `dbus export softether`

# 引用环境变量等
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp


creat_start_up(){
	echo $(date): 加入开机自动启动...
	rm -rf /koolshare/init.d/S82SoftEther.sh
	ln -sf /koolshare/softether/softether.sh /koolshare/init.d/S82SoftEther.sh
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1701`
	if [ -z "$ifopen" ];then
		iptables -I INPUT -p udp --dport 1194 -j ACCEPT
		iptables -I INPUT -p udp --dport 500 -j ACCEPT
		iptables -I INPUT -p udp --dport 4500 -j ACCEPT
		iptables -I INPUT -p udp --dport 1701 -j ACCEPT
		iptables -I INPUT -p tcp --dport 443 -j ACCEPT
		iptables -I INPUT -p tcp --dport 5555 -j ACCEPT
		iptables -I INPUT -p tcp --dport 8888 -j ACCEPT
		iptables -I INPUT -p tcp --dport 992 -j ACCEPT
	fi


	if [ ! -f /jffs/scripts/firewall-start ]; then
		cat > /jffs/scripts/firewall-start <<-EOF
		#!/bin/sh
		EOF
	fi
	fire_rule=$(cat /jffs/scripts/firewall-start | grep "1701")
	if [ -z "$fire_rule" ];then
		cat >> /jffs/scripts/firewall-start <<-EOF
			iptables -I INPUT -p udp --dport 1194 -j ACCEPT
			iptables -I INPUT -p udp --dport 500 -j ACCEPT
			iptables -I INPUT -p udp --dport 4500 -j ACCEPT
			iptables -I INPUT -p udp --dport 1701 -j ACCEPT
			iptables -I INPUT -p tcp --dport 443 -j ACCEPT
			iptables -I INPUT -p tcp --dport 5555 -j ACCEPT
			iptables -I INPUT -p tcp --dport 8888 -j ACCEPT
			iptables -I INPUT -p tcp --dport 992 -j ACCEPT
		EOF
	fi
}

close_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1701`
	if [ ! -z "$ifopen" ];then
		iptables -D INPUT -p udp --dport 1194 -j ACCEPT
		iptables -D INPUT -p udp --dport 500 -j ACCEPT
		iptables -D INPUT -p udp --dport 4500 -j ACCEPT
		iptables -D INPUT -p udp --dport 1701 -j ACCEPT
		iptables -D INPUT -p tcp --dport 443 -j ACCEPT
		iptables -D INPUT -p tcp --dport 5555 -j ACCEPT
		iptables -D INPUT -p tcp --dport 8888 -j ACCEPT
		iptables -D INPUT -p tcp --dport 992 -j ACCEPT
	fi

	fire_rule=$(cat /jffs/scripts/firewall-start | grep "1701")
	if [ ! -z "$fire_rule" ];then
		sed -i '/1194/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/500/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/4500/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/1701/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/443/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/5555/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/8888/d' /jffs/scripts/firewall-start >/dev/null 2>&1
		sed -i '/992/d' /jffs/scripts/firewall-start >/dev/null 2>&1
	fi
}

case $ACTION in
start)
	modprobe tun
	/koolshare/softether/vpnserver start
	i=120
	until [ ! -z "$tap" ]
	do
	    i=$(($i-1))
		tap=`ifconfig | grep tap_ | awk '{print $1}'`
	    if [ "$i" -lt 1 ];then
	        echo $(date): "错误：不能正确启动vpnserver!"
	        exit
	    fi
	    sleep 1
	done
	open_port
	brctl addif br0 $tap
	echo interface=tap_vpn > /jffs/configs/dnsmasq.d/softether.conf
	service restart_dnsmasq
	;;
restart)
	/koolshare/softether/vpnserver stop
	pid=`pidof vpnserver`
	if [ ! -z "$pid" ];then
		kill -9 $pid
	fi
	close_port
	mod=`lsmod |grep tun`
	if [ -z "$mod" ];then
		modprobe tun
	fi
	/koolshare/softether/vpnserver start
	
	i=180
	until [ ! -z "$tap" ]
	do
	    i=$(($i-1))
		tap=`ifconfig | grep tap_ | awk '{print $1}'`
	    if [ "$i" -lt 1 ];then
	        echo $(date): "错误：不能正确启动vpnserver!"
	        exit
	    fi
	    sleep 2
	done
	open_port
	brctl addif br0 $tap
	echo interface=tap_vpn > /jffs/configs/dnsmasq.d/softether.conf
	service restart_dnsmasq
	creat_start_up
	;;
stop)
	/koolshare/softether/vpnserver stop
	close_port
	rm -rf /jffs/configs/dnsmasq.d/softether.conf
	service restart_dnsmasq
	rm -rf /koolshare/init.d/S82SoftEther.sh
	;;
esac
