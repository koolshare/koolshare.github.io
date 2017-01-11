#! /bin/sh

eval `dbus export ss`
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

nvram get extendno |grep X7.3|cut -d "X" -f2

mkdir -p /koolshare/ss
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭ss，保证文件更新成功!
	sh /koolshare/ss/stop.sh stop_all
fi

echo_date 复制相关文件！
cd /tmp

echo_date 复制相关二进制文件！
cp -rf /tmp/shadowsocks/bin/* /koolshare/bin/
chmod 755 /koolshare/bin/*

if [ ! -L /koolshare/bin/base64_decode ];then
	ln -s /koolshare/bin/base64_encode /koolshare/bin/base64_decode
fi

# transform data in skipd when ss version below 3.0.6
if [ -f /koolshare/ss/version ];then
	curr_version=`cat /koolshare/ss/version`
	comp=`versioncmp $curr_version 3.0.6`
	if [ "$comp" == "1" ];then
		echo_date 从ss3.0.6版本开始，将对界面内textarea内的值和ss的密码进行base64加密，方便储存！
		echo_date 生成当前SS版本：$curr_version的配置文件到/jffs根目录！
		dbus list ss > /jffs/ss_conf_backup_$curr_version.txt
		echo_date 对部分ss数据进行base64加密数据！
		node_pass=`dbus list ssconf_basic_password |cut -d "=" -f 1|cut -d "_" -f4|sort -n`
		for node in $node_pass
		do
			dbus set ssconf_basic_password_$node=`dbus get ssconf_basic_password_$node|base64_encode`
		done
		dbus set ss_basic_password=`dbus get ss_basic_password|base64_encode`
		dbus set ss_basic_black_lan=`dbus get ss_basic_black_lan | base64_encode`
		dbus set ss_basic_white_lan=`dbus get ss_basic_white_lan | base64_encode`
		dbus set ss_ipset_black_domain_web=`dbus get ss_ipset_black_domain_web | base64_encode`
		dbus set ss_ipset_white_domain_web=`dbus get ss_ipset_white_domain_web | base64_encode`
		dbus set ss_ipset_dnsmasq=`dbus get ss_ipset_dnsmasq | base64_encode`
		dbus set ss_ipset_black_ip=`dbus get ss_ipset_black_ip | base64_encode`
		dbus set ss_redchn_isp_website_web=`dbus get ss_redchn_isp_website_web | base64_encode`
		dbus set ss_redchn_dnsmasq=`dbus get ss_redchn_dnsmasq | base64_encode`
		dbus set ss_redchn_wan_white_ip=`dbus get ss_redchn_wan_white_ip | base64_encode`
		dbus set ss_redchn_wan_white_domain=`dbus get ss_redchn_wan_white_domain | base64_encode`
		dbus set ss_redchn_wan_black_ip=`dbus get ss_redchn_wan_black_ip | base64_encode`
		dbus set ss_redchn_wan_black_domain=`dbus get ss_redchn_wan_black_domain | base64_encode`
		dbus set ss_game_dnsmasq=`dbus get ss_game_dnsmasq | base64_encode`
		dbus set ss_gameV2_dnsmasq=`dbus get ss_gameV2_dnsmasq | base64_encode`
	fi
fi

echo_date 复制ss各个模式的脚本文件！
cp -rf /tmp/shadowsocks/ss/* /koolshare/ss/

echo_date 复制网页文件！
cp -rf /tmp/shadowsocks/webs/* /koolshare/webs/

echo_date 复制js文件，图标文件！
cp -rf /tmp/shadowsocks/res/* /koolshare/res/

echo_date 复制web提交运行的各种脚本文件！
cp -rf /tmp/shadowsocks/scripts/* /koolshare/scripts/

echo_date 复制socks5开机启动文件！
cp -rf /tmp/shadowsocks/init.d/* /koolshare/init.d/

echo_date 移除安装包！
rm -rf /tmp/shadowsocks* >/dev/null 2>&1

if [ -z "$ss_redchn_chinadns_foreign_method" ];then
	dbus set ss_redchn_chinadns_foreign_method=2
fi

# no use since version 1.0.0
rm -rf /koolshare/ss/ssconfig
rm -rf /koolshare/ss/socks5config

# no use sice version 2.0
rm -rf /koolshare/ss/kcptun

echo_date 为新安装文件赋予执行权限...
chmod 755 /koolshare/ss/game/*
chmod 755 /koolshare/ss/koolgame/*
chmod 755 /koolshare/ss/ipset/*
chmod 755 /koolshare/ss/redchn/*
chmod 755 /koolshare/ss/overall/*
chmod 755 /koolshare/ss/cru/*
chmod 755 /koolshare/ss/dns/*
chmod 755 /koolshare/ss/socks5/*
chmod 755 /koolshare/ss/*.sh
chmod 755 /koolshare/scripts/*
chmod 755 /koolshare/bin/*

# add icon into softerware center
dbus remove softcenter_module_koolsocks_install
dbus remove softcenter_module_koolsocks_version

dbus set softcenter_module_shadowsocks_install=1
dbus set softcenter_module_shadowsocks_version=3.0.6
dbus set softcenter_module_shadowsocks_home_url=Main_Ss_Content.asp

new_version=`cat /koolshare/ss/version`
dbus set ss_basic_version_local=$new_version
#dbus set ss_basic_install_status="3"
sleep 2
echo_date 一点点清理工作...
rm -rf /tmp/shadowsocks* >/dev/null 2>&1
dbus set ss_basic_install_status="0"
echo_date 安装更新成功，你为什么这么屌？！

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启ss！
	dbus set ss_basic_action=1
	. /koolshare/ss/ssconfig.sh restart
fi
echo_date 更新完毕，请等待网页自动刷新！
echo XU6J03M6
sleep 1
killall ssconfig.sh >/dev/null 2>&1
killall sh >/dev/null 2>&1
kill `pidof ssconfig.sh` >/dev/null 2>&1








