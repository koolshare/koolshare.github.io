<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Merlin software center</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="/res/Softerware_center.css"/>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/form.js"></script>
<script type="text/javascript" src="/dbconf?p=softcenter_&v=<% uptime(); %>"></script>
<style>

.cloud_main_radius_left{
    -webkit-border-radius: 10px 0 0 10px;
    -moz-border-radius: 10px 0 0 10px;  
    border-radius: 10px 0 0 10px;
}
.cloud_main_radius_right{
    -webkit-border-radius: 0 10px 10px 0;
    -moz-border-radius: 0 10px 10px 0;  
    border-radius: 0 10px 10px 0;
}
.cloud_main_radius{
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;   
    border-radius: 10px;
}
</style>
<style>
    /* 软件中心icon新样式 by acelan */
    dl,dt,dd{
        padding:0;
        margin:0;
    }
    input[type=button]:focus {
        outline: none;
    }
    .icon{
        float:left;
        position:relative;
        margin: 10px 0px 30px 0px;
    }
    .icon-title{
        line-height: 3em;
        text-align:center;
    }
    .icon-pic{
        background: url(/res/software_center.png) no-repeat 0px 0px;
        width: 64px;
        height: 64px;
        margin: 10px 30px 0px 30px;
    }
    .icon-desc{
        position: absolute;
        left: 0;
        top: 0;
        font-size:0;
        width: 119px;
        border-radius: 8px;
        font-size: 16px;
        opacity: 0;
        background-color:#000;
        line-height: 84px;
        margin:5px;
        text-overflow:ellipsis;
        transition: opacity .5s ease-in;
    }
    .icon-desc .text{
        font-size: 12px;
        line-height: 1.4em;
        vertical-align:middle;
        display: inline-block;
        margin: 10px;
    }
    .icon:hover .icon-desc{
        opacity: .8;
    }
    .icon-desc .opt{
        font-size: 0;
        line-height: 0;
    }
    .icon-desc .install-btn,
    .icon-desc .uninstall-btn,
    .icon-desc .update-btn{
        display: inline-block;
        border: none;
        width: 100%;
        margin-top: 20px;
        border-radius: 0px 0px 5px 5px;
    }
    .icon-desc .uninstall-btn{
        display: none;
    }
    .icon-desc .update-btn{
        display: none;
        border-radius: 0px 0px 0px 5px;
        width:60%;
        border-right: 1px solid #000;
    }
    .show-install-btn,
    .show-uninstall-btn{
        border: none;
        background: #444;
        color: #fff;
        padding: 10px 20px;
        border-radius: 5px 5px 0px 0px;
    }
    .active{
        background: #444f53;
    }
    .install-status-1 .uninstall-btn{
        display: inline-block;
    }
    .install-status-1 .install-btn{
        display: none;
    }
    .install-status-1 .update-btn{
        display: none;
    }
    .install-status-2 .uninstall-btn{
        display: inline-block;
        width: 40%;
        border-radius: 0px 0px 5px 0px;
    }
    .install-status-2 .install-btn{
        display: none;
    }
    .install-status-2 .update-btn{
        display: inline-block;
    }
    .install-status-1{
        display: none;
    }
    .install-status-2{
        display: none;
    }
    .install-status-0{
        display: block;
    }
    .install-view .install-status-1{
        display: block;
    }
    .install-view .install-status-2{
        display: block;
    }
    .install-view .install-status-0{
        display: none;
    }
</style>
<script>
//TODO move this to common javascript files
    jQuery.ajax = (function(_ajax){
    
    var protocol = location.protocol,
        hostname = location.hostname,
        exRegex = RegExp(protocol + '//' + hostname),
        YQL = 'http' + (/^https/.test(protocol)?'s':'') + '://query.yahooapis.com/v1/public/yql?callback=?',
        query = 'select * from html where url="{URL}" and xpath="*"';
    
    function isExternal(url) {
        return !exRegex.test(url) && /:\/\//.test(url);
    }
    
    return function(o) {
        
        var url = o.url;
        
        if ( /get/i.test(o.type) && !/json/i.test(o.dataType) && isExternal(url) ) {
            
            // Manipulate options so that JSONP-x request is made to YQL
            
            o.url = YQL;
            o.dataType = 'json';
            
            o.data = {
                q: query.replace(
                    '{URL}',
                    url + (o.data ?
                        (/\?/.test(url) ? '&' : '?') + jQuery.param(o.data)
                    : '')
                ),
                format: 'xml'
            };
            
            // Since it's a JSONP request
            // complete === success
            if (!o.success && o.complete) {
                o.success = o.complete;
                delete o.complete;
            }
            
            o.success = (function(_success){
                return function(data) {
                    
                    if (_success) {
                        // Fake XHR callback.
                        _success.call(this, {
                            responseText: (data.results[0] || '')
                                // YQL screws with <script>s
                                // Get rid of them
                                .replace(/<script[^>]+?\/>|<script(.|\s)*?\/script>/gi, '')
                        }, 'success');
                    }
                    
                };
            })(o.success);
            
        }
        
        return _ajax.apply(this, arguments);
        
    };
    
})(jQuery.ajax);

