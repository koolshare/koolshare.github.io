#!/bin/sh
PROCS=Pcap_DNSProxy
CONFIG=/koolshare/ss/dns
while true ; do
RUNNING=`ps|grep $PROCS|grep -v grep |wc -l`
 if [ "${RUNNING}" -ge 1  ];then
  sleep 1
  exit 1
  else
  $PROCS -c $CONFIG
  echo "$(date) Starting ${PROCS}!" >> /tmp/dns.log
  sleep 1
  fi
done
exit 0
