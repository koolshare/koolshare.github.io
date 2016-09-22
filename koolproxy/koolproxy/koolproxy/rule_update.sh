#! /bin/sh
# 导入skipd数据
eval `dbus export koolproxy`

info=`curl -s http://entware.mirrors.ligux.com/adblock/info`
rules_date=`echo $info|awk 'NR==2{print}'`
rules_md5=`echo $info|awk 'NR==3{print}'`
video_date=`echo $info|awk 'NR==6{print}`
video_md5=`echo $info|awk 'NR==7{print}'`

rules_md5_local=`md5sum /koolshare/koolproxy/data/koolproxy.txt | awk '{print $1}'`
video_md5_local=`md5sum /koolshare/koolproxy/data/1.dat | awk '{print $1}'`

rules_md5_tmp=`md5sum /tmp/koolproxy.txt | awk '{print $1}'`
video_md5_tmp=`md5sum /tmp/1.dat | awk '{print $1}'`


download_rules(){
	if [ "$koolproxy_update" == "1" ];then
		if [ ! -z "$rules_md5" ];then
			if [ "$rules_md5"x = "$rules_md5_local"x ];then
				echo same version of static rule
			else
				wget -qP /tmp/ http://entware.mirrors.ligux.com/adblock/koolproxy.txt
				if [ "$rules_md5"x = "$rules_md5_tmp"x ];then
					mv /tmp/koolproxy.txt /koolshare/koolproxy/data/
				else
					echo download static rule failue
				fi
			fi
		else
			echo static rule version detect failue
		fi
	else
		echo koolproxy rule update not enabled
	fi
}

download_video(){
	if [ "$koolproxy_update" == "1" ];then
		if [ ! -z "$video_md5" ];then
			if [ "$video_md5"x = "$video_md5_local"x ];then
				echo same version of video rule
			else
				wget -qP /tmp/ http://entware.mirrors.ligux.com/adblock/swf/data/1.dat
				if [ "$video_md5"x = "$video_md5_tmp"x ];then
					mv /tmp/1.dat /koolshare/koolproxy/data/
				else
					echo download video rule failue
				fi
			fi
		else
			echo  video rule version detect failue
		fi
	else
		echo koolproxy rule update not enabled
	fi
}