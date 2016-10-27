#!/bin/sh

cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/

rm -rf /tmp/kms* >/dev/null 2>&1

chmod a+x /koolshare/scripts/kms.sh