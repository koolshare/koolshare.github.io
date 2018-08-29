#!/bin/sh

#From dbus to local variable
eval `dbus export soft`
name=`echo "$soft_name"|cut -d "." -f1`
cat /dev/null > /tmp/syscmd.log
INSTALL_SUFFIX=_install
VER_SUFFIX=_version
cd /tmp

echo $(date): 开启软件离线安装！>> /tmp/syscmd.log
if [ -f /tmp/$soft_name ];then
	echo $(date): /tmp目录下检测到上传的离线安装包$soft_name >> /tmp/syscmd.log
	echo $(date): 尝试解压离线安装包离线安装包 >> /tmp/syscmd.log
	tar -zxvf $soft_name >/dev/null 2>&1
	echo $(date): 解压完成！ >> /tmp/syscmd.log
	if [ -f /tmp/$name/install.sh ];then
		echo $(date): 找到安装脚本！ >> /tmp/syscmd.log
		echo $(date): 运行安装脚本... >> /tmp/syscmd.log
		chmod +x /tmp/$name/install.sh >/dev/null 2>&1
		sh /tmp/$name/install.sh >/dev/null 2>&1
		dbus set "softcenter_module_$name$INSTALL_SUFFIX=1"
		dbus set "softcenter_module_$name$VER_SUFFIX=$soft_install_version"
		install_pid=`ps | grep install.sh | grep -v grep | awk '{print $1}'`
		i=120
		until [ ! -n "$install_pid" ]
		do
		    i=$(($i-1))
		    if [ "$i" -lt 1 ];then
		        echo $(date): "Could not load nat rules!"
		        echo $(date): 安装似乎出了点问题，请手动重启路由器后重新尝试... >> /tmp/syscmd.log
		        echo $(date): 删除相关文件并退出... >> /tmp/syscmd.log
		        rm -rf /tmp/software
		        rm -rf /tmp/$soft_name
		        dbus remove "softcenter_module_$name$INSTALL_SUFFIX"
		        exit
		    fi
		    sleep 1
		done
		echo $(date): 离线包安装完成！ >> /tmp/syscmd.log
		echo $(date): 一点点清理工作... >> /tmp/syscmd.log
		rm -rf /tmp/$soft_name
		echo $(date): 完成！ >> /tmp/syscmd.log
	else
		echo $(date): 没有找到安装脚本！ >> /tmp/syscmd.log
		echo $(date): 删除相关文件并退出... >> /tmp/syscmd.log
		rm -rf /tmp/$soft_name

	fi
else
	echo $(date): 没有找到离线安装包！ >> /tmp/syscmd.log
	echo $(date): 删除相关文件并退出... >> /tmp/syscmd.log
	rm -rf /tmp/software
	rm -rf /tmp/$soft_name
fi
	
	rm -rf /tmp/$soft_name
