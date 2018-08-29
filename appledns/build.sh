#!/bin/sh

MODULE=appledns
VERSION=0.2
TITLE=AppleDNS
DESCRIPTION=加速apple服务
HOME_URL=Module_appledns.asp

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
