# koolshare.github.io
For koolshare.cn 小宝merlin改版固件

<b>此项目的以下文件用于小宝merlin改版固件内文件的自动更新</b>

<b>gfwlist.conf</b><br/>
该文件用于gfwlist模式中，其中的域名用国外dns解析，且走ss流量

<b>chnroute.txt</b><br/>
该文件用于大陆白名单模式和游戏模式中，文件内的IP段不走ss流量

<b>cdn.txt</b><br/>
该文件用于大陆白名单模式和游戏模式中，文件内的域名由国内DNS解析

<b>adblock.conf</b><br/>
该文件用于dnsmasq添加host，过滤列表内的域名，达到过滤广告的效果
<br/>由下面两个文件合并生成

<b>easylist.conf</b><br/>
wget --no-check-certificate -qO - https://easylist-downloads.adblockplus.org/easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' > easylist.conf


<b>chinalist.conf</b><br/>
wget --no-check-certificate -qO - https://easylist-downloads.adblockplus.org/easylistchina.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' > chinalist.conf


