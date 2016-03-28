<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Xunlei</title>
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
<script>
var checkTime = 0;
var xunleiEnable = 0;
var submitDatas = {};
submitDatas["action_mode"] = " Refresh ";
submitDatas["SystemCmd"] = "config-xunlei.sh";
submitDatas["current_page"] = "Module_xunlei.asp";
submitDatas["xunlei_basic_request"] = "00";
function init() {
	show_menu();
	submitData("00");
}
function openWeb() {
	window.open("http://yuancheng.xunlei.com/")
}
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
function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
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
<tr>
<th width="20%">启用迅雷远程</th>
<td>
<div class="left" style="width:94px; float:left; cursor:pointer;" id="radio_enable"></div>
</td>
</tr>
<tr>
<th width="20%">信息提示</th>
<td><span id="xunlei_info"></span>
</td>
</tr>
</table>
<div class="apply_gen">
<button class="button_gen" onclick="window.open('http://yuancheng.xunlei.com/')">迅雷远程管理页面</button>
</div>
<div class="apply_gen"> <img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif"></span> </div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div class="KoolshareBottom">
<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
后台技术支持： <i>Xiaobao</i> <br/>
Shell, Web by： <a href="http://ganky.vicp.net" target="_blank"><i>Ganky</i></a><br/></div>
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

