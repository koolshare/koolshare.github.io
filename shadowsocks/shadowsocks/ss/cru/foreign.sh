#!/bin/sh
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
wget -4 --spider --quiet --tries=2 --timeout=2 www.google.com.tw

if [ "$?" == "0" ]; then
  log='[ '$LOGTIME' ] working...'
else
  log='[ '$LOGTIME' ] Problem detected!'
fi

# nvram set ss_foreign_state="$log"
dbus set ss_basic_state_foreign="$log"
