#!/bin/sh
eval `dbus export ss`
source /koolshare/scripts/base.sh
source helper.sh
# Variable definitions
ss_basic_version_local=`cat /koolshare/ss/version`
dbus set ss_basic_version_local=$ss_basic_version_local
main_url="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowsocks"
backup_url="http://koolshare.ngrok.wang:5000/shadowsocks"
CONFIG_FILE=/koolshare/ss/ss.json
DNS_PORT=7913
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
ISP_DNS=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
lan_ipaddr=$(nvram get lan_ipaddr)
game_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 3`
[ -n "$game_on" ] || [ "$ss_basic_mode" == "3" ] || [ "$ss_basic_mode" == "4" ] && mangle=1
ip_prefix_hex=`nvram get lan_ipaddr | awk -F "." '{printf ("0x%02x", $1)} {printf ("%02x", $2)} {printf ("%02x", $3)} {printf ("00/0xffffff00\n")}'`
ss_basic_password=`echo $ss_basic_password|base64_decode`
IFIP=`echo $ss_basic_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`

# creat dnsmasq.d folder
creat_folder(){
	if [ ! -d /koolshare/configs/dnsmasq.d ];then
		mkdir /koolshare/configs/dnsmasq.d
	fi
}

install_ss(){
	echo_date 开始解压压缩包...
	tar -zxf shadowsocks.tar.gz
	chmod a+x /tmp/shadowsocks/install.sh
	echo_date 开始安装更新文件...
	sh /tmp/shadowsocks/install.sh
}

update_ss(){
	echo_date 更新过程中请不要做奇怪的事，不然可能导致问题！
	
	echo_date 开启SS检查更新：使用主服务器：$main_url...
	echo_date 检测主服务器在线版本号...
	ss_basic_version_web1=`curl --connect-timeout 5 -s "$main_url"/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web1 ];then
		echo_date 检测到主服务器在线版本号：$ss_basic_version_web1
		dbus set ss_basic_version_web=$ss_basic_version_web1
		if [ "$ss_basic_version_local" != "$ss_basic_version_web1" ];then
		echo_date 主服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 不同！
			cd /tmp
			md5_web1=`curl -s "$main_url"/version | sed -n 2p`
			echo_date 开启下载进程，从主服务器上下载更新包...
			wget --no-check-certificate --timeout=5 "$main_url"/shadowsocks.tar.gz
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				echo_date 更新包md5校验不一致！估计是下载的时候出了什么状况，请等待一会儿再试...
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 1
				echo_date 更换备用备用更新地址，请稍后...
				sleep 1
				update_ss2
			else
				echo_date 更新包md5校验一致！ 开始安装！...
				install_ss
			fi
		else
			echo_date 主服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 相同！
			sleep 1
			echo_date 那还更新个毛啊，关闭更新进程!
			exit
		fi
	else
		echo_date 没有检测到主服务器在线版本号,访问github服务器有点问题哦~
		sleep 2
		echo_date 更换备用备用更新地址，请稍后...
		sleep 1
		update_ss2
	fi
}

