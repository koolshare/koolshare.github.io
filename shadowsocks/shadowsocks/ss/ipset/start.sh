#!/bin/sh
#--------------------------------------------------------------------------------------
# Variable definitions
eval `dbus export ss`
source /koolshare/scripts/base.sh
#--------------------------------------------------------------------------------------
resolv_server_ip(){
	IFIP=`echo $ss_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
	if [ -z "$IFIP" ];then
		echo $(date): 检测到你的SS服务器为域名格式，将尝试进行解析...
		if [ "$ss_basic_dnslookup" == "1" ];then
			echo $(date): 使用nslookup方式解析SS服务器的ip地址.
			server_ip=`nslookup "$ss_basic_server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		else
			echo $(date): 使用resolveip方式解析SS服务器的ip地址.
			server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
		fi

		if [ ! -z "$server_ip" ];then
			echo $(date): SS服务器的ip地址解析成功：$server_ip.
			ss_basic_server="$server_ip"
			dbus set ss_basic_server_ip="$server_ip"
			dbus set ss_basic_dns_success="1"
		else
			echo $(date): SS服务器的ip地址解析失败，将由ss-redir自己解析.
			dbus set ss_basic_dns_success="0"
		fi
	else
		echo $(date): 检测到你的SS服务器已经是IP格式，跳过解析... 
	fi
}
# create shadowsocks config file...
creat_ss_json(){
	echo $(date): 创建SS配置文件到/koolshare/ss/ipset/ss.json
	if [ "$ss_basic_use_kcp" == "1" ];then
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > /koolshare/ss/ipset/ss.json <<-EOF
				{
				    "server":"127.0.0.1",
				    "server_port":1091,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "method":"$ss_basic_method"
				}
			EOF
		elif [ "$ss_basic_use_rss" == "1" ];then
			cat > /koolshare/ss/ipset/ss.json <<-EOF
				{
				    "server":"127.0.0.1",
				    "server_port":1091,
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
	else
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > /koolshare/ss/ipset/ss.json <<-EOF
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
			cat > /koolshare/ss/ipset/ss.json <<-EOF
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
	fi
}

creat_dnsmasq_basic_conf(){
	ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	[ "$ss_ipset_cdn_dns" == "1" ] && [ ! -z "$ISP_DNS" ] && dns="$ISP_DNS"
	[ "$ss_ipset_cdn_dns" == "1" ] && [ -z "$ISP_DNS" ] && dns="114.114.114.114"
	[ "$ss_ipset_cdn_dns" == "2" ] && dns="223.5.5.5"
	[ "$ss_ipset_cdn_dns" == "3" ] && dns="223.6.6.6"
	[ "$ss_ipset_cdn_dns" == "4" ] && dns="114.114.114.114"
	[ "$ss_ipset_cdn_dns" == "5" ] && dns="$ss_ipset_cdn_dns_user"
	[ "$ss_ipset_cdn_dns" == "6" ] && dns="180.76.76.76"
	[ "$ss_ipset_cdn_dns" == "7" ] && dns="1.2.4.8"
	[ "$ss_ipset_cdn_dns" == "8" ] && dns="119.29.29.29"

	# make directory if not exist
	mkdir -p /jffs/configs/dnsmasq.d

	# append dnsmasq basic conf
	echo $(date): 创建dnsmasq基础配置到/jffs/configs/dnsmasq.conf.add
	cat > /jffs/configs/dnsmasq.conf.add <<-EOF
		no-resolv
		server=$dns
		EOF

	# append router output chain rules for ss status check
	echo $(date): 创建路由内部走代理的规则，用于SS状态检测.
	cat /koolshare/ss/redchn/output.conf >> /jffs/configs/dnsmasq.conf.add

	# append custom conf dir
	fm_version=`nvram get extendno|sed 's/alpha[0-9]-//g'|sed 's/beta[0-9]-//g'|cut -d "-" -f1|sed 's/X//g'`
	cmp=`versioncmp $fm_version "6.5.1"`
	if [ "$cmp" = "1" ];then
		#from KOOLSHARE firmware version 6.5.1 or below,this line is default in dnsmasq.conf
		echo "conf-dir=/jffs/configs/dnsmasq.d" >> /jffs/configs/dnsmasq.conf.add
	fi

	# create dnsmasq.postconf
	echo $(date): 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
		ln -sf /koolshare/ss/redchn/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		chmod +x /jffs/scripts/dnsmasq.postconf
}

append_gfwlist(){
	# append gfwlist
	if [ ! -f /jffs/configs/dnsmasq.d/gfwlist.conf ];then
		echo $(date): 创建gfwlist的软连接到/jffs/configs/dnsmasq.d/文件夹.
		#cp -rf /koolshare/ss/ipset/gfwlist.conf  /jffs/configs/dnsmasq.d/
		ln -sf /koolshare/ss/ipset/gfwlist.conf /jffs/configs/dnsmasq.d/gfwlist.conf
	fi
}

custom_dnsmasq(){
	# append custom host
	rm -rf /tmp/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	if [ ! -z "$ss_ipset_dnsmasq" ];then
		echo $(date): 添加自定义dnsmasq设置到/jffs/configs/dnsmasq.conf.add
		echo "$ss_ipset_dnsmasq" | sed "s/,/\n/g" | sort -u >> /tmp/custom.conf
	fi
}

append_white_black_conf(){
	rm -rf /jffs/configs/dnsmasq.d/wblist.conf
	rm -rf /tmp/wblist.conf
	# append white domain list
	wanwhitedomain=$(echo $ss_ipset_white_domain_web | sed 's/,/\n/g')
	if [ ! -z $ss_ipset_white_domain_web ];then
		echo $(date): 创建域名白名单到/tmp/wblist.conf
		echo "#for white_domain" >> /tmp/wblist.conf
		for wan_white_domain in $wanwhitedomain
		do
			echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#1053/g" >> /tmp/wblist.conf
			echo "$wan_white_domain" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_domain/g" >> /tmp/wblist.conf
		done
	fi
	
	# append black domain list
	if [ ! -z "$ss_ipset_black_domain_web" ];then
		echo $(date): 创建域名黑名单到/tmp/wblist.conf
		echo "#for_black_domain" >> /tmp/wblist.conf
		echo "$ss_ipset_black_domain_web" | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
		echo "$ss_ipset_black_domain_web" | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/gfwlist/g" >> /tmp/wblist.conf
	fi
}

ln_custom_conf(){
	# ln_custom_conf
	if [ -f /tmp/custom.conf ];then
	echo $(date): 创建自定义dnsmasq配置链接到/jffs/configs/dnsmasq.d/custom.conf
		ln -sf /tmp/custom.conf /jffs/configs/dnsmasq.d/custom.conf
	fi
}

ln_wblist_conf(){
	# ln_wblist_conf
	if [ -f /tmp/wblist.conf ];then
		echo $(date): 创建域名黑/白名单软链接到/jffs/configs/dnsmasq.d/wblist.conf
		ln -sf /tmp/wblist.conf /jffs/configs/dnsmasq.d/wblist.conf
	fi
}

#---------------------------------------------------------------------------------------------------------
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
		echo $(date): 添加nat-start触发事件...用于ss的nat规则重启后或网络恢复后的加载.
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		sed -i '3a sh /koolshare/ss/ipset/nat-start start_all' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
}
#---------------------------------------------------------------------------------------------------------
wan_auto_start(){
	# Add service to auto start
	if [ ! -f /jffs/scripts/wan-start ]; then
		cat > /jffs/scripts/wan-start <<-EOF
		#!/bin/sh
		dbus fire onwanstart
		
		EOF
	fi
	startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/ss_config.sh")
	if [ -z "$startss" ];then
		echo $(date): 添加wan-start触发事件...用于ss的各种程序的开机启动，启动延迟$ss_basic_sleep
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
		sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
}
#=========================================================================================================
write_cron_job(){
	# start setvice
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo $(date): 添加ss规则定时更新任务，每天"$ss_basic_rule_update_time"自动检测更新规则.
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/scripts/ss_rule_update.sh"
	else
		echo $(date): ss规则定时更新任务未启用！
	fi
}

