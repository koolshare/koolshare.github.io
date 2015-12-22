#!/bin/sh
eval `dbus export aria2`
HOME_URL=https://koolshare.github.io
md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/version | sed -n 2p)
md5_web2=$(curl http://file.mjy211.com/aria2/version | sed -n 2p)
md5_web3=$(curl http://file.fancyss.com/aria2/version | sed -n 2p)
md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
version=`cat /jffs/aria2/version`
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


if [ -z $aria2_install_status ];then
	export aria2_install_status="0"
	dbus save aria2
fi

case $(uname -m) in
  armv7l)
    echo your router is suitable \for aria2 install 
    ;;
  mips)
    echo "This is unsupported platform, sorry."
    exit
    ;;
  *)
    echo "This is unsupported platform, sorry."
    exit
    ;;
esac


# Aria2将被安装到jffs分区...
cd /tmp
export aria2_install_status="2"
dbus save aria2
sleep 2
# 正在下载Aria2中...请耐心等待...
export aria2_install_status="3"
dbus save aria2
md5sum_gz=$(md5sum /tmp/aria2.tar.gz | sed 's/ /\n/g'| sed -n 1p)
md5_web1=$(curl https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/version | sed -n 2p)
wget --no-check-certificate --tries=1 --timeout=15 https://koolshare.github.io/aria2/aria2.tar.gz
if [ "$md5sum_gz"x != "$md5_web1"x ]; then
	rm -rf /tmp/aria*
	md5_web2=$(curl http://file.mjy211.com/aria2/version | sed -n 2p)
	wget --no-check-certificate --tries=1 --timeout=15 http://file.mjy211.com/aria2/aria2.tar.gz
	if [ "$md5sum_gz"x != "$md5_web2"x ]; then
		rm -rf /tmp/aria*
		md5_web3=$(curl http://file.fancyss.com/aria2/version | sed -n 2p)

		wget --no-check-certificate --tries=1 --timeout=15 http://file.fancyss.com/aria2/aria2.tar.gz
		if [ "$md5sum_gz"x != "$md5_web3"x ]; then
			export aria2_install_status="8"
			dbus save aria2
			rm -rf /tmp/aria*
			sleep 5
			export aria2_install_status="0"
			dbus save aria2
			exit
		fi
	fi
fi

# 正在安装Aria2中...
export aria2_install_status="4"
dbus save aria2
tar -zxvf aria2.tar.gz
mkdir -p /jffs/
cd aria2
mv -rf /tmp/aria2 /jffs
mv -rf /tmp/www /jffs
mv -rf /tmp/scripts/* /jffs/scripts/
if [ -d /tmp/aria2/webs ];then
	mkdir -p /jffs/webs
	mv -rf /tmp/webs/* /jffs/webs/
fi
cd /jffs
chmod +x /jffs/aria2/*
chmod +x /jffs/www/php-cgi
chmod +x /jffs/scripts/*
chmod 777 /jffs/www/_h5ai/cache
rm -rf /tmp/aria*
sleep 2
export aria2_install_status="5"
dbus save aria2
sleep 2
export aria2_install_status="1"
dbus save aria2
dbus set aria2_version=$version
dbus set aria2_version_web=$version

sleep 10
if [ $aria2_install_status != "0" ] || [ $aria2_install_status != "1" ] ;then
	export aria2_install_status="0"
fi


