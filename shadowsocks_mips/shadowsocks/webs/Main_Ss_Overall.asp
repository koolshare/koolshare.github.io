<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Shadowsocks - 全局模式</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=ss&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>
<style>
.Bar_container{
	width:85%;
	height:20px;
	border:1px inset #999;
	margin:0 auto;
	margin-top:20px \9;
	background-color:#FFFFFF;
	z-index:100;
}
#proceeding_img_text{
	position:absolute; 
	z-index:101; 
	font-size:11px; color:#000000; 
	line-height:21px;
	width: 83%;
}
#proceeding_img{
 	height:21px;
	background:#C0D1D3 url(/images/ss_proceding.gif);
}	
#ClientList_Block_PC {
	border: 1px outset #999;
	background-color: #576D73;
	position: absolute;
*margin-top:26px;
	margin-left: 3px;
*margin-left:-129px;
	width: 255px;
	text-align: left;
	height: auto;
	overflow-y: auto;
	z-index: 200;
	padding: 1px;
	display: none;
}
#ClientList_Block_PC div {
	background-color: #576D73;
	height: auto;
*height:20px;
	line-height: 20px;
	text-decoration: none;
	font-family: Lucida Console;
	padding-left: 2px;
}
#ClientList_Block_PC a {
	background-color: #EFEFEF;
	color: #FFF;
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	text-decoration: none;
}
#ClientList_Block_PC div:hover, #ClientList_Block a:hover {
	background-color: #3366FF;
	color: #FFFFFF;
	cursor: default;
}
</style>
<script>
var socks5 = 0
var ssmode = 4
var $j = jQuery.noConflict();
function onSubmitCtrl(o, s) {
if(validForm()){
showSSLoadingBar(10);
document.form.action_mode.value = s;
updateOptions();
}
}

function done_validating(action){
	return true;
}

function init(){
show_menu();
if(typeof db_ss != "undefined") {
for(var field in db_ss) {
var el = document.getElementById(field);
if(el != null) {
el.value = db_ss[field];
}
}
} else {
document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
}
}
function updateOptions(){
document.form.enctype = "";
document.form.encoding = "";
document.form.action = "/applydb.cgi?p=ss_overall_";
document.form.SystemCmd.value = "ss_config.sh";
document.form.submit();
}

