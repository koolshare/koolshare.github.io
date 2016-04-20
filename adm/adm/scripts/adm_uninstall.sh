#!/bin/sh


rm -rf /koolshare/adm
rm -rf /init.d/S60Adm.sh
rm -rf /scripts/adm_*.sh
rm -rf /webs/Module_adm.asp

cp -rf /tmp/adm/adm /koolshare/
cp -rf /tmp/adm/scripts/* /koolshare/scripts/
cp -rf /tmp/adm/webs/* /koolshare/webs/
cp -rf /tmp/adm/init.d/* /koolshare/init.d/
cp -rf /tmp/adm/res/* /koolshare/res/
