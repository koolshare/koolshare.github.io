#!/bin/sh
 `dbus  export phddns`


Phddns=/koolshare/phddns
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
                dbus set phddns_basic_status=""
        fi
}

if [ "$phddns_basic_request" = "20"]; then
        if [ -e $Phddns/oraysl ]; then
                dbus set phddns_basic_status="020"
                dbus set phddns_basic_info=""
                $Phddns/oraysl &
        else
                dbus set phddns_basic_status="00"
        fi
elif [ "$phddns_basic_request" = "10"]; then
        #if [ -e $Phddns/oraysl ]; then
                dbus set phddns_basic_status="010"
        #       $Phddns/oraysl &
        #else
        #       dbus set phddns_basic_status="00"
        #fi
elif [ "$phddns_basic_request" = "00" ]; then
        if [ -n "$orayproc" ]; then 
                dbus set phddns_basic_status="01"
                getStatus
        else
                #does not exist oray cloese switch#
                dbus set phddns_basic_status="02"
                
        fi
elif [ "$phddns_basic_request" = "01"]; then
        getStatus
elif [ "$phddns_basic_request" = "02"]; then
        if [ -n "$$orayproc" ]; then
                dbus set phddns_basic_status="01"
        else
                dbus set phddns_basic_status="02"
        fi
else
        dbus set phddns_basic_status="00"
fi

#dbus save phddns
