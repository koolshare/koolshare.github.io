<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - ShadowVPN</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=shadowvpn_&v=<% uptime(); %>"></script>
<script>
function init() {
	show_menu();
	buildswitch();
    conf2obj();
    version_show();
    write_shadowvpn_install_status();
   	var lb_mode = '<% nvram_get("wans_mode"); %>';
	//showhide("shadowvpn_wan", (lb_mode !== "lb"));
    var ss_mode = '<% nvram_get("ss_mode"); %>';
	if(ss_mode != "0" && ss_mode != ''){
		document.getElementById('ShadowVPN_detail_table').style.display = "none";
		document.getElementById('warn').style.display = "";
		document.getElementById('cmdBtn').style.display = "none";
		document.form.shadowvpn_enable.value = 0;
		inputCtrl(document.form.switch,0);
		//document.form.cmdBtn.disabled = true;
	}
	var rrt = document.getElementById("switch");
    if (document.form.shadowvpn_enable.value != "1") {
        rrt.checked = false;
        document.getElementById('ShadowVPN_detail_table').style.display = "none";
    } else {
        rrt.checked = true;
        document.getElementById('ShadowVPN_detail_table').style.display = "";
    }
    
}
function done_validating() {
	return true;
//refreshpage(5);
}
function buildswitch(){
	$("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.shadowvpn_enable.value = 1;
			document.getElementById('ShadowVPN_detail_table').style.display = "";
		}else{
			document.form.shadowvpn_enable.value = 0;
			document.getElementById('ShadowVPN_detail_table').style.display = "none";
		}
	});
}
function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	showLoading(15);
	document.form.submit();
}

function conf2obj(){
	$.ajax({
	type: "get",
	url: "dbconf?p=shadowvpn_",
	dataType: "script",
	success: function(xhr) {
    var p = "shadowvpn_";
        var params = ["address", "port", "passwd","token", "number", "net", "wan","mtu", "tun", "mode", "file", "start", "time"];
        for (var i = 0; i < params.length; i++) {
			if (typeof db_shadowvpn_[p + params[i]] !== "undefined") {
				$("#shadowvpn_"+params[i]).val(db_shadowvpn_[p + params[i]]);
				
				}
            
            update_visibility();
        }
	}
	});
}
function write_shadowvpn_install_status(){
	$.ajax({
		type: "get",
		url: "dbconf?p=shadowvpn_",
		dataType: "script",
		success: function() {
		if (db_shadowvpn_['shadowvpn_install_status'] == "1"){
			$("#shadowvpn_install_show").html("<i>正在下载更新...</i>");
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "2"){
			$("#shadowvpn_install_show").html("<i>正在安装更新...</i>");
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "3"){
			$("#shadowvpn_install_show").html("<i>安装更新成功，5秒后刷新本页！</i>");
			version_show();
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "4"){
			$("#shadowvpn_install_show").html("<i>下载文件校验不一致！</i>");
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "5"){
			$("#shadowvpn_install_show").html("<i>然而并没有更新！</i>");
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "6"){
			$("#shadowvpn_install_show").html("<i>正在检查是否有更新~</i>");
		} else if (db_shadowvpn_['shadowvpn_install_status'] == "7"){
			$("#shadowvpn_install_show").html("<i>检测更新错误！</i>");
		} else {
			$("#shadowvpn_install_show").html("");
		}
		setTimeout("write_shadowvpn_install_status()", 1000);
		}
		});
	}

function version_show(){
	if (db_shadowvpn_['shadowvpn_version'] != db_shadowvpn_['shadowvpn_version_web'] && db_shadowvpn_['shadowvpn_version_web'] !== "undefined"){
		$("#shadowvpn_version_status").html("<i>有新版本：" + db_shadowvpn_['shadowvpn_version_web']);
	} else {
		$("#shadowvpn_version_status").html("<i>当前版本：" + db_shadowvpn_['shadowvpn_version']);
	}
}

function update_shadowvpn(o, s){
	document.form.shadowvpn_update_check.value = 1;
	document.form.shadowvpn_enable.value = 0;
	document.form.action_mode.value = s;
	document.form.submit();
	//update_visibility();
	//write_shadowvpn_install_status();
}

