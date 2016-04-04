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
    .icon-desc .hide-btn{
        display: inline-block;
        border: none;
        width: 60%;
        margin-top: 20px;
        border-radius: 0px 0px 0px 5px;
    }
    .icon-desc .uninstall-btn{
        display: none;
    }
    .icon-desc .hide-btn{
        border-radius: 0px 0px 5px 0px;
        width:40%;
        border-left: 1px solid #000;
    }
    .show-install-btn,
    .show-uninstall-btn{
        border: none;
        background: #444;
        color: #fff;
        padding: 10px 20px;
        border-radius: 5px 5px 0px 0px;
    }
    .active-btn{
        background: #444f53;
    }
    .is-install .uninstall-btn{
        display: inline-block;
    }
    .is-install .install-btn{
        display: none;
    }
</style>
<script>

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

function onModuleHide(tr) {
    var id = $(tr).attr("id");
    if(typeof(id) != "undefined") {
        var ob = id.substring(0, id.indexOf("_"));
        if(ob.length == 0) {
            return;
        }

        var visible = "softcenter_module_"+ob+"_visible";
        var data = {"SystemCmd":"echo softccenter", "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};
        data[visible] = "0";
        $.ajax({
                type: "POST",
                url: "applydb.cgi?p=softcenter_",
                dataType: "text",
                data: data,
                success: function() {
                    $(tr).hide();
                    var nel = $(tr).next("tr");
                    if(typeof(nel) != "undefined" && $(nel).attr("class") == "softcenter_tr2") {
                        $(nel).hide();
                    }
                },
                error: function() {
                    console.log("error");
                }
            });
    }
}

//function jsonp_callback(data) {
//    console.log(data);
//}

function init(){
  show_menu();

    parse_softcenter();

    var curr_user = 0;
    if (typeof(db_softcenter_["softcenter_curr_user"]) != "undefined") {
        curr_user = parseInt(db_softcenter_["softcenter_curr_user"]);
        if(typeof(curr_user) == "undefined") {
            curr_user = 0;
        }
    }

    $("#softcenter_td tr.softcenter_tr1").each(function(index, ell){
        var el = $(ell);
        var show = true;
        var id = el.attr("id");
        if(typeof(id) != "undefined") {
            var ob = id.substring(0, id.indexOf("_"));
            if(ob.length > 0) {

                var status = db_softcenter_["softcenter_module_"+ob];
                var mo = softcenter_modules[ob];

                if(typeof(status) != "undefined") {
                    status = parseInt(status);
                } else {
                    status = 0;
                }

                //console.log("ob "+ ob + " status "+status + " curr_user " + curr_user);

                //curr_user < status: status: 2==develop, curr_user: 1==testor, not show this module.
                if((curr_user < status) || (typeof(mo) != "undefined" && mo.visible === "0")) {
                    show = false;
                }
            }
        }

        if(show) {
            el.show();
            var nel = el.next("tr");
            if(typeof(nel) != "undefined" && $(nel).attr("class") == "softcenter_tr2") {
                $(nel).show();
            }
        }
    });

        $(".link_hidden").click(function(e){
            //e.preventDefault();
            var tr = $(this).closest("tr");
            onModuleHide(tr);
    });

        $("#updateBtn").click(function(e){
            //e.preventDefault();
            //TODO better here
	    $("#updateBtn").hide();
            var data = {"SystemCmd":"softcenter.sh", "current_page":"Module_koolnet.asp", "action_mode":" Refresh ", "action_script":""};
            data["softcenter_install_status"] = "0";
            $.ajax({
                    type: "POST",
                    url: "applydb.cgi?p=softcenter_",
                    dataType: "text",
                    data: data,
                    success: function() {
                        //location.reload();
                        setTimeout("location.reload();", 8000);
                    },
                    error: function() {
                        console.log("error");
                    }
                });
    });

    $("#spnCurrVersion").html(db_softcenter_["softcenter_curr_version"]);

    $.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/softcenter/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = jQuery(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = jQuery.parseJSON(txt.replace("'", "\""));
                $("#spnOnlineVersion").html(obj.version);

                if(obj.version != db_softcenter_["softcenter_curr_version"]) {
                    $("#updateBtn").show();
                }
            }
        }
    });
}

