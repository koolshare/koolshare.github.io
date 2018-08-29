#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export koolnet`

PROCS=/koolshare/bin/koolnet
SERVICE_DAEMONIZE=1
SERVICE_WRITE_PID=1
SERVICE_PID_FILE=/tmp/var/koolnet.pid
ARGS="/tmp/koolnet.json"

koolnet_start() {

if [ "$koolnet_enable" == "1" ] ; then
if [ ! -f $PROCS ]; then
	start_download
fi

if [ ! -z $koolnet_txt ] ; then
echo $koolnet_txt|base64_decode > /tmp/koolnet.json
kservice_start $PROCS $ARGS
fi

fi

}


case $ACTION in
start)
    koolnet_start
    ;;
stop | kill )
    kservice_stop $PROCS
    ;;
restart)
    kservice_stop $PROCS
    koolnet_start
    ;;
*)
    kservice_stop $PROCS
    koolnet_start
    ;;
esac
