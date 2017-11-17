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
<style>
input[type=button]:focus {
	outline: none;
}
.show-btn1, .show-btn2 {
	border: 1px solid #222;
	border-bottom:none;
	background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%); /* W3C */
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.45601%;
}
.show-btn1:hover, .show-btn2:hover, .active {
	background: #2f3a3e;
}
.input_ss_table{
	margin-left:2px;
	padding-left:0.4em;
	height:21px;
	width:158.2px;
	line-height:23px \9;	/*IE*/
	font-size:13px;
	font-family: Lucida Console;
	background-image:none;
	background-color: #576d73;
	border:1px solid gray;
	color:#FFFFFF;
}

</style>
<script>

function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}

function init() {
	show_menu();
	buildswitch();
	conf2obj();
	version_show();
	toggle_func();
	var ss_mode = '<% nvram_get("ss_mode"); %>';
	if (ss_mode != "0" && ss_mode != '') {
		E('ShadowVPN_detail_table').style.display = "none";
		E('warn').style.display = "";
		E('cmdBtn').style.display = "none";
		document.form.shadowvpn_enable.value = 0;
		inputCtrl(document.form.switch, 0);
	}
	var lb_mode = '<% nvram_get("wans_mode"); %>';
	if (lb_mode !== "lb") {
		E("shadowvpn_wan").options.length = 0;
		E("shadowvpn_china").options.length = 0;
	}
	E("switch").checked = document.form.shadowvpn_enable.value == "1" ;
	E("udp_boost_enable").checked = document.form.shadowvpn_udp_boost_enable.value == "1" ;
}

function done_validating() {
	return true;
}

function buildswitch() {
	$("#switch").click(
	function() {
		if (E('switch').checked) {
			document.form.shadowvpn_enable.value = 1;
		} else {
			document.form.shadowvpn_enable.value = 0;
		}
	});
}

function save(o, s) {
	E("udp_boost_enable").checked ? document.form.shadowvpn_udp_boost_enable.value = "1" : document.form.shadowvpn_udp_boost_enable.value = "0"
	document.form.action_mode.value = ' Refresh ';
	showLoading(15);
	setTimeout("refreshpage();", 15000);
	document.form.submit();
}

function update_visibility() {
	showhide("shadowvpn_file", (document.form.shadowvpn_mode.value == "1"));
}

function conf2obj() {
	$.ajax({
		type: "get",
		url: "dbconf?p=shadowvpn_",
		dataType: "script",
		success: function(xhr) {
			var p = "shadowvpn_";
			var params = ["address", "port", "passwd", "token", "number", "net", "wan", "china", "mtu", "tun", "mode", "file", "start", "time", "udpv2_lserver", "udpv2_lport", "udpv2_rserver", "udpv2_rport", "udpv2_password", "udpv2_fec", "udpv2_timeout", "udpv2_mode", "udpv2_report", "udpv2_mtu", "udpv2_jitter", "udpv2_interval", "udpv2_drop", "udpv2_other"];
			for (var i = 0; i < params.length; i++) {
				if (typeof db_shadowvpn_[p + params[i]] !== "undefined") {
					$("#shadowvpn_" + params[i]).val(db_shadowvpn_[p + params[i]]);
				}
				update_visibility();
			}
		}
	});
}

function version_show() {
	$("#shadowvpn_version_status").html("<i>当前版本：" + db_shadowvpn_['shadowvpn_version']);
	$.ajax({
		url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/softcenter/config.json.js',
		type: 'GET',
		success: function(res) {
			var txt = $(res.responseText).text();
			if (typeof(txt) != "undefined" && txt.length > 0) {
				//console.log(txt);
				var obj = $.parseJSON(txt.replace("'", "\""));
				$("#shadowvpn_version_status").html("<i>当前版本：" + obj.version);
				if (obj.version != db_shadowvpn_["shadowvpn_version"]) {
					$("#shadowvpn_version_status").html("<i>有新版本：" + obj.version);
				}
			}
		}
	});
}

function toggle_func() {
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("ShadowVPN_detail_table").style.display = "";
			E("UDPspeederV2_table").style.display = "none";
		});
	$(".show-btn2").click(
		//dns pannel
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			E("ShadowVPN_detail_table").style.display = "none";
			E("UDPspeederV2_table").style.display = "";
		});
}

