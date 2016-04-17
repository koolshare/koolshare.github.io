#!/bin/sh

MODULE=tunnel
VERSION=0.2
TITLE=穿透DDNS
DESCRIPTION=穿透 DDNS, 服务器转发方式
HOME_URL=Module_tunnel.asp

cat version
rm -f ${MODULE}.tar.gz
tar -zcvf ${MODULE}.tar.gz $MODULE
md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value",
"home_url":"$HOME_URL",
"title":"$TITLE",
"description":"$DESCRIPTION"
}
EOF

#update md5
python ../softcenter/gen_install.py stage2
