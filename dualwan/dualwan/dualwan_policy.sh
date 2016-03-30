#!/bin/sh
version="0.1"
# load path environment in dbus databse
eval `dbus export dualwanpolicy`
eval `dbus export shadowsocks`
#source /koolshare/configs/ss.sh
CONFIG="/koolshare/dw"
ss_mode=$(nvram get ss_mode)
# run this script when ss start
start=$(dbus list __event__onssstart_)

#-------------------------------------------module--------------------------------------------------------
ss_start(){
if [ -z "start" ];then
dbus event onssstart_policy_route /koolshare/scripts/dualwan_policy.sh
fi
}
stop_policy(){
# delete possible multip ip rule
ip_rule_exist=`ip rule show | grep -c "555"`
if [ ! -z "ip_rule_exist" ];then
	until [ "$ip_rule_exist" = 0 ]
	do 
  ip rule del pref 123 >/dev/null 2>&1
  ip rule del pref 124 >/dev/null 2>&1
  ip rule del from all fwmark 0x22b8 >/dev/null 2>&1
  ip rule del from all fwmark 0x1e61 >/dev/null 2>&1
	ip_rule_exist=`expr $ip_rule_exist - 1`
	done
fi

for number in $(iptables -t mangle -L OUTPUT -v -n --line-numbers | grep operators | cut -d " " -f 1 | sort -nr)
	do
	  iptables -t mangle -D OUTPUT $number
done
for number in $(iptables -t mangle -L PREROUTING -v -n --line-numbers | grep operators | cut -d " " -f 1 | sort -nr)
	do
		iptables -t mangle -D PREROUTING $number
done

ipset -F wan1operators >/dev/null 2>&1
ipset -F wan2operators >/dev/null 2>&1
ipset -F CNNoperators >/dev/null 2>&1
ipset -X wan1operators >/dev/null 2>&1
ipset -X wan2operators >/dev/null 2>&1
ipset -X CNNoperators >/dev/null 2>&1
}
auto_start(){
   # creating iptables rules to firewall-start
   if [ ! -d /jffs/scripts ]; then 
      mkdir -p /jffs/scripts
   fi
   
   if [ ! -f /jffs/scripts/firewall-start ]; then 
      cat > /jffs/scripts/firewall-start <<EOF
#!/bin/sh
EOF
   fi
   
   writenat=$(cat /jffs/scripts/firewall-start | grep "dualwan_policy")
   if [ -z "$writenat" ];then
	   sed -i "1a sleep 30" /jffs/scripts/firewall-start
	   sed -i '2a /koolshare/scripts/dualwan_policy.sh' /jffs/scripts/firewall-start
	   chmod +x /jffs/scripts/firewall-start
   fi
}
auto_stop(){
   # clear start up command line in firewall-start
   sed -i '/sleep 30/d' /jffs/scripts/firewall-start >/dev/null 2>&1
   sed -i '/dualwan_policy/d' /jffs/scripts/firewall-start >/dev/null 2>&1
   echo $(date): ------------------ Custom operators rule runs stop!------------------  >> /tmp/syslog.log
}
start_policy(){
[ "$dualwanpolicy_wan_foreign" == "1" ] && operators_foreign="7777"
[ "$dualwanpolicy_wan_foreign" == "2" ] && operators_foreign="8888"
[ "$dualwanpolicy_wan_ss" == "1" ] && sstable="100"
[ "$dualwanpolicy_wan_ss" == "2" ] && sstable="200"
[ "$dualwanpolicy_wan1" == "1" ] && operators1_config="$CONFIG/telecom.txt"
[ "$dualwanpolicy_wan1" == "2" ] && operators1_config="$CONFIG/mobile.txt"
[ "$dualwanpolicy_wan1" == "3" ] && operators1_config="$CONFIG/unicom.txt"
[ "$dualwanpolicy_wan1" == "4" ] && operators1_config="$CONFIG/cernet.txt"
[ "$dualwanpolicy_wan1" == "5" ] && operators1_config="$CONFIG/cnn.txt"
[ "$dualwanpolicy_wan1" == "6" ] && operators1_config=$dualwanpolicy_wan1_custom
[ "$dualwanpolicy_wan2" == "1" ] && operators2_config="$CONFIG/telecom.txt"
[ "$dualwanpolicy_wan2" == "2" ] && operators2_config="$CONFIG/mobile.txt"
[ "$dualwanpolicy_wan2" == "3" ] && operators2_config="$CONFIG/unicom.txt"
[ "$dualwanpolicy_wan2" == "4" ] && operators2_config="$CONFIG/cernet.txt"
[ "$dualwanpolicy_wan2" == "5" ] && operators2_config="$CONFIG/cnn.txt"
[ "$dualwanpolicy_wan2" == "6" ] && operators2_config=$dualwanpolicy_wan2_custom
use_wan1operators=$operators1_config
sed -e "s/^/-A wan1operators &/g" -e "1 i\-N wan1operators nethash --hashsize 91260" $use_wan1operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
use_wan2operators=$operators2_config
sed -e "s/^/-A wan2operators &/g" -e "1 i\-N wan2operators nethash --hashsize 4096" $use_wan2operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
use_CNNoperators=$CONFIG/cnn.txt
sed -e "s/^/-A CNNoperators &/g" -e "1 i\-N CNNoperators nethash --hashsize 49152" $use_CNNoperators | awk '{print $0} END{print "COMMIT"}' | ipset -R
iptables -t mangle -A PREROUTING -m set --match-set wan1operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
iptables -t mangle -A PREROUTING -m set --match-set wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
iptables -t mangle -A PREROUTING -m set ! --match-set CNNoperators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
iptables -t mangle -A OUTPUT -m set --match-set wan1operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
iptables -t mangle -A OUTPUT -m set --match-set wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
iptables -t mangle -A OUTPUT -m set ! --match-set CNNoperators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
if [ ! -z "$shadowsocks_server_ip" ] && [ "$ss_mode" != "0" ];then
	ip rule add from $shadowsocks_server_ip table $sstable pref 123
	ip rule add to $shadowsocks_server_ip table $sstable pref 124
fi
ip rule add fwmark 7777 table 100 pref 555
ip rule add fwmark 8888 table 200 pref 666
ip route flush cach
echo $(date): --------------Custom operators rule runs successfully!-------------- >> /tmp/syslog.log
}


