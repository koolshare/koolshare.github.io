#!/bin/sh

eval `dbus export ss`
pros=`ps | grep "ss_check" | grep -v grep | grep -v syscmd`

if [ ! -z "$pros" ];then
	sh /koolshare/ss/ssconfig.sh check 
fi
