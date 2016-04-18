#!/bin/sh

eval `dbus export ssconf_basic`

# flush previous ping value in the table
pings=`dbus list ssconf_basic_ping | sort -n -t "_" -k 4|cut -d "=" -f 1`
if [ ! -z "$pings" ];then
	for ping in $pings
	do
		dbus remove "$ping"
	done
fi

# start testing
if [ "$ssconf_basic_Ping_Method" == "1" ];then
	servers=`dbus list ssconf_basic_server | sort -n -t "_" -k 4`
	for server in $servers
	do
		server_mu=`echo $server|cut -d "=" -f 1|cut -d "_" -f 4`
		server_address=`echo $server|cut -d "=" -f 2`
		ping_text=`ping -4 $server_address -c 10 -w 10 -q`
		ping_time=`echo $ping_text | awk -F '/' '{print $4}'`
		ping_loss=`echo $ping_text | awk -F ', ' '{print $3}' | awk '{print $1}'`
	
		if [ ! -z "$ping_time" ];then
			dbus set ssconf_basic_ping_"$server_mu"="$ping_time" ms / "$ping_loss"
		else
			dbus set ssconf_basic_ping_"$server_mu"="failed"
		fi
	done
else

	servers=`dbus list ssconf_basic_server | sort -n -t "_" -k 4`
	for server in $servers
	do
	{
		server_mu=`echo $server|cut -d "=" -f 1|cut -d "_" -f 4`
		server_address=`echo $server|cut -d "=" -f 2`
		[ "$ssconf_basic_Ping_Method" == "2" ] && ping_text=`ping -4 $server_address -c 10 -w 10 -q`
		[ "$ssconf_basic_Ping_Method" == "3" ] && ping_text=`ping -4 $server_address -c 20 -w 20 -q`
		[ "$ssconf_basic_Ping_Method" == "4" ] && ping_text=`ping -4 $server_address -c 50 -w 50 -q`
		ping_time=`echo $ping_text | awk -F '/' '{print $4}'`
		ping_loss=`echo $ping_text | awk -F ', ' '{print $3}' | awk '{print $1}'`
	
		if [ ! -z "$ping_time" ];then
			dbus set ssconf_basic_ping_"$server_mu"="$ping_time" ms / "$ping_loss"
		else
			dbus set ssconf_basic_ping_"$server_mu"="failed"
		fi
	}&
	done

fi

# problem
# servers=`dbus list ssconf_basic_server | sort -n -t "_" -k 4`
# for server in $servers
# do
# 	server_mu=`echo $server|cut -d "=" -f 1|cut -d "_" -f 4`
# 	server_address=`echo $server|cut -d "=" -f 2`
# 	ping_text=`ping -4 $server_address -c 10 -w 10 -q`
# 	ping_time=`echo $ping_text | grep "round-trip" | awk '{print $4}'|cut -d "/" -f 2`
# 	ping_loss=`echo $ping_text | grep "loss" | awk '{print $7}'`
# 	if [ ! -z "$ping_time" ];then
# 		dbus ram ssconf_basic_ping_"$server_mu"="$ping_time" ms
# 	else
# 		dbus ram ssconf_basic_ping_"$server_mu"="failed"
# 	fi
# done

# servers=`dbus list ssconf_basic_server | sort -n -t "_" -k 4`
# for server in $servers
# do
# 	server_mu=`echo $server|cut -d "=" -f 1|cut -d "_" -f 4`
# 	server_address=`echo $server|cut -d "=" -f 2`
# 	ping=`ping -4 $server_address -c 10 -w 10 -q | grep round | awk '{print $4}'|cut -d "/" -f 2`
# 	loss=`ping -4 $server_address -c 10 -w 10 -q | grep loss | awk '{print $7}'`
# 	if [ ! -z "$ping" ];then
# 		dbus ram ssconf_basic_ping_"$server_mu"="$ping" ms / "$loss"
# 	else
# 		dbus ram ssconf_basic_ping_"$server_mu"="failed"
# 	fi
# done

# dbus set ssconf_basic_ping_1="110ms"
# sleep 1
# dbus set ssconf_basic_ping_10="120ms"
# sleep 1
# dbus set ssconf_basic_ping_11="210ms"
# sleep 1
# dbus set ssconf_basic_ping_12="120ms"
# sleep 1
# dbus set ssconf_basic_ping_13="114ms"
# sleep 1
# dbus set ssconf_basic_ping_14="320ms"
# curl -vLo --socks5-hostname 127.0.0.1:23456 https://www.google.com/
# curl -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23456 https://www.google.com/
# curl -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23456 https://www.google.com/


