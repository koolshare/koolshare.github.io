#!/bin/sh

MODULE=aria2
VERSION=`cat aria2/aria2/version`

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
"version':"$VERSION",
"md5":"$md5value"
}
EOF
