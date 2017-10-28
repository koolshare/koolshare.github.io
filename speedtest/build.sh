#!/bin/sh


MODULE=speedtest
VERSION=0.2.2
TITLE=网络测速
DESCRIPTION=让测速更简单
HOME_URL=Module_speedtest.asp

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
