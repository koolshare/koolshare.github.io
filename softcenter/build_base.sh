#!/bin/sh

MODULE=speedtest
VERSION=0.2.0

cat version
rm -f ${MODULE}.tar.gz
#清理mac os 下文件
rm -f $MODULE/.DS_Store
rm -f $MODULE/*/.DS_Store

tar -zcvf ${MODULE}.tar.gz $MODULE
#md5value=`md5sum ${MODULE}.tar.gz|awk -F ' = ' '{print $2}'|sed -n 1p`
md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value"
}
EOF

#update md5
python ../softcenter/gen_install.py stage2
