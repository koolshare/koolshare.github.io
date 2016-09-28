<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - koolproxy</title>
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
<script type="text/javascript" src="/dbconf?p=koolproxy_&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<style>
    .cloud_main_radius h2 { border-bottom:1px #AAA dashed;}
	.cloud_main_radius h3 { font-size:12px;color:#FFF;font-weight:normal;font-style: normal;}
	.cloud_main_radius h4 { font-size:12px;color:#FC0;font-weight:normal;font-style: normal;}
	.cloud_main_radius h5 { color:#FFF;font-weight:normal;font-style: normal;}
</style>

<script>
function init() {
	show_menu();
	buildswitch();
	conf2obj();
	update_visibility();
    var rrt = document.getElementById("switch");
    if (document.form.koolproxy_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch(){
	$j("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.koolproxy_enable.value = 1;
			
		}else{
			document.form.koolproxy_enable.value = 0;
		}
	});
}

function onSubmitCtrl(o, s) {
		document.form.action_mode.value = s;
		document.form.SystemCmd.value = "koolproxy_config.sh";
		showLoading(5);
		document.form.submit();
		refreshpage(5);
}

function conf2obj(){
    for (var field in db_koolproxy_) {
        $j('#'+field).val(db_koolproxy_[field]);
    }
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function update_visibility(){
	showhide("koolproxy_policy_read1", (document.form.koolproxy_policy.value == 1));
	showhide("koolproxy_policy_read2", (document.form.koolproxy_policy.value == 2));
	showhide("update_rules", (document.form.koolproxy_update.value == 1));
	
}

function start_update() {
	checkCmdRet();
	document.getElementById("log_content").style.display = "";
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=koolproxy";
    document.form.SystemCmd.value = "koolproxy_rule_update.sh";
	document.form.submit();
}

var _responseLen;
var noChange = 0;
function checkCmdRet(){

	$j.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
			},
		success: function(response){
			var retArea = $G("log_content1");
			if(response.search("XU6J03M6") != -1){
				retArea.value = response.replace("XU6J03M6", " ");
				//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
				retArea.scrollTop = retArea.scrollHeight;
				//return false;
			}
			
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}

			if(noChange > 15){
				//retArea.scrollTop = retArea.scrollHeight;
				//setTimeout("checkCmdRet();", 2000);
				document.getElementById("log_content").style.display = "none";
				noChange = 0;
				return false;
			}else{
				setTimeout("checkCmdRet();", 500);
			}
			
			retArea.value = response;
			//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=koolproxy_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_koolproxy_.asp"/>
	<input type="hidden" name="next_page" value="Module_koolproxy_.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="koolproxy_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="koolproxy_enable" name="koolproxy_enable" value='<% dbus_get_def("koolproxy_enable", "0"); %>'/>
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
										


												<table width="100%" height="150px" style="border-collapse:collapse;">
                                                    <tr >
                                                        <td colspan="5" class="cloud_main_radius">
                                                            <div style="padding:10px;width:95%;font-style:italic;font-size:14px;">
                                                                <br/><br/>
                                                                <table width="100%" >
                                                                    <tr>
                                                                        <td>
                                                                            <ul style="margin-top:-50px;padding-left:15px;" >
                                                                                <li style="margin-top:-5px;">
                                                                                    <h2 id="push_titile"><em>koolproxy <% dbus_get_def("koolproxy_version", "1.7"); %></em></h2>
                                                                                    <div style="float:auto; width:15px; height:25px;margin-top:-40px;margin-left:680px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                                                                </li>
                                                                                <li style="margin-top:-5px;">
                                                                                    <h3 id="push_content1" >koolproxy是能识别adblock规则的代理软件，目前正在完善中。</h3>
                                                                                </li>
                                                                                <li  style="margin-top:-5px;">
                                                                                    <h3 id="push_content2"><i>koolproxy静态规则：</i><% dbus_get_def("koolproxy_rule_info", "0"); %></h3>
                                                                                </li>
                                                                                <li id="push_content3_li" style="margin-top:-5px;">
                                                                                    <h3 id="push_content3"><i>koolproxy视频规则：</i><% dbus_get_def("koolproxy_video_info", "0"); %></h3>
                                                                                </li>
                                                                                <li id="push_content4_li" style="margin-top:-5px;display: none;">
                                                                                    <h3 id="push_content4"></h3>
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

                                                </table>

										<table style="margin:-20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">开关设置</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启koolproxy</label>
												</th>
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
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<tr id="policy_tr">
												<th>选择过滤模式</th>
												<td>
													<select name="koolproxy_policy" id="koolproxy_policy" class="input_option" onchange="update_visibility();" style="width:auto;margin:0px 0px 0px 2px;">
														<option value="1" selected>全局过滤</option>
														<option value="2">黑名单模式</option>
													</select>
														<span id="koolproxy_policy_read1" style="display: none;">全局模式下，所有80端口的流量都会走koolproxy过，过滤效果最好</span>
														<span id="koolproxy_policy_read2" style="display: none;">黑名单模式下只有黑名单内的域名走koolproxy过，效果不及全局模式</span>
												</td>
											</tr>

											<tr id="rule_update_switch">
												<th>规则更新开关</th>
												<td>
													<select name="koolproxy_update" id="koolproxy_update" class="input_option" style="width:auto;margin:0px 0px 0px 2px;" onchange="update_visibility();">
														<option value="1" selected>开启</option>
														<option value="0">关闭</option>
													</select>

												</td>
											</tr>

											<tr id="update_rules">
												<th width="35%">koolproxy规则更新间隔</a></th>
												<td>
													<select id="koolproxy_update_time" name="koolproxy_update_time" class="ssconfig input_option" title="选择规则列表自动更新时间，更新后将自动重启koolproxy"  >
														<option value="6">6小时</option>
														<option value="12">12小时</option>
														<option value="24">24小时</option>
													</select>
														<input id="update_now" onclick="start_update()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="立即更新" />
														<span>
															<a style="margin-left: 20px;" href="https://github.com/koolproxy/koolproxy_rules" target="_blank"><i><u>规则维护地址</u></i></a>
														</span>
												</td>
											</tr>
                                    	</table>
                                    	<div id="log_content" style="margin-top:10px;display: none;">
											<textarea cols="63" rows="21" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;"></textarea>
										</div>
                                    	
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
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



