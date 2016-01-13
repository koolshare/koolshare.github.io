<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Shadowsocks - Socks5代理设置</title>
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
<script type="text/javascript" src="/ss_conf?v=<% uptime(); %>"></script>
<script type="text/javascript" src="/ss-menu.js"></script>
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
var socks5 = 1
var $G = function (id) {
return document.getElementById(id);
};
function key_event(evt){
if(evt.keyCode != 27 || isMenuopen == 0)
return false;
pullLANIPList(document.getElementById("pull_arrow"));
}
function onSubmitCtrl(o, s) {
if(validForm()){
showSSLoadingBar(10);
document.form.action_mode.value = s;
updateOptions();
}
}
/*
function done_validating(action){
refreshpage(8);
}
*/
function init(){
show_menu(menu_hook);
if(typeof ss != "undefined") {
for(var field in ss) {
var el = document.getElementById("sslocal_"+field);
if(field == "method" || field == "enable") {
continue;
}
if(el != null) {
el.value = ss[field];
}
}
} else {
document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
return;
}
if(typeof sslocal != "undefined") {
for(var field in sslocal) {
var el = document.getElementById("sslocal_"+field);
if(field == "method") {
continue;
}
if(el != null) {
el.value = sslocal[field];
}
}
var o = document.getElementById("sslocal_method");
for(var c = 0; c < o.length; c++)
{
if(o.options[c].value == sslocal.method)
{
o.options[c].selected = true;
break;
}
}
}
}
function updateOptions(){
document.form.enctype = "";
document.form.encoding = "";
document.form.action = "/applyss.cgi";
document.form.SystemCmd.value = "ssconfig basic";
document.form.submit();
}
var $j = jQuery.noConflict();
var _responseLen;
var noChange = 0;
var over_var = 0;
var isMenuopen = 0;
function hideClients_Block(evt){
if(typeof(evt) != "undefined"){
if(!evt.srcElement)
evt.srcElement = evt.target; // for Firefox
if(evt.srcElement.id == "pull_arrow" || evt.srcElement.id == "ClientList_Block"){
return;
}
}
$G("pull_arrow").src = "/images/arrow-down.gif";
$G('ClientList_Block_PC').style.display='none';
isMenuopen = 0;
}
function pullLANIPList(obj){
if(isMenuopen == 0){
obj.src = "/images/arrow-top.gif"
$G("ClientList_Block_PC").style.display = 'block';
isMenuopen = 1;
}
else
hideClients_Block();
}
function validForm(){
var is_ok = true;
return is_ok;
}
function UploadFile() {
if (document.getElementById('ss_file').value == "") return false;
document.getElementById('ss_file_info').style.display = "none";
document.getElementById('loadingicon').style.display = "block";
document.form.action = "ssupload.cgi?a=/tmp/ss.ini";
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
function pass_checked(obj){
switchType(obj, document.form.show_pass.checked, true);
}
function disable_input() {
var dns2socks = document.form.dns2socks.value;
if(dns2socks == '1'){
$j("#warning").html("<font color='#ffcc00'><li>注意：DNS2SOCKS依赖于Socks5。</li><li>如果使用dns2socks作为国外DNS解析，此页面将不允许自由设置。</li><li>不过你仍然可以使用此页面定义的1080端口的socks5协议。</li></font>");
inputCtrl(document.form.sslocal_enable,0);
inputCtrl(document.form.sslocal_server,0);
inputCtrl(document.form.sslocal_port,0);
inputCtrl(document.form.sslocal_password,0);
inputCtrl(document.form.sslocal_method,0);
inputCtrl(document.form.sslocal_timeout,0);
inputCtrl(document.form.sslocal_proxyport,0);
document.form.cmdBtn.disabled = true
document.form.cmdBtn.value = "禁止"
}
}
</script>
</head>
<body onkeydown="key_event(event);" onclick="if(isMenuopen){hideClients_Block(event)}" onload="init();">
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
<!--[if lte IE 6.5]><iframe class="hackiframe"></iframe><![endif]-->
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applyss.cgi" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_SsLocal_Content.asp">
<input type="hidden" name="next_page" value="Main_SsLocal_Content.asp">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="8">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" id="dns2socks" name="dns2socks" value='<% dbus_get_def("dns2socks", ""); %>'/>
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
<div class="formfonttitle">Shadowsocks - Socks5代理设置</div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<div class="SimpleNote"><i>说明：</i>此页面允许配置第二个shadosocks账号，功能仅限于在路由器上打开一个连接到shadowsocks服务器的socks5端口。如果你使用chrome浏览器，你可以使用SwitchyOmega插件去连接这个socks5代理。</div>
<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
<thead>
<tr>
<td colspan="2">Shadowsocks - ss-local - 高级设置</td>
</tr>
</thead>
<tr>
<th width="20%">开关</th>
<td><select id="sslocal_enable" name="sslocal_enable" style="width:165px;margin:0px 0px 0px 2px;" class="ssconfig input_option">
<option value="0">不开启</option>
<option value="1">开启</option>
</select>
</td>
</tr>
<tr>
<th width="20%">服务器(建议填写IP地址)</th>
<td><input style="background-image: none;background-color: #576d73;border:1px solid gray" type="text" class="ssconfig input_ss_table" id="sslocal_server" name="sslocal_server" maxlength="100" value=""></td>
</tr>
<tr>
<th width="20%">服务器端口</th>
<td><input type="text" class="ssconfig input_ss_table" id="sslocal_port" name="sslocal_port" maxlength="100" value=""></td>
</tr>
<tr>
<th width="20%">密码</th>
<td><input type="password" class="ssconfig input_ss_table" id="sslocal_password" name="sslocal_password" maxlength="100" value="">
<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.sslocal_password);">显示密码</div>
</td>
</tr>
<tr>
<th width="20%">加密方法</th>
<td><select id="sslocal_method" name="sslocal_method" style="width:165px;margin:0px 0px 0px 2px;" class="input_option">
<option value="table">table</option>
<option value="rc4">rc4</option>
<option value="rc4-md5">rc4-md5</option>
<option value="aes-128-cfb">aes-128-cfb</option>
<option value="aes-192-cfb">aes-192-cfb</option>
<option value="aes-256-cfb">aes-256-cfb</option>
<option value="bf-cfb">bf-cfb</option>
<option value="camellia-128-cfb">camellia-128-cfb</option>
<option value="camellia-192-cfb">camellia-192-cfb</option>
<option value="camellia-256-cfb">camellia-256-cfb</option>
<option value="cast5-cfb">cast5-cfb</option>
<option value="des-cfb">des-cfb</option>
<option value="idea-cfb">idea-cfb</option>
<option value="rc2-cfb">rc2-cfb</option>
<option value="seed-cfb">seed-cfb</option>
<option value="salsa20">salsa20</option>
<option value="chacha20">chacha20</option>
</select></td>
</tr>
<tr>
<th width="20%">超时时间</th>
<td><input type="text" class="ssconfig input_ss_table" id="sslocal_timeout" name="sslocal_timeout" maxlength="100" value=""></td>
</tr>
<tr>
<th width="20%">代理端口</th>
<td><input type="text" class="ssconfig input_ss_table" id="sslocal_proxyport" name="sslocal_proxyport" maxlength="100" value=""></td>
</tr>
</table>
<div id="warning" style="font-size:14px;margin:20px auto;"></div>
<div class="apply_gen">
<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交" />
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

