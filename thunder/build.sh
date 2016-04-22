#!/bin/sh

MODULE=thunder
VERSION=1.1
TITLE=迅雷远程
DESCRIPTION=迅雷远程~
HOME_URL=Module_thunder.asp

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
