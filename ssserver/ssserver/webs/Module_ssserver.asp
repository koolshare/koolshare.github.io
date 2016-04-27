<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心-SS-SERVER</title>
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
<script>
function init() {
	show_menu();
	buildswitch();
    conf2obj();
	var rrt = document.getElementById("switch");
    if (document.form.ssserver_enable.value != "1") {
        rrt.checked = false;
        document.getElementById('ssserver_detail').style.display = "none";
    } else {
        rrt.checked = true;
        document.getElementById('ssserver_detail').style.display = "";
    }
}
function done_validating() {
refreshpage(5);
}
function buildswitch(){
	$("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.ssserver_enable.value = 1;
			document.getElementById('ssserver_detail').style.display = "";
		}else{
			document.form.ssserver_enable.value = 0;
			document.getElementById('ssserver_detail').style.display = "none";
		}
	});
}
function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	showLoading(5);
	document.form.submit();
}

function conf2obj(){
	$.ajax({
	type: "get",
	url: "dbconf?p=ssserver",
	dataType: "script",
	success: function(xhr) {
    var p = "ssserver";
        var params = ["method", "password", "port", "udp", "ota", "time"];
        for (var i = 0; i < params.length; i++) {
            $("#ssserver_"+params[i]).val(db_ssserver[p + "_" + params[i]]);
        }
	}
	});
}
function pass_checked(obj){
	switchType(obj, document.form.show_pass.checked, true);
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
/*
function show_address(){ //<% nvram_get("ddns_hostname_x"); %></br><% nvram_get("wan0_ipaddr"); %></br><% nvram_get("wan1_ipaddr"); %>
	var address1 = '<% nvram_get("ddns_hostname_x"); %>';
	var address2 = '<% nvram_get("wan0_ipaddr"); %>';
	var address3 = '<% nvram_get("wan1_ipaddr"); %>';

	
	if (address1 = "")
}
*/
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=ssserver_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_ssserver.asp"/>
	<input type="hidden" name="next_page" value="Module_ssserver.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value="5"/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ssserver_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="ssserver_enable" name="ssserver_enable" value='<% dbus_get_def("ssserver_enable", "0"); %>'/>
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
										<div style="float:left;" class="formfonttitle">SS-SERVER</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" id="cmdDesc">开启ss-server后，就可以类似VPN一样，将你的网络共享到公网，让你和你的小伙伴远程连接。</div>										
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">ss-server开关</td>
											</tr>
											</thead>
											<tr>
											<th>开启ss-server</th>
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
													<div id="qos_enable_hint" style="color:#FC0;vertical-align:middle;display:none">Enabling QoS may take several minutes.<!--#Adaptive_note#--></div>
												</td>
											</tr>
                                    	</table>                                    	
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ssserver_detail">
											<thead>
											<tr>
												<td colspan="2">ss-server详细设置</td>
											</tr>
											</thead>
											<!--
											<tr>
												<th>监听地址</th>
												<td>
													<div>
														<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_listen" name="ssserver_listen">
															<option value="0">ipv4</option>
															<option value="1">ipv6</option>
															<option value="2">Both</option>
														</select>
													</div>
												</td>
											</tr>
											-->
											<!--
											<tr>
												<th>ss服务器地址</th>
												<td>
													<div id="address"><% nvram_get("ddns_hostname_x"); %></br><% nvram_get("wan0_ipaddr"); %></br><% nvram_get("wan1_ipaddr"); %></div>
												</td>
											</tr>
											-->
											<tr>
												<th>加密方式</th>
												<td>
													<div>
														<select id="ssserver_method" name="ssserver_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="table">table</option>
															<option class="content_input_fd" value="rc4">rc4</option>
															<option class="content_input_fd" value="rc4-md5">rc4-md5</option>
															<option class="content_input_fd" value="aes-128-cfb">aes-128-cfb</option>
															<option class="content_input_fd" value="aes-192-cfb">aes-192-cfb</option>
															<option class="content_input_fd" value="aes-256-cfb" selected="">aes-256-cfb</option>
															<option class="content_input_fd" value="bf-cfb">bf-cfb</option>
															<option class="content_input_fd" value="camellia-128-cfb">camellia-128-cfb</option>
															<option class="content_input_fd" value="camellia-192-cfb">camellia-192-cfb</option>
															<option class="content_input_fd" value="camellia-256-cfb">camellia-256-cfb</option>
															<option class="content_input_fd" value="cast5-cfb">cast5-cfb</option>
															<option class="content_input_fd" value="des-cfb">des-cfb</option>
															<option class="content_input_fd" value="idea-cfb">idea-cfb</option>
															<option class="content_input_fd" value="rc2-cfb">rc2-cfb</option>
															<option class="content_input_fd" value="seed-cfb">seed-cfb</option>
															<option class="content_input_fd" value="salsa20">salsa20</option>
															<option class="content_input_fd" value="chacha20">chacha20</option>
														</select>
													</div>
												</td>
											</tr>
											<tr>
												<th>密码</th>
												<td>
													<input type="password" name="ssserver_password" id="ssserver_password" class="ssconfig input_ss_table" maxlength="100" value=""/>
													<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ssserver_password);">
															显示密码
													</div>
												</td>
											</tr>
											<tr>
												<th>端口</th>
												<td>
													<div>
														<input type="txt" name="ssserver_port" id="ssserver_port" class="ssconfig input_ss_table" maxlength="100" value=""/>
													</div>
												</td>
											</tr>
											<tr>
												<th>超时时间（秒）</th>
												<td>
													<div>
														<input type="txt" name="ssserver_time" id="ssserver_time" class="ssconfig input_ss_table" maxlength="100" value=""/>
													</div>
												</td>
											</tr>
											<tr>
												<th>UDP转发</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_udp" name="ssserver_udp">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
												</td>
											</tr>
											<tr>
												<th>OTA</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_ota" name="ssserver_ota">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
												</td>
											</tr>

										</table>
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"><i>开启双线路负载均衡模式才能进行本页面设置，建议负载均衡设置比例1：1</i></div>
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

