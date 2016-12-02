#!/bin/sh

source /koolshare/scripts/base.sh

detect_skipd(){
	i=120
	until [ ! -z "$skipd" ]
	do
	    i=$(($i-1))
		skipd=`ps|grep skipd | grep -v grep`
	    if [ "$i" -lt 1 ];then
	    	logger "[软件中心]: 错误：skipd进程未能成功启动！"
	        exit
	    fi
	    sleep 1
	    echo $i
	done
	logger "[软件中心]: skipd进程成功启动！"
}

case $ACTION in
start)
	detect_skipd
	;;
esac