String.prototype.format = String.prototype.f = function() {
    var s = this,
    i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};

function formatString(s, args) {
    i = args.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), args[i]);
    }
    return s;
}

String.prototype.endsWith = function (suffix) {
  return (this.substr(this.length - suffix.length) === suffix);
}

String.prototype.startsWith = function(prefix) {
  return (this.substr(0, prefix.length) === prefix);
}

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

var softcenter_modules = {};
function parse_softcenter() {
    var sm = "softcenter_module_";
    for(o in db_softcenter_) {
        if(o.indexOf(sm) != -1) {
            var pos = o.indexOf("_", sm.length);
            if(pos == -1) {
             continue;
            }
            var name = o.substring(sm.length, pos);
            //console.log(name);
            var ob = null;
            if (typeof(softcenter_modules[name]) != "undefined") {
                ob = softcenter_modules[name];
            } else {
                ob = {};
                softcenter_modules[name] = ob;
            }
            var name_op = o.substring(pos+1);
            //console.log("name_op:"+name_op);
            if(name_op.length == 0) {
                 continue;
            }
            ob[name_op]=db_softcenter_[o];
        }
    }

    //alert(softcenter_modules);
    //console.log(softcenter_modules);
}

// function checkField(o, f, d) {
//     if(typeof o[f] == "undefined") {
//         o[f] = d;
//     }
    
//     return o[f];
// }

// function onModuleHide(tr) {
//     var id = $(tr).attr("id");
//     if(typeof(id) != "undefined") {
//         var ob = id.substring(0, id.indexOf("_"));
//         if(ob.length == 0) {
//             return;
//         }

//         var visible = "softcenter_module_"+ob+"_visible";
//         var data = {"SystemCmd":"echo softccenter", "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};
//         data[visible] = "0";
//         $.ajax({
//                 type: "POST",
//                 url: "applydb.cgi?p=softcenter_",
//                 dataType: "text",
//                 data: data,
//                 success: function() {
//                     $(tr).hide();
//                     var nel = $(tr).next("tr");
//                     if(typeof(nel) != "undefined" && $(nel).attr("class") == "softcenter_tr2") {
//                         $(nel).hide();
//                     }
//                 },
//                 error: function() {
//                     console.log("error");
//                 }
//             });
//     }
// }

//先提交一个请求检测有没有插件正在安装，如果有但安装超时了，或者没有正在安装的，则拿到当前用户提交的moduleInfo信息，交给appInstall函数再产生一个提交，后台会进行安装，同时异常更新当前的安装状态。
// function appInstallTest() {
//     //Check if the installing is exists
//     $.ajax({
//         type: "get",
//         url: "dbconf?p=softcenter_installing_",
//         dataType: "script",
//         success: function(xhr) {
//             console.log("request ok");
//             var o = db_softcenter_installing_;
//             var d = new Date();
//             var curr = d.getTime()/1000 - 20;
//             tick = parseInt(checkField(o, "softcenter_installing_tick", "0"));
//             curr_module = checkField(o, "softcenter_installing_module", "");
//             if(tick > curr && curr_module != "") {
//                 console.log("previous install exists");
//                 return;
//             }

//             moduleInfo = {
//                 "description": "去广告，看疗效~", 
//                 "home_url": "Module_adm.asp", 
//                 "md5": "a9148835ab402d8f1ba920aea40011a3", 
//                 "name": "adm", 
//                 "tar_url": "adm/adm.tar.gz", 
//                 "title": "阿呆猫", 
//                 "version": "0.5"
//             }; 

