<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Shadowsocks - 日志</title>
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
<script type="text/javascript" src="/ss-menu.js"></script>
<style>
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
showLoading();
document.form.action_mode.value = s;
updateOptions();
}
}
function done_validating(action){
refreshpage();
}
function init(){
show_menu(menu_hook);
checkCmdRet();
var retArea = document.getElementById('textarea');
retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
}
function updateOptions(){
document.form.enctype = "";
document.form.encoding = "";
document.form.action = "/applyss.cgi";
document.form.SystemCmd.value = cmd;
document.form.submit();
document.getElementById("loadingIcon").style.display = "";
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
function checkCmdRet(){
$j.ajax({
url: '/cmdRet_check.htm',
dataType: 'html',
error: function(xhr){
setTimeout("checkCmdRet();", 1000);
},
success: function(response){
if(response.search("XU6J03M6") != -1){
document.getElementById("loadingIcon").style.display = "none";
var retArea = document.getElementById('textarea');
retArea.value = response.replace("XU6J03M6", " ");
retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
document.form.SystemCmd.focus();
return false;
}
if(_responseLen == response.length)
noChange++;
else
noChange = 0;
if(noChange > 30){
document.getElementById("loadingIcon").style.display = "none";
retArea.scrollTop = retArea.scrollHeight;
document.form.SystemCmd.focus();
setTimeout("checkCmdRet();", 1000);
}
else{
document.getElementById("loadingIcon").style.display = "";
setTimeout("checkCmdRet();", 1000);
}
var retArea = document.getElementById('textarea');
retArea.value = response;
_responseLen = response.length;
retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
}
});
}
</script>
</head>
<body onkeydown="key_event(event);" onclick="if(isMenuopen){hideClients_Block(event)}" onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applyss.cgi" target="hidden_frame">
  <input type="hidden" name="current_page" value="Main_SsAdvance_Content.asp">
  <input type="hidden" name="next_page" value="Main_SsAdvance_Content.asp">
  <input type="hidden" name="group_id" value="">
  <input type="hidden" name="modified" value="0">
  <input type="hidden" name="action_mode" value="">
  <input type="hidden" name="action_script" value="">
  <input type="hidden" name="action_wait" value="">
  <input type="hidden" name="first_time" value="">
  <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
  <input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
  <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
  <input type="hidden" id="Ssconfig" name="Ssconfig" value='ssconfig'/>
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
                    <div class="formfonttitle">Shadowsocks - 日志</div>
                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                    <div style="margin-top:8px">
                      <textarea cols="63" rows="27" wrap="off" readonly="readonly" id="textarea" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;">
</textarea>
                    </div>
                    <div class="apply_gen"> <img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif"></span> </div>
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
