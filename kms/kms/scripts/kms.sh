#!/bin/sh
# load path environment in dbus databse
eval `dbus export kms`
start_kms(){
	chmod 0755 /koolshare/bin/vlmcsd
	/koolshare/bin/vlmcsd
	touch /jffs/configs/dnsmasq.d/kms.conf
	chmod 0755 /jffs/configs/dnsmasq.d/kms.conf
	echo "srv-host=_vlmcs._tcp.lan,`uname -n`.lan,$k_port,0,100">>/jffs/configs/dnsmasq.d/kms.conf
	nvram set lan_domain=lan
   	nvram commit
	service restart_dnsmasq
# creating iptables rules to firewall-start
   if [ ! -d /jffs/scripts ]; then 
      mkdir -p /jffs/scripts
   fi
   
   if [ ! -f /jffs/scripts/firewall-start ]; then 
      cat > /jffs/scripts/firewall-start <<EOF
#!/bin/sh
EOF
   fi
   
   writenat=$(cat /jffs/scripts/firewall-start | grep "kms")
   if [ -z "$writenat" ];then
	   sed -i "1a sleep 15" /jffs/scripts/firewall-start
	   sed -i '2a /koolshare/scripts/kms.sh' /jffs/scripts/firewall-start
	   sed -i '3a /koolshare/bin/vlmcsd' /jffs/scripts/firewall-start
	   sed -i '4a service restart_dnsmasq' /jffs/scripts/firewall-start
	   chmod +x /jffs/scripts/firewall-start
   fi
	echo $(date): ------------------ Custom operators kms runs!------------------  >> /tmp/syslog.log
}
stop_kms(){
	# clear start up command line in firewall-start
	killall vlmcsd
	rm /jffs/configs/dnsmasq.d/kms.conf
	service restart_dnsmasq
	sed -i '/sleep 15/d' /jffs/scripts/firewall-start >/dev/null 2>&1
	sed -i '/kms/d' /jffs/scripts/firewall-start >/dev/null 2>&1
	sed -i '/vlmcsd/d' /jffs/scripts/firewall-start >/dev/null 2>&1
	sed -i '/service restart_dnsmasq/d' /jffs/scripts/firewall-start >/dev/null 2>&1
	echo $(date): ------------------ Custom operators kms stop!------------------  >> /tmp/syslog.log
	
}

if [ "$kms_enable" == "1" ];then
	stop_kms
   	start_kms
else
  	stop_kms
fi