function update_visibility() {
    showhide("shadowvpn_file", (document.form.shadowvpn_mode.value == "1"));
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=shadowvpn_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_shadowVPN.asp"/>
	<input type="hidden" name="next_page" value="Module_shadowVPN.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="shadowvpn.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="shadowvpn_install_status" name="shadowvpn_install_status" value="0" />
	<input type="hidden" id="shadowvpn_update_check" name="shadowvpn_update_check" value="0" />
	<input type="hidden" id="shadowvpn_poweron" name="shadowvpn_poweron" value="1" />
	<input type="hidden" id="shadowvpn_enable" name="shadowvpn_enable" value='<% dbus_get_def("shadowvpn_enable", "0"); %>'/>
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
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">ShadowVPN</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">轻量级无状态VPN，小巧，好用，支持UDP。</div>
										<div id="shadowvpn_version_status" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"><i>当前版本：<% dbus_get_def("shadowvpn_version", "0"); %></i></div>								
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">开关设置</td>
											</tr>
											</thead>
											<tr>
											<th>开启ShadowVPN</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="switch">
															<input id="switch" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div id="update_button" style="padding-top:5px;margin-left:100px;margin-top:-35px;float: left;">
														<button class="button_gen" onclick="update_shadowvpn(this, ' Refresh ');">检查更新</button>						
													</div>
													<div id="shadowvpn_install_show" style="padding-top:5px;margin-left:10px;margin-top:-30px;float: left;"></div>	
											</td>
											</tr>
                                    	</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ShadowVPN_detail_table">
											<thead>
											<tr>
												<td colspan="2">基本设置</td>
											</tr>
											</thead>
											<tr>
												<th width="35%">服务器地址</th>
												<td>
													<input type="text" class="input_ss_table" style="width:auto;" size="30" id="shadowvpn_address" name="shadowvpn_address" maxlength="20" placeholder="服务器地址" value="" >
												</td>										
											</tr>
											<tr>
												<th width="35%">服务器端口</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_port" name="shadowvpn_port" maxlength="8" placeholder="服务器端口" value="" />
												</td>										
											</tr>
											<tr>
												<th width="35%">密码</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="20"  id="shadowvpn_passwd" name="shadowvpn_passwd" maxlength="30" placeholder="认证密码" value="" />
												</td>										
											</tr>
											<tr>
												<th width="35%">令牌（user_token）</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="20"  id="shadowvpn_token" name="shadowvpn_token" maxlength="30" placeholder="用户令牌" value="" />
												</td>										
											</tr>
												<th width="35%">并发连接数</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_number" name="shadowvpn_number" maxlength="5" placeholder="默认1" value="1" />
												</td>										
											</tr>
												<th width="35%">设置net</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="15"  id="shadowvpn_net" name="shadowvpn_net" maxlength="20" placeholder="默认10.7.0.1/16" value="10.7.0.1/16" />
												</td>										
											</tr>
											</tr>
												<th width="35%">设置MTU</th>
												<td>
													<input  type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_mtu" name="shadowvpn_mtu" maxlength="5" placeholder="默认1440" value="1440" />
												</td>										
											</tr>
												<th width="35%">接口名称</th>
												<td>
														<input  type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_tun" name="shadowvpn_tun" maxlength="5" placeholder="默认tun0" value="tun0" />
												</td>										
											</tr>
											<tr>
											<thead>
											<tr>
												<td colspan="3">路由设置</td>
											</tr>
											</thead>
											    <th width="35%">路由模式</th>
												<td>
													<select id="shadowvpn_mode" name="shadowvpn_mode" class="input_option" onclick="update_visibility();" >
														<option value="1">国内白名单模式</option>
														<option value="2">全局模式</option>
													</select>
												</td>
											</tr>
                                    	    <tr>
											    <th width="35%">路由文件</th>
												<td>
														<input  type="text" class="input_ss_table" style="width:auto; display:none;" size="45"   id="shadowvpn_file" name="shadowvpn_file" maxlength="50" placeholder="请输入绝对文件路径" value="/jffs/ss/shadowvpn/chroute.txt" />
													<span class='software_action'><font color='#ffcc00'>全局模式无需设置</font></span>
												</td>
											</tr>
                                    	    <tr>
											    <th width="35%">指定线路</th>
												<td>
													<select id="shadowvpn_wan" name="shadowvpn_wan" class="input_option"  onclick="update_visibility();" >
														<option value="1">WAN 1</option>
														<option value="2">WAN 2</option>
													</select>
													<span class='software_action'><font color='#ffcc00'>单线路用户无需设置</font></span>
												</td>
											</tr>
											<tr>
											<thead>
											<tr>
												<td colspan="4">启动设置</td>
											</tr>
											</thead>
											    <th width="35%">开机自启</th>
												<td>
													<select id="shadowvpn_start" name="shadowvpn_start" class="input_option" onclick="update_visibility();" >
														<option value="1">是</option>
														<option value="2">否</option>
													</select>
												</td>
											</tr>
                                    	    
                                    	    <tr>
											    <th width="35%">启动延时</th>
												<td>
													<select id="shadowvpn_time" name="shadowvpn_time" class="input_option" onclick="update_visibility();" >
														<option value="1">10S</option>
														<option value="2">15S</option>
														<option value="3">20S</option>
														<option value="4">30S</option>
														<option value="5">60S</option>
													</select>
												</td>
											</tr>

 										</table>
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"><i>你已经开启shadowsocks,请先关闭后才能开启shadowvpn</i></div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="KoolshareBottom">
											<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											后台技术支持： <i>Xiaobao</i> <br/>
											Shell, Web by： <i>fw867</i><br/>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="10" align="center" valign="top"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
	</td>
	<div id="footer"></div>
</body>
</html>


