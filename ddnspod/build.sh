#!/bin/sh

MODULE=ddnspod
VERSION=0.1.6
TITLE=DDnspod
DESCRIPTION=使用Dnspod的ddns服务
HOME_URL=Module_ddnspod.asp

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