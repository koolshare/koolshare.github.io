#!/bin/sh

# 引用环境变量等
source /koolshare/scripts/base.sh

# 导入skipd数据
eval `dbus export thunder`
thunderPath=/koolshare/thunder

# 开机自启
start_with_system() {
	if [ "$thunder_basic_request" = "01" ]; then
		$thunderPath/portal &
	fi
}


case $ACTION in
start)
	start_with_system
	;;
esac