update_ss2(){
	echo_date 开启SS检查更新：使用备用服务器：$backup_url...
	echo_date 检测备用服务器在线版本号...
	ss_basic_version_web2=`curl --connect-timeout 5 -s "$backup_url"/version | sed -n 1p`
	if [ ! -z $ss_basic_version_web2 ];then
	echo_date 检测到备用服务器在线版本号：$ss_basic_version_web1
		dbus set ss_basic_version_web=$ss_basic_version_web2
		if [ "$ss_basic_version_local" != "$ss_basic_version_web2" ];then
		echo_date 备用服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 不同！
			cd /tmp
			md5_web2=`curl -s "$backup_url"/version | sed -n 2p`
			echo_date 开启下载进程，从备用服务器上下载更新包...
			wget "$backup_url"/shadowsocks.tar.gz
			md5sum_gz=`md5sum /tmp/shadowsocks.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web2" ]; then
				echo_date 更新包md5校验不一致！估计是下载的时候除了什么状况，请等待一会儿再试...
				rm -rf /tmp/shadowsocks* >/dev/null 2>&1
				sleep 2
				echo_date 然而只有这一台备用更更新服务器，请尝试离线手动安装...
				exit
			else
				echo_date 更新包md5校验一致！ 开始安装！...
				install_ss
			fi
		else
			echo_date 备用服务器在线版本号："$ss_basic_version_web1" 和本地版本号："$ss_basic_version_local" 相同！
			sleep 2
			echo_date 那还更新个毛啊，关闭更新进程!
			exit 0
		fi
	else
		echo_date 没有检测到备用服务器在线版本号,访问备用服务器有点问题哦，你网络很差欸~
		sleep 2
		echo_date 然而只有这一台备用更更新服务器，请尝试离线手动安装...
		exit
	fi
}
# ================================= ss stop ===============================
restore_conf(){
	# restore dnsmasq conf file
	if [ -f /jffs/configs/dnsmasq.conf.add ]; then
		echo_date 恢复dnsmasq配置文件.
		rm -f /jffs/configs/dnsmasq.conf.add
	fi
	#--------------------------------------------------------------------------
	# delete dnsmasq postconf file
	if [ -f /jffs/scripts/dnsmasq.postconf ]; then
		echo_date 删除/jffs/scripts/dnsmasq.postconf
		rm -f /jffs/scripts/dnsmasq.postconf
	fi
	#--------------------------------------------------------------------------
	# delete custom.conf
	if [ -f /jffs/configs/dnsmasq.d/custom.conf ];then
		echo_date 删除 /jffs/configs/dnsmasq.d/custom.conf
		rm -rf /jffs/configs/dnsmasq.d/custom.conf
	fi	
}

restore_start_file(){
	echo_date 清除nat-start, wan-start中相关的SS启动命令...
	# restore nat-start file if any
	sed -i '/nat-start/d' /jffs/scripts/nat-start >/dev/null 2>&1
	sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
	sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1	
	sed -i '/ssconfig/d' /jffs/scripts/wan-start >/dev/null 2>&1
	sed -i '/ssconfig/d' /jffs/scripts/nat-start >/dev/null 2>&1
}

kill_process(){
	#--------------------------------------------------------------------------
	# kill dnscrypt-proxy
	dnscrypt=$(ps | grep "dnscrypt-proxy" | grep -v "grep")
	if [ ! -z "$dnscrypt" ]; then 
		echo_date 关闭dnscrypt-proxy进程...
		killall dnscrypt-proxy
	fi
	#--------------------------------------------------------------------------
	# kill redsocks2
	redsocks2=$(ps | grep "redsocks2" | grep -v "grep")
	if [ ! -z "$redsocks2" ]; then 
		echo_date 关闭redsocks2进程...
		killall redsocks2
	fi
	#--------------------------------------------------------------------------
	# kill ss-redir
	ssredir=$(ps | grep "ss-redir" | grep -v "grep" | grep -vw "rss-redir")
	if [ ! -z "$ssredir" ];then 
		echo_date 关闭ss-redir进程...
		killall ss-redir
	fi

	rssredir=$(ps | grep "rss-redir" | grep -v "grep" | grep -vw "ss-redir")
	if [ ! -z "$rssredir" ];then 
		echo_date 关闭ssr-redir进程...
		killall rss-redir
	fi
	#--------------------------------------------------------------------------
	# kill ss-local
	sslocal=`ps | grep -w ss-local | grep -v "grep" | grep -w "23456" | awk '{print $1}'`
	if [ ! -z "$sslocal" ];then 
		echo_date 关闭ss-local进程:23456端口...
		kill $sslocal  >/dev/null 2>&1
	fi

	ssrlocal=`ps | grep -w rss-local | grep -v "grep" | grep -w "23456" | awk '{print $1}'`
	if [ ! -z "$ssrlocal" ];then 
		echo_date 关闭ssr-local进程:23456端口...
		kill $ssrlocal  >/dev/null 2>&1
	fi

	#--------------------------------------------------------------------------
	# kill ss-tunnel
	sstunnel=$(ps | grep "ss-tunnel" | grep -v "grep" | grep -vw "rss-tunnel")
	if [ ! -z "$sstunnel" ];then 
		echo_date 关闭ss-tunnel进程...
		killall ss-tunnel
	fi
	
	rsstunnel=$(ps | grep "rss-tunnel" | grep -v "grep" | grep -vw "ss-tunnel")
	if [ ! -z "$rsstunnel" ];then 
		echo_date 关闭rss-tunnel进程...
		killall rss-tunnel
	fi
	
	#--------------------------------------------------------------------------
	# kill pdnsd
	pdnsd=$(ps | grep "pdnsd" | grep -v "grep")
	if [ ! -z "$pdnsd" ];then 
	echo_date 关闭pdnsd进程...
	killall pdnsd
	fi
	#--------------------------------------------------------------------------
	# kill Pcap_DNSProxy
	Pcap_DNSProxy=$(ps | grep "Pcap_DNSProxy" | grep -v "grep")
	if [ ! -z "$Pcap_DNSProxy" ];then 
		echo_date 关闭Pcap_DNSProxy进程...
		pid1=`ps|grep /koolshare/ss/dns/dns.sh | grep -v grep | awk '{print $1}'`
		kill -9 $pid1 >/dev/null 2>&1
		killall Pcap_DNSProxy >/dev/null 2>&1
	fi
	#--------------------------------------------------------------------------
	# kill chinadns
	chinadns=$(ps | grep "chinadns" | grep -v "grep")
	if [ ! -z "$chinadns" ];then 
		echo_date 关闭chinadns进程...
		killall chinadns
	fi
	#--------------------------------------------------------------------------
	# kill dns2socks
	DNS2SOCK=$(ps | grep "dns2socks" | grep -v "grep")
	if [ ! -z "$DNS2SOCK" ];then 
		echo_date 关闭dns2socks进程...
		killall dns2socks
	fi
	
	# kill all koolgame
	koolgame=$(ps | grep "koolgame" | grep -v "grep"|grep -v "pdu")
	if [ ! -z "$koolgame" ];then 
		echo_date 关闭koolgame进程...
		killall koolgame >/dev/null 2>&1
	fi
	
	# kill kcp
	client_linux_arm5=$(ps | grep "client_linux_arm5" | grep -v "grep")
	if [ ! -z "$client_linux_arm5" ];then 
		echo_date 关闭kcp协议进程...
		killall client_linux_arm5 >/dev/null 2>&1
	fi
	
	# kill load balance
	haproxy=$(ps | grep "haproxy" | grep -v "grep")
	if [ ! -z "$haproxy" ];then 
		echo_date 关闭haproxy进程...
		killall haproxy >/dev/null 2>&1
	fi
		
	# kill simple obfs
	obfsLocal=$(ps | grep "obfs-local" | grep -v "grep")
    [ -n "$obfsLocal" ] && echo_date 关闭obfs-local进程... && killall obfs-local >/dev/null 2>&1
    # incase obfs enabled in socks5 page
    [ "$ss_local_obfs" != "0" ] && sh /koolshare/ss/socks5/socks5config.sh restart >/dev/null 2>&1
}

remove_conf_and_settings(){
	echo_date 删除ss相关的名单配置文件.
	# remove conf under /jffs/configs/dnsmasq.d
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	rm -rf /jffs/configs/dnsmasq.d/cdn.conf
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	rm -rf /jffs/configs/dnsmasq.d/wblist.conf
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/wblist.conf
	rm -rf /jffs/configs/dnsmasq.conf.add

	# remove ss state
	dbus remove ss_basic_state_china
	dbus remove ss_basic_state_foreign
}
# ================================= ss prestart ===========================
ss_pre_start(){
	lb_enable=`dbus get ss_lb_enable`
	if [ "$lb_enable" == "1" ];then
		if [ `dbus get ss_basic_server | grep -o "127.0.0.1"` ] && [ `dbus get ss_basic_port` == `dbus get ss_lb_port` ];then
		echo_date ss启动前触发:触发启动负载均衡功能！
			#start haproxy
			sh /koolshare/scripts/ss_lb_config.sh
			#start kcptun
			lb_node=`dbus list ssconf_basic_use_lb_|sed 's/ssconf_basic_use_lb_//g' |cut -d "=" -f 1 | sort -n`
			for node in $lb_node
			do	
				name=`dbus get ssconf_basic_name_$node`
				kcp=`dbus get ssconf_basic_use_kcp_$node`
				kcp_server=`dbus get ssconf_basic_server_$node`
				# marked for change in future 
				server_ip=`nslookup "$kcp_server" 119.29.29.29 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
				kcp_port=`dbus get ss_basic_kcp_port`
				kcp_para=`dbus get ss_basic_kcp_parameter`
				if [ "$kcp" == "1" ];then
					export GOGC=40
					start-stop-daemon -S -q -b -m -p /tmp/var/kcp.pid -x /koolshare/bin/client_linux_arm5 -- -l 127.0.0.1:1091 -r $server_ip:$kcp_port $kcp_para
				fi
			done
		else
			echo_date ss启动前触发:未选择负载均衡节点，不触发负载均衡启动！
		fi
	else
		if [ `dbus get ss_basic_server | grep -o "127.0.0.1"` ] && [ `dbus get ss_basic_port` == `dbus get ss_lb_port` ];then
			echo_date ss启动前触发【警告】：你选择了负载均衡节点，但是负载均衡开关未启用！！
		else
			echo_date ss启动前触发：你选择了普通节点，不触发负载均衡启动！.
		fi
	fi
}
# ================================= ss start ==============================

[ "$ss_dns_china" == "1" ] && [ ! -z "$ISP_DNS" ] && CDN="$ISP_DNS"
[ "$ss_dns_china" == "1" ] && [ -z "$ISP_DNS" ] && CDN="114.114.114.114"
[ "$ss_dns_china" == "2" ] && CDN="223.5.5.5"
[ "$ss_dns_china" == "3" ] && CDN="223.6.6.6"
[ "$ss_dns_china" == "4" ] && CDN="114.114.114.114"
[ "$ss_dns_china" == "5" ] && CDN="114.114.115.115"
[ "$ss_dns_china" == "6" ] && CDN="1.2.4.8"
[ "$ss_dns_china" == "7" ] && CDN="210.2.4.8"
[ "$ss_dns_china" == "8" ] && CDN="112.124.47.27"
[ "$ss_dns_china" == "9" ] && CDN="114.215.126.16"
[ "$ss_dns_china" == "10" ] && CDN="180.76.76.76"
[ "$ss_dns_china" == "11" ] && CDN="119.29.29.29"
[ "$ss_dns_china" == "12" ] && CDN="$ss_dns_china_user"

