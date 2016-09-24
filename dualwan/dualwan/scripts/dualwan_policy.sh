#!/bin/sh
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
ipset -X wan1operators >/dev/null 2>&1
ipset -X wan2operators >/dev/null 2>&1

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
	   sed -i "1a sleep 10" /jffs/scripts/firewall-start
	   sed -i '2a /koolshare/scripts/dualwan_policy.sh' /jffs/scripts/firewall-start
	   chmod +x /jffs/scripts/firewall-start
   fi
}
auto_stop(){
   # clear start up command line in firewall-start
   sed -i '/sleep 10/d' /jffs/scripts/firewall-start >/dev/null 2>&1
   sed -i '/dualwan_policy/d' /jffs/scripts/firewall-start >/dev/null 2>&1
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
if [ "$dualwanpolicy_wan2" != "1" ];then
	use_wanoperators=$operators2_config
	sed -e "s/^/-A wanoperators &/g" -e "1 i\-N wanoperators nethash --hashsize 91260" $use_wanoperators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	iptables -t mangle -A PREROUTING  -m set --match-set wanoperators dst  -j MARK --set-mark 7777
	iptables -t mangle -A PREROUTING  -m set ! --match-set wanoperators dst -j MARK --set-mark 8888
	iptables -t mangle -A OUTPUT  -m set --match-set wanoperators dst  -j MARK --set-mark 7777
	iptables -t mangle -A OUTPUT  -m set ! --match-set wanoperators dst -j MARK --set-mark 8888
else
	use_wan1operators=$operators1_config
	sed -e "s/^/-A wan1operators &/g" -e "1 i\-N wan1operators nethash --hashsize 91260" $use_wan1operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	use_wan2operators=$operators2_config
	sed -e "s/^/-A wan2operators &/g" -e "1 i\-N wan2operators nethash --hashsize 4096" $use_wan2operators | awk '{print $0} END{print "COMMIT"}' | ipset -R
	iptables -t mangle -A PREROUTING -m set --match-set wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
	iptables -t mangle -A PREROUTING -m set ! --match-set wan1operators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
	iptables -t mangle -A PREROUTING -m set --match-set wan1operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set --match-set wan2operators dst  -j MARK --set-mark 8888 >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set ! --match-set wan1operators dst -j MARK --set-mark $operators_foreign >/dev/null 2>&1
	iptables -t mangle -A OUTPUT -m set --match-set wan1operators dst -j MARK --set-mark 7777 >/dev/null 2>&1
fi
if [ ! -z "$shadowsocks_server_ip" ] && [ "$ss_mode" != "0" ];then
	ip rule add from $shadowsocks_server_ip table $sstable pref 123
	ip rule add to $shadowsocks_server_ip table $sstable pref 124
fi
ip rule add fwmark 7777 table 100 pref 555
ip rule add fwmark 8888 table 200 pref 666
ip route flush cach
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
