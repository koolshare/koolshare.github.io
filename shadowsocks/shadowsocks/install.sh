#! /bin/sh


eval `dbus export ss`
if [ "$ss_basic_enable" == "1" ];then
	echo $(date): 先关闭ss，保证文件更新成功!
	sh /koolshare/ss/stop.sh stop_all
fi

echo $(date): 复制相关文件！
cd /tmp
echo $(date): 复制ss各个模式的脚本文件！
cp -rf /tmp/shadowsocks/ss/* /koolshare/ss/
echo $(date): 复制网页文件！
cp -rf /tmp/shadowsocks/webs/* /koolshare/webs/
echo $(date): 复制js文件，图标文件！
cp -rf /tmp/shadowsocks/res/* /koolshare/res/
echo $(date): 复制web提交运行的各种脚本文件！
cp -rf /tmp/shadowsocks/scripts/* /koolshare/scripts/
echo $(date): 复制相关二进制文件！
cp -rf /tmp/shadowsocks/bin/* /koolshare/bin/
echo $(date): 复制socks5开机启动文件！
cp -rf /tmp/shadowsocks/init.d/* /koolshare/init.d/
echo $(date): 移除安装包！
rm -rf /tmp/shadowsocks* >/dev/null 2>&1

# no use since version 1.0.0
rm -rf /koolshare/ss/ssconfig
rm -rf /koolshare/ss/socks5config

# no use sice version 2.0
rm -rf /koolshare/ss/kcptun

echo $(date): 为新安装文件赋予执行权限...
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
dbus set softcenter_module_shadowsocks_version=3.0.4
dbus set softcenter_module_shadowsocks_home_url=Main_Ss_Content.asp

#if [ "$ss_basic_enable" == "1" ];then
#	sleep 1
#	echo $(date): 重新启动ss！
#	sh /koolshare/scripts/ss_config.sh
#fi

