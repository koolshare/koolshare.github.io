<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - thunder</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=thunder_&v=<% uptime(); %>"></script>
<script>
var checkTime = 0;
var thunderEnable = 0;
var submitDatas = {};
submitDatas["action_mode"] = " Refresh ";
submitDatas["SystemCmd"] = "thunder_config.sh";
submitDatas["current_page"] = "Module_thunder.asp";
submitDatas["thunder_basic_request"] = "00";
function init() {
	show_menu();
	submitData("00");
	checkCmdRet();
}
function openWeb() {
	window.open("http://yuancheng.xunlei.com/")
}
function submitData(r) {
	if(r=="01" && thunderEnable==0) return;
	submitDatas["thunder_basic_request"] = r;
	$.ajax({
		type: "POST",
		url: "applydb.cgi?p=thunder_basic",
		dataType: "text",
		data: submitDatas,
		success: function() {
			setTimeout("getDataStatus()", 1000)
		},
		error: function() {
			$("#thunder_info").html("系统不合理异常Ajax:" + r);
		}
	})
}
function getDataStatus() {
	$.ajax({
		type: "get",
		url: "dbconf?p=thunder_basic",
		dataType: "script",
		success: function(s) {
			if (submitDatas["thunder_basic_request"] == "00") {
				if (db_thunder_basic['thunder_basic_status'] == "02") {
					buildIphoneSwitch(0);
				} else if (db_thunder_basic['thunder_basic_status'] == "01") {
					buildIphoneSwitch(1);
				} else {
					buildIphoneSwitch(0);
					$("#thunder_info").html("系统回调异常！请确认迅雷插件是否正常安装！异常代码：" + submitDatas["thunder_basic_request"]);
				}
			}
			if (db_thunder_basic['thunder_basic_status'] == "020") {
				//showLoading(2);
				$("#thunder_info").html("插件关闭中……");
				setTimeout("submitData('02')", 1000)
			} else if (db_thunder_basic['thunder_basic_status'] == "02") {
				$("#thunder_info").html("已关闭")
			} else if (db_thunder_basic['thunder_basic_status'] == "010") {
				//showLoading(6);
				$("#thunder_info").html("启动中，请稍等……");
				checkTime++;
				if (checkTime < 25) {
					setTimeout("submitData('01')", 1000)
				} else {
					$("#thunder_info").html("启动异常，超时！请联系……算了，自己论坛找问题去吧")
				}
			} else if (db_thunder_basic['thunder_basic_status'] == "01") {
				checkTime = 0;
				setTimeout("submitData('01')", 1000);
				if(db_thunder_basic['thunder_basic_info'].length!=0) {
					//var infoArr = eval(db_thunder_basic['thunder_basic_info']);
					var active_code = eval(db_thunder_basic['thunder_basic_info'].split(", ")[4]);
					var user_name = eval(db_thunder_basic['thunder_basic_info'].split(", ")[7]);
					if(active_code.length!=0) {
						$("#thunder_info").html("激活码：" + active_code);
					} else if(user_name.length!=0) {
						$("#thunder_info").html("已绑定账户：" + user_name);
					} else {
						$("#thunder_info").html("明明都正常启动了，居然获取信息异常");
					}
				}
			} else if (db_thunder_basic['thunder_basic_status'] == "00") {
				$("#thunder_info").html("启动异常，请确认迅雷插件是否正常安装！");
			}
		}
	})
}
function buildIphoneSwitch(x) {
	thunderEnable = x;
	$('#radio_enable').iphoneSwitch(x, function() {
		document.form.submit();
		thunderEnable = 1;
		submitData("10");
	}, function() {
		thunderEnable = 0;
		submitData("20");
	})
}
function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function update_visibility(){
showhide("thunder_cpulimit_value", (document.form.f_thunder_cpulimit_enable.value !== "0"));
//showhide("aria2_cpulimit_value", (document.aria2_form.f_aria2_cpulimit_enable.value !== "false"));
}

function oncheckclick(obj) {
    if (obj.checked) {
        document.getElementById("f_" + obj.id).value = "1";
    } else {
        document.getElementById("f_" + obj.id).value = "0";
    }
}
var _responseLen;
var noChange = 0;
function checkCmdRet(){
	$.ajax({
		url: '/res/thunder_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
		},
		success: function(response){
			var retArea = document.getElementById("log_content1");
			var _cmdBtn = document.getElementById("cmdBtn");
			if(response.search("XU6J03M6") != -1){
				retArea.value = response.replace("XU6J03M6", " ");
				setTimeout("refreshpage();", 3000);
				return false;
			}
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}
			if(noChange > 100){
				//document.getElementById("log_content").style.display = "none";
				//noChange = 0;
				//refreshpage();
				setTimeout("checkCmdRet();", 10000);
			}else{
				setTimeout("checkCmdRet();", 1000);
			}
			retArea.value = response;
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
		<form method="post" name="form" action="/applydb.cgi?p=thunder_" target="hidden_frame">
		<input type="hidden" name="current_page" value="Main_Ss_Content.asp"/>
		<input type="hidden" name="next_page" value="Main_Ss_Content.asp"/>
		<input type="hidden" name="group_id" value=""/>
		<input type="hidden" name="modified" value="0"/>
		<input type="hidden" name="action_mode" value=""/>
		<input type="hidden" name="action_script" value=""/>
		<input type="hidden" name="action_wait" value="25"/>
		<input type="hidden" name="first_time" value=""/>
		<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="0" />
		<input type="hidden" id="ss_basic_install_status" name="ss_basic_install_status" value="0" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
		<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value=""/>
		<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
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
										<div class="formfonttitle">迅雷远程下载插件(v1.0)  -  Xware(2.219.3.310)</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" id="cmdDesc"></div>
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
													<th width="20%">启用迅雷远程</th>
													<td>
														<div class="left" style="width:94px; float:left; cursor:pointer;" id="radio_enable"></div>
													</td>
												</tr>
												<tr>
													<th width="20%">信息提示</th>
													<td>
														<span id="thunder_info"></span>
													</td>
												</tr>

 											</table>
                                    	<div id="log_content" style="margin-top:10px;">
											<textarea cols="63" rows="28" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;">
												<% nvram_dump("syscmd.log","syscmd.sh"); %>
											</textarea>
										</div>
										<div class="apply_gen">
											<button class="button_gen" onclick="window.open('http://yuancheng.xunlei.com/')">迅雷远程管理页面</button>
										</div>
										<div class="apply_gen"> <img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif"></span> </div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="KoolshareBottom">
											<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											后台技术支持： <i>Xiaobao</i> <br/>
											Shell, Web by： <a href="http://ganky.vicp.net" target="_blank"><i>Ganky</i></a><br/>
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
		<div id="footer"></div>
	</body>
</html>

