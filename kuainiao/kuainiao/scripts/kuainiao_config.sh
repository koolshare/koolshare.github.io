#!/bin/sh
eval `dbus export kuainiao`
source /koolshare/scripts/base.sh
version="0.3.1"
kuainiaocru=$(cru l | grep "kuainiao")
startkuainiao=$(ls -l /koolshare/init.d/ | grep "S80Kuainiao")

#双WAN判断
wans_mode=$(nvram get wans_mode)
if [ "$kuainiao_config_wan" == "1" ] && [ "$wans_mode" == "lb" ]; then
	wan_selected=$(nvram get wan0_ipaddr)
	if [ "$wan_selected" != "0.0.0.0" ]; then
		bind_address=$wan_selected
	else
		bind_address=""
	fi
elif [ "$kuainiao_config_wan" == "2" ] && [ "$wans_mode" == "lb" ]; then
	wan_selected=$(nvram get wan1_ipaddr)
	if [ "$wan_selected" != "0.0.0.0" ]; then
		bind_address=$wan_selected
	else
		bind_address=""
	fi
else
	bind_address=""
fi

#定义请求函数
if [ -n "$bind_address" ]; then
	HTTP_REQ="wget --bind-address=$bind_address --no-check-certificate -O - "
	POST_ARG="--post-data="
else
	HTTP_REQ="wget --no-check-certificate -O - "
	POST_ARG="--post-data="
fi

#数据mock
uname=$kuainiao_config_uname
pwd=$kuainiao_config_pwd
devicesign=$kuainiao_device_sign

#获取用户真实MAC地址
get_mac_addr(){
	if [ -n "$bind_address" ] && [ "$kuainiao_config_wan" == "1" ]; then
		nic=wan0_hwaddr
	elif [ -n "$bind_address" ] && [ "$kuainiao_config_wan" == "2" ]; then
		nic=wan1_hwaddr
	else
		nic=wan_hwaddr
	fi
	peerid=$(nvram get $nic|awk 'gsub(/:/, "") {printf("%s", toupper($1))}')004V
}
get_mac_addr
#nic=eth0
#peerid=$(ifconfig $nic|grep $nic|awk 'gsub(/:/, "") {print $5}')004V

#转存参数
dbus set kuainiao_config_nic=$nic
dbus set kuainiao_config_peerid=$peerid
dbus set kuainiao_version=$version

#获取迅雷用户uid
get_xunlei_uid(){
	ret=`$HTTP_REQ --header "User-Agent: android-async-http/xl-acc-sdk/version-1.6.1.177600" https://login.mobile.reg2t.sandai.net:443/ $POST_ARG"{\"userName\": \""$uname"\", \"businessType\": 68, \"clientVersion\": \"2.0.3.4\", \"appName\": \"ANDROID-com.xunlei.vip.swjsq\", \"isCompressed\": 0, \"sequenceNo\": 1000001, \"sessionID\": \"\", \"loginType\": 0, \"rsaKey\": {\"e\": \"010001\", \"n\": \"AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD\"}, \"cmdID\": 1, \"verifyCode\": \"\", \"peerID\": \""$peerid"\", \"protocolVersion\": 108, \"platformVersion\": 1, \"passWord\": \""$pwd"\", \"extensionList\": \"\", \"verifyKey\": \"\", \"sdkVersion\": 177550, \"devicesign\": \""$devicesign"\"}"`
	#判断是否登陆成功
	session=`echo $ret|awk -F '"sessionID":' '{print $2}'|awk -F ',' '{print $1}'|grep -oE "[A-F,0-9]{32}"`

	if [ -z "$session" ]
	  then
		  dbus set kuainiao_warning="迅雷账号登陆失败，请检查输入的用户名密码!"
		  #echo "迅雷账号登陆失败，请检查输入的用户名密码!"
	  else
		  uid=`echo $ret|awk -F '"userID":' '{print $2}'|awk -F ',' '{print $1}'`
		  dbus set kuainiao_config_uid=$uid
	fi
}

