<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 系统工具</title>
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
<script type="text/javascript" src="/dbconf?p=kms_&v=<% uptime(); %>"></script>
<script>
var $j = jQuery.noConflict();
function init() {
show_menu();
conf2obj();
buildswitch();
version_show();
var rrt = document.getElementById("switch");
if (document.form.kms_enable.value != "1") {
rrt.checked = false;
document.getElementById("kms_opennat").disabled=true;
document.getElementById("kms_diyport").disabled=true;
kms_diyport
} else {
rrt.checked = true;
document.getElementById("kms_opennat").disabled=false;
document.getElementById("kms_diyport").disabled=false;
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
document.form.kms_enable.value = 1;
document.getElementById("kms_opennat").disabled=false;
document.getElementById("kms_diyport").disabled=false;
}else{
document.form.kms_enable.value = 0;
document.form.kms_opennat.value = 1;
document.getElementById("kms_opennat").disabled=true;
document.getElementById("kms_diyport").disabled=true;
}
});
}
function onSubmitCtrl(o, s) {
document.form.action_mode.value = s;
showLoading(3);
document.form.submit();
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function version_show(){
	$j("#kms_version_status").html("<i>当前版本：" + db_kms_['kms_version']);
    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/kms/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#kms_version_status").html("<i>当前版本：" + obj.version);
		if(obj.version != db_kms_["kms_version"]) {
			$j("#kms_version_status").html("<i>有新版本：" + obj.version);
		}
            }
        }
    });
}
function conf2obj(){
$j.ajax({
type: "get",
url: "dbconf?p=kms_",
dataType: "script",
success: function(xhr) {
var p = "kms_";
var params = ["diyport", "opennat"];
for (var i = 0; i < params.length; i++) {
        for (var i = 0; i < params.length; i++) {
			if (typeof db_kms_[p + params[i]] !== "undefined") {
				$j("#kms_"+params[i]).val(db_kms_[p + params[i]]);
				}
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
<form method="POST" name="form" action="/applydb.cgi?p=kms_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_kms.asp"/>
<input type="hidden" name="next_page" value="Module_kms.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="kms.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="kms_enable" name="kms_enable" value='<% dbus_get_def("kms_enable", "0"); %>'/>
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
<div style="float:left;" class="formfonttitle">系统工具 - 来自网络的胃軟系统工具</div>
<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div class="formfontdesc" id="cmdDesc">该工具用于“鸡或”“胃軟奥菲斯”和“胃軟操作系统”。</div>
<div class="formfontdesc" id="cmdDesc"></div>
<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="kms_table">
<thead>
<tr>
<td colspan="2">系统工具选项</td>
</tr>
</thead>
<tr>
<th width="35%">开启“胃軟”系统工具</th>
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
<div id="kms_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("kms_version", "未知"); %></i></div>
<div id="kms_install_show" style="padding-top:5px;margin-left:330px;margin-top:-25px;"></div>
<a style="margin-left: 318px;" href="https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/kms/Changelog.txt" target="_blank"><em>[<u> 更新日志 </u>]</em></a>
</td>
</tr>
</table>
<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="Routing_rules_table">
<thead>
<tr>
<td colspan="2">系统工具详细设置</td>
</tr>
</thead>
<tr>
<th width="35%">端口配置</th>
<td>
<input style="width:43px;margin-left:-0.5px;" type="text" class="ssconfig input_ss_table" id="kms_diyport" name="kms_diyport" maxlength="5" placeholder="1688" value="" /> 手动指定端口后，无法自动激活需要手动激活。
</td>
</tr>
<tr>
<th width="35%">开放公网选项</th>
<td>
<select id="kms_opennat" name="kms_opennat" class="input_option">
<option value="1">关闭</option>
<option value="2">开启</option>
</select>
</td>
</tr>
</table>
<div class="apply_gen">
<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
</div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div id="NoteBox">
<h2>使用说明：最好使用VOL版本</h2>
<h3>管理员身份运行CMD，红色字体代表变量不是固定的，请参照自己的计算机修改。</h3>
<h3>【1】 <font color="red">自动</font> - 奥菲斯（无法自动激活输入该命令）</h3>
<p> CD <font color="red">X</font>:\Program Files<font color="red">(X86)</font>\Microsoft Office\Office<font color="red">14</font></p>
<p>cscript ospp.vbs /remhst</p>
<p>cscript ospp.vbs /act</p>
<p>cscript ospp.vbs /dstatus</p>
<h3>【2】 <font color="red">手动</font> - 奥菲斯</h3>
<p> CD <font color="red">X</font>:\Program Files<font color="red">(X86)</font>\Microsoft Office\Office<font color="red">14</font></p>
<p>cscript ospp.vbs /sethst:<font color="red">192.168.0.1</font></p>
<p>cscript ospp.vbs /act</p>
<p>cscript ospp.vbs /dstatus</p>
<h3>【3】 <font color="red">手动</font> - 操作系统</h3>
<p>slmgr /ipk <font color="red">MHF9N-XY6XB-WVXMC-BTDCT-MKKG7</font></p>
<p>slmgr /skms <font color="red">192.168.0.1</font></p>
<p>slmgr /ato </p>


<h2>申明：本工具来自国外互联网 <a href="https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms" target="_blank">点我跳转</a></h2>
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
