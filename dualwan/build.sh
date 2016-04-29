#!/bin/sh

MODULE=dualwan
VERSION=0.3
TITLE=策略路由
DESCRIPTION=让分流更简单
HOME_URL=Module_policy_route.asp

#old_version=`cat version | sed -n 1p`
#old_md5sum=`cat version | sed -n 2p`
#if [ "$old_version" != "$VERSION" ];then
#  echo old_version $old_version
#  echo VERSION $VERSION
#  mv ${MODULE}.tar.gz ./history/"${MODULE}"_"$old_version".tar.gz
#  echo $old_version $old_md5sum >> ./history/version
#fi

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

# do something here

do_build_result
