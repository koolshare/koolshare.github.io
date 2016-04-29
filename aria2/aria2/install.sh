#! /bin/sh
cd /tmp
cp -rf /tmp/aria2/aria2 /koolshare/
cp -rf /tmp/aria2/res/* /koolshare/res/
cp -rf /tmp/aria2/scripts/* /koolshare/scripts/
cp -rf /tmp/aria2/webs/* /koolshare/webs/
cp -rf /tmp/aria2/www/* /koolshare/

cd /
rm -rf /tmp/aria2* >/dev/null 2>&1

if [ -L /koolshare/init.d/S91aria2 ];then
	ln -sf /koolshare/aria2/aria2_run.sh /koolshare/init.d/S91aria2.sh
fi

if [ ! -f /koolshare/aria2/aria2.session ];then
	touch /koolshare/aria2/aria2.session
fi

chmod 755 /koolshare/aria2/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/aria2*
chmod 755 /koolshare/www/php-cgi
chmod 777 /koolshare/www/_h5ai/cache

