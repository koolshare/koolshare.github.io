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
                        setTimeout("location.reload();", 3000);
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

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="tunnel_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="ngrokd" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_tunnel.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">穿透DDNS</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																穿透DDNS，服务器转发方式！<a href="http://koolshare.cn/thread-6312-1-3.html" target="_blank"> <i><u>教程</u></i> </a>
															</div>
														</td>
													</tr>
													<tr class="softcenter_tr2" height="10px" id="tunnel_tr2">
														<td colspan="3"></td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="koolnet_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="p2p" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_koolnet.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">
                                                                P2P穿透
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																P2P穿透~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3"></td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="xunlei_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="thunder" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_xunlei.asp'"></div>
														<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">迅雷远程</div>
														<a class="link_hidden" >隐藏</a>
                                                        </td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div id="xunlei_info1" style="padding:10px;width:95%;font-size:14px;">
																<li>点击安装后会自动下载并安装到USB设备中.</li>
																<li>默认下载目录也位于相同的USB设备内.</li>
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3"></td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="aria2_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="aria2" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_aria2.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Aria2</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="aria2_install();"></span>
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																楼上不给力？来我这里试试~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="transmission_tr1"> 
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="Transmission" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_transmission.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Transmission</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="transmission_install();"></span>
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																我方了~<i></i>
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="ssserver_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="ss-server" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_ss_server.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">ss-server</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																在路由器上开一个ss服务器，将你的网络共享到公网~很有卵用~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="shadowvpn_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="shadowvpn" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_shadowVPN.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">shadowvpn</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																轻量级无状态VPN，小巧，好用~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="v2ray_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="v2ray" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_v2ray.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">v2ray</div>
														    <a class="link_hidden" >隐藏</a>
                                                        </td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																Yet another tool help your through great firewall!</i>
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="entware_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="entware" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Entware-ng</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="entware_install();"></span>
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																有了Enterware，还有什么路由器不能做的？<i>（你猜我做好没有？）</i>
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="policy_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="dualwan_policy" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_policy_route.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">策略路由</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="dualwan_policy_install();"></span>
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																你有双线接入？来试试策略路由吧~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="kuainiao_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="thunder_bird" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_kuainiao.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">迅雷快鸟</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="thunder_bird();"></span>
															</div>
                                                            <a class="link_hidden" >隐藏</a>
														</td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																迅雷快鸟~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="speedtest_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="speedtest" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_speedtest.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Speedtest</div>
														    <a class="link_hidden" >隐藏</a>
                                                        </td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																Speedtest~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px" class="softcenter_tr1" id="adm_tr1">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="adm" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_adm.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">阿呆喵</div>
														    <a class="link_hidden" >隐藏</a>
                                                        </td>
														<td width="6px">
															<div align="center"><img src="/images/cloudsync/line.png"></div>
														</td>
														<td width="1px">
														</td>
														<td>
															<div style="padding:10px;width:95%;font-size:14px;">
																去广告，看疗效~
															</div>
														</td>
													</tr>
													<tr height="10px" class="softcenter_tr2">
														<td colspan="3">
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

