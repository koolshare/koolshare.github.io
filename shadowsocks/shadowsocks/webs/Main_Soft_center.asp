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
<script>
var PostDatas = {};
PostDatas["action_mode"] = " Refresh ";
PostDatas["SystemCmd"] = "install-xunlei.sh";
PostDatas["current_page"] = "Module_xunlei.asp";

function validForm() {
return true;
}
function onSubmitCtrl(o, s) {
if(validForm()){
document.form.action_mode.value = s;
showLoading(8);
document.form.submit();
}
}
function done_validating(action){
refreshpage(8);
}
function init(){
show_menu();
write_xunlei_install_status();
}
function jumptocmd() {
window.location.href="Module_webshell.asp";
}
function write_xunlei_install_status(){
	$.ajax({
	type: "get",
	url: "dbconf?p=xunlei_basic",
	dataType: "script",
	success: function() {
		var usb_path = db_xunlei_basic['xunlei_basic_usb'];
		var percentage = db_xunlei_basic['xunlei_basic_percentage'];		
		if (db_xunlei_basic['xunlei_basic_installed'] == "0"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[没有检测USB设备!]</font></span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "1"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[检测到USB设备 " + usb_path + "]</font></span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "2"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[正在下载迅雷...]</font></span>");
			$("#xunlei_info1").html("<font color='#ffcc00'>请耐心等待...正在默默为你下载...</font>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "3"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[正在安装迅雷...]</font></span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "4"){
			$("#xunlei_install").html("<span class='software_action' onclick='PostData(0)'>[卸载]</span>");
			$("#xunlei_info1").html("<li>点击安装后会自动下载并安装到USB设备中.</li><li>默认下载目录也位于相同的USB设备内.</li>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "5"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[停止迅雷...]</font></span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "6"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[卸载中...]</font></span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "7"){
			$("#xunlei_install").html("<span class='software_action' onclick='PostData(1)'>[安装]</span>");
		} else if (db_xunlei_basic['xunlei_basic_installed'] == "8"){
			$("#xunlei_install").html("<span class='software_action'><font color='#ffcc00'>[文件校验错误!]</font></span>");
		} else {
			$("#xunlei_install").html("<span class='software_action' onclick='PostData(1)'>[安装]</span>");
		}
		setTimeout("write_xunlei_install_status()", 2000);
	}
	})
}
//运行install-xunlei.sh

function PostData(s){
if (s == "1"){
	PostDatas["SystemCmd"] = "install-xunlei.sh";
} else if (s == "0"){
	PostDatas["SystemCmd"] = "uninstall-xunlei.sh";
}
$.ajax({
type: "POST",
url: "applydb.cgi?p=xunlei_basic",
dataType: "text",
data: PostDatas,
error: function(xhr) {
end("error");
},
success: function() {
write_xunlei_install_status()
}
});
}
//todo ss-server by sadoneli
function check_ssserver(){
buildIphoneSwitch_ss()
cal_panel_block("ssserver_div", 0.25);
$('#ssserver_div').fadeIn();
}
function close_ssserver_status(){
$('#ssserver_div').fadeOut(100);
}

function buildIphoneSwitch_ss() {
$('#ss-server_enable').iphoneSwitch(0, function() {
xunleiEnable = 1;
}, function() {
xunleiEnable = 0;
})
}

function openWeb() {
window.open("http://yuancheng.xunlei.com/")
}

var checkTime = 0;
var xunleiEnable = 0;
var submitDatas = {};
submitDatas["action_mode"] = " Refresh ";
submitDatas["SystemCmd"] = "config-xunlei.sh";
submitDatas["current_page"] = "Module_xunlei.asp";
submitDatas["xunlei_basic_request"] = "00";


function submitData(r) {
if(r=="01" && xunleiEnable==0) return;
submitDatas["xunlei_basic_request"] = r;
$.ajax({
type: "POST",
url: "applydb.cgi?p=xunlei_basic",
dataType: "text",
data: submitDatas,
success: function() {
setTimeout("getDataStatus()", 200)
},
error: function() {
$("#xunlei_info").html("系统不合理异常Ajax:" + r);
}
})
}
function getDataStatus() {
$.ajax({
type: "get",
url: "dbconf?p=xunlei_basic",
dataType: "script",
success: function(s) {
var usb_path = db_xunlei_basic['xunlei_basic_usb'];
$("#xunlei_description").html("1.&nbsp;得到激活码后请前往<font color='#ffcc00'>[迅雷远程管理页面]</font>绑定账号；<br>2.&nbsp;下载速度过快时，可能消耗更多的CPU资源，你可以在远程管理页面中设置速度限制。<br>3.&nbsp;当前迅雷安装目录：" + usb_path + "/Merlin_softerware/xunlei/<br>4.&nbsp;当前默认下载目录：" + usb_path + "/TDDOWNLOAD/");
if (submitDatas["xunlei_basic_request"] == "00") {
if (db_xunlei_basic['xunlei_basic_status'] == "02") {
buildIphoneSwitch(0);
} else if (db_xunlei_basic['xunlei_basic_status'] == "01") {
buildIphoneSwitch(1);
} else {
buildIphoneSwitch(0);
$("#xunlei_info").html("系统回调异常！请确认迅雷插件是否正常安装！异常代码：" + submitDatas["xunlei_basic_request"]);
}
}
if (db_xunlei_basic['xunlei_basic_status'] == "020") {
showLoading(2);
$("#xunlei_info").html("插件关闭中……");
setTimeout("submitData('02')", 1000)
} else if (db_xunlei_basic['xunlei_basic_status'] == "02") {
$("#xunlei_info").html("已关闭")
} else if (db_xunlei_basic['xunlei_basic_status'] == "010") {
showLoading(6);
$("#xunlei_info").html("启动中，请稍等……");
checkTime++;
if (checkTime < 25) {
setTimeout("submitData('01')", 1000)
} else {
$("#xunlei_info").html("启动异常，超时！请联系……算了，自己论坛找问题去吧")
}
} else if (db_xunlei_basic['xunlei_basic_status'] == "01") {
checkTime = 0;
setTimeout("submitData('01')", 1000);
if(db_xunlei_basic['xunlei_basic_info'].length!=0) {
var infoArr = eval(db_xunlei_basic['xunlei_basic_info']);
if(infoArr[4].length!=0) {
$("#xunlei_info").html("激活码：" + infoArr[4]);
} else if(infoArr[7].length!=0) {
$("#xunlei_info").html("已绑定账户：" + infoArr[7]);
} else {
$("#xunlei_info").html("明明都正常启动了，居然获取信息异常");
}
}
} else if (db_xunlei_basic['xunlei_basic_status'] == "00") {
$("#xunlei_info").html("启动异常，请确认迅雷插件是否正常安装！");
}
}
})
}
function buildIphoneSwitch(x) {
xunleiEnable = x;
$('#radio_enable').iphoneSwitch(x, function() {
xunleiEnable = 1;
submitData("10");
}, function() {
xunleiEnable = 0;
submitData("20");
})
}
function check_xware(){
submitData("00");
cal_panel_block("xware_div", 0.25);
$('#xware_div').fadeIn();
}
function close_xware_status(){
$('#xware_div').fadeOut(100);
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="xware_div" class="xware">
		<table style="width:99%;">
			<tr>
				<td>
					<div class="xware_router_status">梅林固件-迅雷远程</div>
				</td>
			</tr>
				<td>
					<div id="xunlei_description" class="formfontdesc" style="font-style: italic;font-size: 14px;">1.&nbsp;得到激活码后请前往[迅雷远程管理页面]绑定账号；<br>2.&nbsp;下载速度过快时，可能消耗更多的CPU资源，你可以在远程管理页面中设置速度限制。<br>3.&nbsp;当前迅雷安装目录：<br>4.&nbsp;当前默认下载目录：</div>
				</td>
			<tr>
				<td>
					<div>
						<table class="FormTable" width="99%" border="1" align="center" cellpadding="4" cellspacing="0">
							<tr>
								<th>启用/关闭</th>
								<td>
									<div class="left" style="width:94px; float:left; cursor:pointer;" id="radio_enable"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th>信息提示</th>
								<td>
									<div>
										<span id="xunlei_info"></span>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<table style="margin-top:10px;margin-left:auto;margin-right:auto;">
						<tr>
							<td>
								<div style="margin-left:200px;"><input  class="button_gen" type="button" onclick="close_xware_status();" value="关闭"></input></div>
								<div style="margin-top:-33px;margin-left:340px;"><button class="button_gen" onclick="window.open('http://yuancheng.xunlei.com/')">迅雷远程管理页面</button></div>
								<div style="margin-top:-33px;margin-left:535px;">后台技术支持：<font color='#ffcc00'>sadoneli</font><br/>Shell, Web by： <a href="http://ganky.vicp.net" target="_blank"><font color='#ffcc00'>Ganky</font></a></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="xunlei_basic_installed" id="xunlei_basic_installed" value=""/>
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
																					<h2>欢迎</h2>
																				</li>
																				<li style="margin-top:-5px;">
																					欢迎来到插件中心，目前正在紧张开发中，各种插件酝酿中！
																				</li>
																				<li style="margin-top:-5px;">
																					如果你想加入我们的工作，在 <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a>联系我们！
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

													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="ngrokd" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_tunnel.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">穿透DDNS</div>
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
													<tr height="10px">
														<td colspan="3"></td>
													</tr>

													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="p2p" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_koolnet.asp'">></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">P2P穿透</div>
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
													<tr height="10px">
														<td colspan="3"></td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="thunder" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="check_xware();"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">迅雷远程</div>
															<div id="xunlei_install" align="left" style="width:130px;margin-top:2px;margin-left:95px;"></div>
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
													<tr height="10px">
														<td colspan="3"></td>
													</tr>

													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="aria2" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_aria2.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Aria2</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="aria2_install();"></span>
															</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="Transmission" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_transmission.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Transmission</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="transmission_install();"></span>
															</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="ss-server" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_ss_server.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">ss-server</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>
													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="shadowvpn" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_shadowVPN.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">shadowvpn</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>

													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="v2ray" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"  onclick="location.href = '/Module_v2ray.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">v2ray</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>

													
													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="entware" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">Entware-ng</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="entware_install();"></span>
															</div>
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
													<tr height="10px">
														<td colspan="3">
														</td>
													</tr>
													<tr bgcolor="#444f53" width="235px">
														<td bgcolor="#444f53" class="cloud_main_radius_left" width="20%" height="50px">
															<div id="dualwan_policy" style="padding:10px;margin-left:20px;margin-right:150px;cursor:pointer;" align="center" onclick="location.href = '/Module_policy_route.asp'"></div>
															<div align="left" style="width:130px;margin-top:-40px;margin-bottom:21px;margin-left:105px;font-size:18px;text-shadow: 1px 1px 0px black;">策略路由</div>
															<div align="left" style="width:130px;margin-top:2px;margin-left:95px;">
																<span class="software_action" onclick="dualwan_policy_install();"></span>
															</div>
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
													<tr height="10px">
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

