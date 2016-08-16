#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export shadowsocks`
eval `dbus export ss`
source /koolshare/scripts/base.sh
#--------------------------------------------------------------------------------------

resolv_server_ip(){
	server_ip=`resolvip $ss_basic_server`
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
}


# create shadowsocks config file...
creat_ss_json(){
	echo $(date): create shadowsocks config file...
	if [ "$ss_basic_use_rss" == "0" ];then
		cat > /koolshare/ss/redchn/ss.json <<-EOF
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
		cat > /koolshare/ss/redchn/ss.json <<-EOF
			{
			    "server":"$ss_basic_server",
			    "server_port":$ss_basic_port,
			    "local_port":3333,
			    "password":"$ss_basic_password",
			    "timeout":600,
			    "protocol":"$ss_basic_rss_protocol",
			    "obfs":"$ss_basic_rss_obfs",
			    "obfs_param":"$ss_basic_rss_obfs_param",
			    "method":"$ss_basic_method"
			}
		EOF
	fi
	echo $(date): done
	echo $(date):
}

creat_redsocks2_conf(){
	lan_ipaddr=$(nvram get lan_ipaddr)
	echo $(date): Creating redsocks config file...
	cat > /koolshare/ss/redchn/redsocks2.conf <<-EOF
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
		 //login = "$ss_basic_method";
		 //password = "$ss_basic_password";
		}
		EOF
	echo $(date): done
	echo $(date):
}
# create dnsmasq.conf.add

