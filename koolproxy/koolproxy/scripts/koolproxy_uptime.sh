#! /bin/sh

source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
nvram set koolproxy_uptime=`perpls koolproxy |cut -d "/" -f 2 |awk '{print $1}'|sed 's/s//g'`

touch /jffs/hah.txt
