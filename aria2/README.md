# koolshare.github.io
####For koolshare.cn 小宝merlin改版固件 软件中心

<b>aria2文件夹下的内容，用于向在路由器内通过软件中心安装了aria2的用户推送更新</b>

* <b>aria2/aria2 文件夹</b><br/>
该文件夹用于存放aria2c二进制文件，动态生成的配置文件aria2.conf也会存放于此，该文件夹安装在路由器的/jffs/分区根目录。

* <b>aria2/scripts 文件夹 </b><br/>
该文件夹用于存放相关脚本：
	1. aria2_run.sh				
		aria2主脚本，用于安装，卸载，启用，禁止，恢复默认参数等功能；
	2. aria2_pros_check.sh		
		aira2进程守护脚本；
	3. aria2_version_check.sh	
		aira2版本检测脚本。

* <b>aria2/webs</b><br/>
该文件夹用于存放Modual_前缀开头的插件网页，修改此处网页能在路由器管理页面实时生效，免去软替换的麻烦。

* <b>aria2/www</b><br/>
该文件是lighttpd的document root目录，目前用于存放_h5ai,aria2 webui,yaaw网页，内部包含了php-cgi静态编译版本。

* <b>aria2.tar.gz</b><br/>
此文件为aria2文件夹的打包，通过路由器访问https://koolshare.github.io/aria2/aria2.tar.gz获取安装包更新。

* <b>version</b><br/>
在线版本号和aria2.tar.gz的md5校验值，用于判断更新。