# try to resolv the ss server ip if it is domain...
resolv_server_ip(){
	if [ -z "$IFIP" ];then
		echo_date 使用nslookup方式解析SS服务器的ip地址,解析dns：$ss_basic_dnslookup_server
		if [ "$ss_basic_dnslookup" == "1" ];then
			server_ip=`nslookup "$ss_basic_server" $ss_basic_dnslookup_server | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
			if [ "$?" == "0" ]; then
				echo_date SS服务器的ip地址解析成功：$server_ip.
			else
				echo_date SS服务器域名解析失败！
				echo_date 尝试用resolveip方式解析...
				server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
				if [ "$?" == "0" ]; then
			    	echo_date SS服务器的ip地址解析成功：$server_ip.
				else
					echo_date 使用resolveip方式SS服务器域名解析失败！请更换nslookup解析方式的DNS地址后重试！
				fi
			fi
		else
			echo_date 使用resolveip方式解析SS服务器的ip地址.
			server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
		fi

		if [ ! -z "$server_ip" ];then
			ss_basic_server="$server_ip"
			dbus set ss_basic_server_ip="$server_ip"
			dbus set ss_basic_dns_success="1"
		else
			dbus remvoe ss_basic_server_ip
			echo_date SS服务器的ip地址解析失败，将由ss-redir自己解析.
			dbus set ss_basic_dns_success="0"
		fi
	else
		dbus set ss_basic_server_ip=$ss_basic_server
		echo_date 检测到你的SS服务器已经是IP格式：$ss_basic_server,跳过解析... 
		dbus set ss_basic_dns_success="1"
	fi
}
# create shadowsocks config file...
creat_ss_json(){
	if [ "$ss_basic_ss_obfs_host" != "" ];then
		if [ "$ss_basic_ss_obfs" == "http" ];then
			ARG_OBFS="obfs=http;obfs-host=$ss_basic_ss_obfs_host"
		elif [ "$ss_basic_ss_obfs" == "tls" ];then
			ARG_OBFS="obfs=tls;obfs-host=$ss_basic_ss_obfs_host"
		else
			ARG_OBFS=""
		fi
	else
		if [ "$ss_basic_ss_obfs" == "http" ];then
			ARG_OBFS="obfs=http"
		elif [ "$ss_basic_ss_obfs" == "tls" ];then
			ARG_OBFS="obfs=tls"
		else
			ARG_OBFS=""
		fi
	fi
	echo_date 创建SS配置文件到$CONFIG_FILE
	if [ "$ss_basic_use_kcp" == "1" ];then
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > $CONFIG_FILE <<-EOF
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
			cat > $CONFIG_FILE <<-EOF
				{
				    "server":"127.0.0.1",
				    "server_port":1091,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "protocol":"$ss_basic_rss_protocol",
				    "protocol_param":"$ss_basic_rss_protocol_param",
				    "obfs":"$ss_basic_rss_obfs",
				    "obfs_param":"$ss_basic_rss_obfs_param",
				    "method":"$ss_basic_method"
				}
			EOF
		fi
	else
		if [ "$ss_basic_use_rss" == "0" ];then
			cat > $CONFIG_FILE <<-EOF
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
			cat > $CONFIG_FILE <<-EOF
				{
				    "server":"$ss_basic_server",
				    "server_port":$ss_basic_port,
				    "local_port":3333,
				    "password":"$ss_basic_password",
				    "timeout":600,
				    "protocol":"$ss_basic_rss_protocol",
				    "protocol_param":"$ss_basic_rss_protocol_param",
				    "obfs":"$ss_basic_rss_obfs",
				    "obfs_param":"$ss_basic_rss_obfs_param",
				    "method":"$ss_basic_method"
				}
			EOF
		fi
	fi
}

creat_game2_json(){
# create shadowsocks config file...
	echo_date 创建SS配置文件到/koolshare/ss/koolgame/ss.json
	cat > /koolshare/ss/koolgame/ss.json <<-EOF
		{
		    "server":"$ss_basic_server",
		    "server_port":$ss_basic_port,
		    "local_port":3333,
		    "sock5_port":23456,
		    "dns2ss":7913,
		    "adblock_addr":"",
		    "adblock_path":"/koolshare/ss/koolgame/xwhycadblock.txt",
		    "dns_server":"$ss_dns2ss_user",
		    "password":"$ss_basic_password",
		    "timeout":600,
		    "method":"$ss_basic_method",
		    "use_tcp":$ss_basic_koolgame_udp
		}
	EOF
}

start_sslocal(){
	if [ "$ss_basic_use_rss" == "1" ];then
		rss-local -b 0.0.0.0 -l 23456 -c $CONFIG_FILE -u -f /var/run/sslocal1.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		if [ "$ss_basic_ss_obfs" == "0" ];then
			ss-local -b 0.0.0.0 -l 23456 -c $CONFIG_FILE -u -f /var/run/sslocal1.pid >/dev/null 2>&1
		else
			ss-local -b 0.0.0.0 -l 23456 -c $CONFIG_FILE -u --plugin obfs-local --plugin-opts "$ARG_OBFS" -f /var/run/sslocal1.pid >/dev/null 2>&1
		fi
	fi
}

start_dns(){
	# start ss-local on port 23456
	echo_date 开启ss-local，提供socks5代理端口：23456
	start_sslocal
	# Start DNS2SOCKS
	if [ "1" == "$ss_dns_foreign" ] || [ -z "$ss_dns_foreign" ]; then
		echo_date 开启dns2socks，监听端口：23456
		dns2socks 127.0.0.1:23456 "$ss_dns2socks_user" 127.0.0.1:$DNS_PORT > /dev/null 2>&1 &
	fi

	# Start ss-tunnel
	[ "$ss_sstunnel" == "1" ] && gs="208.67.220.220:53"
	[ "$ss_sstunnel" == "2" ] && gs="8.8.8.8:53"
	[ "$ss_sstunnel" == "3" ] && gs="8.8.4.4:53"
	[ "$ss_sstunnel" == "4" ] && gs="$ss_sstunnel_user"	
	if [ "2" == "$ss_dns_foreign" ];then
		if [ "$ss_basic_use_rss" == "1" ];then
			echo_date 开启ssr-tunnel...
			rss-tunnel -b 0.0.0.0 -c /koolshare/ss/ss.json -l $DNS_PORT -L "$gs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
		elif  [ "$ss_basic_use_rss" == "0" ];then
			echo_date 开启ss-tunnel...
			if [ "$ss_basic_ss_obfs" == "0" ];then
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l $DNS_PORT -L "$gs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
			else
				ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l $DNS_PORT -L "$gs" -u --plugin obfs-local --plugin-opts "$ARG_OBFS" -f /var/run/sstunnel.pid >/dev/null 2>&1
			fi
		fi
	fi

	# Start dnscrypt-proxy
	if [ "3" == "$ss_dns_foreign" ];then
		echo_date 开启 dnscrypt-proxy，你选择了"$ss_opendns"节点.
		dnscrypt-proxy --local-address=127.0.0.1:$DNS_PORT --daemonize -L /koolshare/ss/rules/dnscrypt-resolvers.csv -R $ss_opendns >/dev/null 2>&1
	fi

	
	# Start pdnsd
	if [ "4" == "$ss_dns_foreign"  ]; then
		echo_date 开启 pdnsd，pdnsd进程可能会不稳定，请自己斟酌.
		echo_date 创建/koolshare/ss/pdnsd文件夹.
		mkdir -p /koolshare/ss/pdnsd
		if [ "$ss_pdnsd_method" == "1" ];then
			echo_date 创建pdnsd配置文件到/koolshare/ss/pdnsd/pdnsd.conf
			echo_date 你选择了-仅udp查询-，需要开启上游dns服务，以防止dns污染.
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = $DNS_PORT;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=udp_only;
					min_ttl=$ss_pdnsd_server_cache_min;
					max_ttl=$ss_pdnsd_server_cache_max;
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
			if [ "$ss_pdnsd_udp_server" == "1" ];then
				echo_date 开启dns2socks作为pdnsd的上游服务器.
				#echo_date 开启ss-local,为dns2socks提供socks5端口：23456
				#start_sslocal
				dns2socks 127.0.0.1:23456 "$ss_pdnsd_udp_server_dns2socks" 127.0.0.1:1099 > /dev/null 2>&1 &
			elif [ "$ss_pdnsd_udp_server" == "2" ];then
				echo_date 开启dnscrypt-proxy作为pdnsd的上游服务器.
				dnscrypt-proxy --local-address=127.0.0.1:1099 --daemonize -L /koolshare/ss/rules/dnscrypt-resolvers.csv -R "$ss_pdnsd_udp_server_dnscrypt"
			elif [ "$ss_pdnsd_udp_server" == "3" ];then
				[ "$ss_pdnsd_udp_server_ss_tunnel" == "1" ] && dns1="208.67.220.220:53"
				[ "$ss_pdnsd_udp_server_ss_tunnel" == "2" ] && dns1="8.8.8.8:53"
				[ "$ss_pdnsd_udp_server_ss_tunnel" == "3" ] && dns1="8.8.4.4:53"
				[ "$ss_pdnsd_udp_server_ss_tunnel" == "4" ] && dns1="$ss_pdnsd_udp_server_ss_tunnel_user"
				if [ "$ss_basic_use_rss" == "1" ];then
					echo_date 开启ssr-tunnel作为pdnsd的上游服务器.
					rss-tunnel -b 0.0.0.0 -c /koolshare/ss/ss.json -l 1099 -L "$dns1" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
				elif  [ "$ss_basic_use_rss" == "0" ];then
					echo_date 开启ss-tunnel作为pdnsd的上游服务器.
					if [ "$ss_basic_ss_obfs" == "0" ];then
						ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l $DNS_PORT -L "$dns1" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
					else
						ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l $DNS_PORT -L "$dns1" -u --plugin obfs-local --plugin-opts "$ARG_OBFS" -f /var/run/sstunnel.pid >/dev/null 2>&1
					fi
				fi
			fi
		elif [ "$ss_pdnsd_method" == "2" ];then
			echo_date 创建pdnsd配置文件到/koolshare/ss/pdnsd/pdnsd.conf
			echo_date 你选择了-仅tcp查询-，使用"$ss_pdnsd_server_ip":"$ss_pdnsd_server_port"进行tcp查询.
			cat > /koolshare/ss/pdnsd/pdnsd.conf <<-EOF
				global {
					perm_cache=2048;
					cache_dir="/koolshare/ss/pdnsd/";
					run_as="nobody";
					server_port = $DNS_PORT;
					server_ip = 127.0.0.1;
					status_ctl = on;
					query_method=tcp_only;
					min_ttl=$ss_pdnsd_server_cache_min;
					max_ttl=$ss_pdnsd_server_cache_max;
					timeout=10;
				}
				
				server {
					label= "RT-AC68U"; 
					ip = $ss_pdnsd_server_ip;
					port = $ss_pdnsd_server_port;
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
			echo_date 创建pdnsd缓存文件.
			#dd if=/dev/zero of=/koolshare/ss/pdnsd/pdnsd.cache bs=1 count=4 2> /dev/null
			touch /koolshare/ss/pdnsd/pdnsd.cache
			chown -R $USER.$GROUP $CACHEDIR 2> /dev/null
		fi

		echo_date 启动pdnsd进程...
		#pdnsd --daemon -c /koolshare/ss/pdnsd/pdnsd.conf -p /var/run/pdnsd.pid
		pdnsd -c /koolshare/ss/pdnsd/pdnsd.conf -p /var/run/pdnsd.pid >/dev/null 2>&1 &
	fi

	# Start chinadns
	if [ "5" == "$ss_dns_foreign" ];then
		echo_date ┏你选择了chinaDNS作为解析方案！
		[ "$ss_chinadns_china" == "1" ] && rcc="223.5.5.5"
		[ "$ss_chinadns_china" == "2" ] && rcc="223.6.6.6"
		[ "$ss_chinadns_china" == "3" ] && rcc="114.114.114.114"
		[ "$ss_chinadns_china" == "4" ] && rcc="114.114.115.115"
		[ "$ss_chinadns_china" == "5" ] && rcc="1.2.4.8"
		[ "$ss_chinadns_china" == "6" ] && rcc="210.2.4.8"
		[ "$ss_chinadns_china" == "7" ] && rcc="112.124.47.27"
		[ "$ss_chinadns_china" == "8" ] && rcc="114.215.126.16"
		[ "$ss_chinadns_china" == "9" ] && rcc="180.76.76.76"
		[ "$ss_chinadns_china" == "10" ] && rcc="119.29.29.29"
		[ "$ss_chinadns_china" == "11" ] && rcc="$ss_chinadns_china_user"

		if [ "$ss_chinadns_foreign_method" == "1" ];then
			[ "$ss_chinadns_foreign_dns2socks" == "1" ] && rcfd="208.67.220.220:53"
			[ "$ss_chinadns_foreign_dns2socks" == "2" ] && rcfd="8.8.8.8:53"
			[ "$ss_chinadns_foreign_dns2socks" == "3" ] && rcfd="8.8.4.4:53"
			[ "$ss_chinadns_foreign_dns2socks" == "4" ] && rcfd="$ss_chinadns_foreign_dns2socks_user"
			#echo_date ┣开启ss-local,为dns2socks提供socks5端口：23456
			#start_sslocal
			echo_date ┣开启dns2socks，作为chinaDNS上游国外dns，转发dns：$rcfd
			dns2socks 127.0.0.1:23456 "$rcfd" 127.0.0.1:1055 > /dev/null 2>&1 &
		elif [ "$ss_chinadns_foreign_method" == "2" ];then
			echo_date ┣开启 dnscrypt-proxy，作为chinaDNS上游国外dns，你选择了"$ss_chinadns_foreign_dnscrypt"节点.
			dnscrypt-proxy --local-address=127.0.0.1:1055 --daemonize -L /koolshare/ss/rules/dnscrypt-resolvers.csv -R $ss_chinadns_foreign_dnscrypt >/dev/null 2>&1
		elif [ "$ss_chinadns_foreign_method" == "3" ];then
			[ "$ss_chinadns_foreign_sstunnel" == "1" ] && rcfs="208.67.220.220:53"
			[ "$ss_chinadns_foreign_sstunnel" == "2" ] && rcfs="8.8.8.8:53"
			[ "$ss_chinadns_foreign_sstunnel" == "3" ] && rcfs="8.8.4.4:53"
			[ "$ss_chinadns_foreign_sstunnel" == "4" ] && rcfs="$ss_chinadns_foreign_sstunnel_user"
			if [ "$ss_basic_use_rss" == "1" ];then
				echo_date ┣开启ssr-tunnel，作为chinaDNS上游国外dns，转发dns：$rcfs
				rss-tunnel -b 127.0.0.1 -c /koolshare/ss/ss.json -l 1055 -L "$rcfs" -u -f /var/run/sstunnel.pid >/dev/null 2>&1
			elif  [ "$ss_basic_use_rss" == "0" ];then
				echo_date ┣开启ss-tunnel，作为chinaDNS上游国外dns，转发dns：$rcfs
				if [ "$ss_basic_ss_obfs" == "0" ];then
					ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l 1055 -L "$rcfs" -u -f /var/run/sstunnel.pid
				else
					ss-tunnel -b 0.0.0.0 -s $ss_basic_server -p $ss_basic_port -m $ss_basic_method -k $ss_basic_password -l 1055 -L "$rcfs" -u --plugin obfs-local --plugin-opts "$ARG_OBFS" -f /var/run/sstunnel.pid >/dev/null 2>&1
				fi
			fi
		elif [ "$ss_chinadns_foreign_method" == "4" ];then
			echo_date ┣你选择了自定义chinadns国外dns！dns：$ss_chinadns_foreign_method_user
		fi
		echo_date ┗开启chinadns进程！
		chinadns -p $DNS_PORT -s "$rcc",127.0.0.1:1055 -m -d -c /koolshare/ss/rules/chnroute.txt  >/dev/null 2>&1 &
	fi
	
	# Start Pcap_DNSProxy
	if [ "6" == "$ss_dns_foreign"  ]; then
			echo_date 开启Pcap_DNSProxy..
			sed -i "/^Listen Port/c Listen Port = $DNS_PORT" /koolshare/ss/dns/Config.ini
			#sed -i '/^Local Main/c Local Main = 0' /koolshare/ss/dns/Config.conf
			sh /koolshare/ss/dns/dns.sh > /dev/null 2>&1 &
	fi
}
#--------------------------------------------------------------------------------------

load_cdn_site(){
	# append china site
	rm -rf /tmp/sscdn.conf


	if [ "$ss_dns_plan" == "2" ] && [ "$ss_dns_foreign" != "5" ] && [ "$ss_dns_foreign" != "6" ];then
		echo_date 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
		echo "#for china site CDN acclerate" >> /tmp/sscdn.conf
		cat /koolshare/ss/rules/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" | sort | awk '{if ($0!=line) print;line=$0}' >>/tmp/sscdn.conf
	fi

	# append user defined china site
	if [ ! -z "$ss_isp_website_web" ];then
		cdnsites=$(echo $ss_isp_website_web | base64_decode)
		echo_date 生成自定义cdn加速域名到/tmp/sscdn.conf
		echo "#for user defined china site CDN acclerate" >> /tmp/sscdn.conf
		for cdnsite in $cdnsites
		do
			echo "$cdnsite" | sed "s/^/server=&\/./g" | sed "s/$/\/&$CDN/g" >> /tmp/sscdn.conf
		done
	fi
}

custom_dnsmasq(){
	rm -rf /tmp/custom.conf
	if [ ! -z "$ss_dnsmasq" ];then
		echo_date 添加自定义dnsmasq设置到/tmp/custom.conf
		echo "$ss_dnsmasq" | base64_decode | sort -u >> /tmp/custom.conf
	fi
}

append_white_black_conf(){
	# append white domain list, bypass ss
	rm -rf /tmp/wblist.conf
	# github need to go ss
	if [ "$ss_basic_mode" != "6" ];then
		echo "#for router itself" >> /tmp/wblist.conf
		echo "server=/.google.com.tw/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.google.com.tw/router" >> /tmp/wblist.conf
		echo "server=/.github.com/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.github.com/router" >> /tmp/wblist.conf
		echo "server=/.github.io/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.github.io/router" >> /tmp/wblist.conf
		echo "server=/.raw.githubusercontent.com/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.raw.githubusercontent.com/router" >> /tmp/wblist.conf
		echo "server=/.adblockplus.org/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.adblockplus.org/router" >> /tmp/wblist.conf
		echo "server=/.entware.net/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.entware.net/router" >> /tmp/wblist.conf
		echo "server=/.apnic.net/127.0.0.1#7913" >> /tmp/wblist.conf
		echo "ipset=/.apnic.net/router" >> /tmp/wblist.conf
	fi
	# append white domain list,not through ss
	wanwhitedomain=$(echo $ss_wan_white_domain | base64_decode)
	if [ ! -z $ss_wan_white_domain ];then
		echo_date 应用域名白名单
		echo "#for white_domain" >> /tmp/wblist.conf
		for wan_white_domain in $wanwhitedomain
		do 
			echo "$wan_white_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_white_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
		done
	fi
	
	# apple 和microsoft不能走ss
	echo "#for special site" >> /tmp/wblist.conf
	for wan_white_domain2 in "apple.com" "microsoft.com"
	do 
		echo "$wan_white_domain2" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#53/g" >> /tmp/wblist.conf
		echo "$wan_white_domain2" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >> /tmp/wblist.conf
	done
	
	# append black domain list,through ss
	wanblackdomain=$(echo $ss_wan_black_domain | base64_decode)
	if [ ! -z $ss_wan_black_domain ];then
		echo_date 应用域名黑名单
		echo "#for black_domain" >> /tmp/wblist.conf
		for wan_black_domain in $wanblackdomain
		do 
			echo "$wan_black_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" >> /tmp/wblist.conf
			echo "$wan_black_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_list/g" >> /tmp/wblist.conf
		done
	fi
}

ln_conf(){
	# custom dnsmasq
	rm -rf /jffs/configs/dnsmasq.d/custom.conf
	if [ -f /tmp/custom.conf ];then
		#echo_date 创建域自定义dnsmasq配置文件软链接到/jffs/configs/dnsmasq.d/custom.conf
		ln -sf /tmp/custom.conf /jffs/configs/dnsmasq.d/custom.conf
	fi
	
	# custom dnsmasq
	rm -rf /jffs/configs/dnsmasq.d/wblist.conf
	if [ -f /tmp/wblist.conf ];then
		#echo_date 创建域名黑/白名单软链接到/jffs/configs/dnsmasq.d/wblist.conf
		mv -f /tmp/wblist.conf /jffs/configs/dnsmasq.d/wblist.conf
	fi
	rm -rf /jffs/configs/dnsmasq.d/cdn.conf
	if [ -f /tmp/sscdn.conf ];then
		#echo_date 创建cdn加速列表软链接/jffs/configs/dnsmasq.d/cdn.conf
		mv -f /tmp/sscdn.conf /jffs/configs/dnsmasq.d/cdn.conf
	fi

	gfw_on=`dbus list ss_acl_mode_|cut -d "=" -f 2 | grep 1`
	rm -rf /jffs/configs/dnsmasq.d/gfwlist.conf
	if [ "$ss_basic_mode" == "1" ];then
		echo_date 创建gfwlist的软连接到/jffs/etc/dnsmasq.d/文件夹.
		ln -sf /koolshare/ss/rules/gfwlist.conf /jffs/configs/dnsmasq.d/gfwlist.conf
	elif [ "$ss_basic_mode" == "2" ] || [ "$ss_basic_mode" == "3" ];then
		if [ ! -f /jffs/configs/dnsmasq.d/gfwlist.conf ] && [ "$ss_dns_plan" == "1" ] || [ -n "$gfw_on" ];then
			echo_date 创建gfwlist的软连接到/jffs/etc/dnsmasq.d/文件夹.
			ln -sf /koolshare/ss/rules/gfwlist.conf /jffs/configs/dnsmasq.d/gfwlist.conf
		fi
	fi

	#echo_date 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
	rm -rf /jffs/scripts/dnsmasq.postconf
	ln -sf /koolshare/ss/rules/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
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
	
	writenat=$(cat /jffs/scripts/nat-start | grep "ssconfig")
	if [ -z "$writenat" ];then
		echo_date 添加nat-start触发事件...用于ss的nat规则重启后或网络恢复后的加载.
		[ $ss_basic_sleep -ne 0 ] && \
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/nat-start
		[ $ss_basic_sleep -ne 0 ] && \
		sed -i '3a sh /koolshare/ss/ssconfig.sh' /jffs/scripts/nat-start || \
		sed -i '2a sh /koolshare/ss/ssconfig.sh' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi
}

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
		echo_date 添加wan-start触发事件...用于ss的各种程序的开机启动，启动延迟$ss_basic_sleep
		[ $ss_basic_sleep -ne 0 ] && \
		sed -i "2a sleep $ss_basic_sleep" /jffs/scripts/wan-start
		[ $ss_basic_sleep -ne 0 ] && \
		sed -i '3a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start || \
		sed -i '2a sh /koolshare/scripts/ss_config.sh' /jffs/scripts/wan-start
	fi
	chmod +x /jffs/scripts/wan-start
}

#--------------------------------------------------------------------------------------
start_kcp(){
	# Start kcp
	if [ "$ss_basic_use_kcp" == "1" ];then
		echo_date 启动KCP协议进程，为了更好的体验，建议在路由器上创建虚拟内存.
		export GOGC=40
		start-stop-daemon -S -q -b -m \
		-p /tmp/var/kcp.pid \
		-x /koolshare/bin/client_linux_arm5 \
		-- -l 127.0.0.1:1091 \
		-r $ss_basic_server:$ss_basic_kcp_port \
		$ss_basic_kcp_parameter
	fi
}

start_ss_redir(){
	# Start ss-redir
	if [ "$ss_basic_use_rss" == "1" ];then
		echo_date 开启ssr-redir进程，用于透明代理.
		rss-redir -b 0.0.0.0 -c $CONFIG_FILE -u -f /var/run/shadowsocks.pid >/dev/null 2>&1
	elif  [ "$ss_basic_use_rss" == "0" ];then
		echo_date 开启ss-redir进程，用于透明代理.
		if [ "$ss_basic_ss_obfs" == "0" ];then
			ss-redir -b 0.0.0.0 -c $CONFIG_FILE -u -f /var/run/shadowsocks.pid >/dev/null 2>&1
		else
			ss-redir -b 0.0.0.0 -c $CONFIG_FILE -u --plugin obfs-local --plugin-opts "$ARG_OBFS" -f /var/run/shadowsocks.pid >/dev/null 2>&1
		fi
	fi
}

start_koolgame(){
	# Start koolgame
	pdu=`ps|grep pdu|grep -v grep`
	if [ -z "$pdu" ]; then
	echo_date 开启pdu进程，用于优化mtu...
		/koolshare/ss/koolgame/pdu br0 /tmp/var/pdu.pid >/dev/null 2>&1
		sleep 1
	fi
	echo_date 开启koolgame主进程...
	start-stop-daemon -S -q -b -m -p /tmp/var/koolgame.pid -x /koolshare/ss/koolgame/koolgame -- -c /koolshare/ss/koolgame/ss.json
}

write_cron_job(){
	sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "1" == "$ss_basic_rule_update" ]; then
		echo_date 添加ss规则定时更新任务，每天"$ss_basic_rule_update_time"自动检测更新规则.
		cru a ssupdate "0 $ss_basic_rule_update_time * * * /bin/sh /koolshare/scripts/ss_rule_update.sh"
	else
		echo_date ss规则定时更新任务未启用！
	fi
	sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "$ss_basic_node_update" = "1" ];then
		if [ "$ss_basic_node_update_day" = "7" ];then
			cru a ssnodeupdate "0 $ss_basic_node_update_hr * * * /koolshare/scripts/ss_online_update.sh 3"
			echo_date "设置订阅服务器自动更新订阅服务器在每天 $ss_basic_node_update_hr 点。"
		else
			cru a ssnodeupdate "0 $ss_basic_node_update_hr * * ss_basic_node_update_day /koolshare/scripts/ss_online_update.sh 3"
			echo_date "设置订阅服务器自动更新订阅服务器在星期 $ss_basic_node_update_day 的 $ss_basic_node_update_hr 点。"
		fi
	fi
}

kill_cron_job(){
	if [ -n "`cru l|grep ssupdate`" ];then
		echo_date 删除ss规则定时更新任务.
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	if [ -n "`cru l|grep ssnodeupdate`" ];then
		echo_date 删除SSR定时订阅任务.
		sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}
#--------------------------------------nat part begin------------------------------------------------
load_tproxy(){
	MODULES="nf_tproxy_core xt_TPROXY xt_socket xt_comment"
	OS=$(uname -r)
	# load Kernel Modules
	echo_date 加载TPROXY模块，用于udp转发...
	checkmoduleisloaded(){
		if lsmod | grep $MODULE &> /dev/null; then return 0; else return 1; fi;
	}
	
	for MODULE in $MODULES; do
		if ! checkmoduleisloaded; then
			insmod /lib/modules/${OS}/kernel/net/netfilter/${MODULE}.ko
		fi
	done
	
	modules_loaded=0
	
	for MODULE in $MODULES; do
		if checkmoduleisloaded; then
			modules_loaded=$(( j++ )); 
		fi
	done
	
	if [ $modules_loaded -ne 3 ]; then
		echo "One or more modules are missing, only $(( modules_loaded+1 )) are loaded. Can't start.";
		exit 1;
	fi
}

flush_nat(){
	echo_date 清除iptables规则...
	# flush rules and set if any
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1
	sleep 1
	iptables -t nat -F SHADOWSOCKS > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_EXT > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GFW > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GFW > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_CHN > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_CHN > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GLO > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GLO > /dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_HOM > /dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_HOM > /dev/null 2>&1
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS_GAM > /dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS_GAM > /dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -F OUTPUT > /dev/null 2>&1
	iptables -t nat -X SHADOWSOCKS_EXT > /dev/null 2>&1
	iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}

flush_ipset(){
	echo_date 清空ipset名单...
	ipset -F chnroute >/dev/null 2>&1 && ipset -X chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1 && ipset -X black_list >/dev/null 2>&1
	ipset -F gfwlist >/dev/null 2>&1 && ipset -X gfwlist >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1 && ipset -X router >/dev/null 2>&1
}

remove_redundant_rule(){
	ip_rule_exist=`/usr/sbin/ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 310`
	#ip_rule_exist=`ip rule show | grep "fwmark 0x1/0x1 lookup 310" | grep -c 300`
	if [ ! -z "ip_rule_exist" ];then
		echo_date 清除重复的ip rule规则.
		until [ "$ip_rule_exist" = 0 ]
		do 
			#ip rule del fwmark 0x01 table 310
			/usr/sbin/ip rule del fwmark 0x01 table 310
			ip_rule_exist=`expr $ip_rule_exist - 1`
		done
	fi
}

remove_route_table(){
	echo_date 删除ip route规则.
	/usr/sbin/ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

# creat ipset rules
creat_ipset(){
	echo_date 创建ipset名单
	ipset -! create white_list nethash && ipset flush white_list
	ipset -! create black_list nethash && ipset flush black_list
	ipset -! create gfwlist nethash && ipset flush gfwlist
	ipset -! create router nethash && ipset flush router
	ipset -! create chnroute nethash && ipset flush chnroute
	sed -e "s/^/add chnroute &/g" /koolshare/ss/rules/chnroute.txt | awk '{print $0} END{print "COMMIT"}' | ipset -R
}

add_white_black_ip(){
	# black ip/cidr
	ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24"
	for ip in $ip_tg
	do
		ipset -! add black_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_black_ip ];then
		ss_wan_black_ip=`dbus get ss_wan_black_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR黑名单
		for ip in $ss_wan_black_ip
		do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi
	
	# white ip/cidr
	ip1=$(nvram get wan0_ipaddr | cut -d"." -f1,2)
	[ -n "$ss_basic_server_ip" ] && SERVER_IP=$ss_basic_server_ip || SERVER_IP=""
	ISP_DNS1=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
	ISP_DNS2=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p)
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 $ip1.0.0/16 $SERVER_IP 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115 1.2.4.8 210.2.4.8 112.124.47.27 114.215.126.16 180.76.76.76 119.29.29.29 $ISP_DNS1 $ISP_DNS2"
	for ip in $ip_lan
	do
		ipset -! add white_list $ip >/dev/null 2>&1
	done
	
	if [ ! -z $ss_wan_white_ip ];then
		ss_wan_white_ip=`echo $ss_wan_white_ip|base64_decode|sed '/\#/d'`
		echo_date 应用IP/CIDR白名单
		for ip in $ss_wan_white_ip
		do
			ipset -! add white_list $ip >/dev/null 2>&1
		done
	fi
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "SHADOWSOCKS_GFW"
		;;
		2)
			echo "SHADOWSOCKS_CHN"
		;;
		3 | 4)
			echo "SHADOWSOCKS_GAM"
		;;
		5)
			echo "SHADOWSOCKS_GLO"
		;;
		6)
			echo "SHADOWSOCKS_HOM"
		;;
	esac
}

