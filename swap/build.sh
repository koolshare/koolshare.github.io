#!/bin/sh


MODULE=swap
VERSION=2.2
TITLE=虚拟内存
DESCRIPTION=老板，来一斤虚拟内存~
HOME_URL=Module_swap.asp

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
