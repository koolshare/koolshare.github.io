#!/bin/sh
eval `dbus export phddns`

Phddns=/koolshare/phddns
StatusFile=$Phddns/config/oraysl.status
orayproc=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`

echo "request is:"$phddns_basic_request

########get user info SN and status#####
getStatus()
{
    if [ -f "$StatusFile" ]; then
        txt=`cat "$StatusFile"|tr '\n' '$'`
        dbus set phddns_basic_info=$txt
        if [ -n $phddns_basic_info ]; then
                dbus set phddns_basic_status="01"
        fi
    else
        dbus set phddns_basic_status=""
    fi
}

#####Request processing interface#######
if [ "$phddns_basic_request" = "20" ]; then
    if [ -f $Phddns/oraysl ]; then
        dbus set phddns_basic_status="020"
        dbus set phddns_basic_info=""
        $Phddns/../scripts/phddns_run.sh stop
    else
        dbus set phddns_basic_status="00"
    fi
elif [ "$phddns_basic_request" = "10" ]; then
    getStatus
    if [ -f $Phddns/oraysl ]; then
        dbus set phddns_basic_status="010"
        $Phddns/../scripts/phddns_run.sh start
    else
        dbus set phddns_basic_status="00"
    fi
elif [ "$phddns_basic_request" = "00" ]; then
    if [ -n "$orayproc" ]; then 
        #does not exist oray cloese switch#
        dbus set phddns_basic_status="01"
        getStatus
    else
        dbus set phddns_basic_status="02"
    fi
elif [ "$phddns_basic_request" = "30" ]; then
    if [ -f $Phddns/oraysl ]; then
        $Phddns/../scripts/phddns_run.sh reset
        ##reset success##
        dbus set phddns_basic_status="03"
    else
        dbus set phddns_basic_status="030"
    fi
else
    dbus set phddns_basic_status="00"
fi
#dbus save phddns
