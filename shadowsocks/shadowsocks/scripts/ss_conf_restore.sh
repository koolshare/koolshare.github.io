#!/bin/sh

confs=`cat /tmp/ss_conf_backup.txt`

format=`echo $confs|grep "{"`

if [ -z "$format" ];then

	while read conf
	do
	# echo $conf
		dbus set $conf >/dev/null 2>&1
	done </tmp/ss_conf_backup.txt

	dbus remove ss_basic_state_china
	dbus remove ss_basic_foreign_china
	dbus set ss_basic_version=`cat /koolshare/ss/version`

else

	servers=$(cat /tmp/ss_conf_backup.txt |grep -w server|sed 's/"//g'|sed 's/,//g'|cut -d ":" -f 2)
	ports=`cat /tmp/ss_conf_backup.txt |grep -w server_port|sed 's/"//g'|sed 's/,//g'|cut -d ":" -f 2`
	passwords=`cat /tmp/ss_conf_backup.txt |grep -w password|sed 's/"//g'|sed 's/,//g'|cut -d ":" -f 2`
	methods=`cat /tmp/ss_conf_backup.txt |grep -w method|sed 's/"//g'|sed 's/,//g'|cut -d ":" -f 2`
	remarks=`cat /tmp/ss_conf_backup.txt |grep -w remarks|sed 's/"//g'|sed 's/,//g'|cut -d ":" -f 2`
	
	# flush previous test value in the table
	webtest=`dbus list ssconf_basic_webtest_ | sort -n -t "_" -k 4|cut -d "=" -f 1`
		for line in $webtest
		do
			dbus remove "$line"
		done
	
	# flush previous ping value in the table
	pings=`dbus list ssconf_basic_ping | sort -n -t "_" -k 4|cut -d "=" -f 1`
		for ping in $pings
		do
			dbus remove "$ping"
		done
	
	
	last_node=`dbus list ssconf_basic_server|cut -d "=" -f 1| cut -d "_" -f 4| sort -nr|head -n 1`
	if [ ! -z "$last_node" ];then
	k=`expr $last_node + 1`
	else
	k=1
	fi
	min=1
	max=`cat /tmp/ss_conf_backup.txt |grep -wc server`
	while [ $min -le $max ]
	do
	    echo "==============="
	    echo import node $min
	    echo $k
	    
	    server=`echo $servers | awk "{print $"$min"}"`
		port=`echo $ports | awk "{print $"$min"}"`
		password=`echo $passwords | awk "{print $"$min"}"`
		method=`echo $methods | awk "{print $"$min"}"`
		remark=`echo $remarks | awk "{print $"$min"}"`
		
		echo $server
		echo $port
		echo $password
		echo $method
		echo $remark
		
		dbus set ssconf_basic_server_"$k"="$server"
		dbus set ssconf_basic_port_"$k"="$port"
		dbus set ssconf_basic_password_"$k"="$password"
		dbus set ssconf_basic_method_"$k"="$method"
		dbus set ssconf_basic_name_"$k"="$remark"
	    min=`expr $min + 1`
	    k=`expr $k + 1`
	done  

fi
	sleep 3
	rm -rf /tmp/ss_conf_backup.txt
