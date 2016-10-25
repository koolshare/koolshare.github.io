#!/bin/sh
echo $(date): 开始清理shadowsocks配置...
confs=`dbus list ss | cut -d "=" -f 1 | grep -v "version" | grep -v "ss_basic_state_china" | grep -v "ss_basic_state_foreign"`

for conf in $confs
do
	echo $(date): 移除$conf
	dbus remove $conf
done
echo $(date): 设置一些默认参数...
dbus set ss_basic_enable="0"
dbus set ss_basic_version_local=`cat /koolshare/ss/version` 
echo $(date): 尝试关闭shadowsocks...
sh /koolshare/ss/stop.sh stop_all
