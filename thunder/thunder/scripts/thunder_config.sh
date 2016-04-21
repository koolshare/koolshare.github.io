#!/bin/sh
eval `dbus export thunder`

thunderPath=/koolshare/thunder
logFile=$thunderPath/getsysinfo
ifthunderExist=$(ps |grep vod_httpserver |grep -v grep)

getInfo() {
	rm -rf $logFile
	wget -q -O $logFile http://127.0.0.1:9000/getsysinfo
	if [ -e $logFile ]; then
		dbus set thunder_basic_info=$(cat "$logFile")
		if [ -n $thunder_basic_info ]; then
			dbus set thunder_basic_status="01"
		fi
	else
		dbus set thunder_basic_info=""
	fi
}

if [ "$thunder_basic_request" = "20" ]; then
	if [ -e $thunderPath/portal ] && [ -x $thunderPath/portal ]; then
		dbus set thunder_basic_status="020"
		dbus set thunder_basic_info=""
		$thunderPath/portal -s
		#dbus remove __event__onwanstart_thunder
		
	else
		dbus set thunder_basic_status="00"
	fi
elif [ "$thunder_basic_request" = "10" ]; then
	if [ -e $thunderPath/portal ] && [ -x $thunderPath/portal ]; then
		dbus set thunder_basic_status="010"
		$thunderPath/portal &
		#dbus event onwanstart_thunder /jffs/scripts/start-thunder.sh
	else
		dbus set thunder_basic_status="00"
	fi
elif [ "$thunder_basic_request" = "00" ]; then
	if [ -n "$ifthunderExist" ]; then
		dbus set thunder_basic_status="01"
		getInfo
	else
		dbus set thunder_basic_status="02"
	fi
elif [ "$thunder_basic_request" = "01" ]; then
	getInfo
elif [ "$thunder_basic_request" = "02" ]; then
	if [ -n "$ifthunderExist" ]; then
		dbus set thunder_basic_status="01"
	else
		dbus set thunder_basic_status="02"
	fi
else
	dbus set thunder_basic_status="00"
fi


dbus save thunder