</script>
<script>
    var db_softcenter_ = {
        "softcenter_curr_version": "1.0.5",
        "softcenter_install_status": "0",
        "softcenter_module_adm": "0",
        "softcenter_module_adm_install": "1",
        "softcenter_module_adm_ver": "0",
        "softcenter_module_adm_url": "0",
        "softcenter_module_aria2": "0",
        "softcenter_module_aria2_install": "0",
        "softcenter_module_aria2_ver": "0",
        "softcenter_module_aria2_url": "0",
        "softcenter_module_entware": "2",
        "softcenter_module_entware_install": "0",
        "softcenter_module_entware_ver": "0",
        "softcenter_module_entware_url": "0",
        "softcenter_module_koolnet": "0",
        "softcenter_module_koolnet_ver": "0",
        "softcenter_module_koolnet_install": "1",
        "softcenter_module_koolnet_url": "0",
        "softcenter_module_koolnet_visible": "0",
        "softcenter_module_kuainiao": "0",
        "softcenter_module_kuainiao_install": "0",
        "softcenter_module_kuainiao_ver": "0",
        "softcenter_module_kuainiao_url": "0",
        "softcenter_module_policy": "0",
        "softcenter_module_policy_install": "0",
        "softcenter_module_policy_ver": "0",
        "softcenter_module_policy_url": "0",
        "softcenter_module_shadowvpn": "0",
        "softcenter_module_shadowvpn_install": "0",
        "softcenter_module_shadowvpn_ver": "0",
        "softcenter_module_shadowvpn_ur": "0",
        "softcenter_module_speedtest": "0",
        "softcenter_module_speedtest_install": "0",
        "softcenter_module_speedtest_ver": "0",
        "softcenter_module_speedtest_url": "0",
        "softcenter_module_ssserver": "0",
        "softcenter_module_ssserver_install": "1",
        "softcenter_module_ssserver_ver": "0",
        "softcenter_module_ssserver_url": "0",
        "softcenter_module_transmission": "2",
        "softcenter_module_transmission_install": "2",
        "softcenter_module_transmission_ver": "2",
        "softcenter_module_transmission_url": "2",
        "softcenter_module_tunnel": "0",
        "softcenter_module_tunnel_install": "1",
        "softcenter_module_tunnel_url": "",
        "softcenter_module_tunnel_ver": "1.0.0",
        "softcenter_module_tunnel_ver_url": "",
        "softcenter_module_tunnel_visible": "0",
        "softcenter_module_v2ray": "2",
        "softcenter_module_v2ray_install": "2",
        "softcenter_module_v2ray_ver": "2",
        "softcenter_module_v2ray_url": "2",
        "softcenter_module_xunlei": "0",
        "softcenter_module_xunlei_install": "0",
        "softcenter_module_xunlei_ver": "0",
        "softcenter_module_xunlei_url": "0",
        "softcenter_module_xunlei_visible": "0"
    };

    //格式化数据
    var softInfo = (function formatDBSoftcenterData(data) {
        var result = {};
        $.map(db_softcenter_, function (item, key) {
            key = key.split('_');
            if ('module' === key[1]) {
                var app = [key[0], key[1], key[2]].join('_');
                var prop = key[3] || 'status';
                if (!result[app]) {
                    result[app] = {};
                    result[app].name = key[2];
                }
                result[app][prop] = item;
            } else {
                result[key.join('_')] = item;
            }
        });
        return result;
    })(db_softcenter_);

    function initAppStatus() {
        var installCount = 0;
        var uninstallCount = 0;
        $('#IconContainer dl').each(function (i, app) {
            app = $(app);
            var name = 'softcenter_module_' + app.data('name');
            if (1 === parseInt(softInfo[name].install, 10)) {
                app.addClass('is-install');
                installCount++;
            } else {
                uninstallCount++;
            }
        });
        $('.show-install-btn').val('已安装(' + installCount + ')');
        $('.show-uninstall-btn').val('未安装(' + uninstallCount + ')');
    }

    function showInstall(bInstall) {
        $('.show-install-btn').removeClass('active-btn');
        $('.show-uninstall-btn').removeClass('active-btn');
        if (1 === bInstall) {
            $('.show-install-btn').addClass('active-btn');
        } else {
            $('.show-uninstall-btn').addClass('active-btn');
        }
        var apps = $('#IconContainer dl');
        apps.each(function (i, app) {
            app = $(app);
            var name = 'softcenter_module_' + app.data('name');
            if (bInstall === parseInt(softInfo[name].install, 10)) {
                app.show();
            } else {
                app.hide();
            }
        });
    }
    $(function () {
        showInstall(1);
        initAppStatus();
    });
