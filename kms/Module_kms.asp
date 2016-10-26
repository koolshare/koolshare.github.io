<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - KMS Office自动激活工具</title>
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
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/dbconf?p=dualwanpolicy_&v=<% uptime(); %>"></script>
<script>
var $j = jQuery.noConflict();
function init() {
show_menu();
buildswitch();
conf2obj();
version_show();
var ss_mode = '<% nvram_get("ss_mode"); %>';
if(ss_mode == '3'){
$j("#foreign_line").html("<span class='software_action'><font color='#ffcc00'>SS游戏模式下会和策略路由相冲突，不要同时开启</font></span>");
} else if (ss_mode == '2') {
$j("#foreign_line").html("<span class='software_action'><font color='#ffcc00'>SS大陆白名单模式下国外线路默认全部走SS</font></span>");
} else if (ss_mode == '4') {
$j("#foreign_line").html("<span class='software_action'><font color='#ffcc00'>SS全局模式下国内外线路默认全部走SS</font></span>");
} else if (ss_mode == '1') {
$j("#foreign_line1").html("<span class='software_action'><font color='#ffcc00'>当前gfwlsit模式下，gfwlsit以外的国外线路默认全部此端口</font></span>");
} else if (ss_mode == '0') {
$j("#ss_line").html("<span class='software_action'><font color='#ffcc00'>不可用，因为SS未启用</font></span>");
}
var lb_mode = '<% nvram_get("wans_mode"); %>';
if(lb_mode !== "lb"){
document.getElementById('Routing_rules_table').style.display = "none";
document.getElementById('Routing_rules_table1').style.display = "none";
document.getElementById('warn').style.display = "";
document.form.dualwanpolicy_enable.value = 0;
inputCtrl(document.form.switch,0);
document.form.cmdBtn.disabled = true;
}
var rrt = document.getElementById("switch");
if (document.form.dualwanpolicy_enable.value != "1") {
rrt.checked = false;
document.getElementById('Routing_rules_table').style.display = "none";
document.getElementById('Routing_rules_table1').style.display = "none";
} else {
rrt.checked = true;
document.getElementById('Routing_rules_table').style.display = "";
document.getElementById('Routing_rules_table1').style.display = "";
}
}
function done_validating() {
	return true;
//refreshpage(5);
}
function buildswitch(){
$j("#switch").click(
function(){
if(document.getElementById('switch').checked){
document.form.dualwanpolicy_enable.value = 1;
document.getElementById('Routing_rules_table').style.display = "";
document.getElementById('Routing_rules_table1').style.display = "";
}else{
document.form.dualwanpolicy_enable.value = 0;
document.getElementById('Routing_rules_table').style.display = "none";
document.getElementById('Routing_rules_table1').style.display = "none";
}
});
}
function onSubmitCtrl(o, s) {
document.form.action_mode.value = s;
showLoading(3);
document.form.submit();
}
function conf2obj(){
$j.ajax({
type: "get",
url: "dbconf?p=dualwanpolicy_",
dataType: "script",
success: function(xhr) {
var p = "dualwanpolicy_";
var params = ["wan1", "wan2", "wan_foreign", "wan_ss", "wan1_custom", "wan2_custom"];
for (var i = 0; i < params.length; i++) {
        for (var i = 0; i < params.length; i++) {
			if (typeof db_dualwanpolicy_[p + params[i]] !== "undefined") {
				$j("#dualwanpolicy_"+params[i]).val(db_dualwanpolicy_[p + params[i]]);
				}
            update_visibility();
        }
	}
	}
	});
}
function update_visibility() {
showhide("dualwanpolicy_wan1_custom", (document.form.dualwanpolicy_wan1.value == "2"));
showhide("dualwanpolicy_wan2_custom", (document.form.dualwanpolicy_wan2.value == "5"));
}
function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function version_show(){
	$j("#dualwan_version_status").html("<i>当前版本：" + db_dualwanpolicy_['dualwan_version']);
    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/dualwan/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#dualwan_version_status").html("<i>当前版本：" + obj.version);
		if(obj.version != db_dualwanpolicy_["dualwan_version"]) {
			$j("#dualwan_version_status").html("<i>有新版本：" + obj.version);
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
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=dualwanpolicy_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_policy_route.asp"/>
<input type="hidden" name="next_page" value="Module_policy_route.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="dualwan_policy.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="dualwanpolicy_enable" name="dualwanpolicy_enable" value='<% dbus_get_def("dualwanpolicy_enable", "0"); %>'/>
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
<div style="float:left;" class="formfonttitle">KMS - Office自动激活工具</div>
<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div class="formfontdesc" id="cmdDesc">Office 自动激活工具，再也不用为寻找破解版烦恼了。</div>
<div class="formfontdesc" id="cmdDesc"></div>
<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
<thead>
<tr>
<td colspan="2">KMS服务器选项</td>
</tr>
</thead>
<tr>
<th>开启KMS自动激活服务</th>
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
<div id="dualwan_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("dualwan_version", "未知"); %></i></div>
<div id="dualwanpolicy_install_show" style="padding-top:5px;margin-left:330px;margin-top:-25px;"></div>
<a style="margin-left: 318px;" href="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/kms/Changelog.txt" target="_blank"><em>[<u> 更新日志 </u>]</em></a>
</td>
</tr>
</table>
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
