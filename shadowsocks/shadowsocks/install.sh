#! /bin/sh

eval `dbus export ss`
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
mkdir -p /koolshare/ss

# 判断路由架构和平台
case $(uname -m) in
  armv7l)
	echo_date 固件平台【koolshare merlin armv7l】符合安装要求，开始安装插件！
    ;;
  mips)
  	echo_date 本插件适用于koolshare merlin armv7l固件平台，mips平台不能安装！！！
  	echo_date 退出安装！
    exit 0
    ;;
  x86_64)
	echo_date 本插件适用于koolshare merlin armv7l固件平台，x86_64固件平台不能安装！！！
	exit 0
    ;;
  *)
  	echo_date 本插件适用于koolshare merlin armv7l固件平台，其它平台不能安装！！！
  	echo_date 退出安装！
    exit 0
    ;;
esac

remove_conf(){
	ipset_value=`dbus list ss_ipset | cut -d "=" -f 1`
	redchn_value=`dbus list ss_redchn | cut -d "=" -f 1`
	game_value=`dbus list ss_game_ | cut -d "=" -f 1`
	overall_value=`dbus list ss_overall_ | cut -d "=" -f 1`
	onetime_value=`dbus list ssconf_basic|grep onetime_auth | cut -d "=" -f 1`
	for conf in $ipset_value $redchn_value $game_value $overall_value
	do
		echo 移除$conf
		dbus remove $conf
	done
}

# 检测版本号
firmware_version=`nvram get extendno|cut -d "X" -f2|cut -d "-" -f1|cut -d "_" -f1`
firmware_comp=`versioncmp $firmware_version 7.1`
echo_date 因为固件原因，从3.1.6版本开始，SS插件将只适用于X7.2及以后固件，X7.1及其以前固件不再支持!
echo_date 开始检测是否符合升级条件！
if [ "$firmware_comp" == "-1" ];then
	echo_date 检测到固件版本X$firmware_version，符合升级条件！
	echo_date 先清理旧版本SS的一些无用参数...
	remove_conf
else
	echo_date 检测到固件版本X$firmware_version，不符合升级条件，请升级到最新固件并重新尝试！
	echo_date 退出SS插件升级！
	rm -rf /tmp/shadowsocks* >/dev/null 2>&1
	dbus set ss_basic_install_status="0"
	exit 1
fi

# 先关闭ss
if [ "$ss_basic_enable" == "1" ];then
	echo_date 先关闭ss，保证文件更新成功!
	[ -f "/koolshare/ss/stop.sh" ] && sh /koolshare/ss/stop.sh stop_all || sh /koolshare/ss/ssconfig.sh stop
fi

#升级前先删除无关文件
echo_date 清理旧文件
rm -rf /koolshare/ss/*
rm -rf /koolshare/scripts/ss_*
rm -rf /koolshare/webs/Main_Ss*
rm -rf /koolshare/bin/ss-*
rm -rf /koolshare/bin/rss-*
rm -rf /koolshare/bin/obfs*
rm -rf /koolshare/bin/haproxy
rm -rf /koolshare/bin/redsocks2
rm -rf /koolshare/bin/pdnsd
rm -rf /koolshare/bin/Pcap_DNSProxy
rm -rf /koolshare/bin/dnscrypt-proxy
rm -rf /koolshare/bin/dns2socks
rm -rf /koolshare/bin/client_linux_arm5
rm -rf /koolshare/bin/chinadns
rm -rf /koolshare/bin/resolveip


echo_date 开始复制文件！
cd /tmp

echo_date 复制相关二进制文件！
cp -rf /tmp/shadowsocks/bin/* /koolshare/bin/
chmod 755 /koolshare/bin/*

echo_date 创建一些二进制文件的软链接！
[ ! -L "/koolshare/bin/rss-tunnel" ] && ln -sf /koolshare/bin/rss-local /koolshare/bin/rss-tunnel
[ ! -L "/koolshare/bin/base64" ] && ln -sf /koolshare/bin/koolbox /koolshare/bin/base64
[ ! -L "/koolshare/bin/shuf" ] && ln -sf /koolshare/bin/koolbox /koolshare/bin/shuf
[ ! -L "/koolshare/bin/netstat" ] && ln -sf /koolshare/bin/koolbox /koolshare/bin/netstat
[ ! -L "/koolshare/bin/base64_decode" ] && ln -s /koolshare/bin/base64_encode /koolshare/bin/base64_decode

echo_date 复制ss的脚本文件！
cp -rf /tmp/shadowsocks/ss/* /koolshare/ss/
cp -rf /tmp/shadowsocks/scripts/* /koolshare/scripts/
cp -rf /tmp/shadowsocks/init.d/* /koolshare/init.d/

echo_date 复制网页文件！
cp -rf /tmp/shadowsocks/webs/* /koolshare/webs/
cp -rf /tmp/shadowsocks/res/* /koolshare/res/

echo_date 移除安装包！
rm -rf /tmp/shadowsocks* >/dev/null 2>&1

echo_date 为新安装文件赋予执行权限...
chmod 755 /koolshare/ss/koolgame/*
chmod 755 /koolshare/ss/cru/*
chmod 755 /koolshare/ss/rules/*
chmod 755 /koolshare/ss/dns/*
chmod 755 /koolshare/ss/socks5/*
chmod 755 /koolshare/ss/*
chmod 755 /koolshare/scripts/ss*
chmod 755 /koolshare/bin/*

# transform data in skipd when ss version below 3.0.6
curr_version=`dbus get ss_basic_version_local`
comp=`/usr/bin/versioncmp $curr_version 3.0.6`
if [ -n "$curr_version" ] && [ "$comp" == "1" ];then
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

# 设置一些默认值
echo_date 设置一些默认值
[ -z "$ss_dns_china" ] && dbus set ss_dns_china=11
[ -z "$ss_dns_foreign" ] && dbus set ss_dns_foreign=1
[ -z "$ss_basic_ss_obfs" ] && dbus set ss_basic_ss_obfs=0
[ -z "$ss_acl_default_mode" ] && [ -n "$ss_basic_mode" ] && dbus set ss_acl_default_mode="$ss_basic_mode"
[ -z "$ss_acl_default_mode" ] && [ -z "$ss_basic_mode" ] && dbus set ss_acl_default_mode=1
[ -z "$ss_acl_default_port" ] && dbus set ss_acl_default_port=all
[ -z "$ss_dns_plan" ] && dbus set ss_dns_china=1
[ -z "$ss_dns_plan_chn" ] && dbus set ss_dns_china=2
[ -z "$ss_dns_plan_gfw" ] && dbus set ss_dns_china=1

# 离线安装时设置软件中心内储存的版本号和连接
dbus set softcenter_module_shadowsocks_install=1
dbus set softcenter_module_shadowsocks_version=3.6.1
dbus set softcenter_module_shadowsocks_home_url=Main_Ss_Content.asp

new_version=`cat /koolshare/ss/version`
dbus set ss_basic_version_local=$new_version

sleep 2
echo_date 一点点清理工作...
rm -rf /tmp/shadowsocks* >/dev/null 2>&1
dbus set ss_basic_install_status="0"
echo_date 插件安装成功，你为什么这么屌？！

if [ "$ss_basic_enable" == "1" ];then
	echo_date 重启ss！
	dbus set ss_basic_action=1
	. /koolshare/ss/ssconfig.sh restart
fi
echo_date 更新完毕，请等待网页自动刷新！







