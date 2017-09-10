#!/bin/sh

MODULE=phddns
VERSION=0.2
TITLE="花生壳内网版"
DESCRIPTION=让局域网控制能简单

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