#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export KCP`
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
server_ip=`resolvip $KCP_basic_server`

#--------------------------------------------------------------------------------------

creat_kcptun_conf(){
	# create kcptun config file...
	echo $(date): create kcptun config file...
	cat > /koolshare/kcptun/kcptun_config.json <<-EOF
		{
		    "server":"$server_ip",
		    "server_port":$KCP_basic_port,
		    "password":"$KCP_basic_password",
		    "crypt":"$KCP_basic_crypt",
		    "socks5_port":23456,
		    "redir_port":3333,
		    "mode":"$KCP_basic_mode",
		    "conn":$KCP_basic_conn,
		    "sndwnd":$KCP_basic_sndwnd,
		    "rcvwnd":$KCP_basic_rndwnd,
		    "mtu":$KCP_basic_mtu,
		    "nocomp":$KCP_basic_nocomp
		    
		}
		EOF
	echo $(date): done
	echo $(date):
}

creat_dnsmasq_conf(){
	ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	[ "$KCP_chnmode_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
	[ "$KCP_chnmode_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
	[ "$KCP_chnmode_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$KCP_chnmode_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$KCP_chnmode_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$KCP_chnmode_dns_china" == "5" ] && CDN="$KCP_chnmode_dns_china_user"
	[ "$KCP_chnmode_dns_china" == "6" ] && CDN="180.76.76.76"
	[ "$KCP_chnmode_dns_china" == "7" ] && CDN="1.2.4.8"
	[ "$KCP_chnmode_dns_china" == "8" ] && CDN="119.29.29.29"

	# make directory if not exist
	if [ ! -d /jffs/configs/dnsmasq.d ]; then
		mkdir -p /jffs/configs/dnsmasq.d
	fi

	# create dnsmasq.conf.add
	echo $(date): create dnsmasq.conf.add..
	cat > /jffs/configs/dnsmasq.conf.add <<-EOF
		no-resolv
		server=127.0.0.1#1053
	EOF
	echo $(date): done
	echo $(date):

	# append router output chain rules
	echo $(date): append router output chain rules
	cat /koolshare/kcptun/chnmode/output.conf >> /jffs/configs/dnsmasq.conf.add
	echo $(date): done
	echo $(date):

	# append china site
	rm -rf /tmp/cdn.conf
	rm -rf /jffs/configs/dnsmasq.d/cdn.conf
	echo $(date): append CDN list into dnsmasq conf \file
	echo "#for china site CDN acclerate" >> /tmp/cdn.conf
		cat /koolshare/kcptun/chnmode/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >> /tmp/cdn.conf
	echo $(date): done
	echo $(date):
}

append_white_black_conf(){
	# append domain white list
	wanwhitedomain=$(echo $KCP_chnmode_wan_white_domain | sed 's/,/\n/g')
	rm -rf /tmp/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	if [ ! -z $KCP_chnmode_wan_white_domain ];then
		echo $(date): append white_domain
		echo "#for white_domain" >> /tmp/custom.conf
		for wan_white_domain in $wanwhitedomain
		do 
			echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /tmp/custom.conf
			echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_domain/g" >> /tmp/custom.conf
		done
		echo $(date): done
		echo $(date):
	fi

	# append domain black list
	wanblackdomain=$(echo $KCP_chnmode_wan_black_domain | sed "s/,/\n/g")
	if [ ! -z $KCP_chnmode_wan_black_domain ];then
		echo $(date): append black_domain
		echo "#for black_domain" >> /jffs/configs/dnsmasq.conf.add
		for wan_black_domain in $wanblackdomain
		do 
			echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /tmp/custom.conf
			echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_domain/g" >> /tmp/custom.conf
		done
		echo $(date): done
		echo $(date):
	fi
}

user_cdn_site(){

	# append user defined china site
	if [ ! -z "$KCP_chnmode_isp_website_web" ];then
	echo $(date): append user defined domian
	echo "#for user defined china site CDN acclerate" >> /tmp/cdn.conf
	echo "$KCP_chnmode_isp_website_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /tmp/cdn.conf
	echo $(date): done
	echo $(date):
	fi	


}


custom_dnsmasq(){
	# append coustom dnsmasq settings
	custom_dnsmasq=$(echo $KCP_chnmode_dnsmasq | sed "s/,/\n/g")
	if [ ! -z $KCP_chnmode_dnsmasq ];then
		echo $(date): append coustom dnsmasq settings
		echo "#for coustom dnsmasq settings" >> /jffs/configs/dnsmasq.conf.add
		for line in $custom_dnsmasq
		do 
			echo "$line" >> /jffs/configs/dnsmasq.conf.add
		done
		echo $(date): done
		echo $(date):
	fi
}

ln_conf(){
	if [ -f /tmp/custom.conf ];then
		ln -sf /tmp/custom.conf /jffs/configs/dnsmasq.d/custom.conf
	fi

	if [ -f /tmp/cdn.conf ];then
		ln -sf /tmp/cdn.conf /jffs/configs/dnsmasq.d/cdn.conf
	fi
}



#--------------------------------------------------------------------------------------
nat_auto_start(){
	# creating iptables rules to nat-start
	mkdir -p /jffs/scripts
	if [ ! -f /jffs/scripts/nat-start ]; then
		cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			dbus fire onnatstart
	
			EOF
	fi
	
	writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
	if [ -z "$writenat" ];then
		echo $(date): Creating iptables rules \for kcptun
		sed -i '2a sh /koolshare/kcptun/chnmode/nat-start' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
	echo $(date): done
	echo $(date):
}

#--------------------------------------------------------------------------------------
wan_auto_start(){
	# Add service to auto start
	if [ ! -f /jffs/scripts/wan-start ]; then
		cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			dbus fire onwanstart
	
			EOF
	fi
	
	startKCP=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/kcp_config.sh")
	if [ -z "$startKCP" ];then
		echo $(date): Adding service to wan-start...
		sed -i '2a sh /koolshare/scripts/kcp_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
	echo $(date): done
	echo $(date):
}

#=======================================================================================

start_dns(){
	# Start dnscrypt-proxy
	if [ "1" == "$KCP_chnmode_dns_foreign" ];then
		echo $(date): Starting dnscrypt-proxy...
		dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$KCP_chnmode_opendns"
		echo $(date): done
		echo $(date):
	fi
	
	# Start DNS2SOCKS
	if [ "4" == "$KCP_chnmode_dns_foreign" ]; then
		echo $(date): Starting DNS2SOCKS..
		dns2socks 127.0.0.1:23456 "$KCP_chnmode_dns2socks_user" 127.0.0.1:1053 > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	fi
	
	# Start Pcap_DNSProxy
	if [ "5" == "$KCP_chnmode_dns_foreign"  ]; then
		echo $(date): Start Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 1053' /koolshare/ss/dns/Config.conf
		sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	fi

	# Start pdnsd
	if [ "6" == "$KCP_chnmode_dns_foreign"  ]; then
			echo $(date): Start pdnsd..
			mkdir -p /koolshare/ss/pdnsd
		if [ "$KCP_chnmode_pdnsd_method" == "1" ];then
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 1053;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=udp_only;
					min_ttl=$KCP_chnmode_pdnsd_server_cache_min;
					max_ttl=$KCP_chnmode_pdnsd_server_cache_max;
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
				
			if [ "$KCP_ipset_pdnsd_udp_server" == "1" ];then
				echo $(date): Starting DNS2SOCKS \for pdnsd..
				dns2socks 127.0.0.1:23456 "$KCP_ipset_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
				echo $(date): done
				echo $(date):
			elif [ "$KCP_ipset_pdnsd_udp_server" == "2" ];then
				echo $(date): Starting dnscrypt-proxy \for pdnsd...
				dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$KCP_ipset_pdnsd_udp_server_dnscrypt"
				echo $(date): done
				echo $(date):
			fi
		elif [ "$KCP_chnmode_pdnsd_method" == "2" ];then
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 1053;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=tcp_only;
					min_ttl=$KCP_chnmode_pdnsd_server_cache_min;
					max_ttl=$KCP_chnmode_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = $KCP_ipset_pdnsd_server_ip;
					port = $KCP_ipset_pdnsd_server_port;
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
}

stop_dns(){
	dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
	pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
	chinadns=$(ps | grep "chinadns" | grep -v "grep")
	DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
	Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
	
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): kill dnscrypt-proxy...
		killall dnscrypt-proxy
		echo $(date): done
		echo $(date):
	fi

	# kill pdnsd
	if [ ! -z "$pdnsd" ]; then 
		echo $(date): kill pdnsd...
		killall pdnsd
		echo $(date): done
		echo $(date):
	fi
	
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then 
		echo $(date): kill Pcap_DNSProxy...
		killall dns.sh >/dev/null 2>&1
		killall Pcap_DNSProxy >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi

	# kill chinadns
	if [ ! -z "$chinadns" ]; then 
		echo $(date): kill chinadns...
		killall chinadns
		echo $(date): done
		echo $(date):
	fi
	
	# kill dns2socks
	if [ ! -z "$DNS2SOCK" ]; then 
		echo $(date): kill dns2socks...
		killall dns2socks
		echo $(date): done
		echo $(date):
	fi
	rm -rf /tmp/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/configs/dnsmasq.conf.add
}

#---------------------------------------------------------------------------------------------------------

Start_kcptun(){
	# Start kcptun
	echo $(date): starting kcptun...
	perp=`ps | grep perpd |grep -v grep`
	if [ -z "$perp" ];then
		sh /koolshare/perp/perp.sh stop
		sh /koolshare/perp/perp.sh start
	fi

	if [ "$KCP_basic_guardian" == "1" ];then
		perpctl A kcptun
		#/koolshare/bin/perpctl A kcptun
	else
		start-stop-daemon -S -q -b -m -p /tmp/var/kcptun.pid -x /koolshare/bin/kcp_router -- -c /koolshare/kcptun/kcptun_config.json
	fi
	echo $(date): done
	echo $(date):
}

load_nat(){
	i=120
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	until [ -n "$nat_ready" ]
	do
	        i=$(($i-1))
	        if [ "$i" -lt 1 ]
	        then
	            echo $(date): "Could not load nat rules!"
	            sh /koolshare/ss/stop.sh
	            exit
	        fi
	        sleep 1
	done
	echo $(date): "Apply nat rules!"
	sh /koolshare/kcptun/chnmode/nat-start start_all
	echo $(date): done
	echo $(date):
}

# Restart dnsmasq
restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}



