<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
        margin: 10px 30px 0px 30px;
    }
    .icon-pic img{
        border:0;
        width: 60px;
        height: 60px;
        margin:2px;
    }
    .icon-desc{
        position: absolute;
        left: 0;
        top: 0;
        height: 105%;
        visibility: hidden;
        font-size:0;
        width: 119px;
        border-radius: 8px;
        font-size: 16px;
        opacity: 0;
        background-color:#000;
        margin:5px;
        text-overflow:ellipsis;
        transition: opacity .5s ease-in;
    }
    .icon-desc .text{
        font-size: 12px;
        line-height: 1.4em;
        display: block;
        height: 100%;
        padding: 10px;
        box-sizing: border-box;
    }
    .icon:hover .icon-desc{
        opacity: .8;
        visibility: visible;
    }
    .icon-desc .opt{
        position: absolute;
        bottom: 0;
        height: 18px;
        width: 100%;
    }
    .install-status-0 .icon-desc .opt{
        height: 100%;
    }
    .icon-desc .install-btn,
    .icon-desc .uninstall-btn,
    .icon-desc .update-btn{
    	background: #fff;
    	color:#333;
    	cursor:pointer;
    	text-align: center;
    	font-size: 13px;
    	padding-bottom: 5px;
    	margin-left: 10px;
    	margin-right: 10px;
        display: block;
        width: 100%;
        height: 18px;
        border-radius: 0px 0px 5px 5px;
        border: 0px;
        position: absolute;
        bottom: 0;
        left: -10px;
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
        display: block;
    }
    .install-status-1 .install-btn{
        display: none;
    }
    .update-btn{
        display: none;
    }
    .install-status-1 .update-btn{
        display: none;
    }
    .install-status-4 .uninstall-btn{
        display: block;
    }
    .install-status-4 .install-btn{
        display: none;
    }
    .install-status-4 .update-btn{
        display: none;
    }
    .install-status-2 .uninstall-btn{
        display: block;
        width: 40%;
        border-radius: 0px 0px 5px 0px;
        right: -10px;
        left: auto;
        border-left: 1px solid #000;
    }
    .install-status-2 .install-btn{
        display: none;
    }
    .install-status-2 .update-btn{
        display: block;
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
    .install-status-4{
        display: none;
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
    .install-view .install-status-4{
        display: block;
    } 
    .cloud_main_radius h2 { border-bottom:1px #AAA dashed;}
	.cloud_main_radius h3,
	.cloud_main_radius h4 { font-size:12px;color:#FC0;font-weight:normal;font-style: normal;}
	.cloud_main_radius h5 { color:#FFF;font-weight:normal;font-style: normal;}
</style>
<script>
//set tabstop=4 set shiftwidth=4 set expandtab
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
function checkField(o, f, d) {
    if(typeof o[f] == "undefined") {
        o[f] = d;
    }

    return o[f];
}
function appPostScript(moduleInfo, script) {
    if(currState.installing) {
    console.log("current is in installing state");
    return;
    }
    //Current page must has prefix of "Module_"
    var data = {"SystemCmd":script, "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};

    var applyUrl = "applydb.cgi?p=softcenter_";

    //currState.name = moduleInfo.name;
    //TODO auto choose for home_url
    data["softcenter_home_url"] = "https://koolshare.ngrok.wang";
    data["softcenter_installing_todo"] = moduleInfo.name;
    if(script == "ks_app_install.sh") {
    data["softcenter_installing_tar_url"] = moduleInfo.tar_url;
    data["softcenter_installing_md5"] = moduleInfo.md5;
    data["softcenter_installing_version"] = moduleInfo.version;

    //Update title for this module
    data[moduleInfo.name + "_title"] = moduleInfo.title;
        applyUrl = applyUrl + "," + moduleInfo.name;
    }

        $.ajax({
                type: "POST",
                url: applyUrl,
                dataType: "text",
                data: data,
                success: function() {
                    var d = new Date();
                    //持续更新
                    currState.lastChangeTick = d/1000 + TIMEOUT_SECONDS;
                    currState.installing = true;
                    showInstallStatus(true);
                },
                error: function() {
                    currState.installing = false;
                    console.log("install error");
                }
        });
}
function appInstallModule(moduleInfo) {
    appPostScript(moduleInfo, "ks_app_install.sh");
}
function appUninstallModule(moduleInfo) {

    if (!window.confirm('确定卸载吗')) {
        return;
    }
    appPostScript(moduleInfo, "ks_app_remove.sh");
}
</script>
<script>
    //TODO auto detect home url
    db_softcenter_["softcenter_home_url"] = "https://koolshare.ngrok.wang";
    
    // 安装信息更新策略:
    // 当软件安装的时候,安装进程内部会有超时时间. 超过超时时间 没安装成功,则认为失败.
    // 但是路由内部的绝对时间与浏览器上的时间可能不同步,所以无法使用路由器内的时间. 浏览器的策略是,
    // 安装的时候会有一个同样的计时,若这个超时时间内,安装状态有变化,则更新安装状态.从而可以实时更新安装进程.
    var currState = {"installing": false, "lastChangeTick": 0, "lastStatus": "-1", "module":""};
    var TIMEOUT_SECONDS = 18;
    // TODO 如何避免实用全局变量?
    var softInfo = null;
    function initInstallStatus() {
    var o = db_softcenter_;
    var base = "softcenter_installing_";
    if(o[base+"status"]) {
        //状态不是0/1/7,则当前正处于安装状态,实时更新安装信息
        if((o[base+"status"] != "0") && (o[base+"status"] != "1") && (o[base+"status"] != "7")) {
            var d = new Date();
            currState.lastChangeTick = d/1000 + TIMEOUT_SECONDS;
            currState.lastStatus = o[base+"status"];
            currState.installing = true;
            //currState.name = o[base+"module"];
            showInstallStatus(true);
        }
    }
    }
    function showInstallStatus(isInit) {
        $.ajax({
        type: "get",
        url: "dbconf?p=softcenter_installing_",
        dataType: "script",
        success: function(xhr) {
            var o = db_softcenter_installing_;
            var base = "softcenter_installing_";
            console.log("status: " + o[base+"status"]);
            if(isInit) {
                currState.lastStatus = o[base+"status"];
            }
            var d = new Date();
            var curr = d.getTime()/1000;
            curr_module = checkField(o, "softcenter_installing_module", "");
            if(o[base+"status"] != currState.lastStatus) {
                currState.lastStatus = o[base+"status"];
                showInstallInfo(curr_module, currState.lastStatus);

                // Install ok now
                if(currState.lastStatus == "1" || currState.lastStatus == "7") {
                    currState.installing = false;
                    setTimeout("window.location.reload()", 1000);
                    return;
                } else if(currState.lastStatus == "0") {
                    currState.installing = false;
                }
            }
            if(currState.lastChangeTick > curr) {
                    setTimeout("showInstallStatus()", 1500);
            } else {
                    currState.installing = false;
                    $("#appInstallInfo").html("等待超时,可尝试手动刷新");
                    //showInstallInfo("", currState.lastStatus);
            }
           }
        })
    }

    function showInstallInfo(module, scode) {
        var code = parseInt(scode);
        var s = module.capitalizeFirstLetter();
        var infos = [
            "操作失败",
            "已安装",
            "将被安装到jffs分区...",
            "正在下载中...请耐心等待...",
            "正在安装中...",
            "安装成功！请5秒后刷新本页面！...",
            "卸载中......",
            "卸载成功！",
            "没有检测到在线版本号！",
            "正在下载更新......",
            "正在安装更新...",
            "安装更新成功，5秒后刷新本页！ ",
            "下载文件校验不一致！",
            "然而并没有更新！",
            "正在检查是否有更新~",
            "检测更新错误！"
        ];
        document.getElementById("install_status").style.display = "";
        $("#appInstallInfo").html(s + infos[code]);
    }
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
        // set apps to global variable of softInfo
        softInfo = apps;
        //console.log(softInfo);

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
        var tpl = ['',
            '<dl class="icon install-status-#{install}" data-name="#{name}">',
                '<dd class="icon-pic">',
                    //当图标娶不到的时候，使用默认图标，如果已经是默认图标且娶不到，就狗带了，不管
                    '<img src="#{icon}" onerror="this.src.indexOf(\'icon-default.png\')===-1 && (this.src=\'/res/icon-default.png\');" alt="图标出走了～"/>',
                    '<img class="update-btn" style="position: absolute;width:20px;height:20px;margin-top:-66px;margin-left:44px;" src="/res/upgrade.png"',
                '</dd>',
                '<dt class="icon-title">#{title}</dt>',
                '<dd class="icon-desc">',
                    '<a class="text" href="/#{home_url}">',
                        '#{description}',
                    '</a>',
                    '<div class="opt">',
                        '<a type="button" class="install-btn" data-name="#{name}">安装</a>',
                        '<a type="button" class="update-btn" data-name="#{name}">更新</a>',
                        '<a type="button" class="uninstall-btn" data-name="#{name}">卸载</a>',
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
        $('.show-uninstall-btn').val('未安装(' + uninstallCount + ')');
    }
    var syncRemoteSuccess = 0; //判断是否进入页面后已经成功进行远端同步
    function getRemoteData() {
        var remoteURL = db_softcenter_["softcenter_home_url"] + '/softcenter/app.json.js';
        return $.ajax({
            url: remoteURL,
            method: 'GET',
            dataType: 'jsonp',
            timeout: 1 * 1000
        });
    }

function softceterInitData(data) {
    var remoteData = data;
    $("#spnOnlineVersion").html(remoteData.version);
    if(remoteData.version != db_softcenter_["softcenter_version"]) {
     $("#updateBtn").show();
     $("#updateBtn").click(function () {
          var moduleInfo = {
        "name":"softcenter",
        "md5": remoteData.md5,
        "tar_url": remoteData.tar_url,
        "version": remoteData.version
        };
          appPostScript(moduleInfo, "ks_app_install.sh");
     });
    }
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
                    if (prop) {
                        result[name][prop] = item;
                    }
                }
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
            //设置默认值和设置icon的路径
            $.map(result, function (item, name) {
                _setDefault(item, {
                    home_url: "Module_" + name + ".asp",
                    title: name.capitalizeFirstLetter(),
                    tar_url:  "{0}/{0}.tar.gz".format(name),
                    install: "0",
                    description: "暂无",
                    new_version: false
                });

                // icon 规则:
                // 如果已安装的插件,那图标必定在 /koolshare/res 目录, 通过 /res/icon-{name}.png 请求路径得到图标
                // 如果是未安装的插件,则必定在 https://koolshare.ngrok.wang/{name}/{name}/icon-{name}.png
                // TODO 如果因为一些错误导致没有图标, 有可能显示一张默认图标吗?
                item.icon = parseInt(item.install, 10) !== 0
                    ? ('/res/icon-' + item.name + '.png')
                    : ('https://koolshare.ngrok.wang' + new Array(3).join('/softcenter') + '/res/icon-' + item.name + '.png');
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
                    softceterInitData(remoteData);

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
    notice_show();
    }
    //初始化整个界面展现，包括安装未安装的获取
    //当初始化过程获取软件列表失败时候，用本地的模块进行渲染
    //只要一次获取成功，以后不在重新获取，知道页面刷新重入
    $(function () {
    //梅林要求用这个函数来显示左测菜单
    show_menu(menu_hook);

    if(!db_softcenter_["softcenter_version"]) {
        db_softcenter_["softcenter_version"] = "0.0";
    }
    $("#spnCurrVersion").html(db_softcenter_["softcenter_version"]);

        init(function () {
            toggleAppPanel(1);
        //一刷新界面是否就正在插件在安装.
        initInstallStatus();
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
            appInstallModule(softInfo[name]);
        });
        $('#IconContainer').on('click', '.uninstall-btn', function () {
            var name = $(this).data('name');
            console.log('uninstall', name);
            appUninstallModule(softInfo[name]);
        });
        $('#IconContainer').on('click', '.update-btn', function () {
            var name = $(this).data('name');
            console.log('update', name);
            appInstallModule(softInfo[name]);

        });

    });
var enable_ss = "<% nvram_get("enable_ss"); %>";
var enable_soft = "<% nvram_get("enable_soft"); %>";
function menu_hook() {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp");
}
	
function notice_show(){
    $.ajax({
        url: 'https://koolshare.ngrok.wang/softcenter/push_message.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
			$("#push_titile").html(res.title);
			$("#push_content1").html(res.content1);
			$("#push_content2").html(res.content2);
			if(res.content3){
				document.getElementById("push_content3_li").style.display = "";
				$("#push_content3").html(res.content3);
			}
			if(res.content4){
				document.getElementById("push_content4_li").style.display = "";
				$("#push_content4").html(res.content4);
			}
        }
    });
}
    
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
                <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
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
                                                                                    <h2 id="push_titile"><em>欢迎</em></h2>
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    <h4 id="push_content1" >欢迎来到插件中心，目前正在紧张开发中，各种插件酝酿中！</h4>
                                                                                </li>
                                                                                <li  style="margin-top:-5px;">
                                                                                    <h4 id="push_content2">如果你想加入我们的工作，在 <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a>联系我们！</h4>
                                                                                </li>
                                                                                <li id="push_content3_li" style="margin-top:-5px;display: none;">
                                                                                    <h4 id="push_content3"></h4>
                                                                                </li>
                                                                                <li id="push_content4_li" style="margin-top:-5px;display: none;">
                                                                                    <h4 id="push_content4"></h4>
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    <h5>当前版本：<span id="spnCurrVersion"></span> 在线版本：<span id="spnOnlineVersion"></span>
                                                                                    <input type="button" id="updateBtn" value="更新" style="display:none" /></h5>
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

                                                    <tr bgcolor="#444f53" id="install_status" style="display: none;" width="235px">
                                                        <td>
                                                            <div style="padding:10px;width:95%;font-size:14px;" id="appInstallInfo">
                                                            </div>
                                                        </td>
                                                        <td class="cloud_main_radius_right">
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
                                                    <tr height="10px">
                                                        <td colspan="3"></td>
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
