#!/bin/sh
modprobe xt_set
# Loading ipset modules
lsmod | grep "xt_set" > /dev/null 2>&1 || \
for module in ip_set ip_set_hash_net ip_set_hash_ip xt_set
    do
    insmod $module
done
# load path environment in dbus databse
eval `dbus export dualwanpolicy`
eval `dbus export shadowsocks`
#source /koolshare/configs/ss.sh
CONFIG="/koolshare/dw"
ss_enable=`dbus get ss_basic_enable`
ss_mode=`dbus get ss_basic_mode`
[ "$ss_enable" == "0" ] && ss_mode=0
# run this script when ss start
start=$(dbus list __event__onssstart_)

#-------------------------------------------module--------------------------------------------------------
# detect if the router is arm or mips
case $(uname -m) in
  armv7l)
    MATCH_SET='--match-set'
    ;;
  mips)
    MATCH_SET='--set'
    ;;
esac

ss_start(){
if [ -z "start" ];then
dbus event onssstart_policy_route /koolshare/scripts/dualwan_policy.sh
fi
}
stop_policy(){
# delete possible multip ip rule
ip_rule_exist=`ip rule show | grep -c "20555"`
if [ ! -z "ip_rule_exist" ];then
	until [ "$ip_rule_exist" = 0 ]
	do
  ip rule del pref 20123 >/dev/null 2>&1
  ip rule del pref 20124 >/dev/null 2>&1
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
ipset -X wan1operators >/dev/null 2>&1
ipset -X wan2operators >/dev/null 2>&1

for tun_number in $(ip route list table 100 | grep "tun" | awk '{print $3}')
	do
        ip_route=$(ip route list table 100 | grep $tun_number)
        ip route del $ip_route table 100 >/dev/null 2>&1
done
for tun_number in $(ip route list table 200 | grep "tun" | awk '{print $3}')
        do
        ip_route=$(ip route list table 200 | grep $tun_number)
        ip route del $ip_route table 200 >/dev/null 2>&1
done
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
	   sed -i '1a sleep 10' /jffs/scripts/firewall-start
	   sed -i '2a /koolshare/scripts/dualwan_policy.sh' /jffs/scripts/firewall-start
	   chmod +x /jffs/scripts/firewall-start
   fi

   # creating iptables rules to openvpn-event
   if [ ! -d /jffs/scripts ]; then
      mkdir -p /jffs/scripts
   fi

   if [ ! -f /jffs/scripts/openvpn-event ]; then
      cat > /jffs/scripts/openvpn-event <<EOF
#!/bin/sh
EOF
   fi

   writenat=$(cat /jffs/scripts/openvpn-event | grep "ip_route")
   if [ -z "$writenat" ];then
	   sed -i '1a sleep 10' /jffs/scripts/openvpn-event
	   sed -i '2a for tun_number in $(ip route | grep "tun" | awk '"'"'{print $3}'"'"')' /jffs/scripts/openvpn-event
	   sed -i '3a do' /jffs/scripts/openvpn-event
	   sed -i '4a ip_route=$(ip route | grep $tun_number)' /jffs/scripts/openvpn-event
	   sed -i '5a ip route add $ip_route table 100 >/dev/null 2>&1' /jffs/scripts/openvpn-event
	   sed -i '6a ip route add $ip_route table 200 >/dev/null 2>&1' /jffs/scripts/openvpn-event
	   sed -i '7a done' /jffs/scripts/openvpn-event
	   chmod +x /jffs/scripts/openvpn-event
   fi
}

auto_stop(){
   # clear start up command line in firewall-start
   sed -i '/sleep 10/d' /jffs/scripts/firewall-start >/dev/null 2>&1
   sed -i '/dualwan_policy/d' /jffs/scripts/firewall-start >/dev/null 2>&1
   # clear start up command line in openvpn-event
   sed -i '/do/d' /jffs/scripts/openvpn-event >/dev/null 2>&1
   sed -i '/sleep 10/d' /jffs/scripts/openvpn-event >/dev/null 2>&1
   sed -i '/tun_number/d' /jffs/scripts/openvpn-event >/dev/null 2>&1
   sed -i '/ip_route/d' /jffs/scripts/openvpn-event >/dev/null 2>&1
   echo $(date): ------------------ Custom operators rule runs stop!------------------  >> /tmp/syslog.log
}