function reload_Soft_Center() {
	location.href = "/Main_Soft_center.asp";
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "shadowvpn");
	tablink[tablink.length - 1] = new Array("", "Module_shadowvpn.asp");
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
	<input type="hidden" name="SystemCmd" value="shadowvpn.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="shadowvpn_poweron" name="shadowvpn_poweron" value="1" />
	<input type="hidden" id="shadowvpn_udp_boost_enable" name="shadowvpn_udp_boost_enable" value='<% dbus_get_def("shadowvpn_udp_boost_enable", "0"); %>' />
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
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">轻量级无状态VPN，小巧，好用，支持UDP，游戏玩家首选，专为PSN、XBOX优化。双WAN用户请关闭策略路由！</div>
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
														<div class="switch_field" style="display:table-cell;float: left;">
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
														<div id="shadowvpn_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("shadowvpn_version", "未知"); %></i></div>
														<div id="shadowvpn_install_show" style="padding-top:5px;margin-left:330px;margin-top:-25px;"></div>	
												<a style="margin-left: 318px;" href="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowvpn/Changelog.txt" target="_blank"><em>[<u> 更新日志 </u>]</em></a>
												</td>
												</tr>
                                    		</table>
											<div id="tablets">
												<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
													<tr width="235px">
														<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
															<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="svpn设置" />
															<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="udp加速" />
														</td>
													</tr>
												</table>
											</div>
                                    	
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ShadowVPN_detail_table">
												<tr>
													<th colspan="2"><em>基本设置</em></th>
												</tr>
												<tr>
													<th width="35%">服务器地址</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="30" id="shadowvpn_address" name="shadowvpn_address" maxlength="20" placeholder="服务器地址" value="">
													</td>
												</tr>
												<tr>
													<th width="35%">服务器端口</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_port" name="shadowvpn_port" maxlength="8" placeholder="服务器端口" value="" />
													</td>
												</tr>
												<tr>
													<th width="35%">密码</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="20" id="shadowvpn_passwd" name="shadowvpn_passwd" maxlength="30" placeholder="认证密码" value="" />
													</td>
												</tr>
												<tr>
													<th width="35%">令牌（user_token）</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="20" id="shadowvpn_token" name="shadowvpn_token" maxlength="30" placeholder="用户令牌" value="" />
													</td>
												</tr>
												<tr>
													<th width="35%">并发连接数</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_number" name="shadowvpn_number" maxlength="5" placeholder="默认1" value="1" readonly="true" />	<span class='software_action'><font color='#ffcc00'>当前版本不支持设置</font></span>
													</td>
												</tr>
												<tr>
													<th width="35%">设置net</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="15" id="shadowvpn_net" name="shadowvpn_net" maxlength="20" placeholder="默认10.7.0.1/16" value="10.7.0.1/16" />
													</td>
												</tr>
												<tr>
													<th width="35%">设置MTU</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_mtu" name="shadowvpn_mtu" maxlength="5" placeholder="默认1440" value="1440" />
													</td>
												</tr>
												<tr>
													<th width="35%">接口名称</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" size="8" id="shadowvpn_tun" name="shadowvpn_tun" maxlength="5" placeholder="默认tun0" value="tun0" readonly="true" />	<span class='software_action'><font color='#ffcc00'>当前版本不支持设置</font></span>
													</td>
												</tr>
												<tr>
													<th colspan="2"><em>路由设置</em></th>
												</tr>
												<tr>
													<th width="35%">路由模式</th>
													<td>
														<select id="shadowvpn_mode" name="shadowvpn_mode" class="input_option" onclick="update_visibility();">
															<option value="1">国内白名单模式</option>
															<option value="2">全局模式</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="35%">路由文件</th>
													<td>
														<input type="text" class="input_ss_table" style="width:auto; display:none;" size="45" id="shadowvpn_file" name="shadowvpn_file" maxlength="50" placeholder="请输入绝对文件路径" value="/koolshare/dw/cnn.txt" />	<span class='software_action'><font color='#ffcc00'>全局模式无需设置</font></span>
													</td>
												</tr>
												<tr>
													<th width="35%">VPN线路</th>
													<td>
														<select id="shadowvpn_wan" name="shadowvpn_wan" class="input_option" onclick="update_visibility();">
															<option value="1">WAN 1</option>
															<option value="2">WAN 2</option>
														</select>	<span class='software_action'><font color='#ffcc00'>单线路用户无需设置</font></span>
													</td>
												</tr>
												<tr>
													<th width="35%">国内线路</th>
													<td>
														<select id="shadowvpn_china" name="shadowvpn_china" class="input_option" onclick="update_visibility();">
															<option value="1">WAN 1</option>
															<option value="2">WAN 2</option>
														</select>	<span class='software_action'><font color='#ffcc00'>单线路用户无需设置</font></span>
													</td>
												</tr>
												<tr>
													<th colspan="2"><em>启动设置</em></th>
												</tr>
												<tr>
													<th width="35%">开机自启</th>
													<td>
														<select id="shadowvpn_start" name="shadowvpn_start" class="input_option" onclick="update_visibility();">
															<option value="1">是</option>
															<option value="2">否</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="35%">启动延时</th>
													<td>
														<select id="shadowvpn_time" name="shadowvpn_time" class="input_option" onclick="update_visibility();">
															<option value="1">10S</option>
															<option value="2">15S</option>
															<option value="3">20S</option>
															<option value="4">30S</option>
															<option value="5">60S</option>
														</select>
													</td>
												</tr>
											</table>
											<table id="UDPspeederV2_table" style="display:none;margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th colspan="2"><i>UDPspeederV2 设置</i></th>
												</tr>
												<tr>
													<th width="35%">UDP加速开关</th>
													<td>
														<input type="checkbox" id="udp_boost_enable"/>
													</td>
												</tr>

												<tr id="shadowvpn_udpv2_l_server_port_tr">
													<th width="35%">* 本地监听地址：端口 （-l）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_lserver" id="shadowvpn_udpv2_lserver" class="input_ss_table" style="width:120px;" maxlength="200" value="0.0.0.0" readonly/>
														:
														<input type="text" name="shadowvpn_udpv2_lport" id="shadowvpn_udpv2_lport" class="input_ss_table" style="width:44px;" maxlength="200" value="1092" readonly/>
														<a>预设不可更改，ss-redir的UDP流量会转发到此</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_r_server_port_tr">
													<th width="35%">* 服务器地址：端口 （-r）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_rserver" id="shadowvpn_udpv2_rserver" class="input_ss_table" style="width:120px;" maxlength="200" value=""/>
														:
														<input type="text" name="shadowvpn_udpv2_rport" id="shadowvpn_udpv2_rport" class="input_ss_table" style="width:44px;" maxlength="200" value=""/>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_password_tr">
													<th width="35%">* 密码 （-k,--key）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_password" id="shadowvpn_udpv2_password"  class="input_ss_table" maxlength="200" value="" style="width:120px;" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_middle">
													<th colspan="2">
														<em>以下为包发送选项，两端设置可以不同, 只影响本地包发送。</em>
													</th>
												</tr>
												<tr id="shadowvpn_udpv2_fec_tr">
													<th width="35%">* fec参数 （-f）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_fec" id="shadowvpn_udpv2_fec" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>必填，x:y，每x个包额外发送y个包。</a>
														<a type="button" class="ss_btn" style="cursor:pointer" target="_blank" href="https://github.com/wangyu-/UDPspeeder/wiki/%E4%BD%BF%E7%94%A8%E7%BB%8F%E9%AA%8C">fec使用经验</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_timeout_tr">
													<th width="35%">* timeout参数 （--timeout）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_timeout" id="shadowvpn_udpv2_timeout" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>单位：ms，默认8，留空则使用默认值，仅在--mode 0下起作用</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_mode_tr">
													<th width="35%">* mode参数 （--mode）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_mode" id="shadowvpn_udpv2_mode" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>默认1，留空则使用默认值</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_report_tr">
													<th width="35%">* 数据发送和接受报告 （--report）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_report" id="shadowvpn_udpv2_report" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>单位：s，留空则不使用。</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_mtu_tr">
													<th width="35%">* mtu参数 （--mtu）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_mtu" id="shadowvpn_udpv2_mtu" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>默认1250，留空则使用默认值</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_jitter_tr">
													<th width="35%">* 原始数据抖动延迟 （-j,--jitter）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_jitter" id="shadowvpn_udpv2_jitter" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>单位：ms，默认0，留空则使用默认值</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_interval_tr">
													<th width="35%">* 时间窗口 （-i,--interval）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_interval" id="shadowvpn_udpv2_interval" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>单位：ms，默认0，留空则使用默认值。</a>
													</td>
												</tr>

												<tr id="shadowvpn_udpv2_drop_tr">
													<th width="35%">* 随机丢包 （--random-drop）</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_drop" id="shadowvpn_udpv2_drop" class="input_ss_table" style="width:120px;" maxlength="200" value="" />
														<a>单位：0.01%，默认0，留空则使用默认值。</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_middle">
													<th colspan="2">
														<em>以下服务器和客户端设置必须一致！</em>
													</th>
												</tr>
												<tr id="shadowvpn_udpv2_disableobscure_tr">
													<th width="35%">* 关闭数据包随机填充（--disable-obscure）</th>
													<td>
														<input type="checkbox" id="shadowvpn_udpv2_disableobscure" />
														<a>关闭可节省一点带宽和cpu。</a>
													</td>
												</tr>
												<tr id="shadowvpn_udpv2_middle">
													<th colspan="2">
														<em>其它参数</em>
													</th>
												</tr>
												<tr id="shadowvpn_udpv2_other_tr">
													<th width="35%">* 其它参数</th>
													<td>
														<input type="text" name="shadowvpn_udpv2_other" id="shadowvpn_udpv2_other" class="input_ss_table" style="width:200px;" value="" />
														<a>其它高级参数，请手动输入，如 -q1 等。</a>
													</td>
												</tr>	
											</table>										
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"><i>你已经开启shadowsocks,请先关闭后才能开启shadowvpn</i></div>
										<div class="apply_gen">
											<input class="button_gen" type="button" onclick="save()" value="提交">
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
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



