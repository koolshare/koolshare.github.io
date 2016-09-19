#!/bin/sh

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* /koolshare/webs
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		cp -rf /tmp/softcenter/perp /koolshare/
		cp -rf /tmp/softcenter/scripts /koolshare/
		cp -rf /tmp/softcenter/shellinabox /koolshare/
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/adm/*
		chmod 755 /koolshare/scripts/*
		chmod 755 /koolshare/shellinabox/*
		rm -rf /tmp/softcenter
		if [ ! -f "/koolshare/init.d/S10Softcenter.sh" ]; then
		ln -sf /koolshare/scripts/app_install.sh /koolshare/init.d/S10Softcenter.sh
		fi
		sleep 1
		dbus set __event__onwanstart_shellinlinux=/koolshare/shellinabox/shellinabox_start.sh
		sh /koolshare/shellinabox/shellinabox_start.sh
	fi
}

softcenter_install