get_mode_name() {
	case "$1" in
		0)
			echo "不通过SS"
		;;
		1)
			echo "gfwlist模式"
		;;
		2)
			echo "大陆白名单模式"
		;;
		3)
			echo "游戏模式"
		;;
		4)
			echo "游戏模式V2"
		;;
		5)
			echo "全局模式"
		;;
		6)
			echo "回国模式"
		;;
	esac
}

factor(){
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

get_jump_mode(){
	case "$1" in
		0)
			echo "j"
		;;
		*)
			echo "g"
		;;
	esac
}

gamev2_control(){
	# lan control
	black=$(echo $ss_game2_black_lan | base64_decode | sed "s/,/ /g")
	white=$(echo $ss_game2_white_lan | base64_decode | sed "s/,/ /g")
	if [ "$ss_game2_lan_control" == "1" ];then
		if [ ! -z $ss_game2_black_lan ];then
			echo_date 添加局域网黑名单IP，添加的IP地址将不会走游戏模式V2，其余的走游戏模式V2。
			for balck_ip in $black
			do
				iptables -t nat -A SHADOWSOCKS -p tcp -s $balck_ip -j RETURN
				iptables -t mangle -A SHADOWSOCKS -p udp -s $balck_ip -j RETURN
			done
		else
			echo_date 你开启了局域网黑名单，但是未填写任何内容，跳过！
		fi
		iptables -t nat -A SHADOWSOCKS -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
		iptables -t mangle -A SHADOWSOCKS -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
	elif [ "$ss_game2_lan_control" == "2" ];then
		if [ ! -z $ss_game2_white_lan ];then
			echo_date 添加局域网白名单IP，添加的IP地址将会走游戏模式V2，其余的不走游戏模式V2。
			for white_ip in $white
			do
				iptables -t nat -A SHADOWSOCKS -p tcp -s $white_ip -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
				iptables -t mangle -A SHADOWSOCKS -p udp -s $white_ip -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
			done
			ss_acl_default_mode=0
		else
			echo_date 你开启了局域网白名单，但是未填写任何内容，跳过！
			iptables -t nat -A SHADOWSOCKS -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
			iptables -t mangle -A SHADOWSOCKS -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
		fi
	else 
		echo_date 局域网控制功能未启用！
		iptables -t nat -A SHADOWSOCKS -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
		iptables -t mangle -A SHADOWSOCKS -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
	fi	
}