//             appInstall(moduleInfo);
            
//         }
//     });

// }

// function oninstall(el) {
//     var app = $(el).closest("dl");
//     var name = 'softcenter_module_' + $(app).data('name');
//     var appInfo = softInfo[name];
//     if(appInfo.install == "1") {
//         alert("already installed");
//     }
//     console.log(appInfo);
// }

// function onuninstall(el) {
//     console.log(el);
// }

// function appInstall(moduleInfo) {
//     //Current page must has prefix of "Module_"
//         var data = {"SystemCmd":"app_install.sh", "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};
//     data["softcenter_installing_todo"] = moduleInfo.name;
//     data["softcenter_installing_version"] = moduleInfo.version;
//     data["softcenter_installing_md5"] = moduleInfo.md5;
//     data["softcenter_installing_tar_url"] = moduleInfo.tar_url;

//     //TODO auto choose for home_url
//     data["softcenter_home_url"] = "http://koolshare.ngrok.wang:5000";

//     //Update title for this module
//     data[moduleInfo.name + "_title"] = moduleInfo.title;

//         $.ajax({
//                 type: "POST",
//                 url: "applydb.cgi?p=softcenter_,"+moduleInfo.name,
//                 dataType: "text",
//                 data: data,
//                 success: function() {
//             console.log("install ok");

//             //TODO update installing status
//             		setTimeout("showInstallStatus()");
//                 },
//                 error: function() {
//             		console.log("install error");
//                 }
//         });

// }


//         $("#updateBtn").click(function(e){
//             //e.preventDefault();
//             //TODO better here
//         $("#updateBtn").hide();
//             var data = {"SystemCmd":"softcenter.sh", "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};
//             data["softcenter_install_status"] = "0";
//             $.ajax({
//                     type: "POST",
//                     url: "applydb.cgi?p=softcenter_",
//                     dataType: "text",
//                     data: data,
//                     success: function() {
//                         //location.reload();
//                         setTimeout("location.reload();", 8000);
//                     },
//                     error: function() {
//                         console.log("error");
//                     }
//                 });

