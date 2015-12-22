#!/bin/sh
eval `dbus export aria2`

# aria2_install_status=		#Aria2尚未安装
# aria2_install_status=0	#Aria2尚未安装
# aria2_install_status=1	#Aria2已安装***
# aria2_install_status=2	#Aria2将被安装到jffs分区...
# aria2_install_status=3	#正在下载Aria2中...请耐心等待...
# aria2_install_status=4	#正在安装Aria2中...
# aria2_install_status=5	#Aria2安装成功！请5秒后刷新本页面！...
# aria2_install_status=6	#Aria2卸载中......
# aria2_install_status=7	#Aria2卸载成功！
# aria2_install_status=8	#Aria2下载文件校验不一致！

export aria2_install_status="6"
dbus set aria2_enable=0
sh /jffs/scripts/aria2_run.sh
rm -rf /jffs/www
rm -rf /jffs/aria2

for r in `dbus list aria2|cut -d"=" -f 1`
do
dbus remove $r
done

dbus remove tmp_aria2_version

sleep 2
export aria2_install_status="7"
sleep 3
export aria2_install_status="0"

