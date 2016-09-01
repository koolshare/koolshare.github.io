#! /bin/sh
cd /tmp
mkdir -p /koolshare/adbyby/
cp -rf /tmp/adbyby/adbyby/* /koolshare/adbyby/
cp -rf /tmp/adbyby/webs/* /koolshare/webs/
cp -rf /tmp/adbyby/res/* /koolshare/res/
cp -rf /tmp/adbyby/scripts/* /koolshare/scripts/

chmod 755 /koolshare/adbyby/*
chmod 755 /koolshare/scripts/*