</script>
<script>
    // home_url 与 tar_url 可能不存在,不存在时默认为 Module_{module}.asp 与 {module}/{module}.tar.gz
    var db_softcenter_ = {
        "softcenter_curr_version": "1.0.5",
        "softcenter_install_status": "0",
        "softcenter_home_url": "https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui",

        "softcenter_module_adm_status": "0",
        "softcenter_module_adm_install": "1",
        "softcenter_module_adm_version": "0",
        "softcenter_module_adm_tar_url": "",
        "softcenter_module_adm_home_url": "Module_adm.asp",
        "softcenter_module_adm_title": "阿呆猫",

        "softcenter_module_aria2_status": "0",
        "softcenter_module_aria2_install": "0",
        "softcenter_module_aria2_version": "0",
        "softcenter_module_aria2_tar_url": "",
        "softcenter_module_aria2_title": "Aria2",

        "softcenter_module_entware_status": "2",
        "softcenter_module_entware_install": "0",
        "softcenter_module_entware_version": "0",
        "softcenter_module_entware_tar_url": "",
        "softcenter_module_entware_title": "Entware-ng",

        "softcenter_module_koolnet_status": "0",
        "softcenter_module_koolnet_version": "0",
        "softcenter_module_koolnet_install": "1",
        "softcenter_module_koolnet_tar_url": "",
        "softcenter_module_koolnet_title": "P2P穿透",

        "softcenter_module_kuainiao_status": "0",
        "softcenter_module_kuainiao_install": "0",
        "softcenter_module_kuainiao_version": "0",
        "softcenter_module_kuainiao_tar_url": "",
        "softcenter_module_kuainiao_title": "快鸟",

        "softcenter_module_policy_status": "0",
        "softcenter_module_policy_install": "0",
        "softcenter_module_policy_version": "0",
        "softcenter_module_policy_tar_url": "",
        "softcenter_module_policy_title": "策略路由",

        "softcenter_module_shadowvpn_status": "0",
        "softcenter_module_shadowvpn_install": "0",
        "softcenter_module_shadowvpn_version": "0",
        "softcenter_module_shadowvpn_tar_url": "",
        "softcenter_module_shadowvpn_title": "ShadowVPN",

        "softcenter_module_speedtest_status": "0",
        "softcenter_module_speedtest_install": "0",
        "softcenter_module_speedtest_version": "0",
        "softcenter_module_speedtest_tar_url": "",
        "softcenter_module_speedtest_title": "网络测速",

        "softcenter_module_ssserver_status": "0",
        "softcenter_module_ssserver_install": "1",
        "softcenter_module_ssserver_version": "0",
        "softcenter_module_ssserver_tar_url": "",
        "softcenter_module_ssserver_title": "SS服务器",

        "softcenter_module_transmission_status": "2",
        "softcenter_module_transmission_install": "2",
        "softcenter_module_transmission_version": "2",
        "softcenter_module_transmission_tar_url": "",
        "softcenter_module_transmission_title": "Transmission",

        "softcenter_module_tunnel_status": "0",
        "softcenter_module_tunnel_install": "1",
        "softcenter_module_tunnel_tar_url": "",
        "softcenter_module_tunnel_version": "1.0.0",
        "softcenter_module_tunnel_title": "穿透DDNS",

        "softcenter_module_v2ray_status": "2",
        "softcenter_module_v2ray_install": "2",
        "softcenter_module_v2ray_version": "2",
        "softcenter_module_v2ray_url": "2",
        "softcenter_module_v2ray_title": "V2Ray",

        "softcenter_module_xunlei_status": "0",
        "softcenter_module_xunlei_install": "0",
        "softcenter_module_xunlei_version": "0",
        "softcenter_module_xunlei_url": "0",
        "softcenter_module_xunlei_title": "Xunlei下载"
    };

    //Global state
    var currState = {"needUpdate": true};

    // function showInstallStatus() {
    //     $.ajax({
    //     type: "get",
    //     url: "dbconf?p=softcenter_installing_",
    //     dataType: "script",
    //     success: function(xhr) {
    //         var o = db_softcenter_installing_;
    //         var d = new Date();
    //         var curr = d.getTime()/1000 - 20;
    //         tick = parseInt(checkField(o, "softcenter_installing_tick", "0"));
    //         curr_module = checkField(o, "softcenter_installing_module", "");
    //         if(tick > curr && curr_module != "") {
    //         }
    //        }
    //     })
    // }
    
    // function showInstallInfo(module, scode) {
    //     var code = parseInt(scode);
    //     var s = module.capitalizeFirstLetter();
    //     var infoTxt = "尚未安装 \
    //         已安装 \
    //         将被安装到jffs分区... \
    //         正在下载中...请耐心等待... \
    //         正在安装中... \
    //         安装成功！请5秒后刷新本页面！... \
    //         卸载中...... \
    //         卸载成功！ \
    //         没有检测到在线版本号！ \
    //         正在下载更新...... \
    //         正在安装更新... \
    //         安装更新成功，5秒后刷新本页！ \
    //         下载文件校验不一致！ \
    //         然而并没有更新！ \
    //         正在检查是否有更新~ \
    //         检测更新错误！"
    //     var infos = infoTxt.split(" ");
    //     $("#appInstallInfo").html(s + infos[code]);
    // }

    // $(function () {
    //     showInstall(1);
    // });

    //切换安装未安装面板
    function toggleAppPanel(showInstall) {
        $('.show-install-btn').removeClass('active');
        $('.show-uninstall-btn').removeClass('active');
        $(showInstall ? '.show-install-btn' : '.show-uninstall-btn').addClass('active');
        $('#IconContainer')[showInstall ? 'addClass' : 'removeClass']('install-view');
    }
    /**
     * 渲染apps，安装和未安装按照class hook进行显示隐藏，存在同一个面板中
     */
    function renderView(apps) {
        //简单模板函数
        function _format(source, opts) {
            var source = source.valueOf(),
                data = Array.prototype.slice.call(arguments, 1),
                toString = Object.prototype.toString;
            if(data.length){
                data = data.length == 1 ? 
                    (opts !== null && (/\[object Array\]|\[object Object\]/.test(toString.call(opts))) ? opts : data) 
                    : data;
                return source.replace(/#\{(.+?)\}/g, function (match, key){
                    var replacer = data[key];
                    // chrome 下 typeof /a/ == 'function'
                    if('[object Function]' == toString.call(replacer)){
                        replacer = replacer(key);
                    }
                    return ('undefined' == typeof replacer ? '' : replacer);
                });
            }
            return source;
        }
        //app 模板
	// icon 规则: 
	// 如果已安装的插件,那图标必定在 /koolshare/res 目录, 通过 /res/icon-{name}.png 请求路径得到图标
	// 如果是未安装的插件,则必定在 http://koolshare.ngrok.wang:5000/{name}/{name}/icon-{name}.png
	// TODO 如果因为一些错误导致没有图标, 有可能显示一张默认图标吗?
        var tpl = ['',
            '<dl class="icon install-status-#{install}" data-name="#{name}">',
                '<dd class="icon-pic"></dd>',
                '<dt class="icon-title">#{title}</dt>',
                '<dd class="icon-desc">',
                    '<div class="text">',
                        '<a href="/#{home_url}">#{description}</a>',
                    '</div>',
                    '<div class="opt">',
                        '<button type="button" class="install-btn" data-name="#{name}">安装</button>',
                        '<button type="button" class="update-btn" data-name="#{name}">更新</button>',
                        '<button type="button" class="uninstall-btn" data-name="#{name}">卸载</button>',
                    '</div>',
                '</dd>',
            '</dl>'
        ].join('');

        var installCount = 0;
        var uninstallCount = 0;
        var html = $.map(apps, function (app, name) {
            parseInt(app.install, 10) ? installCount++ : uninstallCount++;
            return _format(tpl, app);
        });

        $('#IconContainer').html(html.join(''));
        //更新安装数
        $('.show-install-btn').val('已安装(' + installCount + ')');
        $('.show-uninstall-btn').val('已安装(' + uninstallCount + ')');
    }

    var syncRemoteSuccess = 0; //判断是否进入页面后已经成功进行远端同步

    function getRemoteData() {
        var remoteURL = db_softcenter_["softcenter_home_url"] + '/softcenter/app.json.js';
        return $.ajax({
            url: remoteURL,
            method: 'GET',
            dataType: 'json',
            timeout: 1 * 1000
        });
    }
    function init(cb) {
        //设置默认值
        function _setDefault(source, defaults) {
            $.map(defaults, function (value, key) {
                if (!source[key]) {
                    source[key] = value;
                }
            });
        }
        //把本地数据平面化转换成以app为对象
        function _formatLocalData(localData) {
            var result = {};
            $.map(db_softcenter_, function (item, key) {
                key = key.split('_');
                if ('module' === key[1]) {
                    var name = key[2];
                    var prop = key.slice(3).join("_");
                    if (!result[name]) {
                        result[name] = {};
                        result[name].name = name;
                    }
                    result[name][prop] = item;
                }
            });
            //设置默认值
            $.map(result, function (item, name) {
                _setDefault(item, {
                    home_url: "Module_" + name + ".asp",
                    title: name.capitalizeFirstLetter(),
                    tar_url:  "{0}/{0}.tar.gz".format(name),
                    install: "0",
                    description: "暂无",
                    new_version: false
                });
            });
            return result;
        }
        //将本地和远程进行一次对比合并
        function _mergeData(remoteData) {
            var result = {};
            var localData = _formatLocalData(db_softcenter_);
            $.each(remoteData, function (i, app) {
                var name = app.name;
                var oldApp = localData[name] || {};
                var install = (parseInt(oldApp.install, 10) === 1 && app.version !== oldApp.version) ? 2 : oldApp.install || "0"; 
                result[name] = $.extend(oldApp, app);
                result[name].install = install;
            });
            $.map(localData, function (app, name) {
                if (!result[name]) {
                    result[name] = app;
                }
            });
            return result;
        };
        if (syncRemoteSuccess) {
            cb();
            return;
        } else {
            getRemoteData()
                .done(function (remoteData) {
                    //远端更新成功
                    syncRemoteSuccess = 1;
                    remoteData = remoteData.apps || [];
                    renderView(_mergeData(remoteData));
                    cb();
                })
                .fail(function () {
                    //如果没有更新成功，比如没网络，就用空数据merge本地
                    renderView(_mergeData({}));
                    cb();
                });
        }
    }
    //初始化整个界面展现，包括安装未安装的获取
    //当初始化过程获取软件列表失败时候，用本地的模块进行渲染
    //只要一次获取成功，以后不在重新获取，知道页面刷新重入
    $(function () {
	//梅林要求用这个函数来显示左测菜单
	show_menu();

        init(function () {
            toggleAppPanel(1);
        });
        //挂接tab切换安装状态事件
        $('.show-install-btn').click(function () {
            init(function () {
                toggleAppPanel(1);
            });
        });
        $('.show-uninstall-btn').click(function () {
            init(function () {
                toggleAppPanel(0);
            });
        });
        //挂接安装或者卸载事件
        $('#IconContainer').on('click', '.install-btn', function () {
            var name = $(this).data('name');
            console.log('install', name);
        });
        $('#IconContainer').on('click', '.uninstall-btn', function () {
            var name = $(this).data('name');
            console.log('uninstall', name);
        });
        $('#IconContainer').on('click', '.update-btn', function () {
            var name = $(this).data('name');
            console.log('update', name);
        });
    });
