#!/bin/sh
#
#迅雷远程 Xware V1 守护进程脚本
#脚本版本：2016-11-21-001
#改进作者：泽泽酷儿
#1.本脚本仅适用于迅雷远程V1系列，启动时自动生成守护进程；使用者需自行手动设置自启动。直接运行命令为：sh /脚本路径/脚本名称；
#2.可自动判断迅雷远程的关键进程崩溃情况，并自动重启；
#3.适当限制线程数量区间，避免迅雷远程反复重启，避免设备 CPU 负载过大；
#4.添加日志循环清空重写指令，避免日志叠加写入，避免浪费闪存空间，影响闪存寿命；
#5.可自定义命令循环周期；
#6.支持自动安装迅雷远程 Xware V1。只要把脚本的安装路径设置正确，运行脚本即可自动完成迅雷远程安装并启动守护进程。激活码的中文提示信息见日志；
#
SCRIPTS_FILE="$(basename $0)"																						#本脚本的文件名称，读取名称，不可以自定义
LOCAL_DIR=$(cd "$(dirname "$0")"; pwd)																				#本脚本的保存路径，读取路径，不可以自定义
LOG_FILE="$(basename $0).log"																						#日志文件名称，可以自定义
LOG_DIR=$(cd "$(dirname "$0")"; pwd)																				#日志保存路径，可以自定义
LOG_FULL="${LOG_DIR}"/"${LOG_FILE}"
cat /dev/null > "${LOG_FULL}"
if [ -e "/jffs/.koolshare/thunder" ]; then																			#判断是否已安装 Koolshare 梅林软件中心的迅雷远程
		echo -e "$(date +%Y年%m月%d日\ %X)： 已检测到 Koolshare 梅林固件软件中心的迅雷远程，将优先调用该软件……" >> "${LOG_FULL}"
		PROCESS_1=thunder																							#进程名称为安装路径中的关键词
		INSTALL_DIR=/jffs/.koolshare/thunder																		#Koolshare 梅林软件中心的迅雷远程安装路径，不可以自定义
else
		echo -e "$(date +%Y年%m月%d日\ %X)： 开始检测自行安装的迅雷远程……" >> "${LOG_FULL}"
		PROCESS_1=xunlei																							#进程名称为安装路径中的关键词
		INSTALL_DIR=/jffs/xunlei																					#自行安装的迅雷远程路径，需要自定义