</script>
</head>
<body onload="init();">
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
                                                            <input class="show-install-btn" type="button" value="已安装" onclick="showInstall(1);" />
                                                            <input class="show-uninstall-btn" type="button" value="未安装" onclick="showInstall(0);" />
                                                        </td>
                                                    </tr>

													<tr bgcolor="#444f53" width="235px">
                                                        <td colspan="4" id="IconContainer">
                                                            <dl class="icon" data-name="tunnel">
                                                                <dd class="icon-pic"></dd>
                                                                <dt class="icon-title">穿透DDNS</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_tunnel.asp">穿透DDNS，服务器转发方式！</a>
                                                                        <a href="http://koolshare.cn/thread-6312-1-3.html" target="_blank">教程</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="koolnet">
                                                                <dd class="icon-pic" style="background-position: 0px -67px;"></dd>
                                                                <dt class="icon-title">P2P穿透</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_koolnet.asp">P2P穿透~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="xunlei">
                                                                <dd class="icon-pic" style="background-position: 0px -134px;"></dd>
                                                                <dt class="icon-title">迅雷远程</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_xunlei.asp">
                                                                            点击安装后会自动下载并安装到USB设备中.<br/>
                                                                            默认下载目录也位于相同的USB设备内.
                                                                        </a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="aria2">
                                                                <dd class="icon-pic" style="background-position: 0px -201px;"></dd>
                                                                <dt class="icon-title">Aria2</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_aria2.asp">
                                                                            楼上不给力？来我这里试试~
                                                                        </a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="transmission">
                                                                <dd class="icon-pic" style="background-position: 0px -268px;"></dd>
                                                                <dt class="icon-title">Transmission</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_transmission.asp">我方了~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="ssserver">
                                                                <dd class="icon-pic" style="background-position: 0px -335px;"></dd>
                                                                <dt class="icon-title">ss-server</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_ss_server.asp">在路由器上开一个ss服务器，将你的网络共享到公网~很有卵用~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="shadowvpn">
                                                                <dd class="icon-pic" style="background-position: 0px -399px;"></dd>
                                                                <dt class="icon-title">shadowvpn</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_shadowVPN.asp">轻量级无状态VPN，小巧，好用~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="v2ray">
                                                                <dd class="icon-pic" style="background-position: 0px -466px;"></dd>
                                                                <dt class="icon-title">v2ray</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_v2ray.asp">Yet another tool help your through great firewall!</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="entware">
                                                                <dd class="icon-pic" style="background-position: 0px -532px;"></dd>
                                                                <dt class="icon-title">Entware-ng</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        有了Enterware，还有什么路由器不能做的？<i>（你猜我做好没有？）</i>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="policy">
                                                                <dd class="icon-pic" style="background-position: 0px -598px;"></dd>
                                                                <dt class="icon-title">策略路由</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_policy_route.asp">你有双线接入？来试试策略路由吧~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="kuainiao">
                                                                <dd class="icon-pic" style="background-position: 0px -730px;"></dd>
                                                                <dt class="icon-title">迅雷快鸟</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_kuainiao.asp">迅雷快鸟，不解释~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="speedtest">
                                                                <dd class="icon-pic" style="background-position: -67px -2px;"></dd>
                                                                <dt class="icon-title">speedtest</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_speedtest.asp">speedtest~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                            <dl class="icon" data-name="adm">
                                                                <dd class="icon-pic" style="background-position: -67px -67px;"></dd>
                                                                <dt class="icon-title">阿呆猫</dt>
                                                                <dd class="icon-desc">
                                                                    <div class="text">
                                                                        <a href="/Module_adm.asp">去广告，看疗效~</a>
                                                                    </div>
                                                                    <div class="opt">
                                                                        <button type="button" class="install-btn" onclick="">安装</button>
                                                                        <button type="button" class="uninstall-btn" onclick="">卸载</button>
                                                                        <button type="button" class="hide-btn"onclick="">隐藏</button>
                                                                    </div>
                                                                </dd>
                                                            </dl>
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
																<div style="padding:10px;width:95%;font-size:14px;">
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