</script>
</head>
<body>
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
    <input type="hidden" name="current_page" value="Main_Soft_center.asp">
    <input type="hidden" name="next_page" value="Main_Soft_center.asp">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="action_wait" value="8">
    <input type="hidden" name="first_time" value="">
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
    <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<table class="content" align="center" cellpadding="0" cellspacing="0">  
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
                <table id="softcenter_td" width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top">
                            <div>
                                <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
                                    <tr>
                                        <td bgcolor="#4D595D" colspan="3" valign="top">
                                            <div>&nbsp;</div>
                                            <div class="formfonttitle">Software Center</div>
                                            <div style="margin-left:5px;margin-top:5px;margin-bottom:5px"><img src="/images/New_ui/export/line_export.png"></div>
                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
                                                </table>
                                                <table width="100%" height="150px" style="border-collapse:collapse;">
                                                    <tr bgcolor="#444f53">
                                                        <td colspan="5" bgcolor="#444f53" class="cloud_main_radius">
                                                            <div style="padding:10px;width:95%;font-style:italic;font-size:14px;">
                                                                <br/><br/>
                                                                <table width="100%" >
                                                                    <tr>
                                                                        <td>
                                                                            <ul style="margin-top:-50px;padding-left:15px;" >
                                                                                <li style="margin-top:-5px;">
                                                                                    <h2>欢迎</h2>
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    欢迎来到插件中心，目前正在紧张开发中，各种插件酝酿中！
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    如果你想加入我们的工作，在 <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a>联系我们！
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    当前版本：<span id="spnCurrVersion"></span> 在线版本：<span id="spnOnlineVersion"></span>
                                                                                    <input type="button" id="updateBtn" value="更新" style="display:none" />
                                                                                </li>
                                                                            </ul>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr height="10px">
                                                        <td colspan="3"></td>
                                                    </tr>

                                                    <tr width="235px">
                                                        <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0">
                                                            <input class="show-install-btn" type="button" value="已安装"/>
                                                            <input class="show-uninstall-btn" type="button" value="未安装"/>
                                                        </td>
                                                    </tr>

                                                    <tr bgcolor="#444f53" width="235px">
                                                        <td colspan="4" id="IconContainer">
                                                            <div style="text-align:center; line-height: 4em;">更新中...</div>
                                                        </td>
                                                    </tr>

                                                    <tr bgcolor="#444f53" width="235px">
                                                            <td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
                                                                <div style="padding:10px;" align="left">
                                                                    <li>摄像头挂载？</li>
                                                                    <li>百度云？</li>
                                                                    <li>Transmission？</li>
                                                                    <li>Owncloud？</li>
                                                                    <li>中文SSID?</li>
                                                                    <li>校园网认证？</li>
                                                                    
                                                                    <li>....</li>
                                                                </div>
                                                            </td>
                                                            <td width="6px">
                                                                <div align="center"><img src="/images/cloudsync/line.png"></div>
                                                            </td>
                                                            <td width="1px">
                                                            </td>
                                                            <td>
                                                                <div style="padding:10px;width:95%;font-size:14px;" id="appInstallInfo">
                                                                    然而并没有...请随时关注固件更新哦~<i>（上古天坑区）</i>
                                                                </div>
                                                            </td>
                                                            <td class="cloud_main_radius_right">
                                                            </td>
                                                        </tr>
                                                </table>
                                            <div class="KoolshareBottom">论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a>
                                                <br/>博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a>
                                                <br/>Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a>
                                                <br/>Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> </a>, Web by： <i>Xiaobao</i>
                                            </div>
                                        </td>
                                    </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

