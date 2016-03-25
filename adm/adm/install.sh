#! /bin/sh
cd /tmp
cp -rf /tmp/adm/adm /koolshare/
cp -rf /tmp/adm/perp /koolshare/
cp -rf /tmp/adm/bin/* /koolshare/bin/
cp -rf /tmp/adm/scripts/* /koolshare/scripts/
cp -rf /tmp/adm/webs/* /koolshare/webs/
cp -rf /tmp/adm/init.d/* /koolshare/init.d/
cd /
rm -rf /tmp/adm* >/dev/null 2>&1



chmod 755 /koolshare/adm/*
chmod 755 /koolshare/perp/*
chmod 755 /koolshare/perp/.boot/*
chmod 755 /koolshare/perp/.control/*
chmod 755 /koolshare/perp/adm/*
chmod 755 /koolshare/bin/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/*



