#! /bin/sh

sh /koolshare/ss/ssconfig.sh stop
sh /koolshare/scripts/ss_conf_remove.sh
sleep 1
rm -rf /koolshare/ss/*
rm -rf /koolshare/webs/Main_Ss*
rm -rf /koolshare/bin/ss-redir
rm -rf /koolshare/bin/ss-tunnel
rm -rf /koolshare/bin/ss-local
rm -rf /koolshare/bin/rss-*
rm -rf /koolshare/bin/resolveip
rm -rf /koolshare/bin/redsocks2
rm -rf /koolshare/bin/client_linux_arm5
rm -rf /koolshare/scripts/ss_*
rm -rf /koolshare/res/ss-menu.js

dbus remove softcenter_module_shadowsocks_home_url
dbus remove softcenter_module_shadowsocks_install
dbus remove softcenter_module_shadowsocks_md5
dbus remove softcenter_module_shadowsocks_version

dbus remove ss_basic_enable
dbus remove ss_basic_version_local
dbus remove ss_basic_version_web
