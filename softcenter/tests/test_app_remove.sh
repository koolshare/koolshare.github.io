#!/bin/sh

dbus set softcenter_home_url="http://koolshare.ngrok.wang:5000"
dbus set softcenter_installing_todo=adm

sh /koolshare/scripts/app_remove.sh