kill_cron_job(){
	jobexist=`cru l|grep ssupdate`
	# kill crontab job
	if [ ! -z "$jobexist" ];then
		echo $(date): 删除ss规则定时更新任务.
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

start_dns(){
	# Start dnscrypt-proxy
	if [ "$ss_ipset_foreign_dns" == "0" ]; then
		echo $(date): 开启 dnscrypt-proxy，你选择了"$ss_redchn_opendns"节点.
		dnscrypt-proxy --local-address=127.0.0.1:7913 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_ipset_opendns"
	fi
	[ "$ss_ipset_tunnel" == "1" ] && it="208.67.220.220:53"
	[ "$ss_ipset_tunnel" == "2" ] && it="8.8.8.8:53"
	[ "$ss_ipset_tunnel" == "3" ] && it="8.8.4.4:53"
	[ "$ss_ipset_tunnel" == "4" ] && it="$ss_ipset_tunnel_user"

	if [ "$ss_ipset_foreign_dns" == "1" ]; then
		if [ "$ss_basic_use_rss" == "1" ];then
			echo $(date): 开启ssr-tunnel...
			rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			echo $(date): 开启ss-tunnel...
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -A -f /var/run/sstunnel.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 7913 -L "$it" -u -f /var/run/sstunnel.pid
			fi
		fi
	fi

	# Start DNS2SOCKS
	if [ "$ss_ipset_foreign_dns" == "2" ]; then
		echo $(date): 开启ss-local，提供socks5端口：23456
		if [ "$ss_basic_use_rss" == "1" ];then
			rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			if [ "$ss_basic_onetime_auth" == "1" ];then
				ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid
			elif [ "$ss_basic_onetime_auth" == "0" ];then
				ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid
			fi
		fi
			echo $(date): 开启dns2socks，监听端口：23456
			dns2socks 127.0.0.1:23456 "$ss_ipset_dns2socks_user" 127.0.0.1:7913 > /dev/null 2>&1 &
	fi

	# Start Pcap_DNSProxy
	if [ "$ss_ipset_foreign_dns" == "3" ]; then
		echo $(date): 开启Pcap_DNSProxy..
		sed -i '/^Listen Port/c Listen Port = 7913' /koolshare/ss/dns/Config.conf
		sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
		/koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
	fi

# Start pdnsd
	if [ "$ss_ipset_foreign_dns" == "4" ]; then
		echo $(date): 开启 pdnsd，pdnsd进程可能会不稳定，请自己斟酌.
		echo $(date): 创建/koolshare/ss/pdnsd文件夹.
		mkdir -p /koolshare/ss/pdnsd
		if [ "$ss_ipset_pdnsd_method" == "1" ];then
			echo $(date): 创建pdnsd配置文件到/koolshare/ss/pdnsd/pdnsd.conf
			echo $(date): 你选择了-仅udp查询-，需要开启上游dns服务，以防止dns污染.
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 7913;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=udp_only;
					min_ttl=$ss_ipset_pdnsd_server_cache_min;
					max_ttl=$ss_ipset_pdnsd_server_cache_max;
					timeout=10;
				}

				server {
					label= "koolshare"; 
					ip = 127.0.0.1;
					port = 1099;
					root_server = on;   
					uptest = none;    
				}
			EOF
			if [ "$ss_ipset_pdnsd_udp_server" == "1" ];then
				echo $(date): 开启dns2socks作为pdnsd的上游服务器.
				if [ "$ss_basic_use_rss" == "1" ];then
					rss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid >/dev/null 2>&1
				elif  [ "$ss_basic_use_rss" == "0" ];then
					if [ "$ss_basic_onetime_auth" == "1" ];then
						ss-local -b 0.0.0.0 -l 23456 -A -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid > /dev/null 2>&1 &
					elif [ "$ss_basic_onetime_auth" == "0" ];then
						ss-local -b 0.0.0.0 -l 23456 -c /koolshare/ss/ipset/ss.json -u -f /var/run/sslocal1.pid > /dev/null 2>&1 &
					fi
				fi
				dns2socks 127.0.0.1:23456 "$ss_ipset_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
			elif [ "$ss_ipset_pdnsd_udp_server" == "2" ];then
				echo $(date): 开启dnscrypt-proxy作为pdnsd的上游服务器.
				dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L /koolshare/ss/dnscrypt-resolvers.csv -R "$ss_ipset_pdnsd_udp_server_dnscrypt"
			elif [ "$ss_ipset_pdnsd_udp_server" == "3" ];then
				[ "$ss_ipset_pdnsd_udp_server_ss_tunnel" == "1" ] && dns1="208.67.220.220:53"
				[ "$ss_ipset_pdnsd_udp_server_ss_tunnel" == "2" ] && dns1="8.8.8.8:53"
				[ "$ss_ipset_pdnsd_udp_server_ss_tunnel" == "3" ] && dns1="8.8.4.4:53"
				[ "$ss_ipset_pdnsd_udp_server_ss_tunnel" == "4" ] && dns1="$ss_ipset_pdnsd_udp_server_ss_tunnel_user"
				if [ "$ss_basic_use_rss" == "1" ];then
					echo $(date): 开启ssr-tunnel作为pdnsd的上游服务器.
					rss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid > /dev/null 2>&1 &
				elif  [ "$ss_basic_use_rss" == "0" ];then
					echo $(date): 开启ss-tunnel作为pdnsd的上游服务器.
					if [ "$ss_basic_onetime_auth" == "1" ];then
						ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 1099 -L "$dns1" -u -A -f /var/run/sstunnel.pid > /dev/null 2>&1 &
					elif [ "$ss_basic_onetime_auth" == "0" ];then
						ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -c /koolshare/ss/ipset/ss.json -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid > /dev/null 2>&1 &
					fi
				fi
				sleep 1
			fi
		elif [ "$ss_ipset_pdnsd_method" == "2" ];then
			echo $(date): 创建pdnsd配置文件到/koolshare/ss/pdnsd/pdnsd.conf
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
			echo $(date): 你选择了-仅tcp查询-，使用"$ss_redchn_pdnsd_server_ip":"$ss_redchn_pdnsd_server_port"进行tcp查询.
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = 7913;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=tcp_only;
					min_ttl=$ss_ipset_pdnsd_server_cache_min;
					max_ttl=$ss_ipset_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = $ss_ipset_pdnsd_server_ip;
					port = $ss_ipset_pdnsd_server_port;
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
			echo $(date): 创建pdnsd缓存文件.
			dd if=/dev/zero of=/koolshare/ss/pdnsd/pdnsd.cache bs=1 count=4 >/dev/null 2>&1
			chown -R $USER.$GROUP $CACHEDIR
		fi
		echo $(date): 启动pdnsd进程...
		pdnsd --daemon -c /koolshare/ss/pdnsd/pdnsd.conf -p /var/run/pdnsd.pid >/dev/null 2>&1
	fi
}

