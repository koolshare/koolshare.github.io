#!/bin/sh

MODULE=dualwan
VERSION=2.1
TITLE=策略路由
DESCRIPTION="让分流更简单"
HOME_URL=Module_policy_route.asp

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
