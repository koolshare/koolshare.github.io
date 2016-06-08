#!/bin/sh
eval `dbus  export phddns`

PhddnsPath=/koolshare/phddns
StatusFile=$Phddns/config/oraysl.status
orayproc=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`

########get user info SN and status#####
getStatus()
{
if [ -e $StatusFile ]; then
        dbus set phddns_basic_info=$(cat "$StatusFile")
        if [ -n $phddns_basic_info ]; then
                dbus set phddns_basic_status ="01"
        fi
else
        dbus set phddns_basic_status = ""
fi
}
#####Request processing interface#######
if [ "$phddns_basic_request" = "20"]; then
        if [ -e $Phddns/oraysl ]; then
                dbus set phddns_basic_status="020"
                dbus set phddns_basic_info=""
                $PhddnsPath/../script/phddns_run.sh stop
        else
                dbus set phddns_basic_status="00"
        fi
elif [ "$phddns_basic_request" = "10"]; then
        if [ -e $Phddns/oraysl ]; then
                dbus set phddns_basic_status ="010"
                $PhddnsPath/../script/phddns_run.sh start
        else
                dbus set phddns_basic_status="00"
        fi
elif [ "$phddns_basic_request" = "00" ]; then
        if [ -n "$orayproc" ]; then 
                #does not exist oray cloese switch#
                dbus set phddns_basic_status ="01"
                getStatus
        else
                dbus set phddns_basic_status ="02"
        fi
elif [ "$phddns_basic_request" = "30"]; then
        if [-e $Phddns/oraysl ]; then
                $PhddnsPath/../script/phddns_run.sh reset
                ##reset success##
                dbus set phddns_basic_status="03"
        else
                dbus set phddns_basic_status="030"
        fi
else
        dbus set phddns_basic_status ="00"
fi

#dbus save phddns
