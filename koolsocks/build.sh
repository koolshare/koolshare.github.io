#!/bin/sh


MODULE=koolsocks
VERSION=1.0
TITLE=shadowsocks
DESCRIPTION=科学上网
HOME_URL=Main_Ss_Content.asp


# Check and include base
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$MODULE" == "" ]; then
	echo "module not found"
	exit 1
fi

if [ -f "$DIR/$MODULE/$MODULE/install.sh" ]; then
	echo "install script not found"
	exit 2
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# Now in module working directory

if [ "$VERSION" = "" ]; then
	echo "version not found"
	exit 3
fi

rm -f koolsocks.tar.gz
#清理mac os 下文件
rm -f koolsocks/.DS_Store
rm -f koolsocks/*/.DS_Store


tar -zcvf koolsocks.tar.gz koolsocks
md5value=`md5sum koolsocks.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

DATE=`date +%Y-%m-%d_%H:%M:%S`
cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value",
"home_url":"$HOME_URL",
"title":"$TITLE",
"description":"$DESCRIPTION",
"build_date":"$DATE"
}
EOF

#update md5
python ../softcenter/gen_install.py stage2


