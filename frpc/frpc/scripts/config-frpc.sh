#!/bin/sh

eval `dbus export frpc_`
source /koolshare/scripts/base.sh
NAME=frpc
BIN=/koolshare/bin/frpc
INI_FILE=/koolshare/configs/frpc.ini
PID_FILE=/tmp/frpc.pid

onstart() {
killall frpc || true
dbus set frpc_client_version=`${BIN} --version`
en=$frpc_enable
if [ "$en" == "1" ]; then
cat > ${INI_FILE}<<-EOF
[common]
server_addr = $frpc_common_server_addr
server_port = $frpc_common_server_port
privilege_token = $frpc_common_privilege_token
log_file = $frpc_common_log_file
log_level = $frpc_common_log_level
log_max_days = $frpc_common_log_max_days
EOF

server_nu=`dbus list frpc_subname_node | sort -n -t "_" -k 4|cut -d "=" -f 1|cut -d "_" -f 4`
for nu in $server_nu
do
	array_subname=`dbus get frpc_subname_node_$nu`
	array_type=`dbus get frpc_proto_node_$nu`
	array_local_ip=`dbus get frpc_localhost_node_$nu`
	array_local_port=`dbus get frpc_localport_node_$nu`
	array_remote_port=`dbus get frpc_remoteport_node_$nu`
	array_custom_domains=`dbus get frpc_subdomain_node_$nu`
	array_use_encryption=`dbus get frpc_encryption_node_$nu`
	array_use_gzip=`dbus get frpc_gzip_node_$nu`
cat >> ${INI_FILE} <<EOF
[${array_subname}]
privilege_mode = true
type = ${array_type}
local_ip = ${array_local_ip}
local_port = ${array_local_port}
remote_port = ${array_remote_port}
custom_domains = ${array_custom_domains}
use_encryption = ${array_use_encryption}
use_gzip = ${array_use_gzip}
EOF
done
echo -n "starting kcptun..."
start-stop-daemon -S -q -b -m -p ${PID_FILE} -x ${BIN} -- -c ${INI_FILE}
echo " done"
fi
}
stop() {
	echo -n "stop kcptun..."
		killall frpc || true
	echo " done"
}

case $ACTION in
start)
	onstart
	;;
stop)
	stop
	;;
*)
	onstart
	;;
esac  
