#! /bin/sh
# ====================================变量定义====================================
# 版本号定义
version="1.6"
dbus set swap_version="$version"
# 导入skipd数据
eval `dbus export swap`

# 引用环境变量等
source /koolshare/scripts/base.sh

check_usb_status(){
	
	# 1	没有找到可用的USB磁盘
	# 2	USB磁盘格式不符合要求
	# 3	成功检测到ext？格式磁盘,可以创建swap
	# 4	swap分区已经加载

	ext_type=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f5`
	usb_disk=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	swapon=`free | grep Swap | awk '{print $2}'`
	dbus set swap_usb_type="$ext_type"
	dbus set swap_usb_disk="$usb_disk"
	
if [ "$swapon" == "0" ];then
	if [ -z "$usb_disk" ];then
		dbus set swap_warnning="1"
	else
		if [ -f "$usb_disk"/swapfile ];then
			swapon "$usb_disk"/swapfile
			dbus set swap_warnning="4"
		else
			if [ "$ext_type" == "ext2" ] || [ "$ext_type" == "ext3" ] || [ "$ext_type" == "ext4" ];then
				dbus set swap_warnning="3"
			else
				dbus set swap_warnning="2"
			fi
		fi
	fi
else
		dbus set swap_warnning="4"
fi
}


mkswap(){
	if [ "$swap_warnning" == "3" ];then
		[ "$swap_size" == "1" ] && size=256144
		[ "$swap_size" == "2" ] && size=524288
		[ "$swap_size" == "3" ] && size=1048576
		if [ ! -f  $usb_disk/swap ];then
			dd if=/dev/zero of=$usb_disk/swapfile bs=1024 count="$size"
			/sbin/mkswap $usb_disk/swapfile
			chmod 0600 $usb_disk/swapfile
			swapon $usb_disk/swapfile
		fi
	fi
}

swap_load_start(){
	if [ ! -f /jffs/scripts/post-mount ]; then
		echo "#! /bin/sh" > /jffs/scripts/post-mount
		echo " " >> /jffs/scripts/post-mount
		chmod +x /jffs/scripts/post-mount
	fi

	startswap=$(cat /jffs/scripts/post-mount | grep "swap_load")
	if [ -z "$startstart" ];then
		#sed -i '2a sh /koolshare/scripts/swap_load.sh' /jffs/scripts/post-mount
		#awk '{print $0}END{print "sh /koolshare/scripts/swap_load.sh"}' /jffs/scripts/post-mount
		sed -i '$a\sh\ \/koolshare/scripts/swap_load.sh' /jffs/scripts/post-mount
	fi
		chmod +x /jffs/scripts/post-mount
}

swap_unload_start(){
	sed -i '/swap_load/d' /jffs/scripts/post-mount >/dev/null 2>&1
}

case $ACTION in
load)
	check_usb_status
	mkswap
	swap_load_start
	;;
unload)
	usb_disk=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	swapoff $usb_disk/swapfile
	rm -rf $usb_disk/swapfile
	swap_unload_start
	;;
check)
	check_usb_status
	;;
esac

