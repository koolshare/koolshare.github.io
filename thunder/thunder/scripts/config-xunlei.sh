#!/bin/sh
eval `dbus export xunlei`
# xunleiPath=/jffs/xunlei
xunleiPath=$xunlei_basic_usb/Merlin_software/xunlei
logFile=$xunleiPath/getsysinfo
ifXunleiExite=$(ps |grep vod_httpserver |grep -v grep)

getInfo() {
	rm -rf $logFile
	wget -q -O $logFile http://127.0.0.1:9000/getsysinfo
	if [ -e $logFile ]; then
		export xunlei_basic_info=$(cat "$logFile")
		if [ -n $xunlei_basic_info ]; then
			export xunlei_basic_status="01"
		fi
	else
		export xunlei_basic_info=""
	fi
}

if [ "$xunlei_basic_request" = "20" ]; then
	if [ -e $xunleiPath/portal ] && [ -x $xunleiPath/portal ]; then
		export xunlei_basic_status="020"
		export xunlei_basic_info=""
		$xunleiPath/portal -s
		dbus remove __event__onwanstart_xunlei
		
	else
		export xunlei_basic_status="00"
	fi
elif [ "$xunlei_basic_request" = "10" ]; then
	if [ -e $xunleiPath/portal ] && [ -x $xunleiPath/portal ]; then
		export xunlei_basic_status="010"
		$xunleiPath/portal &
		dbus event onwanstart_xunlei /jffs/scripts/start-xunlei.sh
	else
		export xunlei_basic_status="00"
	fi
elif [ "$xunlei_basic_request" = "00" ]; then
	if [ -n "$ifXunleiExite" ]; then
		export xunlei_basic_status="01"
		getInfo
	else
		export xunlei_basic_status="02"
	fi
elif [ "$xunlei_basic_request" = "01" ]; then
	getInfo
elif [ "$xunlei_basic_request" = "02" ]; then
	if [ -n "$ifXunleiExite" ]; then
		export xunlei_basic_status="01"
	else
		export xunlei_basic_status="02"
	fi
else
	export xunlei_basic_status="00"
fi


dbus save xunlei

