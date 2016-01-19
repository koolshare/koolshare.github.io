#!/bin/sh
PROCS=Pcap_DNSProxy
BIN=/usr/bin
START=$BIN/$PROCS
CONFIG=/koolshare/ss/dns
while true ; do
sleep 18
RUNNING=`ps|grep $PROCS|grep -v grep |wc -l`
  if [ "${RUNNING}" -lt "1"  ];then
  $START -c $CONFIG
  echo "$(date) ${PROCS} is down,reboot!" >> /tmp/dns.log
  fi
done
exit 0
