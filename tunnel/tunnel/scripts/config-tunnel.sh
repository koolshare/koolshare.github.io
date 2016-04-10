#!/bin/sh

eval `dbus export tunnel_config`
source /koolshare/scripts/base.sh

onstart() {

killall tunnel
txt=$tunnel_config_txt
en=$tunnel_config_enable

if [ -z "$txt" ]; then
echo "not config"
else

if [ "$en" == "1" ]; then
touch /tmp/tunnel.log
echo $txt|base64_decode > /tmp/tunnel.json
tunnel -c /tmp/tunnel.json -p /tmp/tunnel.pid -d
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
