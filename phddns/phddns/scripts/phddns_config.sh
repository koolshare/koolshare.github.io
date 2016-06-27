#!/bin/sh
eval `dbus export phddns`

Phddns=/koolshare/phddns
StatusFile=$Phddns/config/oraysl.status
orayproc=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`

logger "request is:"$phddns_basic_request

########get user info SN and status#####
getStatus()
{
    if [ -f "$StatusFile" ]; then
        txt=`cat "$StatusFile"|tr '\n' '$'`
        dbus set phddns_basic_info=$txt
    else
        dbus set phddns_basic_status=""
    fi
}

#####Request processing interface#######
if [ "$phddns_basic_request" = "20" ]; then
    if [ -f $Phddns/oraysl ]; then
        dbus set phddns_basic_status="020"
        dbus set phddns_basic_info=""
        sleep 2
        $Phddns/../scripts/phddns_run.sh stop
    else
        dbus set phddns_basic_status="00"
    fi
elif [ "$phddns_basic_request" = "10" ]; then
    if [ -f $Phddns/oraysl ]; then
        dbus set phddns_basic_status="010"
        $Phddns/../scripts/phddns_run.sh start
        sleep 2
    else
        dbus set phddns_basic_status="00"
    fi
    getStatus
elif [ "$phddns_basic_request" = "00" ]; then
    if [ -n "$orayproc" ]; then 
        #does not exist oray cloese switch#
        dbus set phddns_basic_status="01"
        getStatus
    else
        dbus set phddns_basic_status="02"
    fi
elif [ "$phddns_basic_request" = "30" ]; then
    if [ -f $Phddns/config/PhMain.ini ]; then
        $Phddns/../scripts/phddns_run.sh reset
        ##reset success##
        dbus set phddns_basic_status="010"
        dbus set phddns_reset_status="01"
        sleep 2
    else
        dbus set phddns_reset_status="00"
    fi
else
    dbus set phddns_basic_status="00"
fi

sleep 2
#dbus save phddns