lan_acess_control(){
	# lan access control
	acl_nu=`dbus list ss_acl_mode|sed 1d|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	if [ -n "$acl_nu" ]; then
		for acl in $acl_nu
		do
			ipaddr=`dbus get ss_acl_ip_$acl`
			ipaddr_hex=`dbus get ss_acl_ip_$acl | awk -F "." '{printf ("0x%02x", $1)} {printf ("%02x", $2)} {printf ("%02x", $3)} {printf ("%02x\n", $4)}'`
			ports=`dbus get ss_acl_port_$acl`
			[ "$ports" == "all" ] && ports=""
			proxy_mode=`dbus get ss_acl_mode_$acl`
			proxy_name=`dbus get ss_acl_name_$acl`
			[ "$ports" == "" ] && echo_date 加载ACL规则：$ipaddr:all模式为：$(get_mode_name $proxy_mode) || echo_date 加载ACL规则：$ipaddr:$ports模式为：$(get_mode_name $proxy_mode)
			# normal acl
			iptables -t nat -A SHADOWSOCKS $(factor $ipaddr "-s") -p tcp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			# acl in OUTPUT（used by koolproxy）
			iptables -t nat -A SHADOWSOCKS_EXT -p tcp  $(factor $ports "-m multiport --dport") -m mark --mark "$ipaddr_hex" -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			# 当主模式为游戏模式(3)，acl主机为其它模式（!3），则这些主机的udp默认不走ss
			[ "$ss_basic_mode" == "3" ] && [ "$proxy_mode" != "3" ] && iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp -j RETURN
			# acl主机为游戏模式(3)，这些主机的udp走ss
			[ "$proxy_mode" == "3" ] && iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
		done
		
		if [ -n "ss_acl_default_mode=" ];then
			echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $ss_acl_default_mode)
		else
			echo_date 加载ACL规则：其余主机模式为：$(get_mode_name $ss_basic_mode)
			dbus set ss_acl_default_mode="$ss_basic_mode"
		fi
	else
		ss_acl_default_mode=$ss_basic_mode
		echo_date 加载ACL规则：所有模式为：$(get_mode_name $ss_basic_mode)
	fi
}

apply_nat_rules(){
	[ "$ss_acl_default_port" == "all" ] && ss_acl_default_port=""
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建SHADOWSOCKS nat rule
	iptables -t nat -N SHADOWSOCKS
	# 扩展
	iptables -t nat -N SHADOWSOCKS_EXT
	# IP/cidr/白域名 白名单控制（不走ss）
	iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set white_list dst -j RETURN
	#-----------------------FOR GLOABLE---------------------
	# 创建gfwlist模式nat rule
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -N SHADOWSOCKS_GLO
	# IP黑名单控制-gfwlist（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_GLO -p tcp -j REDIRECT --to-ports 3333
	#-----------------------FOR GFWLIST---------------------
	# 创建gfwlist模式nat rule
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -N SHADOWSOCKS_GFW
	# IP/CIDR/黑域名 黑名单控制（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# IP黑名单控制-gfwlist（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	#-----------------------FOR CHNMODE---------------------
	# 创建大陆白名单模式nat rule
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -N SHADOWSOCKS_CHN
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	#-----------------------FOR GAMEMODE---------------------
	# 创建游戏模式nat rule
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	#-----------------------FOR HOMEMODE---------------------
	# 创建回国模式nat rule
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -N SHADOWSOCKS_HOM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_HOM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_HOM -p tcp -m set --match-set chnroute dst -j REDIRECT --to-ports 3333

	[ "$mangle" == "1" ] && load_tproxy
	[ "$mangle" == "1" ] && /usr/sbin/ip rule add fwmark 0x01 table 310
	[ "$mangle" == "1" ] && /usr/sbin/ip route add local 0.0.0.0/0 dev lo table 310
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS -p udp -m set --match-set white_list dst -j RETURN
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set --match-set black_list dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
	# cidr黑名单控制-chnroute（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x01
	#-------------------------------------------------------
	# 局域网黑名单（不走ss）/局域网黑名单（走ss）
	[ "$ss_basic_mode" != "4" ] && lan_acess_control || gamev2_control
	#-----------------------FOR ROUTER---------------------
	# router itself
	[ "$ss_basic_mode" != "6" ] && iptables -t nat -A OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A OUTPUT -p tcp -m mark --mark "$ip_prefix_hex" -j SHADOWSOCKS_EXT
	
	# 把最后剩余流量重定向到相应模式的nat表中对应的主模式的链
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS -p tcp $(factor $ss_acl_default_port "-m multiport --dport") -j $(get_action_chain $ss_acl_default_mode)
	[ "$ss_basic_mode" != "4" ] && iptables -t nat -A SHADOWSOCKS_EXT -p tcp $(factor $ss_acl_default_port "-m multiport --dport") -j $(get_action_chain $ss_acl_default_mode)
	
	# 如果是主模式游戏模式，则把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM链
	# 如果主模式不是游戏模式，则不需要把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM，不然会造成其他模式主机的udp也走游戏模式
	[ "$mangle" == "1" ] && ss_acl_default_mode=3
	[ "$ss_basic_mode" == "3" ] && iptables -t mangle -A SHADOWSOCKS -p udp -j $(get_action_chain $ss_acl_default_mode)
	# 重定所有流量到 SHADOWSOCKS
	KP_NU=`iptables -nvL PREROUTING -t nat |sed 1,2d | sed -n '/KOOLPROXY/='`
	[ "$KP_NU" == "" ] && KP_NU=0
	INSET_NU=`expr "$KP_NU" + 1`
	iptables -t nat -I PREROUTING "$INSET_NU" -p tcp -j SHADOWSOCKS
	#iptables -t nat -I PREROUTING 1 -p tcp -j SHADOWSOCKS
	[ "$mangle" == "1" ] && iptables -t mangle -I PREROUTING 1 -p udp -j SHADOWSOCKS
}

chromecast(){
	LOG1=开启chromecast功能（DNS劫持功能）
	LOG2=chromecast功能未开启，建议开启~
	kp_enable=`iptables -t nat -L PREROUTING | grep KOOLPROXY |wc -l`
	kp_mode=`dbus get koolproxy_policy`
	chromecast_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|awk '{print $1}'`
	if [ "$ss_basic_chromecast" == "1" ];then
		if [ -z "$chromecast_nu" ]; then
			IPT_ACTION="-A"
			echo_date $LOG1
		else
			echo_date DNS劫持规则已经添加，跳过~
		fi
	else
		if [ "$kp_mode" != 2 ] || [ "$kp_enable" -eq 0 ]; then
			if [ -n "$chromecast_nu" ]; then
				IPT_ACTION="-D"
				echo_date $LOG2
			fi
		else
			if [ -z "$chromecast_nu" ]; then
				IPT_ACTION="-A"
				echo_date $LOG1
			fi
		fi
	fi	
	iptables -t nat $IPT_ACTION PREROUTING -p udp --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
}
# -----------------------------------nat part end--------------------------------------------------------

