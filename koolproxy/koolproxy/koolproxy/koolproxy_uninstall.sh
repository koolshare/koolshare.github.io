#!/bin/sh

sh /koolshare/koolproxy/koolproxy.sh stop
rm -rf /koolshare/perp/koolproxy
rm -rf /koolshare/koolproxy
rm -rf /init.d/S93koolproxy.sh
rm -rf /scripts/koolproxy_*.sh
rm -rf /webs/Module_koolproxy.asp

