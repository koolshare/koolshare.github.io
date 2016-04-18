<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - P2P穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<style>
#ClientList_Block_PC{
	border:1px outset #999;
	background-color:#576D73;
	position:absolute;
	*margin-top:26px;	
	margin-left:2px;
	*margin-left:-353px;
	width:346px;
	text-align:left;	
	height:auto;
	overflow-y:auto;
	z-index:200;
	padding: 1px;
	display:none;
}
#ClientList_Block_PC div{
	background-color:#576D73;
	height:auto;
	*height:20px;
	line-height:20px;
	text-decoration:none;
	font-family: Lucida Console;
	padding-left:2px;
}

#ClientList_Block_PC a{
	background-color:#EFEFEF;
	color:#FFF;
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
	text-decoration:none;	
}
#ClientList_Block_PC div:hover{
	background-color:#3366FF;
	color:#FFFFFF;
	cursor:default;
}	
</style>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>

<script>
var Base64;
var globalConfig;
if(typeof btoa == "Function") {
    Base64 = {encode:function(e){ return btoa(e); }, decode:function(e){ return atob(e);}};
} else {
   Base64 ={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
}

function toTunnel(conf) {
    console.log(conf);
    var obj = {"masterhost":"error", "masterport":0, "localport":0};
    ss1 = conf.split(";");
    if (ss1.length >= 2) {
	ss2 = ss1[0].split(":");
	ss3 = ss1[1].split(":");
	if (ss2.length >= 2) {
		obj.masterhost = ss2[0];
		obj.masterport = ss2[1];
	}
	if (ss3.length >= 2) {
		obj.localport = ss3[1];
	}
    }
    return obj;
}

function refreshTunnels(config) {
    var html = '';
    var ss = [];
    $("#conf_table").find("tr:gt(2)").remove();
    for(var i = 0; i < config.listen.length; i++) {
        var tunnel = toTunnel(config.listen[i]);
        html += '<tr><td>'+tunnel.masterhost+'</td><td>'+tunnel.masterport+'</td><td>'+tunnel.localport+'</td>';
        html += '<td width="10%"><div><input id=tr_'+ i +' class="remove_btn" onclick="remove_tr(this);" value=""/></div></td></tr>';
    }
    $('#conf_table tr:last').after(html);
}

function initial(){
	show_menu();

     var v = $("#koolnet_install_status").val();
     if(v == "0") {
	$("#cmdDesc").html("未下载安装,启用则自动下载");
     } else if(v == "1") {
	$("#cmdDesc").html("下载中...");
     } else if(v == "2") {
	$("#cmdDesc").html("验证码出错");
     } else if (v == "3") {
	$("#cmdDesc").html("<a href='http://koolshare.cn/' target='_blank'>查看教程</a>");
     }

    $("#radio_koolnet_enable").iphoneSwitch($("#koolnet_config_enable").val(), function () {
    $("#koolnet_config_enable").val("1");
    }, function () {
    $("#koolnet_config_enable").val("0");
    });

    var val = $("#koolnet_config_txt").val();
    if(val != "") {
        var txt = Base64.decode(val);
        globalConfig = JSON.parse(txt);
        var ids = ["server","port","user", "password"];
	var obj = globalConfig;
        for(var i = 0; i < ids.length; i++) {
            if(typeof obj[ids[i]] != "undefined") {
                $("#"+ids[i]).val(obj[ids[i]]);
            }
        }
        refreshTunnels(globalConfig);
    } else {
        globalConfig = {};
        globalConfig.listen = [];
    }
}

function addTr() {
    var  obj = {};
    obj.masterhost = $("#masterhost").val();
    obj.masterport = $("#masterport").val();
    obj.localport = parseInt($("#localport").val());
    var conf = obj.masterhost + ":" + obj.masterport + ";:" + obj.localport;
    globalConfig.listen.push(conf);
    refreshTunnels(globalConfig);

    $("#masterhost").val("");
    $("#masterport").val("");
    $("#localport").val("");
}

function remove_tr(el) {
    var obj = $(el);
    var idstr = obj.attr("id");
    id = parseInt(idstr.split("_")[1]);
    globalConfig.listen.splice(id, 1);
    refreshTunnels(globalConfig);
}

function validForm(){
	return true;
}

function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
        var ids = ["server","port","user", "password"];
	globalConfig.server = $("#server").val();
	globalConfig.port = parseInt($("#port").val());
	globalConfig.user = $("#user").val();
	globalConfig.password = $("#password").val();
	var txt = Base64.encode(JSON.stringify(globalConfig));
	$("#koolnet_config_txt").val(txt);
	showLoading(5);
	document.form.submit();
}
function done_validating(action) {
    refreshpage(5);
}
function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=koolnet_config_" target="hidden_frame"> 
<input type="hidden" name="current_page" value="Module_koolnet.asp"/>
<input type="hidden" name="next_page" value="Module_koolnet.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="config-koolnet.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="koolnet_config_txt" name="koolnet_config_txt" value='<% dbus_get_def("koolnet_config_txt", ""); %>'/>
<input type="hidden" id="koolnet_config_enable" name="koolnet_config_enable" value='<% dbus_get_def("koolnet_config_enable", "0"); %>'/>
<input type="hidden" id="koolnet_install_status" name="koolnet_install_status" value='<% dbus_get_def("koolnet_install_status", "0"); %>'/>

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
						<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">		
							<tr>
								<td bgcolor="#4D595D" colspan="3" valign="top">
									<div>&nbsp;</div>
									<div style="float:left;" class="formfonttitle">软件中心 - P2P穿透</div>
									<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'" /></div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
									<div class="formfontdesc" id="cmdDesc"></div>
									<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <th width="20%">开启</th>
                                            <td>
												<div class="left" style="width:94px; float:left; cursor:pointer;" id="radio_koolnet_enable"></div>
                                            </td>
                                        </tr>

										<tr>
											<th width="20%">服务器</th>
											<td>
                                          <input type="text" class="input_ss_table" value="ngrok.wang" id="server" name="server" maxlength="20"/>
											</td>										
										</tr>

										<tr>
											<th width="20%">端口</th>
											<td>
                                          <input type="text" class="input_ss_table" value="18886" id="port" name="port" maxlength="20"/>
											</td>										
										</tr>

										<tr>
											<th width="20%">用户名</th>
											<td>
                                          <input type="text" class="input_ss_table" value="" id="user" name="user" maxlength="20"/>
											</td>										
										</tr>

										<tr>
										    <th width="20%">密码</th>
											<td>
										<input type="password" class="input_ss_table" id="password" name="password" maxlength="10" />
											</td>
										</tr>
                                        
									</table>

                            <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top:8px;">
									  	<thead>
									  		<tr>
												<td colspan="6">限制最多&nbsp;条数&nbsp;8)</td>
									  		</tr>
									  	</thead>
						
									  	<tr>
                                        <th><a class="hintstyle" href="javascript:void(0);" onclick="">内网主机地址</a></th>
                                        <th><a class="hintstyle" href="javascript:void(0);" onclick="">内网主机端口</a></th>
                                        <th><a class="hintstyle" href="javascript:void(0);" onclick="">客户主机端口</a></th>
						        		<th><#list_add_delete#></th>
									  	</tr>			  
									  	<tr>							  		
                                         <td>
											<input type="text" id="masterhost" class="input_15_table" maxlength="20" name="masterhost" placeholder=""/>
				            			</td>
                                        <td>
											<input type="text" id="masterport" class="input_20_table" maxlength="50" name="masterport" placeholder=""/>
				            			</td>
                                        <td>
											<input type="text" id="localport" class="input_6_table" maxlength="10" name="localport" placeholder=""/>
				            			</td>
				            			<td width="10%">
											<div> 
												<input type="button" class="add_btn" onclick="addTr()" value=""/>
											</div>
				            			</td>
									  	</tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <input class="remove_btn" onclick="remove_tr(this);" value=""/>
                                            </td>
                                        </tr>
									  </table>        			

			           	<div class="apply_gen">
					<span><input class="button_gen_long" id="cmdBtn" onclick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交"/></span>
		            	</div>
								</td>
							</tr>
						</table>

								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<!--===================================Ending of Main Content===========================================-->
		</td>
		<td width="10" align="center" valign="top"></td>
	</tr>
</table>
</form>

<div id="footer"></div>
</body>
<script type="text/javascript">
<!--[if !IE]>-->
    (function($){
        var i = 0;
	})(jQuery);
<!--<![endif]-->
</script>
</html>
