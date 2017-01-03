#!/bin/sh

# ======================================
# get gfwlist for shadowsocks ipset mode
./fwlist.py gfwlist_download.conf

if [ -f "gfwlist_download.conf" ];then
	cat gfwlist_download.conf gfwlist_koolshare.conf | sed "s/server=\/\.//g" | sed "s/server=\///g" | sed "s/ipset=\/\.//g" | sed "s/ipset=\///g" | sed -r "s/\/\S{1,30}//g" | sed -r "s/\/\S{1,30}//g" | sed '/^\./d' | sort | sed '$!N; /^\(.*\)\n\1$/!P; D' | sed '/^#/d' | sed '1d' | sed "s/,/\n/g" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#7913/g" > gfwlist_merge.conf
	cat gfwlist_download.conf gfwlist_koolshare.conf | sed "s/server=\/\.//g" | sed "s/server=\///g" | sed "s/ipset=\/\.//g" | sed "s/ipset=\///g" | sed -r "s/\/\S{1,30}//g" | sed -r "s/\/\S{1,30}//g" | sed '/^\./d' | sort | sed '$!N; /^\(.*\)\n\1$/!P; D' | sed '/^#/d' | sed '1d' | sed "s/,/\n/g" | sed "s/^/ipset=&\/./g" | sed "s/$/\/gfwlist/g" >> gfwlist_merge.conf
fi

sort -k 2 -t. -u gfwlist_merge.conf > gfwlist1.conf
rm gfwlist_merge.conf

# delete site below if any
sed -i '/m-team/d' "gfwlist1.conf"
sed -i '/85.17.73.31/d' "gfwlist1.conf"
sed -i '/windowsupdate/d' "gfwlist1.conf"
sed -i '/v2ex/d' "gfwlist1.conf"

md5sum1=$(md5sum gfwlist1.conf | sed 's/ /\n/g'| sed -n 1p)
md5sum2=$(md5sum ../gfwlist.conf | sed 's/ /\n/g'| sed -n 1p)

echo =================
if [ "$md5sum1"x = "$md5sum2"x ];then
	echo gfwlist same md5!
	rm gfwlist1.conf
	rm gfwlist_download.conf
else
	echo update gfwlist!
	rm gfwlist_download.conf
	mv -f gfwlist1.conf ../gfwlist.conf
	sed -i "1c `date +%Y-%m-%d` # $md5sum1 gfwlist" ../version1
fi
echo =================
# ======================================
# get chnroute for shadowsocks chn and game mode

curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > chnroute1.txt

md5sum3=$(md5sum chnroute1.txt | sed 's/ /\n/g'| sed -n 1p)
md5sum4=$(md5sum ../chnroute.txt | sed 's/ /\n/g'| sed -n 1p)

echo =================
if [ "$md5sum3"x = "$md5sum4"x ];then
	echo chnroute same md5!
	rm chnroute1.txt
else
	echo update chnroute!
	mv -f chnroute1.txt chnroute.txt
	sed -i "2c `date +%Y-%m-%d` # $md5sum3 chnroute" ../version1
fi
echo =================
# ======================================
# get cdn list for shadowsocks chn and game mode

wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf

cat accelerated-domains.china.conf | sed "s/server=\/\.//g" | sed "s/server=\///g" | sed -r "s/\/\S{1,30}//g" | sed -r "s/\/\S{1,30}//g" > cdn_download.txt
cat cdn_koolshare.txt cdn_download.txt | sort -u > cdn1.txt

md5sum5=$(md5sum cdn1.txt | sed 's/ /\n/g'| sed -n 1p)
md5sum6=$(md5sum ../cdn.txt | sed 's/ /\n/g'| sed -n 1p)

echo =================
if [ "$md5sum5"x = "$md5sum6"x ];then
	echo cdn list same md5!
	rm cdn1.txt accelerated-domains.china.conf cdn_download.txt
else
	echo update cdn!
	rm accelerated-domains.china.conf cdn_download.txt
	mv -f cdn1.txt ../cdn.txt
	sed -i "4c `date +%Y-%m-%d` # $md5sum5 cdn" ../version1
fi
echo =================
# ======================================
