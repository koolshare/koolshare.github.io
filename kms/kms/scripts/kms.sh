cd /jffs/
wget "http://cheen.cn/koolshare/kms/vlmcsd.t"
mv vlmcsd.t vlmcsd
chmod 0755 vlmcsd
/jffs/vlmcsd
clear
echo 
netstat -an |grep 1688
echo 
touch /jffs/configs/dnsmasq.d/kms.conf
chmod 0755 /jffs/configs/dnsmasq.d/kms.conf
echo "domain=lan">/jffs/configs/dnsmasq.d/kms.conf
echo "expand-hosts">>/jffs/configs/dnsmasq.d/kms.conf
echo "bogus-priv">>/jffs/configs/dnsmasq.d/kms.conf
echo "local=/lan/">>/jffs/configs/dnsmasq.d/kms.conf
echo "dhcp-option=lan,15,lan">>/jffs/configs/dnsmasq.d/kms.conf
echo "srv-host=_vlmcs._tcp.lan,`uname -n`.lan,1688">>/jffs/configs/dnsmasq.d/kms.conf

service restart_dnsmasq
iptables -I INPUT -p tcp --dport 1688 -j ACCEPT

echo "#!/bin/sh">>/jffs/scripts/firewall-start
echo "/jffs/vlmcsd">>/jffs/scripts/firewall-start
echo "service restart_dnsmasq">>/jffs/scripts/firewall-start
echo "iptables -I INPUT -p tcp --dport 1688 -j ACCEPT">>/jffs/scripts/firewall-start
chmod 0755 /jffs/scripts/firewall-start
