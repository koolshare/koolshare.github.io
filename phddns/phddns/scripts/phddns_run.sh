#!/bin/sh

source /koolshare/scripts/base.sh

PhddnsPath=/koolshare/phddns
ORAY_DAEMON="/koolshare/phddns/phddns_daemon.sh"

###start peanuthull###
start()
{

killall oraysl
killall oraynewph

$PhddnsPath/oraysl  -a 127.0.0.1 -p 16062 -s phsle01.oray.net:80 -d > /dev/null 2>&1
$PhddnsPath/oraynewph -s 0.0.0.0 & > /dev/null 2>&1 &
$ORAY_DAEMON >/dev/null 2>&1 &
}

##stop peanuthull###
stop()
{

killall phddns_daemon.sh
killall oraysl
killall oraynewph

##clean the statu file##
rm -rf $PhddnsPath/config/oraysl.status
}

reset(){
    
rm -rf /jffs/configs/init.status
rm -rf /jffs/configs/PhMain.ini
    
}

case $ACTION in 
start)
        start
        exit 0
        ;;
stop)
        stop 
        exit 0
        ;;
reset)
        reset
        exit 0
        ;;
*)
        echo "Usage : $0(start|stop|reset)"
        exit 1
        ;;
esac