restart_dnsmasq(){
	# Restart dnsmasq
	echo_date 重启dnsmasq服务...
	service restart_dnsmasq >/dev/null 2>&1
}

remove_status(){
	nvram set ss_foreign_state=""
	nvram set ss_china_state=""
}

load_module(){
	xt=`lsmod | grep xt_set`
	OS=$(uname -r)
	if [ -f /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko ] && [ -z "$xt" ];then
		echo_date "加载xt_set.ko内核模块！"
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_set.ko
	fi
}

qos_warning(){
	echo_date 检测是否符合游戏模式启动条件...
	QOSO=`iptables -t mangle -S | grep -o QOSO | wc -l`
	if [ $QOSO -gt 1 ];then
		printf "$(date +%Y年%m月%d日\ %X): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!! 发现你开启了 Adaptive Qos - 传统带宽管理,该Qos模式和游戏模式\(V2\)冲突！!!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!! 即使主模式没有使用游戏模式\(V2\),访问控制内有主机使用的话，同样会出现冲突！!!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!! 如果你仍然希望在游戏模式下使用Qos，可以使用Adaptive QoS网络监控家模式。  !!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!! 但是该模式下走ss的流量不会有Qos效果！                                 !!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!! 退出应用应用操作，关闭ss！请等待10秒！                                !!!\n"
		printf "$(date +%Y年%m月%d日\ %X): !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
		dbus set ss_basic_enable=0
		sleep 10
		exit
	else
		echo_date 未检测到系统设置冲突，符合启动条件！
	fi
}

