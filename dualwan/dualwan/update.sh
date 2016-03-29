#!/bin/sh

if [ ! -d /koolshare/dw ]; then
   mkdir -p /koolshare/dw
fi

cp -rf /tmp/dualwan/dualwan_policy.sh /koolshare/scripts/dualwan_policy.sh
cp -rf /tmp/dualwan/Module_policy_route.asp /koolshare/webs/Module_policy_route.asp
cp -rf /tmp/dualwan/dw/* /koolshare/dw/

rm -rf /tmp/dualwan* >/dev/null 2>&1

chmod a+x /koolshare/scripts/dualwan_policy.sh
