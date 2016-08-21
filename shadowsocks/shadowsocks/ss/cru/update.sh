#!/bin/sh
eval `dbus export ss`
source /koolshare/scripts/base.sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")

# version dectet
version_gfwlist1=$(cat /jffs/ss/cru/version | sed -n 1p | sed 's/ /\n/g'| sed -n 1p)
version_chnroute1=$(cat /jffs/ss/cru/version | sed -n 2p | sed 's/ /\n/g'| sed -n 1p)
version_cdn1=$(cat /jffs/ss/cru/version | sed -n 4p | sed 's/ /\n/g'| sed -n 1p)

echo ========================================================================================================== >> /tmp/syscmd.log
echo $(date): Begin to update shadowsocks rules! please wait... >> /tmp/syscmd.log
wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/version1 > /tmp/version1
online_content=$(cat /tmp/version1)
if [ -z "$online_content" ];then
	rm -rf /tmp/version1
	echo $(date): check version failed! >> /tmp/syscmd.log
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
			echo $(date): new version decteted, will update gfwlist >> /tmp/syscmd.log
			echo $(date): downloading gfwlist to tmp file >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/gfwlist.conf > /tmp/gfwlist.conf
			md5sum_gfwlist1=$(md5sum /tmp/gfwlist.conf | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_gfwlist1"x = "$md5sum_gfwlist2"x ];then
				echo $(date): md5sum check succeed \for gfwlist, apply tmp file to the original file >> /tmp/syscmd.log
				mv /tmp/gfwlist.conf /jffs/ss/ipset/gfwlist.conf
				sed -i "1s/.*/$git_line1/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): your gfwlist is up to date >> /tmp/syscmd.log
			else
				echo $(date): md5sum check failed \for gfwlist >> /tmp/syscmd.log
			fi
		else
			echo $(date): same version decteted,will not update gfwlist >> /tmp/syscmd.log
		fi
	else
		echo $(date): file down load failed \for gfwlist >> /tmp/syscmd.log
	fi
else
	echo $(date): gfwlist update not enabled >> /tmp/syscmd.log
fi


# update chnroute
if [ "$ss_basic_chnroute_update" == "1" ];then
	if [ ! -z "$version_chnroute2" ];then
		if [ "$version_chnroute1" != "$version_chnroute2" ];then
			echo $(date): new version decteted, will update chnroute >> /tmp/syscmd.log
			echo $(date): downloading chnroute to tmp file >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/chnroute.txt > /tmp/chnroute.txt
			md5sum_chnroute1=$(md5sum /tmp/chnroute.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_chnroute1"x = "$md5sum_chnroute2"x ];then
				echo $(date): md5sum check succeed \for chnroute, apply tmp file to the original file >> /tmp/syscmd.log
				mv /tmp/chnroute.txt /jffs/ss/redchn/chnroute.txt
				sed -i "2s/.*/$git_line2/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): your chnroute is up to date >> /tmp/syscmd.log
			else
				echo $(date): md5sum check failed \for chnroute >> /tmp/syscmd.log
			fi
		else
			echo $(date): same version decteted,will not update chnroute >> /tmp/syscmd.log
		fi
	else
		echo $(date): file down load failed \for gfwlist >> /tmp/syscmd.log
	fi
else
	echo $(date): chnroute update not enabled >> /tmp/syscmd.log
fi


# update cdn file
if [ "$ss_basic_cdn_update" == "1" ];then
	if [ ! -z "$version_cdn2" ];then
		if [ "$version_cdn1" != "$version_cdn2" ];then
			echo $(date): new version decteted, will update cdn >> /tmp/syscmd.log
			echo $(date): downloading cdn list to tmp file >> /tmp/syscmd.log
			wget --no-check-certificate --tries=1 --timeout=15 -qO - https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/maintain_files/cdn.txt > /tmp/cdn.txt
			md5sum_cdn1=$(md5sum /tmp/cdn.txt | sed 's/ /\n/g'| sed -n 1p)
			if [ "$md5sum_cdn1"x = "$md5sum_cdn2"x ];then
				echo $(date): md5sum check succeed \for cdn, apply tmp file to the original file >> /tmp/syscmd.log
				mv /tmp/cdn.txt /jffs/ss/redchn/cdn.txt
				sed -i "4s/.*/$git_line4/" /jffs/ss/cru/version
				reboot="1"
				echo $(date): your cdn is up to date >> /tmp/syscmd.log
			else
				echo $(date): md5sum check failed \for cdn >> /tmp/syscmd.log
			fi
		else
			echo $(date): same version decteted,will not update cdn >> /tmp/syscmd.log
		fi
	else
		echo $(date): file down load failed \for gfwlist >> /tmp/syscmd.log
	fi
else
	echo $(date): cdn update not enabled >> /tmp/syscmd.log
fi

rm -rf /tmp/gfwlist.conf1
rm -rf /tmp/chnroute.txt1
rm -rf /tmp/cdn.txt1
rm -rf /tmp/version1

echo $(date): Shadowsocks rules update complete! >> /tmp/syscmd.log
# write number
nvram set update_ipset="$(cat /jffs/ss/cru/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
nvram set update_chnroute="$(cat /jffs/ss/cru/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
nvram set update_cdn="$(cat /jffs/ss/cru/version | sed -n 4p | sed 's/#/\n/g'| sed -n 1p)"
nvram set ipset_numbers=$(cat /jffs/ss/ipset/gfwlist.conf | grep -c ipset)
nvram set chnroute_numbers=$(cat /jffs/ss/redchn/chnroute.txt | grep -c .)
nvram set cdn_numbers=$(cat /jffs/ss/redchn/cdn.txt | grep -c .)

# reboot ss
if [ "$reboot" == "1" ];then
echo $(date): reboot shadowsocks service automaticly to apply newly updated list >> /tmp/syscmd.log
sh /koolshare/ss/ssconfig.sh start_all
fi
echo ========================================================================================================== >> /tmp/syscmd.log
exit

