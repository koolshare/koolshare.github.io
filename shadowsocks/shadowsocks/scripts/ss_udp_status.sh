#!/bin/sh

eval `dbus export ss`
source /koolshare/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
game_on=`dbus list ss_acl_mode|cut -d "=" -f 2 | grep 3`
[ -n "$game_on" ] || [ "$ss_basic_mode" == "3" ] && mangle=1


check_status(){
	if [ "$ss_basic_udp_boost_enable" == "1" ];then
		if [ "$mangle" == "1" ];then
			if [ "$ss_basic_udp_node" == "$ssconf_basic_node" ];then
				if [ "$ss_basic_udp_software" == "1" ];then
					v1=`pidof speederv1`
					if [ -n "$v1" ];then
						echo UDPspeederV1运行中，pid：$v1
					else
						echo 警告：UDPspeederV1进程未运行！
					fi
				elif  [ "$ss_basic_udp_software" == "2" ];then
					v2=`pidof speederv2`
					if [ -n "$v2" ];then
						echo UDPspeederV2运行中，pid：$v2
					else
						echo 警告：UDPspeederV2进程未运行！
					fi
				elif  [ "$ss_basic_udp_software" == "3" ];then
					raw=`pidof udp2raw`
					if [ -n "$raw" ];then
						echo UDP2raw运行中，pid：$raw
					else
						echo 警告：UDP2raw进程未运行！
					fi
				fi
			else
				echo 加速节点和正在使用的节点不一致，udp加速未运行！
			fi
		else
			echo 当前非游戏模式，或者访问控制中无游戏模式主机，udp加速未运行！
		fi
	else
		echo udp加速开关未启用，udp加速未运行！
	fi
}

if [ "$ss_basic_enable" == "1" ];then
	check_status > /tmp/ss_udp_status.log 2>&1
else
	echo 插件尚未启用！> /tmp/ss_udp_status.log 2>&1
fi
echo XU6J03M6 >> /tmp/ss_udp_status.log