detect_qos(){
	game_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 3`
	[ -n "$game_on" ] || [ "$ss_basic_mode" == "3" ] || [ "$ss_basic_mode" == "4" ] && qos_warning
}

restart_addon(){
	#ss_basic_action=4
	echo_date ----------------------------- 重启附加功能 -----------------------------
	# for sleep walue in start up files
	old_sleep=`cat /jffs/scripts/nat-start | grep sleep | awk '{print $2}'`
	new_sleep="$ss_basic_sleep"
	if [ "$old_sleep" = "$new_sleep" ];then
		echo_date 开机延迟时间未改变，仍然是"$ss_basic_sleep"秒.
	else
		echo_date 设置"$ss_basic_sleep"秒开机延迟...
		# delete boot delay in nat-start and wan-start
		sed -i '/koolshare/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/nat-start >/dev/null 2>&1
		sed -i '/koolshare/d' /jffs/scripts/wan-start >/dev/null 2>&1
		sed -i '/sleep/d' /jffs/scripts/wan-start >/dev/null 2>&1
		# re add delay in nat-start and wan-start
		nat_auto_start >/dev/null 2>&1
		wan_auto_start >/dev/null 2>&1
	fi
	
	#remove_status
	remove_status
	
	if [ "$ss_basic_dnslookup" == "1" ];then
		echo_date 设置使用nslookup方式解析SS服务器的ip地址.
	else
		echo_date 设置使用resolveip方式解析SS服务器的ip地址.
	fi
	echo_date -------------------------- 附加功能重启完毕！ ---------------------------
}

# write number into nvram with no commit
write_numbers(){
	nvram set update_ipset="$(cat /koolshare/ss/rules/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_chnroute="$(cat /koolshare/ss/rules/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_cdn="$(cat /koolshare/ss/rules/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_Routing="$(cat /koolshare/ss/rules/version | sed -n 5p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_WhiteList="$(cat /koolshare/ss/rules/version | sed -n 6p | sed 's/#/\n/g'| sed -n 1p)"
	
	nvram set ipset_numbers=$(cat /koolshare/ss/rules/gfwlist.conf | grep -c ipset)
	nvram set chnroute_numbers=$(cat /koolshare/ss/rules/chnroute.txt | grep -c .)
	nvram set cdn_numbers=$(cat /koolshare/ss/rules/cdn.txt | grep -c .)
	nvram set Routing_numbers=$(cat /koolshare/ss/dns/Routing.txt |grep -c /)
	nvram set WhiteList_numbers=$(cat /koolshare/ss/dns/WhiteList.txt |grep -Ec "^\.\*")
}

set_ulimit(){
	ulimit -n 16384
}

disable_ss(){
	echo_date =============== 梅林固件 - shadowsocks by sadoneli\&Xiaobao ===============
	echo_date
	echo_date -------------------------- 关闭Shadowsocks ------------------------------
	nvram set ss_mode=0
	dbus set dns2socks=0
	nvram commit
	restore_conf
	remove_conf_and_settings
	restart_dnsmasq
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	restore_start_file
	kill_process
	kill_cron_job
	echo_date -------------------------- Shadowsocks已关闭 -----------------------------
	dbus set ss_basic_action="1"
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo_date "错误：不能正确加载nat规则!"
	        disable_ss
	        exit
	    fi
	    sleep 2
	done
	echo_date "加载nat规则!"
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
}

apply_ss(){
	# router is on boot
	WAN_ACTION=`ps|grep /jffs/scripts/wan-start|grep -v grep`
	# now stop first
	echo_date =============== 梅林固件 - shadowsocks by sadoneli\&Xiaobao ===============
	echo_date
	echo_date -------------------------- 关闭Shadowsocks ------------------------------
	nvram set ss_mode=0
	dbus set dns2socks=0
	nvram commit
	restore_conf
	remove_conf_and_settings
	# restart dnsmasq when ss server is not ip or on router boot
	[ -z "$IFIP" ] && [ -z "$WAN_ACTION" ] && restart_dnsmasq
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	restore_start_file
	kill_process
	kill_cron_job
	echo_date -------------------------- Shadowsocks已关闭 -----------------------------
	
	# pre-start
	echo_date ----------------------- shadowsocks 启动前触发脚本 -----------------------
	ss_pre_start
	
	# start
	echo_date ------------------------- 梅林固件 shadowsocks --------------------------
	detect_qos
	resolv_server_ip
	# do not re generate json on router start, use old one
	if [ "$ss_basic_mode" != "4" ];then
		[ -z "$WAN_ACTION" ] && creat_ss_json
	else
		[ -z "$WAN_ACTION" ] && creat_game2_json
	fi
	#creat_dnsmasq_basic_conf
	load_cdn_site
	custom_dnsmasq
	append_white_black_conf && ln_conf
	nat_auto_start
	wan_auto_start
	write_cron_job
	[ "$ss_basic_mode" != "4" ] && start_dns
	[ "$ss_basic_mode" != "4" ] && start_ss_redir || start_koolgame
	[ "$ss_basic_mode" != "4" ] && start_kcp
	load_module
	#===load nat start===
	load_nat
	#===load nat end===
	restart_dnsmasq
	remove_status
	nvram set ss_mode=2
	nvram commit
	echo_date ------------------------- shadowsocks 启动完毕 -------------------------
	[ "$ss_basic_action" == "4" ] && restart_addon
}
# =========================================================================

case $ACTION in
start)
	if [ "$ss_basic_enable" == "1" ];then
		creat_folder
		set_ulimit
		apply_ss
    	write_numbers
	else
		echo ss not enabled
	fi
	;;
stop | kill )
	disable_ss
	echo_date
	echo_date 你已经成功关闭shadowsocks服务~
	echo_date See you again!
	echo_date
	echo_date =============== 梅林固件 - shadowsocks by sadoneli\&Xiaobao ===============
	;;
restart)
	creat_folder
	set_ulimit
	apply_ss
	write_numbers
	echo_date
	echo_date "Across the Great Wall we can reach every corner in the world!"
	echo_date
	echo_date =============== 梅林固件 - shadowsocks by sadoneli\&Xiaobao ===============
	dbus fire onssstart
	# creat nat locker
	[ ! -f "/tmp/shadowsocks.nat_lock" ] && touch /tmp/shadowsocks.nat_lock
	return 0
	;;
update)
	update_ss
	;;
*)
	WAN_ACTION=`ps|grep /jffs/scripts/wan-start|grep -v grep`
	[ -n "$WAN_ACTION" ] && exit 0
	# detect nat locker,do not restart nat on reouter boot
	[ ! -f "/tmp/shadowsocks.nat_lock" ] && exit 0
	flush_nat
	flush_ipset
	remove_redundant_rule
	remove_route_table
	creat_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
	;;
esac
