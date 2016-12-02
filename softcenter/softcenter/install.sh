#!/bin/sh

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* /koolshare/webs/
		cp -rf /tmp/softcenter/init.d/* /koolshare/init.d/
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		cp -rf /tmp/softcenter/perp /koolshare/
		cp -rf /tmp/softcenter/scripts /koolshare/
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/init.d/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/adm/*
		chmod 755 /koolshare/scripts/*
		rm -rf /tmp/softcenter
		if [ ! -f "/koolshare/init.d/S10Softcenter.sh" ]; then
			ln -sf /koolshare/scripts/app_install.sh /koolshare/init.d/S10Softcenter.sh
		fi
		rm -rf /koolshare/res/icon-koolsocks.png
		dbus remove softcenter_module_koolsocks_install
		dbus remove softcenter_module_koolsocks_version
		if [ -f "/koolshare/ss/ssconfig.sh" ]; then
		dbus set softcenter_module_shadowsocks_install=4
		dbus set softcenter_module_shadowsocks_version=1.3
		fi
	fi
}

softcenter_install
