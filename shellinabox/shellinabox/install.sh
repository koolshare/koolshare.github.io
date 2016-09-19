#! /bin/sh
			
	cp -rf /tmp/shellinabox/shellinabox /koolshare/
	cp -rf /tmp/shellinabox/res/* /koolshare/res/
	cp -rf /tmp/shellinabox/webs/* /koolshare/webs
	chmod 755 /koolshare/shellinabox/*	
	sleep 1
	sh /koolshare/shellinabox/shellinabox_start.sh
	dbus set __event__onwanstart_shellinlinux=/koolshare/shellinabox/shellinabox_start.sh

	rm -rf /tmp/shellinabox*
	
