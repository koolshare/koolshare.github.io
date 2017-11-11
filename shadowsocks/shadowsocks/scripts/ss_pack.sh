#!/bin/sh
rm -rf /tmp/shadowsocks*

echo "开始打包..."
echo "请等待一会儿..."

cd /tmp
mkdir shadowsocks
mkdir shadowsocks/bin
mkdir shadowsocks/scripts
mkdir shadowsocks/init.d
mkdir shadowsocks/webs
mkdir shadowsocks/res

TARGET_FOLDER=/tmp/shadowsocks
cp /koolshare/scripts/ss_install.sh $TARGET_FOLDER/install.sh
cp /koolshare/scripts/uninstall_shadowsocks.sh $TARGET_FOLDER/uninstall.sh
cp /koolshare/scripts/ss_* $TARGET_FOLDER/scripts/
cp /koolshare/bin/ss-local $TARGET_FOLDER/bin/
cp /koolshare/bin/ss-redir $TARGET_FOLDER/bin/
cp /koolshare/bin/ss-tunnel $TARGET_FOLDER/bin/
cp /koolshare/bin/obfs-local $TARGET_FOLDER/bin/
cp /koolshare/bin/rss-local $TARGET_FOLDER/bin/
cp /koolshare/bin/rss-redir $TARGET_FOLDER/bin/
cp /koolshare/bin/pdnsd $TARGET_FOLDER/bin/
cp /koolshare/bin/Pcap_DNSProxy $TARGET_FOLDER/bin/
cp /koolshare/bin/dns2socks $TARGET_FOLDER/bin/
cp /koolshare/bin/dnscrypt-proxy $TARGET_FOLDER/bin/
cp /koolshare/bin/chinadns $TARGET_FOLDER/bin/
cp /koolshare/bin/resolveip $TARGET_FOLDER/bin/
cp /koolshare/bin/haproxy $TARGET_FOLDER/bin/
cp /koolshare/bin/client_linux_arm5 $TARGET_FOLDER/bin/
cp /koolshare/bin/base64_encode $TARGET_FOLDER/bin/
cp /koolshare/bin/koolbox $TARGET_FOLDER/bin/
#cp /koolshare/init.d/S99shadowsocks.sh $TARGET_FOLDER/init.d
cp /koolshare/init.d/S89Socks5.sh $TARGET_FOLDER/init.d
cp /koolshare/webs/Main_Ss_Content.asp $TARGET_FOLDER/webs/
cp /koolshare/webs/Main_Ss_LoadBlance.asp $TARGET_FOLDER/webs/
cp /koolshare/webs/Main_SsLocal_Content.asp $TARGET_FOLDER/webs/
cp /koolshare/res/icon-shadowsocks.png $TARGET_FOLDER/res/
cp /koolshare/res/ss-menu.js $TARGET_FOLDER/res/
cp /koolshare/res/all.png $TARGET_FOLDER/res/
cp /koolshare/res/gfw.png $TARGET_FOLDER/res/
cp /koolshare/res/chn.png $TARGET_FOLDER/res/
cp /koolshare/res/game.png $TARGET_FOLDER/res/
cp /koolshare/res/gameV2.png $TARGET_FOLDER/res/
cp /koolshare/res/shadowsocks.css $TARGET_FOLDER/res/
cp /koolshare/res/ss_proc_status.htm $TARGET_FOLDER/res/
cp -rf /koolshare/res/layer $TARGET_FOLDER/res/
cp -r /koolshare/ss $TARGET_FOLDER/
rm -rf $TARGET_FOLDER/ss/*.json

tar -czv -f /tmp/shadowsocks.tar.gz shadowsocks/
rm -rf $TARGET_FOLDER
echo "打包完毕！"