case $1 in
start_all)
	#KCP_basic_action=0 应用所有设置
	echo $(date): ------------------- kcptun gfwlist mode Starting-------------------------
	creat_kcptun_conf
	creat_dnsmasq_conf
	append_white_black_conf
	user_cdn_site
	custom_dnsmasq
	nat_auto_start
	wan_auto_start
	start_dns
	Start_kcptun
	load_nat
	restart_dnsmasq
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
	nvram set KCP_mode=2
	nvram commit
	echo $(date): -------------------- kcptu gfwlist mode Started -------------------------
	;;
restart_dns)
	#KCP_basic_action=1 应用DNS设置
	echo $(date): --------------------------- Restart dns ---------------------------------
	stop_dns
	creat_dnsmasq_conf
	user_cdn_site
	custom_dnsmasq
	ln_conf
	start_dns
	#load_nat
	restart_dnsmasq
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
	echo $(date): -------------------------- dns Restarted --------------------------------
	;;
restart_wb_list)
	#KCP_basic_action=2 应用黑白名单设置
	echo $(date): --------------------- Restart white_black_list --------------------------
	ipset -F white_domain >/dev/null 2>&1
	ipset -F black_domain >/dev/null 2>&1
	#creat_dnsmasq_conf
	append_white_black_conf
	#custom_dnsmasq
	ln_conf
	sh /koolshare/kcptun/chnmode/nat-start add_white_black_ip
	restart_dnsmasq
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
	#echo $(date): --------------------- white_black_list applied --------------------------
	;;
restart_kcptun)
	#KCP_basic_action=3 应用kcptun主进程
	echo $(date): ---------------------- Restart kcptun process----------------------------
	echo $(date): kill kcptun...
	killall kcp_router
	echo $(date): done
	echo $(date):
	creat_kcptun_conf
	Start_kcptun
	echo $(date): --------------------- kcptun process restarted---------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_kcptun|restart_wb_list|restart_dns)"
	exit 1
	;;
esac