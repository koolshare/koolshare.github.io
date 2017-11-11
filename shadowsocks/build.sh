#!/bin/sh

MODULE=shadowsocks
VERSION=`cat ./shadowsocks/ss/version|sed -n 1p`
TITLE=科学上网
DESCRIPTION=科学上网
HOME_URL=Main_Ss_Content.asp


old_version=`cat version | sed -n 1p`
old_md5sum=`cat version | sed -n 2p`
new_md5=`md5sum ${MODULE}.tar.gz`
# backupz package
#if [ "$old_version" != "$VERSION" ];then
  #echo old_version $old_version
  echo backup VERSION $VERSION
  mv ${MODULE}.tar.gz ./history/"${MODULE}"_"$VERSION".tar.gz
  echo $old_version $old_md5sum >> ./history/version
#fi

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
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

# do something here

do_build_result
