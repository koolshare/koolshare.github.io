#! /bin/sh
eval `dbus export KCP`
source /koolshare/scripts/base.sh

# creat dnsmasq.d folder
creat_folder(){
if [ ! -d /koolshare/configs/dnsmasq.d ];then
	mkdir /koolshare/configs/dnsmasq.d
fi
}

# Decteting if jffs partion is enabled
enable_jffs2(){
	if [ ! -d /jffs/scripts ];then
		nvram set jffs2_on=1
		nvram set jffs2_format=1
		nvram set jffs2_scripts=1
		nvram commit
		echo You have to reboot the router and try again. Exiting...
		exit 1
	fi

	jffs2_script=`nvram get jffs2_scripts`
	if [ "$jffs2_script" != "1" ];then
		nvram set jffs2_on=1
		nvram set jffs2_scripts=1
		nvram commit
		echo "auto enable jffs2 scripts"
	fi
}

# Enable service by user choose
apply_KCP(){
	#KCP_basic_action=0 应用所有设置
	#KCP_basic_action=1 应用DNS设置
	#KCP_basic_action=2 应用黑白名单设置
	#KCP_basic_action=3 重启主进程
	
	if [ "$KCP_basic_enable" == "1" ];then
		if [ "$KCP_basic_action" == "0" ];then
			if [ "$KCP_basic_policy" == "1" ]; then
				sh /koolshare/kcptun/stop.sh
				/koolshare/kcptun/gfwlist/start.sh start_all
			elif [ "$KCP_basic_policy" == "2" ]; then
				sh /koolshare/kcptun/stop.sh
				/koolshare/kcptun/chnmode/start.sh start_all
			fi
		elif [ "$KCP_basic_action" == "1" ];then
			if [ "$KCP_basic_policy" == "1" ];then
				sh /koolshare/kcptun/gfwlist/start.sh restart_dns
			elif [ "$KCP_basic_policy" == "2" ];then
				sh /koolshare/kcptun/chnmode/start.sh restart_dns
			fi
			dbus set KCP_basic_action="0"
		elif [ "$KCP_basic_action" == "2" ];then
			if [ "$KCP_basic_policy" == "1" ];then
				sh /koolshare/kcptun/gfwlist/start.sh restart_wb_list
			elif [ "$KCP_basic_policy" == "2" ];then
				sh /koolshare/kcptun/chnmode/start.sh restart_wb_list
			fi
			dbus set KCP_basic_action="0"
		elif [ "$KCP_basic_action" == "3" ];then
			if [ "$KCP_basic_policy" == "1" ];then
				sh /koolshare/kcptun/gfwlist/start.sh restart_addon
			elif [ "$KCP_basic_policy" == "2" ];then
				sh /koolshare/kcptun/chnmode/start.sh restart_addon
			fi
			dbus set KCP_basic_action="0"
		fi
	elif [ "$KCP_basic_enable" == "0" ];then
		sh /koolshare/kcptun/stop.sh
	fi 
}

disable_KCP(){
	sh /koolshare/kcptun/stop.sh
}

print_success_info(){
	if [ "$KCP_basic_mode" == "0" ];then
		echo $(date):
		echo $(date): You have disabled kcptun service
		echo $(date): See you again!
		echo $(date):
		echo $(date): ======================= Shell, web by sadoneli ==========================
	else
		echo $(date):
		echo $(date): kcptun service success applied!
		echo $(date): Any question? find us at http://koolshare.cn
		echo $(date):
		echo $(date): ======================= Shell, web by sadoneli ==========================
	fi
}

set_ulimit(){
	ulimit -n 8192
}

case $ACTION in
start)
	# start is for system startup
	if [ "$KCP_basic_enable" == "1" ];then
	creat_folder
	set_ulimit
    apply_KCP
	fi
	;;
stop | kill )
	disable_KCP
	;;
restart)
	creat_folder
	set_ulimit
	apply_KCP
	print_success_info
	;;
*)
	echo "Usage: $0 (start|stop|restart|restart_kcptun|restart_dns|restart_nat)"
	exit 1
	;;
esac
