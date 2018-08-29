#! /bin/sh
eval `dbus export koolproxy`
source /koolshare/scripts/base.sh

case $ACTION in
start)
	sh /koolshare/koolproxy/kp_config.sh start
	;;
*)
	if [ "$koolproxy_enable" == "1" ];then
		sh /koolshare/koolproxy/kp_config.sh restart  > /tmp/koolproxy_run.log
	else
		sh /koolshare/koolproxy/kp_config.sh stop  > /tmp/koolproxy_run.log
	fi
	echo XU6J03M6 >> /tmp/koolproxy_run.log
	sleep 1
	rm -rf /tmp/koolproxy_run.log
	;;
esac