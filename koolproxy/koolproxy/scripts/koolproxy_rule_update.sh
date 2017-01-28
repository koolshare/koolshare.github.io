#! /bin/sh
# 导入skipd数据
eval `dbus export koolproxy`

koolproxy_update_server=http://rules.ngrok.wang:5000
web_info=`curl -s http://rules.ngrok.wang:5000/version`

update_kp_rules(){
	rm -rf /tmp/version
	wget -qP /tmp/ $koolproxy_update_server/version
	if [ "$?" == "0" ]; then
		echo $(date): =================== 在线版本检测 ===================
		echo $(date): 检测到在线版本，开启更新主进程...
		
		# 检查静态规则更新
		rm -rf /tmp/koolproxy.txt
		wget -qP /tmp/ $koolproxy_update_server/koolproxy.txt
		if [ "$?" == "0" ]; then
		
			rules_md5_local=`md5sum /koolshare/koolproxy/data/koolproxy.txt | awk '{print $1}'`
			rules_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==2{print}'`
			rules_nu_local=`cat /koolshare/koolproxy/data/koolproxy.txt | grep -v ! | wc -l`
		
			rules_md5_web=`cat /tmp/version | awk 'NR==1{print}'`
			rules_date_web=`cat /tmp/version | awk 'NR==2{print}'`
			rules_nu_web=`cat /tmp/koolproxy.txt | grep -v ! | wc -l`
			
			if [ "$rules_md5_web"x = "$rules_md5_local"x ];then
				echo $(date): =================== 静态规则更新 ===================
				echo $(date): 本地静态规则md5：$rules_md5_local
				echo $(date): 本地静态规则日期：$rules_date_local
				echo $(date): 本地静态规则条数：$rules_nu_local
				echo $(date): -------------------------------------------------
				echo $(date): 在线静态规则md5：$rules_md5_web
				echo $(date): 在线静态规则日期：$rules_date_web
				echo $(date): 在线静态规则条数：$rules_nu_web
				echo $(date): -------------------------------------------------
				echo $(date): 静态规则版本未变化，不应用静态规则更新！
			else
				echo $(date): =================== 静态规则更新 ===================
				echo $(date): 本地静态规则md5：$rules_md5_local
				echo $(date): 本地静态规则日期：$rules_date_local
				echo $(date): 本地静态规则条数：$rules_nu_local
				echo $(date): -------------------------------------------------
				echo $(date): 在线静态规则md5：$rules_md5_web
				echo $(date): 在线静态规则日期：$rules_date_web
				echo $(date): 在线静态规则条数：$rules_nu_web
				echo $(date): -------------------------------------------------
				echo $(date): 静态规则成功检测到更新，开始更新静态规则！
				cp -f /tmp/koolproxy.txt /koolshare/koolproxy/data/
				echo $(date): 静态规则更新成功!
				reboot="1"
			fi
		else
			echo $(date): 视频规则下载失败! 请检查你的网络！
		fi
		sleep 1
		rm -rf /tmp/koolproxy.txt
		
		# 检查视频规则更新
		rm -rf /tmp/1.dat
		wget -qP /tmp/ "$koolproxy_update_server"/1.dat
		if [ "$?" == "0" ]; then
			video_md5_local=`md5sum /koolshare/koolproxy/data/1.dat | awk '{print $1}'`
			video_date_local=`cat /koolshare/koolproxy/data/version|awk 'NR==4{print}'`
		
			video_md5_web=`cat /tmp/version | awk 'NR==3{print}'`
			video_date_web=`cat /tmp/version | awk 'NR==4{print}'`
			if [ "$video_md5_local"x = "$video_md5_web"x ];then
				echo $(date): =================== 视频规则更新 ===================
				echo $(date): 本地视频规则md5：$video_md5_local
				echo $(date): 本地视频规则日期：$video_date_local
				echo $(date): -------------------------------------------------
				echo $(date): 在线视频规则md5：$video_md5_web
				echo $(date): 在线视频规则日期：$video_date_web
				echo $(date): -------------------------------------------------
				echo $(date): 视频规则版本未变化，不应用视频规则更新！
				echo $(date): =================================================
			else
				echo $(date): =================== 视频规则更新 ===================
				echo $(date): 本地视频规则md5：$video_md5_local
				echo $(date): 本地视频规则日期：$video_date_local
				echo $(date): -------------------------------------------------
				echo $(date): 在线视频规则md5：$video_md5_web
				echo $(date): 在线视频规则日期：$video_date_web
				echo $(date): -------------------------------------------------
				echo $(date): 视频规则成功检测到更新，开始更新视频规则！
				cp -f /tmp/1.dat /koolshare/koolproxy/data/
				echo $(date): 视频规则更新成功!
				reboot="1"
			fi
		else
			echo $(date): 视频规则下载失败! 请检查你的网络！
		fi
		sleep 1
		rm -rf /tmp/1.dat
		mv -f /tmp/version /koolshare/koolproxy/data/
	else
		echo $(date): =================== 在线版本检测 ===================
		echo $(date): 检测在线版本号错误! 请检查你的网络！
		echo $(date): =================== 结束更新进程 ===================
		exit
	fi
	sleep 1
	rm -rf /tmp/version
	
	
	# 应用更新
	if [ "$reboot" == "1" ] && [ "$koolproxy_enable" == "1" ];then
		echo $(date): ================== koolproxy重启 =================
		echo $(date): 自动重启koolproxy插件，以应用新的规则文件！请稍后！ >> /tmp/syscmd.log
		sh /koolshare/koolproxy/koolproxy.sh restart
		echo $(date): =================================================
	fi

}

update_kp_rules  > /tmp/koolproxy_run.log
echo XU6J03M6 >> /tmp/koolproxy_run.log
sleep 1
rm -rf /tmp/koolproxy_run.log