stop_dns(){
	dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
	pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
	DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
	Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
	sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
	rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
	
	# kill dnscrypt-proxy
	if [ ! -z "$dnscrypt" ]; then 
		echo $(date): 关闭dnscrypt-proxy进程...
		killall dnscrypt-proxy
	fi

	# kill ss-tunnel
	if [ ! -z "$sstunnel" ]; then 
		echo $(date): 关闭ss-tunnel进程...
		killall ss-tunnel >/dev/null 2>&1
	fi
	
	if [ ! -z "$rsstunnel" ]; then 
		echo $(date): 关闭rss-tunnel进程...
		killall rss-tunnel >/dev/null 2>&1
	fi

	# kill pdnsd
	if [ ! -z "$pdnsd" ]; then 
		echo $(date): 关闭pdnsd进程...
		echo $(date): kill pdnsd...
		killall pdnsd
	fi
	
	# kill Pcap_DNSProxy
	if [ ! -z "$Pcap_DNSProxy" ]; then 
		echo $(date): 关闭Pcap_DNSProxy进程...
		killall dns.sh >/dev/null 2>&1
		killall Pcap_DNSProxy >/dev/null 2>&1
	fi
	
	# kill dns2socks
	if [ ! -z "$DNS2SOCK" ]; then 
		echo $(date): 关闭dns2socks进程...
		killall dns2socks
	fi
}

