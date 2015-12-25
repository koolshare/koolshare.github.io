#!/bin/sh
eval `dbus export shadowvpn`

PID=$(cat $pidfile 2>/dev/null)

echo "$(date '+%c') up.$1 ShadowVPN[$PID] $2"

# Configure IP address and MTU of VPN interface
ip addr add $net dev $intf
ip link set $intf mtu $mtu
ip link set $intf up

# Get original gateway
if [ "$shadowvpn_wan" == "2" ];then
  gateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/' |sed -n 3p)
  #gateway=`nvram get wan1_gateway`
  else
  gateway=$(ip route show 0/0 | sed -e 's/.* via \([^ ]*\).*/\1/' |sed -n 2p)
  #gateway=`nvram get wan0_gateway`
fi
echo "$(date '+%c') The default gateway: via $gateway"

# Turn on NAT over VPN
iptables -t nat -A POSTROUTING -o $intf -j MASQUERADE
iptables -I FORWARD 1 -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o $intf -j ACCEPT
echo "$(date '+%c') Turn on NAT over $intf"

# Change routing table
ip route add $server via $gateway
ip route add   0/1 dev $intf
ip route add 128/1 dev $intf
echo "$(date '+%c') Default route changed to VPN tun"

# Load route rules
if [ "$shadowvpn_mode" == 1 -a -f "$shadowvpn_file" ]; then
  suf="via $gateway"
	grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}" $shadowvpn_file >/tmp/shadowvpn_routes
	sed -e "s/^/route add /" -e "s/$/ $suf/" /tmp/shadowvpn_routes | ip -batch -
	echo "$(date '+%c') Route rules have been loaded"
fi

echo "$(date '+%c') Script $0 completed"

