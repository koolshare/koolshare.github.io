#!/bin/sh

eval `dbus export shadowvpn`
PID=$(cat $pidfile 2>/dev/null)
echo "$(date '+%c') down.$1 ShadowVPN[$PID] $2"

# Turn off NAT over VPN
iptables -t nat -D POSTROUTING -o $intf -j MASQUERADE
iptables -D FORWARD -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -D FORWARD -o $intf -j ACCEPT
echo "$(date '+%c') Turn off NAT over $intf"

# Change routing table
ip route del $server
if [ "$shadowvpn_mode" == 2 ]; then
  ip route del 128/1
  ip route del   0/1
	echo "$(date '+%c') Default route changed to original route"
fi

# Remove route rules
if [ -f /tmp/shadowvpn_routes ]; then
	sed -e "s/^/route del /" /tmp/shadowvpn_routes | ip -batch -
	echo "$(date '+%c') Route rules have been removed"
fi

rm -rf /tmp/shadowvpn_routes

echo "$(date '+%c') Script $0 completed"
