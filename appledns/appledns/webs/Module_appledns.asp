<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - AppleDNS加速服务</title>
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
<script type="text/javascript" src="/dbconf?p=appledns_&v=<% uptime(); %>"></script>
<script>
var $j = jQuery.noConflict();

function init() {
show_menu();
buildswitch();
conf2obj();
version_show();
var rrt = document.getElementById("switch");
if (document.form.appledns_enable.value != "1") {
rrt.checked = false;
document.getElementById('Routing_rules_table').style.display = "none";
} else {
rrt.checked = true;
document.getElementById('Routing_rules_table').style.display = "";
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
document.form.appledns_enable.value = 1;
document.getElementById('Routing_rules_table').style.display = "";
}else{
document.form.appledns_enable.value = 0;
document.getElementById('Routing_rules_table').style.display = "none";
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
url: "dbconf?p=appledns_",
dataType: "script",
success: function(xhr) {
var p = "appledns_";
var params = ["wan"];
for (var i = 0; i < params.length; i++) {
        for (var i = 0; i < params.length; i++) {
			if (typeof db_appledns_[p + params[i]] !== "undefined") {
				$j("#appledns_"+params[i]).val(db_appledns_[p + params[i]]);
				}
            update_visibility();
        }
	}
	}
	});

}
function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}


function version_show(){
	$j("#appledns_version_status").html("<i>当前版本：" + db_appledns_['appledns_version']);

    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/appledns/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#appledns_version_status").html("<i>当前版本：" + obj.version);
		if(obj.version != db_appledns_["appledns_version"]) {
			$j("#appledns_version_status").html("<i>有新版本：" + obj.version);
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
<form method="POST" name="form" action="/applydb.cgi?p=appledns_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_policy_route.asp"/>
<input type="hidden" name="next_page" value="Module_policy_route.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="appledns.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="appledns_enable" name="appledns_enable" value='<% dbus_get_def("appledns_enable", "0"); %>'/>
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
<div style="float:left;" class="formfonttitle">AppleDNS加速服务</div>
<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div class="formfontdesc" id="cmdDesc">AppleDNS 通过收集 Apple 在全中国几乎所有省级行政区的 CDN IP 列表，解决 App Store / Mac App Store / iTunes Store / Apple Music / iBooks / TestFlight 在中国部分地区速度缓慢的问题。</div>
<div class="formfontdesc" id="cmdDesc"></div>
<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
<thead>
<tr>
<td colspan="2">开关设置</td>
</tr>
</thead>
<tr>
<th>开启AppleDNS加速服务</th>
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
<div id="appledns_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("appledns_version", "未知"); %></i></div>
<div id="appledns_install_show" style="padding-top:5px;margin-left:330px;margin-top:-25px;"></div>
<a style="margin-left: 318px;" href="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/appledns/Changelog.txt" target="_blank"><em>[<u> 更新日志 </u>]</em></a>
</td>
</tr>
</table>
<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="Routing_rules_table">
<thead>
<tr>
<td colspan="2">宽带运营商设置</td>
</tr>
</thead>
</tr>
<tr>
<th width="35%">宽带服务商配置文件</th>
<td>
<select id="appledns_wan" name="appledns_wan" class="input_option" onclick="update_visibility();" >
<option value="1">中国电信</option>
<option value="2">中国移动</option>
<option value="3">中国联通</option>
</td>
</tr>
</table>
<div class="apply_gen">
<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
</div>
<div id="line_image1" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
<div id="NoteBox">
<h2>关于AppleDNS</h2>
<p> 本插件源于论坛用户gongjianhui的一个开源项目<a href="https://koolshare.cn/thread-38725-1-1.html" target="_blank"><em>[<u> 原贴地址 </u>]</em></a> ，后经论坛用户eyre0950改编成shell脚本<a href="https://koolshare.cn/thread-44385-1-1.html" target="_blank"><em>[<u> 原贴地址 </u>]</em></a> ，为了方便更多用户使用整理成插件版。</p>
<h3>本插件开启后会根据你的网络状态动态生成配置文件，整个过程大概需要20分钟，是的！你没看错，所以开启后不会立即生效，但我又不想让你看那么长时间的状态条。。。
插件会在后台自动运行，当然你也可以关闭本页面。</h3>
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

