# koolshare.github.io
####For koolshare.cn 小宝merlin改版固件 软件中心

<b>shadowsocks文件夹下的内容，用于向路由器内shadowsocks功能推送更新,另外软件中心主页的更新也由这里更新</b><br/>

* <b>shadowsocks/ss 文件夹 </b><br/>
该文件夹用于存放shadowsocks相关脚本和规则文件：

* <b>shadowsocks/webs</b><br/>
该文件夹用于存放shadowsocks和软件中心的网页。

* <b>shadowsocks/res</b><br/>
该文件夹用于存放shadowsocks和软件中心的网页元素。

* <b>shadowsocks/bin</b><br/>
该文件夹用于存放shadowsocks的二进制文件。

* <b>shadowsocks/init.d</b><br/>
该文件夹用于存放shadowsocks的开机启动文件，目前因为shadowsocks的启动依赖wan-start和nat-start两个启动文件，所以并没有用init.d的启动方式，而socks5使用了该方式



* <b>shadowsocks.tar.gz</b><br/>
此文件为shadowsocks文件夹的打包，通过路由器访问 [https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks/shadowsocks.tar.gz](https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks/shadowsocks.tar.gz) 获取安装包更新。
如果你更新出现问题，请按照以下方式手动更新：
手动下载https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/shadowsocks/shadowsocks.tar.gz或者需要的历史版本，将压缩包放在路由器的/tmp目录，然后运行

<pre>cd /tmp
tar -zxvf shadowsocks.tar.gz
cd shadowsocks
chmod +x install.sh
sh install.sh
</pre>

* <b>history文件夹</b><br/>
该文件夹用于存放shadowsocks历史安装包，需要回滚历史版本的，可以下载对应版本，然后手动安装。

* <b>version</b><br/>
在线版本号和shadowsocks.tar.gz的md5校验值，用于判断更新。

