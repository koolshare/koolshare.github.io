#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

china_domain_list="https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"
china_routing_list="https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"
DATE=$(date "+%Y-%m-%d %H:%M:%S")


update_list(){
	echo =======================================================================================================
	echo_date 开始更新 Local Hosts，请等待...
	wget --tries=2 -P /tmp --no-check-certificate $china_domain_list
	[ "$?" != "0" ] && echo_date 下载错误，退出！ && exit 0
	echo -e '[Local Hosts]' >> /tmp/WhiteList.txt
	echo -e '## China mainland domains' >> /tmp/WhiteList.txt
	echo -e '## Get the latest database: https://github.com/xinhugo/Free-List/blob/master/WhiteList.txt' >> /tmp/WhiteList.txt
	echo -e '## Report an issue: https://github.com/xinhugo/Free-List/issues' >> /tmp/WhiteList.txt
	echo -e "## Last update: $DATE\n" >> /tmp/WhiteList.txt
	sed 's|/114.114.114.114$||' /tmp/accelerated-domains.china.conf > /tmp/WhiteList_tmp.txt
	sed -i 's|\(\.\)|\\\1|g' /tmp/WhiteList_tmp.txt
	sed -i 's|server=/|.*\\\b|' /tmp/WhiteList_tmp.txt
	sed -i 's|b\(cn\)$|\.\1|' /tmp/WhiteList_tmp.txt
	cat /tmp/WhiteList_tmp.txt >> /tmp/WhiteList.txt
	
	cp -r /tmp/WhiteList.txt $KSROOT/ss/dns/
	rm -f /tmp/WhiteList_tmp.txt /tmp/WhiteList.txt /tmp/accelerated-domains.china.conf* /tmp/google.china.conf
	echo_date 你的WhiteList.txt已经更新到最新了哦~
	echo --------------------------------------------------------------------------------------------------------

	echo_date 开始更新 Local Routing，请等待...	

	wget --tries=2 -O- --no-check-certificate $china_routing_list > /tmp/Routing_IPv4_orign.txt
	[ "$?" != "0" ] && echo_date 下载错误，退出！ && exit 0
	
	cat /tmp/Routing_IPv4_orign.txt | grep ipv4 | grep CN | awk -F\| '{printf("%s/%d\n", $4, 32-log($5)/log(2))}' > /tmp/Routing_IPv4.txt
	echo -e '[Local Routing]' >> /tmp/Routing_IPv4_tmp.txt
	echo -e '## China mainland routing blocks' >> /tmp/Routing_IPv4_tmp.txt
	echo -e "## Last update: $DATE\n\n" >> /tmp/Routing_IPv4_tmp.txt
	echo -e '## IPv4' >> /tmp/Routing_IPv4_tmp.txt
	echo -e '## Get the latest database from APNIC -> https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' >> /tmp/Routing_IPv4_tmp.txt
	cat /tmp/Routing_IPv4.txt >> /tmp/Routing_IPv4_tmp.txt

	cat /tmp/Routing_IPv4_orign.txt | grep ipv6 | grep CN | awk -F\| '{printf("%s/%d\n", $4, $5)}' > /tmp/Routing_IPv6.txt
	echo -e '## IPv6' >> /tmp/Routing_IPv6_tmp.txt
	echo -e '## Get the latest database from APNIC -> https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' >> /tmp/Routing_IPv6_tmp.txt
	cat /tmp/Routing_IPv6.txt >> /tmp/Routing_IPv6_tmp.txt

	cat /tmp/Routing_IPv6_tmp.txt >> /tmp/Routing_IPv4_tmp.txt
	touch /tmp/Routing.txt
	cat /tmp/Routing_IPv4_tmp.txt >> /tmp/Routing.txt

	cp -r /tmp/Routing.txt $KSROOT/ss/dns/
	rm -f /tmp/Routing_IPv4.txt /tmp/Routing_IPv4_tmp.txt /tmp/Routing_IPv6.txt /tmp/Routing_IPv6_tmp.txt /tmp/Routing.txt /tmp/Routing_IPv4_orign.txt
	echo_date 你的Routing.txt已经更新到最新了哦~
	echo --------------------------------------------------------------------------------------------------------

	# reboot ss
	if [ "$reboot" == "1" ];then
		echo_date 自动重启shadowsocks，以应用新的规则文件！请稍后！
		sh $KSROOT/ss/ssstart.sh restart
	fi
	echo =======================================================================================================	
}

update_list