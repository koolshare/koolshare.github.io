#!/bin/sh

MODULE=koolnet

cd /
cp -f /tmp/$MODULE/bin/* /koolshare/bin/
cp -f /tmp/$MODULE/scripts/* /koolshare/scripts/
cp -f /tmp/$MODULE/webs/* /koolshare/webs/
cp -f /tmp/$MODULE/init.d/* /koolshare/init.d/
rm -f /tmp/koolnet* >/dev/null 2>&1



chmod 755 /koolshare/bin/koolnet
chmod 755 /koolshare/scripts/*
