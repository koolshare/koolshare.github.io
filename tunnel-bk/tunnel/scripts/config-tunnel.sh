#!/bin/sh

eval `dbus export tunnel_`
source /koolshare/scripts/base.sh

onstart() {

killall tunnel || true
txt=$tunnel_txt
en=$tunnel_enable

if [ -z "$txt" ]; then
echo "not config"
else

if [ "$en" == "1" ]; then
touch /tmp/tunnel.log
echo $txt|base64_decode > /tmp/tunnel.json
tunnel -c /tmp/tunnel.json -p /tmp/tunnel.pid -d &
fi
fi

}

case $ACTION in
start)
	onstart
	;;
*)
	onstart
	;;
esac  
