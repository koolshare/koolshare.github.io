#!/bin/sh

PhddnsPATH=/koolshare/phddns

ORAYSL_PID=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`
ORAYNEWPH_PID=`ps | grep "oraynewph" | grep -v 'grep' | awk '{print $1}'`
ORAYNEWPH_COMMAND="$PhddnsPath/oraynewph -s 0.0.0.0 >/dev/null 2>&1 &"
ORAYSL_COMMAND="$PhddnsPath/oraysl -a 127.0.0.1 -p 16062 -s phsle01.oray.net:80 -d >/dev/null 2>&1 &"


checkoraysl(){
	ORAYSL_PID=`ps | grep "oraysl" | grep -v 'grep' | awk '{print $1}'`
	if [ -z $ORAYSL_PID ]; then
                $ORAYSL_COMMAND
                echo "oraysl started"
        fi
}
checkoraynewph(){
	ORAYNEWPH_PID=`ps | grep "oraynewph" | grep -v 'grep' | awk '{print $1}'`
     	if  [ -z $ORAYNEWPH_PID ]; then
               $ORAYNEWPH_COMMAND
                echo "oraynewph started"
        fi
}
while true
	do 
	checkoraysl  &
	checkoraynewph  &
	sleep 1
	done
