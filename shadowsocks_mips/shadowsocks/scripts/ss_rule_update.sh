#!/bin/sh
eval `dbus export ss`
source /koolshare/scripts/base.sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")

# version dectet
version_gfwlist1=$(cat /jffs/ss/cru/version | sed -n 1p | sed 's/ /\n/g'| sed -n 1p)
version_chnroute1=$(cat /jffs/ss/cru/version | sed -n 2p | sed 's/ /\n/g'| sed -n 1p)
version_cdn1=$(cat /jffs/ss/cru/version | sed -n 4p | sed 's/ /\n/g'| sed -n 1p)

echo ========================================================================================================== >> /tmp/syscmd.log
echo $(date): 开始更新shadowsocks规则，请等待... > /tmp/syscmd.log
wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/version1 > /tmp/version1
online_content=$(cat /tmp/version1)
if [ -z "$online_content" ];then
	rm -rf /tmp/version1
	echo $(date): 没有检测到在线版本欸，可能是访问github有问题，去大陆白名单模式试试吧！ >> /tmp/syscmd.log
	exit
fi


git_line1=$(cat /tmp/version1 | sed -n 1p)
git_line2=$(cat /tmp/version1 | sed -n 2p)
git_line4=$(cat /tmp/version1 | sed -n 4p)

version_gfwlist2=$(echo $git_line1 | sed 's/ /\n/g'| sed -n 1p)
version_chnroute2=$(echo $git_line2 | sed 's/ /\n/g'| sed -n 1p)
version_cdn2=$(echo $git_line4 | sed 's/ /\n/g'| sed -n 1p)

md5sum_gfwlist2=$(echo $git_line1 | sed 's/ /\n/g'| tail -n 2 | head -n 1)
md5sum_chnroute2=$(echo $git_line2 | sed 's/ /\n/g'| tail -n 2 | head -n 1)
md5sum_cdn2=$(echo $git_line4 | sed 's/ /\n/g'| tail -n 2 | head -n 1)

# detect ss version
ss_basic_version_web1=`curl -s https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowsocks/version | sed -n 1p`
if [ ! -z $ss_basic_version_web1 ];then
	dbus set ss_basic_version_web=$ss_basic_version_web1
fi

# update gfwlist
if [ "$ss_basic_gfwlist_update" == "1" ];then
	if [ ! -z "$version_gfwlist2" ];then
		if [ "$version_gfwlist1" != "$version_gfwlist2" ];then
			echo $(date): 检测到新版本gfwlist，开始更新... >> /tmp/syscmd.log
			echo $(date): 下载gfwlist到临时文件... >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/gfwlist.conf > /tmp/gfwlist.conf
			md5sum_gfwlist1=$(md5sum /tmp/gfwlist.conf | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gfwlist1"x = "$md5sum_gfwlist2"x ];then
				echo $(date): 下载完成，校验通过，将临时文件覆盖到原始gfwlist文件 >> /tmp/syscmd.log
				mv /tmp/gfwlist.conf /jffs/ss/ipset/gfwlist.conf
				sed -i "1s/.*/$git_line1/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): 你的gfwlist已经更新到最新了哦~ >> /tmp/syscmd.log
			else
				echo $(date): 下载完成，但是校验没有通过！ >> /tmp/syscmd.log
			fi
		else
			echo $(date): 检测到gfwlist本地版本号和在线版本号相同，那还更新个毛啊! >> /tmp/syscmd.log
		fi
	else
		echo $(date): gfwlist文件下载失败！ >> /tmp/syscmd.log
	fi
else
	echo $(date): 然而你并没有勾选gfwlist更新！ >> /tmp/syscmd.log
fi


# update chnroute
if [ "$ss_basic_chnroute_update" == "1" ];then
	if [ ! -z "$version_chnroute2" ];then
		if [ "$version_chnroute1" != "$version_chnroute2" ];then
			echo $(date): 检测到新版本chnroute，开始更新... >> /tmp/syscmd.log
			echo $(date): 下载chnroute到临时文件... >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/chnroute.txt > /tmp/chnroute.txt
			md5sum_chnroute1=$(md5sum /tmp/chnroute.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_chnroute1"x = "$md5sum_chnroute2"x ];then
				echo $(date): 下载完成，校验通过，将临时文件覆盖到原始chnroute文件 >> /tmp/syscmd.log
				mv /tmp/chnroute.txt /jffs/ss/redchn/chnroute.txt
				sed -i "2s/.*/$git_line2/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): 你的chnroute已经更新到最新了哦~ >> /tmp/syscmd.log
			else
				echo $(date): md5sum 下载完成，但是校验没有通过！ >> /tmp/syscmd.log
			fi
		else
			echo $(date): 检测到chnroute本地版本号和在线版本号相同，那还更新个毛啊! >> /tmp/syscmd.log
		fi
	else
		echo $(date): file chnroute文件下载失败！ >> /tmp/syscmd.log
	fi
else
	echo $(date): 然而你并没有勾选chnroute更新！ >> /tmp/syscmd.log
fi


# update cdn file
if [ "$ss_basic_cdn_update" == "1" ];then
	if [ ! -z "$version_cdn2" ];then
		if [ "$version_cdn1" != "$version_cdn2" ];then
			echo $(date): 检测到新版本cdn名单，开始更新... >> /tmp/syscmd.log
			echo $(date): 下载cdn名单到临时文件... >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/cdn.txt > /tmp/cdn.txt
			md5sum_cdn1=$(md5sum /tmp/cdn.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_cdn1"x = "$md5sum_cdn2"x ];then
				echo $(date): 下载完成，校验通过，将临时文件覆盖到原始cdn名单文件 >> /tmp/syscmd.log
				mv /tmp/cdn.txt /jffs/ss/redchn/cdn.txt
				sed -i "4s/.*/$git_line4/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): 你的cdn名单已经更新到最新了哦~ >> /tmp/syscmd.log
			else
				echo $(date): 下载完成，但是校验没有通过！ >> /tmp/syscmd.log
			fi
		else
			echo $(date): 检测到cdn名单本地版本号和在线版本号相同，那还更新个毛啊! >> /tmp/syscmd.log
		fi
	else
		echo $(date): file cdn名单文件下载失败！ >> /tmp/syscmd.log
	fi
else
	echo $(date): 然而你并没有勾选cdn名单更新！ >> /tmp/syscmd.log
fi

rm -rf /tmp/gfwlist.conf1
rm -rf /tmp/chnroute.txt1
rm -rf /tmp/cdn.txt1
rm -rf /tmp/version1

echo $(date): Shadowsocks更新进程运行完毕！ >> /tmp/syscmd.log
# write number
nvram set update_ipset="$(cat /jffs/ss/cru/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
nvram set update_chnroute="$(cat /jffs/ss/cru/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
nvram set update_cdn="$(cat /jffs/ss/cru/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p)"
nvram set ipset_numbers=$(cat /jffs/ss/ipset/gfwlist.conf | grep -c ipset)
nvram set chnroute_numbers=$(cat /jffs/ss/redchn/chnroute.txt | grep -c .)
nvram set cdn_numbers=$(cat /jffs/ss/redchn/cdn.txt | grep -c .)

# reboot ss
if [ "$reboot" == "1" ];then
echo $(date): 自动重启shadowsocks，以应用新的规则文件！请稍后！ >> /tmp/syscmd.log
sh /koolshare/ss/ssconfig.sh restart
fi
echo ========================================================================================================== >> /tmp/syscmd.log
exit