fi
check_autorun()
{
CWS_X="sh ${LOCAL_DIR}/$(basename $0) &"
if [ -f "/usr/bin/dbus" ]; then
	EOC=`dbus list __|grep "${LOCAL_DIR}/$(basename $0)"`
	Key1=`dbus list __|grep "${LOCAL_DIR}/$(basename $0)"|awk -F = '{print $1}'`	
	Key2=`dbus list __|grep "${LOCAL_DIR}/$(basename $0)"|awk -F = '{print $2}'`
	if [ "${EOC}" ]; then
		echo "$(date +%Y年%m月%d日\ %X)： 存在默认自启动方案，正在删除该方案……"
		dbus remove "${Key1}" "${Key2}"
	fi
fi
if [ -f "${LOCAL_DIR}/wan-start" ]; then
	CWS=`cat ${LOCAL_DIR}/wan-start|grep "${CWS_X}"`
	if [ -z "${CWS}" ]; then
		echo "$(date +%Y年%m月%d日\ %X)： 调整自启动方案，启用多线程并发自启动方案……"
		sed -i "1a ${CWS_X}" "${LOCAL_DIR}/wan-start"
	else
		echo "$(date +%Y年%m月%d日\ %X)： 清除可能引起冲突的自启动命令……"
		sed -i "/$(basename $0)/d" "${LOCAL_DIR}/wan-start"
		echo "$(date +%Y年%m月%d日\ %X)： 启用用多线程并发自启动方案……"
		sed -i "1a ${CWS_X}" "${LOCAL_DIR}/wan-start"	
	fi
else
	cat > "${LOCAL_DIR}/wan-start" <<EOF
#!/bin/sh
${CWS_X}
EOF
fi
chmod 755 "${LOCAL_DIR}/wan-start"
if [ -z "$(dbus list __|grep "${LOCAL_DIR}/wan-start")" ]; then
		echo "$(date +%Y年%m月%d日\ %X)： 将多线程并发自启动脚本添加到系统自启动……"
		dbus event onwanstart_wan-start "${LOCAL_DIR}/wan-start"
fi
}
check_xware_process_quantity()
{
ps|grep "${PROCESS_1}"|grep -v grep|wc -l
}
check_xware_process_details()
{
echo "******************************    迅雷远程线程详情    ******************************"
ps|grep "${PROCESS_1}"|grep -v grep|awk '{print}'																	#获取迅雷远程相关进程的所有线程详情
echo "**************************    迅雷远程的总线程数量：$(check_xware_process_quantity)    **************************"
}
check_xware_link_status()
{
rm -rf getsysinfo.txt
wget -c -N -q --tries=3 --timeout=5 -O getsysinfo.txt http://127.0.0.1:9000/getsysinfo
		if [ -e "getsysinfo.txt" ]; then
				ACTIVE_CODE=`cut -d '"' -f2 getsysinfo.txt`
				USER_ID=`cut -d '"' -f6 getsysinfo.txt`
				if [ $ACTIVE_CODE ]; then
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程尚未绑定用户及设备，请尽快完成绑定！"
						echo "$(date +%Y年%m月%d日\ %X)： 你的迅雷远程激活码是：$ACTIVE_CODE"
				elif [ $USER_ID ]; then
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程与服务器连接正常！"
						echo "$(date +%Y年%m月%d日\ %X)： 设备绑定的用户名为：$USER_ID"
				else
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程与服务器失去响应，正在重启……"
						./portal
						check_xware_process_details
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程已重启完成！"						
						wget -c -N -q --tries=3 --timeout=5 -O getsysinfo.txt http://127.0.0.1:9000/getsysinfo
						if [ ! $ACTIVE_CODE ] && [ ! $USER_ID ]; then
								echo "$(date +%Y年%m月%d日\ %X)： 网络连接异常，请检查网络连接状态！"
						fi
				fi
		else
				echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程安装错误，请重新安装……"
		fi
}
create_xware_guard_monitor()
{
cd /tmp
if [ ! -e check_xware_guard.sh ]; then
cat > "check_xware_guard.sh" <<EOF
#!/bin/sh
#
sleep 1m
check_xware_guard()
{
while true; do
		COUNT_xware_guard=\`ps|grep "sh\(.*\)$(basename $0)"|grep -v grep|wc -l\`
		PID_xware_guard=\`ps|grep "sh\(.*\)$(basename $0)"|grep -v grep|awk '{print \$1}'\`
		if [ "\${COUNT_xware_guard}" -gt "1" ]; then
				kill \${PID_xware_guard}
				sh ${LOCAL_DIR}/$(basename $0)
		elif [ "\${COUNT_xware_guard}" -eq "0" ]; then
				sh ${LOCAL_DIR}/$(basename $0)
		fi
		sleep 1m
done
}
check_xware_guard>>/dev/null 2>&1 &
EOF
chmod 755 "check_xware_guard.sh"
fi
}
check_xware_guard_process()
{
create_xware_guard_monitor
PID_check_xware_guard=`ps|grep check_xware_guard|grep -v grep|awk '{print $1}'`
if [ -z "${PID_check_xware_guard}" ]; then
		sh check_xware_guard.sh
fi
}
check_xware()
{
while true; do
		check_autorun
		COUNT_1=`ps|grep "${PROCESS_1}"|grep -v grep|wc -l`															#统计迅雷远程相关进程的总线程数量
		PID_1=`ps|grep "${PROCESS_1}"|grep -v grep|awk '{print $1}'`													#获取迅雷远程相关进程的所有线程 PID
		check_xware_process_details
		cd $INSTALL_DIR
		chmod 777 * -R
		if [ -e lib ]; then
				echo "$(date +%Y年%m月%d日\ %X)： 当前脚本的绝对路径为 \"$LOCAL_DIR\"，脚本的文件名称为 \"$SCRIPTS_FILE\""
				echo "$(date +%Y年%m月%d日\ %X)： 导出日志的绝对路径为 \"$LOG_DIR\"，日志的文件名称为 \"$LOG_FILE\""
				echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程的安装路径为 \"$INSTALL_DIR\"，守护进程的名称为 \"$PROCESS_1\""
				if ( ! grep -qE 'EmbedThunderManager|ETMDaemon|vod_httpserver' "${LOG_FULL}" ); then				#判断迅雷远程关键进程如果没有全部正在运行
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程关键进程未运行，正在启动……"
						./portal																					#重新启动迅雷远程
						check_xware_process_details
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程已启动完成！"
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程守护进程运行正常！"
				elif [ "${COUNT_1}" -lt "3" ]; then																	#判断迅雷远程关键进程正在运行，且线程数量小于3
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程运行异常，正在重启……"
						./portal																					#重新启动迅雷远程
						check_xware_process_details
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程已重启完成！"
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程守护进程运行正常！"
				elif [ "${COUNT_1}" -ge "3" ] && [ "${COUNT_1}" -le "15" ]; then									#判断迅雷远程关键进程正在运行，且线程数量大于或等于3且小于或等于15
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程运行正常！"
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程守护进程运行正常！"
				elif [ "${COUNT_1}" -gt "15" ]; then																#判断迅雷远程关键进程正在运行，且线程数量大于15
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程线程过多，设备负载过大，正在重启……"
						./portal																					#重新启动迅雷远程
						check_xware_process_details
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程已重启完成！"
						echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程守护进程运行正常！"
				fi
		elif [ -e portal ]; then
				echo "$(date +%Y年%m月%d日\ %X)： 已检测到迅雷远程安装包，正在进行安装……"
				./portal
				check_xware_process_details
				echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程安装完成！"
		else
				echo "$(date +%Y年%m月%d日\ %X)： 迅雷远程未安装或安装路径设置错误，请检查安装情况并设置正确的安装路径！"
		fi
		check_xware_link_status
		sleep 10m																									#本脚本的循环执行周期为10分钟(秒单位为s，分钟单位为m，小时单位为h)
		if ( grep -qE 'THE ACTIVE CODE IS: ' "${LOG_FULL}" ); then
				./portal -s    
		fi
		cat /dev/null > "${LOG_FULL}"																				#清空日志内容(按周期循环重写，日志文件体积不会无限变大。如果需要查看历史日志，本行命令可以删除或用#注释掉)
done
}
check_xware>>"${LOG_FULL}" 2>&1 &
check_xware_guard_process>>"${LOG_FULL}" 2>&1 &