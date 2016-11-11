#! /bin/sh

# stop kcptun first
VERSION="2.2.4"
sh /koolshare/kcptun/stop.sh
dbus set KCP_basic_enable=0
cd /tmp
cp -rf /tmp/kcptun/bin/kcp_router /koolshare/bin/
cp -rf /tmp/kcptun/kcptun /koolshare/
cp -rf /tmp/kcptun/perp/kcptun /koolshare/perp/
cp -rf /tmp/kcptun/scripts/* /koolshare/scripts/
cp -rf /tmp/kcptun/webs/* /koolshare/webs/
cp -rf /tmp/kcptun/res/* /koolshare/res/
cd /
rm -rf /tmp/kcptun* >/dev/null 2>&1
rm -f /koolshare/kcptun/version

chmod 755 /koolshare/bin/*
chmod 755 /koolshare/kcptun/*.sh
chmod 755 /koolshare/kcptun/chnmode/start.sh
chmod 755 /koolshare/kcptun/chnmode/nat-start
chmod 755 /koolshare/kcptun/gfwlist/start.sh
chmod 755 /koolshare/kcptun/gfwlist/nat-start
chmod 755 /tmp/kcptun/perp/kcptun/*
chmod 755 /koolshare/scripts/kcp_config.sh

dbus set KCP_basic_version="${VERSION}"
dbus set KCP_client_version=$(/koolshare/bin/kcp_router --version | awk '{print $3}')
