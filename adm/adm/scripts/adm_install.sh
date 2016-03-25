#!/bin/sh

eval `dbus export adm`
# 相关链接定义
UPDATE_VERSION_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/version"
UPDATE_TAR_URL="https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/adm/adm.tar.gz"
	# adm_install_status=	#adm尚未安装
	# adm_install_status=0	#adm尚未安装
	# adm_install_status=1	#adm已安装
	# adm_install_status=2	#adm将被安装到jffs分区...
	# adm_install_status=3	#正在下载adm中...请耐心等待...
	# adm_install_status=4	#正在安装adm中...
	# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
	# adm_install_status=6	#adm卸载中......
	# adm_install_status=7	#adm卸载成功！
	# adm_install_status=8	#没有检测到在线版本号！

	# adm_install_status=9	#正在下载adm更新......
	# adm_install_status=10	#正在安装adm更新...
	# adm_install_status=11	#安装更新成功，5秒后刷新本页！
	# adm_install_status=12	#下载文件校验不一致！
	# adm_install_status=13	#然而并没有更新！
	# adm_install_status=14	#正在检查是否有更新~
	# adm_install_status=15	#检测更新错误！

	# adm_install_status=2	#adm将被安装到jffs分区...
	dbus set adm_install_status="2"
	adm_version_web1=`curl -s $UPDATE_VERSION_URL | sed -n 1p`
	if [ ! -z $adm_version_web1 ];then
		dbus set adm_version_web=$adm_version_web1
		# adm_install_status=3	#正在下载adm中...请耐心等待...
		dbus set adm_install_status="3"
		cd /tmp
		md5_web1=$(curl $UPDATE_VERSION_URL | sed -n 2p)
		wget --no-check-certificate --tries=1 --timeout=15 $UPDATE_TAR_URL
		md5sum_gz=$(md5sum /tmp/adm.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		if [ "$md5sum_gz"x != "$md5_web1"x ]; then
			# adm_install_status=12	#下载文件校验不一致！
			dbus set adm_install_status="12"
			rm -rf /tmp/adm*
			sleep 3
			# adm_install_status=0	#adm尚未安装
			dbus set adm_install_status="0"
			exit
		else
			tar -zxf adm.tar.gz
			dbus set adm_enable="0"
			# adm_install_status=4	#正在安装adm中...
			dbus set adm_install_status="4"
			chmod a+x /tmp/adm/install.sh
			sh /tmp/adm/install.sh
			sleep 2
			# adm_install_status=5	#adm安装成功！请5秒后刷新本页面！...
			dbus set adm_install_status="5"
			dbus set adm_version=$adm_version_web1
			sleep 2
			# adm_install_status=1	#adm已安装
			dbus set adm_install_status="1"
		fi
	else
		dbus set adm_install_status="8"
		sleep 3
		# adm_install_status=0	#adm尚未安装
		dbus set adm_install_status="0"
		exit
	fi