#获取加速API
get_kuainiao_api(){
	portal=`$HTTP_REQ http://api.portal.swjsq.vip.xunlei.com:81/v2/queryportal`
	portal_ip=`echo $portal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
	portal_port_temp=`echo $portal|grep -oE "port...[0-9]{1,5}"`
	portal_port=`echo $portal_port_temp|grep -oE '[0-9]{1,5}'`
	if [ -z "$portal_ip" ]
		then
			dbus set kuainiao_warning="迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
			#echo "迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
		else
			api_url="http://$portal_ip:$portal_port/v2"
			dbus set kuainiao_config_api=$api_url
	fi
}

#检测快鸟加速信息
get_bandwidth(){
	if [ -n "$api_url" ]; then
		band=$(bandwidth)
		can_upgrade=`echo $band|awk -F '"can_upgrade":' '{print $2}'|awk -F ',' '{print $1}'`
		dbus set kuainiao_can_upgrade=$can_upgrade
		kuainiao_can_upgrade=$can_upgrade
		#判断是否满足加速条件
		if [[ $can_upgrade -eq 1 ]]; then
			#echo "迅雷快鸟可以加速~~~愉快的开始加速吧~~"
			#获取加速详细信息
			old_downstream=`echo $band|awk -F '"bandwidth":' '{print $2}'|awk -F '"downstream":' '{print $2}'|awk -F ',' '{print $1}'`
			max_downstream=`echo $band|awk -F '"max_bandwidth":' '{print $2}'|awk -F '"downstream":' '{print $2}'|awk -F ',' '{print $1}'`
			dbus set kuainiao_warning="迅雷快鸟可以加速~~~愉快的开始加速吧~~"
			dbus set kuainiao_old_downstream=$old_downstream
			dbus set kuainiao_max_downstream=$max_downstream
		else
			dbus set kuainiao_warning="T_T 不能加速啊，不满足加速条件哦~~"
			#echo "T_T 不能加速啊，不满足加速条件哦~~"
		fi
	fi
}

#检测是否可以使用迅雷快鸟服务
check_kuainiao(){
	portal=`$HTTP_REQ http://api.portal.swjsq.vip.xunlei.com:81/v2/queryportal`
	portal_ip=`echo $portal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
	portal_port_temp=`echo $portal|grep -oE "port...[0-9]{1,5}"`
	portal_port=`echo $portal_port_temp|grep -oE '[0-9]{1,5}'`
	if [ -z "$portal_ip" ]
		then
			#export kuainiao_warning="迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
			echo "迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
		else
			api_url="http://$portal_ip:$portal_port/v2"
			#开始尝试加速
			res=`$HTTP_REQ "$api_url/upgrade?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
			#echo $res
			errno=`echo $res|awk -F '"errno":' '{print $2}'|awk -F ',' '{print $1}'`
			#判断是否加速成功(errno=812的时候为:当前宽带已处于提速状态)
			if [ -n "$errno" ]
				then
					richmessage=`echo $res|awk -F '"richmessage":' '{print $2}'|awk -F ',' '{print $1}'|awk '{sub(/^"*/,"");sub(/"*$/,"")}1'`
					#export kuainiao_warning=$richmessage
					echo $richmessage
				else
					downstream=`echo $ret|awk -F '"downstream":' '{print $2}'|awk -F ',' '{print $1}'`
					upstream=`echo $ret|awk -F '"upstream":' '{print $2}'|awk -F ',' '{print $1}'`
			fi
	fi
}

#检测试用加速信息
query_try_info(){
	info=`$HTTP_REQ "$api_url/query_try_info?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
	echo $info
}
##{"errno":0,"message":"","number_of_try":0,"richmessage":"","sequence":0,"timestamp":1455936922,"try_duration":10}

#检测提速带宽
bandwidth(){
	width=`$HTTP_REQ "$api_url/bandwidth?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
	echo $width
}
##{"bandwidth":{"downstream":51200,"upstream":0},"can_upgrade":1,"dial_account":"100001318645","errno":0,"max_bandwidth":{"downstream":102400,"upstream":0},"message":"","province":"bei_jing","province_name":"北京","richmessage":"","sequence":0,"sp":"cnc","sp_name":"联通","timestamp":1455936922}

#迅雷快鸟加速心跳
kuainiao_keepalive(){
	keepalive=`$HTTP_REQ "$api_url/keepalive?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
	echo $keepalive
}

#快鸟加速注销
kuainiao_recover(){
	recover=`$HTTP_REQ "$api_url/recover?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
	echo $recover
}

#将执行脚本写入crontab定时运行
add_kuainiao_cru(){
	if [ "$kuainiao_can_upgrade" == "1" ] && [ -f /koolshare/kuainiao/kuainiao.sh ]; then
		#确保有执行权限
		chmod +x /koolshare/kuainiao/kuainiao.sh
		cru a kuainiao "*/4 * * * * /koolshare/kuainiao/kuainiao.sh"
	fi
}

#加入开机自动运行
auto_start(){
	if [ "$kuainiao_can_upgrade" == "1" ] && [ "$kuainiao_start" == "1" ] && [ -f /koolshare/kuainiao/kuainiao.sh ]; then
		if [ -f /koolshare/init.d/S80Kuainiao.sh ]; then
			rm -rf /koolshare/init.d/S80Kuainiao.sh
		fi
		cat > /koolshare/init.d/S80Kuainiao.sh <<EOF
#!/bin/sh
cru a kuainiao "*/4 * * * * /koolshare/kuainiao/kuainiao.sh"
dbus ram kuainiao_run_i=6
sh /koolshare/kuainiao/kuainiao.sh
EOF
		chmod +x /koolshare/init.d/S80Kuainiao.sh
	fi
}

#停止快鸟服务
stop_kuainiao(){
	#停掉cru里的任务
	if [ ! -z "$kuainiaocru" ]; then
		cru d kuainiao
	fi
	#停止自启动
	if [ -f /koolshare/init.d/S80Kuainiao.sh ]; then
		rm -rf /koolshare/init.d/S80Kuainiao.sh
	fi
	#清理运行环境临时变量
	dbus remove kuainiao_run_i
	dbus ram kuainiao_run_warnning=""
	dbus ram kuainiao_run_status=0
	dbus remove kuainiao_run_orig_day
	dbus remove kuainiao_run_session
}

##主逻辑
#执行初始化
dbus set kuainiao_warning=""
dbus set kuainiao_can_upgrade=0
stop_kuainiao

if [ "$kuainiao_enable" == "1" ]; then
	#登陆迅雷获取uid
	get_xunlei_uid
	#判断是否登陆成功
	if [ -n "$uid" ]; then
		get_kuainiao_api
		get_bandwidth
		dbus set kuainiao_config_downstream=$(expr $old_downstream / 1024)
		dbus set kuainiao_config_max_downstream=$(expr $max_downstream / 1024)
		#写入crontab
		add_kuainiao_cru
		#开机执行
		auto_start
		#开始初始化执行
		sleep $kuainiao_time
		#判断cru脚本是否正在执行
		kuainiao_is_run=$(ps|grep '/koolshare/kuainiao/kuainiao.sh'|grep -v grep)
		if [ ! -z "$kuainiao_is_run" ]; then
			sleep 5
		fi
		dbus ram kuainiao_run_i=6
		sh /koolshare/kuainiao/kuainiao.sh
	fi
fi
