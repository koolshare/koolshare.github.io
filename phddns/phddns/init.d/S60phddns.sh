#!/bin/sh

#proc=`ps | grep oraysl | grep -v "grep" | grep -v "grep"|awk '{print $1}'`
PROC=`pidof oraysl`
start_with_sys(){
    if [ -z "$PROC" ]; then
        /koolshare/scripts/phddns_run.sh start >/dev/null 2>&1
    fi
}

case $1 in
start)
    start_with_sys
    ;;
stop)
    ;;
esac