start_policy(){
[ "$dualwanpolicy_wan_foreign" == "1" ] && operators_foreign="7777"
[ "$dualwanpolicy_wan_foreign" == "2" ] && operators_foreign="8888"
[ "$dualwanpolicy_wan_ss" == "1" ] && sstable="100"
[ "$dualwanpolicy_wan_ss" == "2" ] && sstable="200"
[ "$dualwanpolicy_wan1" == "1" ] && operators1_config="$CONFIG/cnn.txt"
[ "$dualwanpolicy_wan1" == "2" ] && operators1_config=$dualwanpolicy_wan1_custom
[ "$dualwanpolicy_wan2" == "1" ] && operators2_config="$CONFIG/tel.txt"
[ "$dualwanpolicy_wan2" == "2" ] && operators2_config="$CONFIG/cmc.txt"
[ "$dualwanpolicy_wan2" == "3" ] && operators2_config="$CONFIG/cnc.txt"
[ "$dualwanpolicy_wan2" == "4" ] && operators2_config="$CONFIG/crc.txt"
[ "$dualwanpolicy_wan2" == "5" ] && operators2_config=$dualwanpolicy_wan2_custom
if [ "$dualwanpolicy_wan2" == "1" ];then
	use_wan2operators=$operators2_config
	sed -e "s/^/-A wan2operators &/g" -e "1 i\-N wan2operators nethash --hashsize 91260" $use_wan2operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	iptables -t mangle -A PREROUTING -m set $MATCH_SET wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
	iptables -t mangle -A PREROUTING -m set ! $MATCH_SET wan2operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set $MATCH_SET wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set ! $MATCH_SET wan2operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
else
	use_wan1operators=$operators1_config
	sed -e "s/^/-A wan1operators &/g" -e "1 i\-N wan1operators nethash --hashsize 91260" $use_wan1operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	use_wan2operators=$operators2_config
	sed -e "s/^/-A wan2operators &/g" -e "1 i\-N wan2operators nethash --hashsize 16384" $use_wan2operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	iptables -t mangle -A PREROUTING -m set ! $MATCH_SET wan1operators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
	iptables -t mangle -A PREROUTING -m set $MATCH_SET wan1operators dst  -j MARK --set-mark 7777 >/dev/null 2>&1
	iptables -t mangle -A PREROUTING -m set $MATCH_SET wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set ! $MATCH_SET wan1operators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set $MATCH_SET wan1operators dst  -j MARK --set-mark 7777 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set $MATCH_SET wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
fi
if [ ! -z "$shadowsocks_server_ip" ] && [ "$ss_mode" != "0" ];then
	ip rule add from $shadowsocks_server_ip table $sstable pref 20123
	ip rule add to $shadowsocks_server_ip table $sstable pref 20124
fi
ip rule add fwmark 7777 table 100 pref 20555
ip rule add fwmark 8888 table 200 pref 20666

for tun_number in $(ip route | grep "tun" | awk '{print $3}')
	do
		ip_route=$(ip route | grep $tun_number)
		ip route add $ip_route table 100 >/dev/null 2>&1
		ip route add $ip_route table 200 >/dev/null 2>&1
done

echo 4 > /proc/sys/net/ipv4/rt_cache_rebuild_count

#Flush IP Route Cache
ip route flush cache
echo $(date): --------------Custom operators rule runs successfully!-------------- >> /tmp/syslog.log
}



#---------------------------------------------start or stop--------------------------------------------------

if [ "$dualwanpolicy_enable" == "1" ];then
   stop_policy
   start_policy
   auto_start
   ss_start
 else
  stop_policy
  auto_stop
fi
