# koolshare-gdddns

## 简介 

> 这是一个适用于梅林固件(koolshare) 的 Godaddy DDNS 插件，开发参考了 [aliddns](https://github.com/kyriosli/koolshare-aliddns) ，并完善了一些安装卸载脚本

## 插件使用

- 首先自己的域名需要托管在 Godaddy
- 在 [Godaddy Developer](https://developer.godaddy.com/keys/) 网站上生成用于调用 Godaddy API 的 Key 和 Secret
- 安装本插件，填入对应 Key 和 Secret，并设置解析域名等相关参数即可

## 开发规范

鉴于 koolshare 还没有一个完整的开发文档(有的可以发我下，感谢)，以下总结了一些写这个插件摸索的一些经验


### 本插件目录结构规范

本插件目录结构如下

``` sh
├── LICENSE                        授权声明
├── README.md                      说明文档
├── build.sh                       编译脚本，一般为打包脚本，感觉也可以写点从源码编译的动作
├── gdddns                         插件主目录(目录名最好和文件名等一致，这是一种默认的约定，暂不确定乱写会不会有问题)
│   ├── install.sh                 安装脚本(默认离线安装会执行此脚本，这里面主要是向 DBUS 注册当前插件状态以及复制文件等)
│   ├── res                        资源目录(一般放插件图标等静态资源文件，按照 web 开发的理解这里面可以放 js、css 等)
│   │   └── icon-gdddns.png        插件图标(命令方式最好和已有插件保持一致，即 icon-xxxx，图片格式暂不确定是否有要求，感觉应该没有)
│   ├── scripts                    插件辅助执行脚本(本插件只需要用脚本执行，其他插件如 shadowsocks 等有二进制执行文件，这里面放的都是辅助脚本)
│   │   ├── gdddns_config.sh       插件配置脚本(主要完成安装、卸载初始化配置等)
│   │   ├── gdddns_update.sh       本插件的主要执行脚本(DDNS 更新域名记录主要从这里执行)
│   │   └── uninstall_gdddns.sh    卸载脚本(默认插件中心点击卸载后，会调用此脚本，主要执行反注册 DBUS 信息和删除插件文件)
│   └── webs                       页面资源文件(主要使用 asp 编写)
│       └── Module_gdddns.asp      插件设置页面(该页面通过 jQuery post 方式调用后端脚本，同时页面内可以使用标签动态调用 DBUS)
└── gdddns.tar.gz                  插件打包文件
```

**约定优于配置: 默认的安装卸载脚本文件名(install.sh、uninstall_xxxx.sh) 请不要乱更改，否则可能不会执行；尤其是插件的文件名约定，
最好参考已有插件命名，不要乱造；否则这些脚本可能不会被执行，点击卸载时也只是做了 DBUS 反注册信息而已，实际文件并未被删除**


### 插件中心目录结构规

**插件在打包成 tar.gz 文件后，安装时将插件各个目录中的内容释放到 `/koolshare` 目录，以下是 `/koolshare` 目录结构**


``` sh
koolshare
├── bin            二进制文件(如果插件需要相关二进制文件，则应当释放到此目录)
├── configs        配置目录(我目前在里面只看到了默认的一个配置，如果插件需要保存配置也可以持久化到此目录，一般为 json 文件)
├── init.d         初始化脚本(放一些初始化脚本，暂时没用到)
├── perp           预处理脚本(个人理解此目录应该放一些每次插件执行都要做的准备脚本)
├── res            资源文件目录
├── scripts        脚本目录
└── webs           页面资源文件(关于 asp 写法可参考其他插件，老本行撸 java 的，感觉跟 jsp 一样...)
```

**从上面 koolshare 目录结构可以看出，实际上插件内的目录结构应该是与其一致的，一般是能少不能多，因为在安装后插件内各个目录中的文件
都会被释放到 `/koolshare` 目录下的相应目录中(安装脚本控制)，除非特殊情情况，比如 shadowsocks 文件很多所以单独创建了文件件(在 `/koolshare`
下差创建了一个 ss 的目录)；**

### 插件更新推送机制
- 插件git地址需要先被 [modules.json](https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/softcenter/modules.json) 收录；
- 插件作者提交插件相关更新后，更改config.json.js内的版本号；
- 插件作者运行 python build.py，会自动生成插件安装包，插件备份
- koolshare插件中心服务器会每隔5分钟检查一次该项目config.json.js内的版本号，如果有更新，则会拉取一份到中转服务
- 同时会将config.json.js的内容插入[app.json.js](https://koolshare.ngrok.wang/softcenter/app.json.js)
- 用户访问软件中心请求[app.json.js](https://koolshare.ngrok.wang/softcenter/app.json.js)，即可知道插件的状态


