creat_dnsmasq_basic_conf(){
	ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	[ "$ss_redchn_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
	[ "$ss_redchn_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
	[ "$ss_redchn_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$ss_redchn_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$ss_redchn_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$ss_redchn_dns_china" == "5" ] && CDN="$ss_redchn_dns_china_user"
	[ "$ss_redchn_dns_china" == "6" ] && CDN="180.76.76.76"
	[ "$ss_redchn_dns_china" == "7" ] && CDN="1.2.4.8"
	[ "$ss_redchn_dns_china" == "8" ] && CDN="119.29.29.29"

	# make directory if not exist
	mkdir -p /jffs/configs/dnsmasq.d
	
	# append dnsmasq basic conf
	echo $(date): create dnsmasq.conf.add..
	cat > /jffs/configs/dnsmasq.conf.add <<-EOF
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
		rm -rf /tmp/sscdn.conf
		echo "#for china site CDN acclerate" > /tmp/sscdn.conf
		cat /koolshare/ss/redchn/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >/tmp/sscdn.conf
	echo $(date): done
	echo $(date):

	# create dnsmasq postconf
	echo $(date): create dnsmasq.postconf
		#cp /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		ln -sf /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
	echo $(date): done
	echo $(date):

}

user_cdn_site(){
	# append user defined china site
	if [ ! -z "$ss_redchn_isp_website_web" ];then
		echo $(date): append user defined domian
		echo "#for user defined china site CDN acclerate" >> /tmp/sscdn.conf
		echo "$ss_redchn_isp_website_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /tmp/sscdn.conf
		echo $(date): done
		echo $(date):
	fi
}

custom_dnsmasq(){
	# append coustom dnsmasq settings
	custom_dnsmasq=$(echo $ss_redchn_dnsmasq | sed "s/,/\n/g")
	if [ ! -z $ss_redchn_dnsmasq ];then
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

append_white_black_conf(){
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /tmp/custom.conf
	# append white domain list
	wanwhitedomain=$(echo $ss_redchn_wan_white_domain | sed 's/,/\n/g')
	if [ ! -z $ss_redchn_wan_white_domain ];then
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
	
	# append black domain list
	wanblackdomain=$(echo $ss_redchn_wan_black_domain | sed "s/,/\n/g")
	if [ ! -z $ss_redchn_wan_black_domain ];then
		echo $(date): append black_domain
		echo "#for black_domain" >> /tmp/custom.conf
		for wan_black_domain in $wanblackdomain
		do 
			echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /tmp/custom.conf
			echo "$wan_black_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_domain/g" >> /tmp/custom.conf
		done
		echo $(date): done
		echo $(date):
	fi
}


ln_conf(){
	if [ -f /tmp/custom.conf ];then
		ln -sf /tmp/custom.conf /jffs/configs/dnsmasq.d/custom.conf
	fi
	rm -rf /jffs/configs/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
		ln -sf /tmp/sscdn.conf /jffs/configs/dnsmasq.d/cdn.conf
	fi
}

#--------------------------------------------------------------------------------------
nat_auto_start(){
	mkdir -p /jffs/scripts
	# creating iptables rules to nat-start
	if [ ! -f /jffs/scripts/nat-start ]; then
	cat > /jffs/scripts/nat-start <<-EOF
		#!/bin/sh
		dbus fire onnatstart
		
		EOF
	fi
	
	echo $(date): Add service to nat-start...
	writenat=$(cat /jffs/scripts/nat-start | grep "nat-start")
	if [ -z "$writenat" ];then
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		sed -i '3a sh /koolshare/ss/redchn/nat-start start_all' /jffs/scripts/nat-start
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
	
	echo $(date): Add service to wan-start...
	startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
	if [ -z "$startss" ];then
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
		sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
	echo $(date): done
	echo $(date):
}

#=======================================================================================

start_sslocal(){
	# start ss-local on port 23456
	echo $(date): Socks5 enable on port 23456 \for DNS2SOCKS..
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_onetime_auth" == "1" ];then
			ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/redchn/ss.json -u -f /var/run/sslocal1.pid
		fi
	fi
	echo $(date): done
	echo $(date):
}

write_cron_job(){
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): ss rule schedual update enabled
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/ss/cru/update.sh"
		echo $(date): done
		echo $(date):
	else
		echo $(date): ss rule schedual update not enabled
		echo $(date): done
		echo $(date):
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep ssupdate`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): kill crontab job
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
		echo $(date): done
		echo $(date): -------------------- Shadowsock service Stopped--------------------------
		echo $(date):
	fi
}


start_dns(){
	# Start dnscrypt-proxy
	if [ "1" == "$ss_redchn_dns_foreign" ];then
		echo $(date): Starting dnscrypt-proxy...
		dnscrypt-proxy --local-address=127.0.0.1:1053 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_redchn_opendns"
		echo $(date): done
		echo $(date):
	fi
	
	# Start ss-tunnel
	[ "$ss_redchn_sstunnel" == "1" ] && gs="208.67.220.220:53"
	[ "$ss_redchn_sstunnel" == "2" ] && gs="8.8.8.8:53"
	[ "$ss_redchn_sstunnel" == "3" ] && gs="8.8.4.4:53"
	[ "$ss_redchn_sstunnel" == "4" ] && gs="$ss_redchn_sstunnel_user"	
	if [ "2" == "$ss_redchn_dns_foreign" ];then
		echo $(date): Starting ss-tunnel...
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1053 -L "$gs" -u -f /var/run/sstunnel.pid
			fi
		fi
		echo $(date): done
		echo $(date):
	fi
	
	# Start chinadns
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
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -f /var/run/sstunnel.pid
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 127.0.0.1 -c /koolshare/ss/redchn/ss.json -l 1055 -L "$rdf" -u -f /var/run/sstunnel.pid
			fi
		fi
		chinadns -p 1053 -s "$rcc",127.0.0.1:1055 -m -d -c /koolshare/ss/redchn/chnroute.txt  >/dev/null 2>&1 &
		echo $(date): done
		echo $(date):
	fi
	
	# Start DNS2SOCKS
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
	
	# Start pdnsd
	if [ "6" == "$ss_redchn_dns_foreign"  ]; then
			echo $(date): Start pdnsd..
			mkdir -p /koolshare/ss/pdnsd
		if [ "$ss_redchn_pdnsd_method" == "1" ];then
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 1053;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=udp_only;
					min_ttl=$ss_redchn_pdnsd_server_cache_min;
					max_ttl=$ss_redchn_pdnsd_server_cache_max;
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
			if [ "$ss_redchn_pdnsd_udp_server" == "1" ];then
				echo $(date): Starting DNS2SOCKS \for pdnsd..
				dns2socks 127.0.0.1:23456 "$ss_redchn_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
				echo $(date): done
				echo $(date):
			elif [ "$ss_redchn_pdnsd_udp_server" == "2" ];then
				echo $(date): Starting dnscrypt-proxy \for pdnsd...
				dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_redchn_pdnsd_udp_server_dnscrypt"
				echo $(date): done
				echo $(date):
			elif [ "$ss_redchn_pdnsd_udp_server" == "3" ];then
				[ "$ss_redchn_pdnsd_udp_server_ss_tunnel" == "1" ] && dns1="208.67.220.220:53"
				[ "$ss_redchn_pdnsd_udp_server_ss_tunnel" == "2" ] && dns1="8.8.8.8:53"
				[ "$ss_redchn_pdnsd_udp_server_ss_tunnel" == "3" ] && dns1="8.8.4.4:53"
				[ "$ss_redchn_pdnsd_udp_server_ss_tunnel" == "4" ] && dns1="$ss_redchn_pdnsd_udp_server_ss_tunnel_user"
				echo $(date): Starting ss-tunnel \for pdnsd...
				if [ "$ss_basic_use_rss" == "1" ];then
					rss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid
				elif  [ "$ss_basic_use_rss" == "0" ];then
					if [ "$ss_basic_onetime_auth" == "1" ];then
						ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1099 -L "$dns1" -u -A -f /var/run/sstunnel.pid
					elif [ "$ss_basic_onetime_auth" == "0" ];then
						ss-tunnel -b 0.0.0.0 -c /koolshare/ss/redchn/ss.json -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid
					fi
				fi
				echo $(date): done
				echo $(date):
			fi
		elif [ "$ss_redchn_pdnsd_method" == "2" ];then
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 1053;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=$ss_redchn_pdnsd_method;
					min_ttl=$ss_redchn_pdnsd_server_cache_min;
					max_ttl=$ss_redchn_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = $ss_redchn_pdnsd_server_ip;
					port = $ss_redchn_pdnsd_server_port;
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
	sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
	rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
	
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): kill dnscrypt-proxy...
		killall dnscrypt-proxy
		echo $(date): done
		echo $(date):
	fi

	# kill ss-tunnel
	if [ ! -z "$sstunnel" ]; then 
		echo $(date): kill ss-tunnel...
		killall ss-tunnel >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
	
	if [ ! -z "$rsstunnel" ]; then 
		echo $(date): kill rss-tunnel...
		killall rss-tunnel >/dev/null 2>&1
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
	rm -rf /jffs/configs/dnsmasq.conf.add
}

#---------------------------------------------------------------------------------------------------------
start_redsocks2(){
	# Start REDSOCKS2
	echo $(date): starting REDSOCKS2...
	redsocks2 -c /koolshare/ss/redchn/redsocks2.conf -p /var/run/redsocks2.pid
	echo $(date): done
	echo $(date):
}


load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 2
	done
	echo $(date): "Apply nat rules!"
	sh /koolshare/ss/redchn/nat-start start_all
}

restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): restarting dnsmasq...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
	echo $(date): done
	echo $(date):
}

remove_status(){
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
}

case $1 in
start_all)
	#ss_basic_action=1 搴旂敤鎵€鏈夎缃?
	echo $(date): ------------------- Shadowsock CHN mode Starting-------------------------
	resolv_server_ip
	creat_ss_json
	creat_redsocks2_conf
	creat_dnsmasq_basic_conf
	user_cdn_site
	custom_dnsmasq
	append_white_black_conf
	ln_conf
	nat_auto_start
	wan_auto_start
	start_sslocal
	write_cron_job
	start_dns
	start_redsocks2
	load_nat
	restart_dnsmasq
	remove_status
	nvram set ss_mode=2
	nvram commit
	echo $(date): -------------------- Shadowsock CHN mode Started-------------------------
	;;
restart_dns)
	#ss_basic_action=2 搴旂敤DNS璁剧疆
	echo $(date): --------------------------- Restart DNS ---------------------------------
	stop_dns
	creat_dnsmasq_basic_conf
	user_cdn_site
	custom_dnsmasq
	ln_conf
	start_dns
	#load_nat
	restart_dnsmasq
	remove_status
	echo $(date): -------------------------- DNS Restarted --------------------------------
	;;
restart_wb_list)
	#ss_basic_action=3 搴旂敤榛戠櫧鍚嶅崟璁剧疆
	echo $(date): --------------------- Restart white_black_list --------------------------
	ipset -F white_domain >/dev/null 2>&1
	ipset -F black_domain >/dev/null 2>&1
	append_white_black_conf
	ln_conf
	sh /koolshare/ss/redchn/nat-start add_new_ip
	restart_dnsmasq
	remove_status
	echo $(date): --------------------- white_black_list applied --------------------------
	;;
restart_addon)
	#ss_basic_action=4 搴旂敤榛戠櫧鍚嶅崟璁剧疆
	echo $(date): ---------------------- Restart chnmode addon  ---------------------------
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo $(date): boot delay time not changing, still "$ss_basic_sleep" seconds
		echo $(date): done
		echo $(date):
	else
		echo $(date): set boot delay to "$ss_basic_sleep" seconds before starting kcptun service
		# delete boot delay in nat-start and wan-start
		sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
		# re add delay in nat-start and wan-start
		nat_auto_start >/dev/null 2>&1
		wan_auto_start >/dev/null 2>&1
		echo $(date): done
		echo $(date):
	fi
	
	# for chromecast surpport
	# also for chromecast
	sh /koolshare/ss/redchn/nat-start start_part_for_addon
	
	# for list update
	kill_cron_job
	write_cron_job
	#remove_status
	remove_status


	echo $(date): ----------------------  chnmode addon applied ---------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_kcptun|restart_wb_list|restart_dns)"
	exit 1
	;;
esac
