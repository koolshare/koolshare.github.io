#! /bin/sh
export PERP_BASE=/koolshare/perp
/koolshare/bin/perpls koolproxy |cut -d "/" -f 2 |awk '{print $1}'|sed 's/s//g'
