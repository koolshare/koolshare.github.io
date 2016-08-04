#!/bin/sh

eval `dbus export KCP`

sh /koolshare/kcptun/kcpconfig.sh restart
