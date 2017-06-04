#!/bin/sh
eval `dbus export appledns`
CONFIG="/koolshare/appledns"
[ "$appledns_wan" == "1" ] && appledns_config="$CONFIG/tel.json"
[ "$appledns_wan" == "2" ] && appledns_config="$CONFIG/cmc.json"
[ "$appledns_wan" == "3" ] && appledns_config="$CONFIG/cnc.json"

if [ ! -d "/jffs/configs/dnsmasq.d" ];then
mkdir -p /jffs/configs/dnsmasq.d/
fi
avgcompare(){
  for ip_addr in $*
  do
  avgtime=`ping -s 1000 -c 2 $ip_addr |awk -F'/' '/round-trip/ {print $4}'|sed 's/\.//g'`
  lossnum=`ping -s 1000 -c 2 $ip_addr |awk '/loss/{split($7,a,"%");print a[1]}'`
  echo "$ip_addr  $avgtime"
  if [ "$avgtime" != "" -a $lossnum -eq 0 ];then
  if [ $avgtime -le $compare ];then
  ip_addr_sel=$ip_addr
  compare=$avgtime
  fi
  fi
  done
  #echo $ip_addr_sel
}
dnsmasq(){
for domain in $*
do
if [ "$domain" != "itunes.apple.com" -a "$ip_addr_sel" != "" ];then
echo "address=/$domain/$ip_addr_sel" >>/jffs/configs/dnsmasq.d/apple.conf
fi
done
$ip_addr_sel=""
}
configuration(){
for i in 3 7 11 15 19
do
eval dm='\$'$i''
eval ia='\$'$((i+2))''
domains=`awk '{printf $0}' $appledns_config |awk -F'[][]' '{print '$dm'}' |sed 's/\"//g;s/ //g;s/,/ /g'`
ip_addrs=`awk '{printf $0}' $appledns_config |awk -F'[][]' '{print '$ia'}' |sed 's/\"//g;s/ //g;s/,/ /g;s/\:443//g'`
compare=10000000
avgcompare $ip_addrs
dnsmasq $domains
done
sleep 2
#cat $CONFIG/appstore |awk '{if( /^a/) {print "address=/"$1".phobos.apple.com""/"$4"" }}' >>/jffs/configs/dnsmasq.d/apple.conf
cat $CONFIG/appstore |awk '/^a/ {print "address=/phobos.apple.com/"$4 }' >>/jffs/configs/dnsmasq.d/apple.conf
awk '!a[$0]++' /jffs/configs/dnsmasq.d/apple.conf >>/jffs/configs/dnsmasq.d/apple.conf.bak
mv /jffs/configs/dnsmasq.d/apple.conf.bak /jffs/configs/dnsmasq.d/apple.conf
}

if [ "$appledns_enable" == "1" ];then
  rm -rf /jffs/configs/dnsmasq.d/apple.conf >/dev/null 2>&1
  configuration
  service restart_dnsmasq
  echo $(date): --------------appledns start!-------------- >> /tmp/syslog.log
 else
  rm -rf /jffs/configs/dnsmasq.d/apple.conf >/dev/null 2>&1
  service restart_dnsmasq
  echo $(date): --------------appledns stop!-------------- >> /tmp/syslog.log
fi
