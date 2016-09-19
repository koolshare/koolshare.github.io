#!/bin/sh

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* /koolshare/webs
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		cp -rf /tmp/softcenter/perp /koolshare/
		cp -rf /tmp/softcenter/scripts /koolshare/
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/adm/*
		chmod 755 /koolshare/scripts/*
		rm -rf /tmp/softcenter
		if [ ! -f "/koolshare/init.d/S10Softcenter.sh" ]; then
			ln -sf /koolshare/scripts/app_install.sh /koolshare/init.d/S10Softcenter.sh
		fi
	fi
}

softcenter_install
