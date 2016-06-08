#!/bin/sh

PhddnsPath=/koolshare/phddns
ORAY_DAEMON="$PhddnsPath/phddns_daemon.sh"

###start peanuthull###
start()
{
killall oraysl || true
killall oraynewph || true
sleep 1

$PhddnsPath/oraysl -a 127.0.0.1 -p 16062 -s phsle01.oray.net:80 -d >/dev/null 2>&1
$PhddnsPath/oraynewph -s 0.0.0.0  >/dev/null 2>&1 &
sleep 1
$ORAY_DAEMON >/dev/null 2>&1 &
}

##stop peanuthull###
stop()
{

killall phddns_daemon.sh || true
killall oraysl || true
killall oraynewph || true

sleep 1
##clean the statu file##
#rm -rf $PhddnsPath/config/oraysl.status
}

reset(){
rm -rf $PhddnsPath/config/init.status
rm -rf $PhddnsPath/config/PhMain.ini
}

case $1 in 
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