delete_conf_files(){
	rm -rf /tmp/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/configs/dnsmasq.conf.add
}

start_kcp(){
	if [ "$ss_basic_use_kcp" == "1" ];then
		echo $(date): 启动KCP协议进程，为了更好的体验，建议在路由器上创建虚拟内存.
		export GOGC=40
		start-stop-daemon -S -q -b -m -p /tmp/var/kcp.pid -x /koolshare/bin/client_linux_arm5 -- -l 127.0.0.1:1091 -r $ss_basic_server:$ss_basic_kcp_port $ss_basic_kcp_parameter
	fi
}

start_ss_redir(){
	# Start ss-redir
	if [ "$ss_basic_use_rss" == "1" ];then
		echo $(date): 开启ssr-redir进程，用于透明代理.
		rss-redir -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		echo $(date): 开启ss-redir进程，用于透明代理.
		if [ "$ss_basic_onetime_auth" == "1" ];then
			echo $(date): 你开启了ss-redir的一次性验证，请确保你的ss服务器是否支持.
			ss-redir -b 0.0.0.0 -A -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid
		elif [ "$ss_basic_onetime_auth" == "0" ];then
			ss-redir -b 0.0.0.0 -c /koolshare/ss/ipset/ss.json -f /var/run/shadowsocks.pid
		fi
	fi
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "错误：不能正确加载nat规则!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 2
	done
	echo $(date): "加载nat规则!"
	sh /koolshare/ss/ipset/nat-start start_all
}


