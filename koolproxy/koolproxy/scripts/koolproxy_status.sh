#! /bin/sh

status=`ps|grep -w koolproxy | grep -cv grep`

if [ "$status" == "2" ];then
	echo koolproxy进程运行正常！ > /tmp/koolproxy.log
else
	echo 【警告】：koolproxy进程未运行！ > /tmp/koolproxy.log
fi
echo XU6J03M6 >> /tmp/koolproxy.log
sleep 2
rm -rf /tmp/koolproxy.log
