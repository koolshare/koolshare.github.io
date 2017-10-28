#!/bin/sh

MODULE=shadowvpn
VERSION=2.9
TITLE=Shadowvpn
DESCRIPTION=SVPN让游戏更畅快
HOME_URL=Module_shadowvpn.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

# now backup
sh backup.sh $MODULE
