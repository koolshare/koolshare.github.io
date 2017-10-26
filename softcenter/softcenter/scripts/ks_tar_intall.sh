#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

#From dbus to local variable
eval `dbus export soft`
name=`echo "$soft_name"|sed 's/.tar.gz//g'|awk -F "_" '{print $1}'|awk -F "-" '{print $1}'`

cat /dev/null > /tmp/syscmd.log
INSTALL_SUFFIX=_install
VER_SUFFIX=_version
NAME_SUFFIX=_name
rm -rf /tmp/syscmd.log
cd /tmp/
echo_date 开启软件离线安装！>> /tmp/syscmd.log
sleep 1
if [ -f /tmp/$soft_name ];then
	echo_date /tmp目录下检测到上传的离线安装包$soft_name >> /tmp/syscmd.log
	sleep 1
	echo_date 尝试解压离线安装包离线安装包 >> /tmp/syscmd.log
	sleep 1
	tar -zxvf $soft_name >/dev/null 2>&1
	echo_date 解压完成！ >> /tmp/syscmd.log
	sleep 1
	cd /tmp/
	if [ -f /tmp/$name/install.sh ];then
		echo_date 找到安装脚本！ >> /tmp/syscmd.log
		chmod +x /tmp/$name/install.sh >/dev/null 2>&1
		echo_date 运行安装脚本... >> /tmp/syscmd.log
		echo_date ====================== step 1 =========================== >> /tmp/syscmd.log
		sleep 1
		start-stop-daemon -S -q -x /tmp/$name/install.sh >> /tmp/syscmd.log 2>&1
		#sh /tmp/$name/install.sh >> /tmp/syscmd.log 2>&1
		echo_date ====================== step 2 =========================== >> /tmp/syscmd.log
		dbus set "softcenter_module_$name$NAME_SUFFIX=$name"
		dbus set "softcenter_module_$name$INSTALL_SUFFIX=1"
		#dbus set "softcenter_module_$name$VER_SUFFIX=$soft_install_version"
		if [ -n "$soft_install_version" ];then
			dbus set "softcenter_module_$name$VER_SUFFIX=$soft_install_version"
			echo_date "从插件文件名中获取到了版本号：$soft_install_version" >> /tmp/syscmd.log
		else
			#已经在插件安装中设置了
			if [ -z "`dbus get softcenter_module_$name$VER_SUFFIX`" ];then
				dbus set "softcenter_module_$name$VER_SUFFIX=0.1"
				echo_date "插件安装脚本里没有找到版本号，设置默认版本号为0.1" >> /tmp/syscmd.log
			else
				echo_date "插件安装脚本已经设置了插件版本号为：`dbus get softcenter_module_$name$VER_SUFFIX`" >> /tmp/syscmd.log
			fi
		fi
		install_pid=`ps | grep install.sh | grep -v grep | awk '{print $1}'`
		i=120
		until [ ! -n "$install_pid" ]
		do
		    i=$(($i-1))
		    if [ "$i" -lt 1 ];then
		        echo_date "Could not load nat rules!"
		        echo_date 安装似乎出了点问题，请手动重启路由器后重新尝试... >> /tmp/syscmd.log
		        echo_date 删除相关文件并退出... >> /tmp/syscmd.log
				sleep 1
		        rm -rf /tmp/$name
		        rm -rf /tmp/$soft_name
		        dbus remove "softcenter_module_$name$INSTALL_SUFFIX"
				echo XU6J03M6 >> /tmp/syscmd.log
		        exit
		    fi
		    sleep 1
		done
		echo_date 离线包安装完成！ >> /tmp/syscmd.log
		sleep 1
		echo_date 一点点清理工作... >> /tmp/syscmd.log
		sleep 1
		rm -rf /tmp/$name
		rm -rf /tmp/$soft_name
		echo_date 完成！离线安装插件成功，现在你可以退出本页面~ >> /tmp/syscmd.log
		sleep 1
	else
		echo_date 没有找到安装脚本！ >> /tmp/syscmd.log
		echo_date 删除相关文件并退出... >> /tmp/syscmd.log
		rm -rf /tmp/$name
		rm -rf /tmp/$soft_name
	fi
else
	echo_date 没有找到离线安装包！ >> /tmp/syscmd.log
	echo_date 删除相关文件并退出... >> /tmp/syscmd.log
	rm -rf /tmp/$name
	rm -rf /tmp/$soft_name
fi

dbus remove soft_install_version
dbus remove soft_name
echo XU6J03M6 >> /tmp/syscmd.log
rm -rf /tmp/$name
rm -rf /tmp/$soft_name