function validForm(){
var is_ok = true;
return is_ok;
}
function UploadFile() {
if (document.getElementById('ss_file').value == "") return false;
document.getElementById('ss_file_info').style.display = "none";
document.getElementById('loadingicon').style.display = "block";
if(document.getElementById('fileselect').value == "0") {
document.form.action = "ssupload.cgi?a=/tmp/chnroute.txt";
} else {
document.form.action = "ssupload.cgi?a=/tmp/overall_whitelist.txt";
}
document.form.enctype = "multipart/form-data";
document.form.encoding = "multipart/form-data";
document.form.submit();
}
function upload_ok(isok) {
var info = document.getElementById('ss_file_info');
if(isok==1){
info.innerHTML="上传完成";
} else {
info.innerHTML="上传失败";
}
info.style.display = "block";
document.getElementById('loadingicon').style.display = "none";
}
function openShutManager(oSourceObj,oTargetObj,shutAble,oOpenTip,oShutTip){
var sourceObj = typeof oSourceObj == "string" ? document.getElementById(oSourceObj) : oSourceObj;
var targetObj = typeof oTargetObj == "string" ? document.getElementById(oTargetObj) : oTargetObj;
var openTip = oOpenTip || "";
var shutTip = oShutTip || "";
if(targetObj.style.display!="none"){
if(shutAble) return;
targetObj.style.display="none";
if(openTip && shutTip){
sourceObj.innerHTML = shutTip;
}
} else {
targetObj.style.display="block";
if(openTip && shutTip){
sourceObj.innerHTML = openTip;
}
}
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="LoadingBar" class="popup_bar_bg">
<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
	<tr>
		<td height="100">
		<div id="loading_block3" style="margin:10px auto;width:85%; font-size:12pt;"></div>
		<div id="loading_block1" class="Bar_container">
			<span id="proceeding_img_text"></span>
			<div id="proceeding_img"></div>
		</div>
		
		<div id="loading_block2" style="margin:10px auto; width:85%;">此期间请勿访问屏蔽网址，以免污染DNS进入缓存</div>
		</td>
	</tr>
</table>
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=ss" target="hidden_frame">
  <input type="hidden" name="current_page" value="Main_Ss_Overall.asp">
  <input type="hidden" name="next_page" value="Main_Ss_Overall.asp">
  <input type="hidden" name="group_id" value="">
  <input type="hidden" name="modified" value="0">
  <input type="hidden" name="action_mode" value="">
  <input type="hidden" name="action_script" value="">
  <input type="hidden" name="action_wait" value="8">
  <input type="hidden" name="first_time" value="">
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="1" />
<input type="hidden" id="ss_basic_mode" name="ss_basic_mode" value="4" />
  <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
  <input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
  <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
  <table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td width="17">&nbsp;</td>
      <td valign="top" width="202"><div id="mainMenu"></div>
        <div id="subMenu"></div></td>
      <td valign="top"><div id="tabMenu" class="submenuBlock"></div>
        <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
          <tr>
            <td align="left" valign="top"><table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
                <tr>
                  <td bgcolor="#4D595D" colspan="3" valign="top"><div>&nbsp;</div>
                    <div class="formfonttitle">Shadowsocks - 全局模式</div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="SimpleNote"><i>说明：</i>全局模式能将所有的TCP流量经过shadowsocks代理，<em>暂不支持UDP</em>。</div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                      <thead>
                        <tr>
                          <td colspan="2">Shadowsocks - 全局模式 - 高级设置</td>
                        </tr>
                      </thead>
                      <tr>
                        <th width="10%"><b>
                          <center>
                            <font color="#ffcc00">全局模式</font>
                          </center>
                          </b></th>
                        <td><select id="ss_overall_mode" name="ss_overall_mode" class="input_option">
                            <option value="0">全局HTTP(s)</option>
                            <option value="1">全局TCP</option>
                          </select>
                          <span>默认：全局HTTP(s)</span></td>
                      </tr>
                      <tr>
                        <th width="20%"><center>
                            <b><font color="#ffcc00">全局模式DNS</font></b>
                          </center></th>
                        <td><select id="ss_overall_dns" name="ss_overall_dns" class="input_option">
                            <option value="0">OpenDNS方式</option>
                            <option value="1">UDP转发方式</option>
                            <option value="2">OpenDNS方式 + UDP转发方式</option>
                          </select>
                          <span>默认：OpenDNS方式 </span></td>
                      </tr>
                    </table>
                    <div class="apply_gen">
                      <input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交" />
                    </div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="SimpleNote">
                      <button onclick="openShutManager(this,'NoteBox',false,'点击关闭详细说明','点击查看详细说明') " class="NoteButton">点击查看详细说明</button>
                    </div>
                    <div id="NoteBox" style="display:none">
                      <h3> 全局模式：</h3>
                      <p><b>全局HTTP(s)：</b>该模式将只代理TCP链接的80和443端口。</p>
                      <p><b>全局TCP：</b>该模式将代理全部的TCP链接(局域网除外)。</p>
                      <h3>全局模式DNS：</h3>
                      <p>选择你将使用的用以解析被代理网站的DNS服务器。</p>
                      <p> Shadowsocks账号支持UDP转发的能三个都能选择，你可以根据解析效果自己确定一个。如果你的账号不支持UDP转发，默认提供OpenDNS方式。</p>
                    </div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div class="KoolshareBottom">论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
                      博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
                      Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
                      Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> </a>, Web by： <i>Xiaobao</i> </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
      <td width="10" align="center" valign="top"></td>
    </tr>
  </table>
</form>
<div id="footer"></div>
</body>
<script type="text/javascript">
<!--[if !IE]>-->
jQuery.noConflict();
(function($){
var i = 0;
})(jQuery);
<!--<![endif]-->
</script>
</html>
