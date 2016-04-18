#!/bin/sh

MODULE=kuainiao
VERSION=0.1.0
TITLE=讯雷快鸟
DESCRIPTION=迅雷快鸟，不解释~
HOME_URL=Module_kuainiao.asp

cat version
rm -f ${MODULE}.tar.gz
#清理mac os 下文件
rm -f $MODULE/.DS_Store
rm -f $MODULE/*/.DS_Store

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
