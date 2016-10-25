#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export ssconf_basic`

# flush previous test value in the table
webtest=`dbus list ssconf_basic_webtest_ | sort -n -t "_" -k 4|cut -d "=" -f 1`
if [ ! -z "$webtest" ];then
	for line in $webtest
	do
		dbus remove "$line"
	done
fi

# start testing

server_nu=`dbus list ssconf_basic_server | sort -n -t "_" -k 4|cut -d "=" -f 1|cut -d "_" -f 4`

for nu in $server_nu

do
	array1=`dbus get ssconf_basic_server_$nu`
	array2=`dbus get ssconf_basic_port_$nu`
	array3=`dbus get ssconf_basic_password_$nu`
	array4=`dbus get ssconf_basic_method_$nu`
	array5=`dbus get ssconf_basic_use_rss_$nu`
	array6=`dbus get ssconf_basic_onetime_auth_$nu`
	array7=`dbus get ssconf_basic_rss_protocol_$nu`
	array8=`dbus get ssconf_basic_rss_obfs_$nu`
	if [ "$array5" == "1" ];then
cat > /tmp/tmp_ss.json <<EOF
{
    "server":"$array1",
    "server_port":$array2,
    "local_port":23458,
    "password":"$array3",
    "timeout":600,
    "protocol":"$array7",
    "obfs":"$array8",
    "method":"$array4"
}

EOF
		rss-local -b 0.0.0.0 -l 23458 -c /tmp/tmp_ss.json -u -f /var/run/sslocal2.pid >/dev/null 2>&1
		result=`curl -o /dev/null -s -w %{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23458 $ssconf_basic_test_domain`
		# result=`curl -o /dev/null -s -w %{time_connect}:%{time_starttransfer}:%{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23456 https://www.google.com/`
		sleep 1
		dbus set ssconf_basic_webtest_$nu=$result
		sleep 1
		kill -9 `ps|grep ss-local|grep 23458|awk '{print $1}'`
		rm -rf /tmp/tmp_ss.json
	else
		if [ "$array6" == "1" ];then
			ss-local -b 0.0.0.0 -l 23458 -s $array1 -p $array2 -k $array3 -m $array4 -u -A -f /var/run/sslocal3.pid >/dev/null 2>&1
			result=`curl -o /dev/null -s -w %{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23458 $ssconf_basic_test_domain`
			sleep 1
			dbus set ssconf_basic_webtest_$nu=$result
			sleep 1
			kill -9 `ps|grep ss-local|grep 23458|awk '{print $1}'`
		else
			ss-local -b 0.0.0.0 -l 23458 -s $array1 -p $array2 -k $array3 -m $array4 -u -f /var/run/sslocal3.pid >/dev/null 2>&1
			sleep 1
			result=`curl -o /dev/null -s -w %{time_total}:%{speed_download} --socks5-hostname 127.0.0.1:23458 $ssconf_basic_test_domain`
			sleep 1
			dbus set ssconf_basic_webtest_$nu=$result
			sleep 1
			kill -9 `ps|grep ss-local|grep 23458|awk '{print $1}'`
		fi
	fi
done

