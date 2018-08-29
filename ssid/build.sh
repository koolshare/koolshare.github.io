#!/bin/sh


MODULE=ssid
VERSION=1.3
TITLE=中文SSID
DESCRIPTION=中文SSID，装逼利器！
HOME_URL=Module_ssid.asp

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