restart_dnsmasq(){
	# Restart dnsmasq
	echo $(date): 重启dnsmasq服务...
	/sbin/service restart_dnsmasq >/dev/null 2>&1
}

remove_status(){
	nvram set ss_foreign_state=""
	nvram set ss_china_state=""
}

main_portal(){
	if [ "$ss_main_portal" == "1" ];then
		nvram set enable_ss=1
		nvram commit
	else
		nvram set enable_ss=0
		nvram commit
	fi
}
	
case $1 in
start_all)
	#ss_basic_action=1 应用所有设置
	echo $(date): ------------------- 梅林固件 shadowsocks gfwlist模式 ----------------------
	resolv_server_ip
	creat_ss_json
	creat_dnsmasq_basic_conf
	append_gfwlist
	custom_dnsmasq
	append_white_black_conf
	ln_custom_conf
	ln_wblist_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	start_dns
	start_ss_redir
	start_kcp
	load_nat
	restart_dnsmasq
	remove_status
	nvram set ss_mode=1
	nvram commit
	echo $(date): --------------------- shadowsocks gfwlist模式启动完毕 ---------------------
	;;
restart_dns)
	#ss_basic_action=2 应用DNS设置
	echo $(date): ------------------------ gflist模式-重启dns服务 ---------------------------
	resolv_server_ip
	stop_dns
	rm -rf /tmp/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	creat_dnsmasq_basic_conf
	custom_dnsmasq
	ln_custom_conf
	start_dns
	restart_dnsmasq
	remove_status
	echo $(date): ----------------------- gflist模式-dns服务重启完毕 -------------------------
	;;
restart_wb_list)
	#ss_basic_action=3 应用黑白名单设置
	echo $(date): ----------------------- gflist模式-重启黑白名单服务 -------------------------
	ipset -F white_domain >/dev/null 2>&1
	ipset -F black_domain >/dev/null 2>&1
	append_white_black_conf
	ln_wblist_conf
	sh /koolshare/ss/ipset/nat-start add_black_wan_ip
	restart_dnsmasq
	remove_status
	echo $(date): ----------------------- gflist模式-重启黑白名单服务 -------------------------
	;;
restart_addon)
	#ss_basic_action=4 应用黑白名单设置
	echo $(date): --------------------=--- gflist模式-重启附加功能 -----=---------------------
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo $(date): boot delay time not changing, still "$ss_basic_sleep" seconds
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
	fi
	
	# for chromecast surpport
	# also for chromecast
	sh /koolshare/ss/ipset/nat-start start_part_for_addon
	
	# for list update
	kill_cron_job
	write_cron_job
	#remove_status
	remove_status
	main_portal
	
	if [ "$ss_basic_dnslookup" == "1" ];then
		echo $(date): 设置使用nslookup方式解析SS服务器的ip地址.
	else
		echo $(date): 设置使用resolveip方式解析SS服务器的ip地址.
	fi
	
	echo $(date): --------------------- gflist模式-附加功能重启完毕！ -------------------------
	;;
*)
	echo "Usage: $0 (start_all|restart_dns|restart_wb_list|restart_addon)"
	exit 1
	;;
esac
