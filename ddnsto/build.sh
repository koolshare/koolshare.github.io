#!/bin/sh

MODULE=ddnsto
VERSION=1.2
TITLE="ddnsto内网穿透"
DESCRIPTION="ddnsto：koolshare小宝开发的基于http2的快速穿透。"
HOME_URL="Module_ddnsto.asp"

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
