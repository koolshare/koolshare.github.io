#!/bin/sh

PhddnsPath=/koolshare/phddns
StatusFile=$PhddnsPath/config/oraysl.status

ORAYSL_PID=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`
ORAYNEWPH_PID=`ps | grep "oraynewph" | grep -v 'grep' | awk '{print $1}'`
ORAYNEWPH_COMMAND="$PhddnsPath/oraynewph -s 0.0.0.0 >/dev/null 2>&1 &"
ORAYSL_COMMAND="$PhddnsPath/oraysl -a 127.0.0.1 -p 16062 -s phsle01.oray.net:80 -d >/dev/null 2>&1 &"


checkoraysl(){
    ORAYSL_PID=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`
    if [ -z $ORAYSL_PID ]; then
                $ORAYSL_COMMAND
                echo "oraysl started"
        fi
}
checkoraynewph(){
    ORAYNEWPH_PID=`ps | grep "oraynewph" | grep -v 'grep' | awk '{print $1}'`
        if  [ -z $ORAYNEWPH_PID ]; then
               $ORAYNEWPH_COMMAND
                echo "oraynewph started"
        fi
}

getStatus() {
    if [ -f "$StatusFile" ]; then
        txt=`cat "$StatusFile"|tr '\n' '$'`
        phddns_basic_info=`dbus get phddns_basic_info`
        if [ "$txt" != "$phddns_basic_info" ];then
            dbus set phddns_basic_info=$txt
        fi
    fi
}

while true
    do 
        checkoraysl  &
        checkoraynewph  &
        getStatus &
        sleep 20
    done
