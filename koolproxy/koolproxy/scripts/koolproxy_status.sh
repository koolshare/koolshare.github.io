#! /bin/sh

status=`ps|grep -w koolproxy | grep -cv grep`

kp_version=`cd /koolshare/koolproxy && ./koolproxy -v`
rules_date_local=`cat /koolshare/koolproxy/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3,$4}'`
rules_nu_local=`grep -v "!x" /koolshare/koolproxy/data/rules/koolproxy.txt | wc -l`
video_date_local=`cat /koolshare/koolproxy/data/rules/koolproxy.txt  | sed -n '4p'|awk '{print $3,$4}'`


if [ "$status" == "2" ];then
	echo koolproxy $kp_version  进程运行正常！@@更新日期：$rules_date_local / $rules_nu_local条@@更新日期：$video_date_local > /tmp/koolproxy.log
else
	echo koolproxy $kp_version 【警告】：进程未运行！@@更新日期：$rules_date_local / $rules_nu_local条@@更新日期：$video_date_local > /tmp/koolproxy.log
fi
echo XU6J03M6 >> /tmp/koolproxy.log
sleep 2
rm -rf /tmp/koolproxy.log
