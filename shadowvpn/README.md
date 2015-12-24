# koolshare.github.io
####For koolshare.cn 小宝merlin改版固件 软件中心

<b>shadowvpn文件夹下的内容，用于向路由器内软件中心shadowvpn功能推送更新</b>

* <b>shadowvpn/scripts 文件夹 </b><br/>
该文件夹用于存放shadowvpn相关脚本：
1. shadowvpn.sh
	用于shadowvpn的启动，停止，更新；
2. shadowvpn_client_up.sh
	用于shadowvpn加载tun，路由表等；
3. shadowvpn_client_down.sh
	用于删除路由表等功能。

* <b>shadowvpn/webs</b><br/>
该文件夹用于存放Modual_前缀开头的插件网页，修改此处网页能在路由器管理页面实时生效，免去软替换的麻烦。

* <b>shadowvpn.tar.gz</b><br/>
此文件为shadowvpn文件夹的打包，通过路由器访问 [https://koolshare.github.io/shadowvpn/shadowvpn.tar.gz](https://koolshare.github.io/shadowvpn/shadowvpn.tar.gz) 获取安装包更新。

* <b>version</b><br/>
在线版本号和shadowvpn.tar.gz的md5校验值，用于判断更新。



