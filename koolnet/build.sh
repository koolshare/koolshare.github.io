#!/bin/sh

MODULE=koolnet
VERSION=0.2
TITLE="P2P 穿透"
DESCRIPTION="点对点建立连接,下载更快"

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