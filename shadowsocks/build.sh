#!/bin/sh

MODULE=shadowsocks
VERSION=`cat ./shadowsocks/ss/version`
old_version=`cat version | sed -n 1p`
old_md5sum=`cat version | sed -n 2p`

if [ $old_version !== $VERSION ];then
  mv ${MODULE}.tar.gz ./history/"${MODULE}"_"$old_version".tar.gz
  echo $old_version $old_md5sum >> ./history/version
fi


tar -zcvf ${MODULE}.tar.gz $MODULE
md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF

echo $VERSION
echo $md5value