check_version() {
dualwanpolicy_version_web1=$(curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/dualwan/version | sed -n 1p)

if [ ! -z $dualwanpolicy_version_web1 ];then
	dbus set dualwanpolicy_version_web=$dualwanpolicy_version_web1
fi
}

#-----------------------------------------------update-----------------------------------------------

if [ $dualwanpolicy_update_check = "1" ];then

	# dualwanpolicy_install_status=	#
	# dualwanpolicy_install_status=0	#
	# dualwanpolicy_install_status=1	#正在下载更新......
	# dualwanpolicy_install_status=2	#正在安装更新...
	# dualwanpolicy_install_status=3	#安装更新成功，5秒后刷新本页！
	# dualwanpolicy_install_status=4	#下载文件校验不一致！
	# dualwanpolicy_install_status=5	#然而并没有更新！
	# dualwanpolicy_install_status=6	#正在检查是否有更新~
	# dualwanpolicy_install_status=7	#检测更新错误！

	dbus set dualwanpolicy_install_status="6"
	dualwanpolicy_version_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/dualwan/version | sed -n 1p`
	if [ ! -z $dualwanpolicy_version_web1 ];then
		dbus set dualwanpolicy_version_web=$dualwanpolicy_version_web1
		cmp=`versioncmp $dualwanpolicy_version_web1 $version`
		if [ "$cmp" = "-1" ];then
			dbus set dualwanpolicy_install_status="1"
			cd /tmp
			md5_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/dualwan/version | sed -n 2p`
			wget --no-check-certificate --tries=1 --timeout=15 https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/dualwan/dualwan.tar.gz
			md5sum_gz=`md5sum /tmp/dualwan.tar.gz | sed 's/ /\n/g'| sed -n 1p`
			if [ "$md5sum_gz" != "$md5_web1" ]; then
				dbus set dualwanpolicy_install_status="4"
				rm -rf /tmp/dualwan* >/dev/null 2>&1
				sleep 5
				dbus set dualwanpolicy_install_status="0"
			else
				stop_vpn
				tar -zxf dualwan.tar.gz
				dbus set dualwanpolicy_install_status="2"
				chmod a+x /tmp/dualwan/update.sh
				sh /tmp/dualwan/update.sh
				sleep 2
				dbus set dualwanpolicy_install_status="3"
				dbus set dualwanpolicy_version_local=$dualwanpolicy_version_web1
				sleep 2
				dbus set dualwanpolicy_install_status="0"
			fi
		else
			dbus set dualwanpolicy_install_status="5"
			sleep 2
			dbus set dualwanpolicy_install_status="0"
		fi
	else
		dbus set dualwanpolicy_install_status="7"
		sleep 5
		dbus set dualwanpolicy_install_status="0"
	fi
	dbus set dualwanpolicy_update_check="0"
fi


#---------------------------------------------start or stop--------------------------------------------------

if [ "$dualwanpolicy_enable" == "1" ];then
   stop_policy
   check_version
   dbus set dualwanpolicy_version_local=$version
   start_policy 
   auto_start
   ss_start  
 else
  stop_policy
  auto_stop
fi


