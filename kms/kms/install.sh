#!/bin/sh

if [ ! -d /koolshare/kms ]; then
   mkdir -p /koolshare/kms
fi

rm /koolshare/dw/*

cp -rf /tmp/kms/scripts/kms.sh /koolshare/scripts/kms.sh
cp -rf /tmp/kms/bin/vlmcsd /koolshare/bin/vlmcsd
cp -rf /tmp/kms/webs/Module_kms.asp /koolshare/webs/Module_kms.asp
cp /tmp/kms/res/* /koolshare/res

rm -rf /tmp/kms* >/dev/null 2>&1

chmod a+x /koolshare/scripts/kms.sh
