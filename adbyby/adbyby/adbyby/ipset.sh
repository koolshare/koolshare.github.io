#!/bin/sh
ipset -N adbyby_list hash:ip
iptables -t nat -A PREROUTING -p tcp -m set --match-set adbyby_list dst -j REDIRECT --to-port 8118

sed -e '/.*adbyby_host.conf/d' -i /etc/dnsmasq.conf
echo "conf-file=/tmp/adbyby_host.conf" >> "/etc/dnsmasq.conf"

#/etc/storage/dnsmasq/dnsmasq.conf
restart_dhcpd
/etc/init.d/dnsmasq restart