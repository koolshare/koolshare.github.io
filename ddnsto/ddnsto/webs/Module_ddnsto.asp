<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ddnsto穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=ddnsto&v=<% uptime(); %>"></script>
<style> .Bar_container {
	width:85%;
	height:20px;
	border:1px inset #999;
	margin:0 auto;
	margin-top:20px \9;
	background-color:#FFFFFF;
	z-index:100;
}
#proceeding_img_text {
	position:absolute;
	z-index:101;
	font-size:11px;
	color:#000000;
	line-height:21px;
	width: 83%;
}
#proceeding_img {
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
.kp_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:16%;
}
.kp_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:16%;
}

input[type=button]:focus {
	outline: none;
}

</style>
<script>
var socks5 = 1
var $j = jQuery.noConflict();
var $G = function (id) {
return document.getElementById(id);
};

function init(){
	show_menu(menu_hook);
	conf_to_obj();
    buildswitch();
    toggle_switch();
	$j("#ddnsto_website").click(
		function() {
		window.open("https://ddns.to");
		});
}

function toggle_switch(){
    var rrt = document.getElementById("switch");
    if (document.form.ddnsto_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch(){
    $j("#switch").click(
    function(){
        if(document.getElementById('switch').checked){
            document.form.ddnsto_enable.value = 1;
            
        }else{
            document.form.ddnsto_enable.value = 0;
        }
    });
}

function conf_to_obj(){
	if(typeof db_ddnsto != "undefined") {
		for(var field in db_ddnsto) {
			var el = document.getElementById(field);
			if(el != null) {
				el.value = db_ddnsto[field];
			}
		}
	} 
}

function onSubmitCtrl(o, s) {
	showSSLoadingBar(5);
	document.form.action_mode.value = s;
	updateOptions();
}

function done_validating(action){
	return true;
}

function updateOptions(){
	document.form.enctype = "";
	document.form.encoding = "";
	document.form.action = "/applydb.cgi?p=ddnsto_";
	document.form.SystemCmd.value = "ddnsto_config.sh";
	document.form.submit();
}

function menu_hook(title, tab) {
	var enable_ss = "<% nvram_get("enable_ss"); %>";
	var enable_soft = "<% nvram_get("enable_soft"); %>";
	if(enable_ss == "1" && enable_soft == "1"){
		tabtitle[tabtitle.length -2] = new Array("", "ddnsto 内网穿透");
		tablink[tablink.length -2] = new Array("", "Module_ddnsto.asp");
	}else{
		tabtitle[tabtitle.length -1] = new Array("", "ddnsto 内网穿透");
		tablink[tablink.length -1] = new Array("", "Module_ddnsto.asp");
	}
}

function openShutManager(oSourceObj, oTargetObj, shutAble, oOpenTip, oShutTip) {
	var sourceObj = typeof oSourceObj == "string" ? document.getElementById(oSourceObj) : oSourceObj;
	var targetObj = typeof oTargetObj == "string" ? document.getElementById(oTargetObj) : oTargetObj;
	var openTip = oOpenTip || "";
	var shutTip = oShutTip || "";
	if (targetObj.style.display != "none") {
		if (shutAble) return;
		targetObj.style.display = "none";
		if (openTip && shutTip) {
			sourceObj.innerHTML = shutTip;
		}
	} else {
		targetObj.style.display = "block";
		if (openTip && shutTip) {
		    sourceObj.innerHTML = openTip;
		}
	}
}


function showSSLoadingBar(seconds){
	if(window.scrollTo)
		window.scrollTo(0,0);

	disableCheckChangedStatus();
	
	htmlbodyforIE = document.getElementsByTagName("html");  //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden";	  //hidden the Y-scrollbar for preventing from user scroll it.
	
	winW_H();

	var blockmarginTop;
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;
	
	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;

	if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if(winWidth >1050){
	
		winPadding = (winWidth-1050)/2;	
		winWidth = 1105;
		blockmarginLeft= (winWidth*0.3)+winPadding-150;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.3+document.body.scrollLeft-160;

	}
	
	if(winHeight >660)
		winHeight = 660;
	
	blockmarginTop= winHeight*0.3-140		
	
	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop+"px";
	document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft+"px";
	document.getElementById("loadingBarBlock").style.width = 770+"px";
	document.getElementById("LoadingBar").style.width = winW+"px";
	document.getElementById("LoadingBar").style.height = winH+"px";
	
	loadingSeconds = seconds;
	progress = 100/loadingSeconds;
	y = 0;
	LoadingLocalProgress(seconds);
}


function LoadingLocalProgress(seconds){
	document.getElementById("LoadingBar").style.visibility = "visible";
	if (document.form.ddnsto_enable == 1){
		document.getElementById("loading_block3").innerHTML = "ddnsto启用中 ..."
	}else{
		document.getElementById("loading_block3").innerHTML = "ddnsto关闭中 ..."
	}
	//$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>此模式非科学上网方式，会影响国内网页速度...</font></li><li><font color='#ffcc00'>注意：全局模式并非VPN，只支持TCP流量转发...</font></li>");
	y = y + progress;
	if(typeof(seconds) == "number" && seconds >= 0){
		if(seconds != 0){
			document.getElementById("proceeding_img").style.width = Math.round(y) + "%";
			document.getElementById("proceeding_img_text").innerHTML = Math.round(y) + "%";
	
			if(document.getElementById("loading_block1")){
				document.getElementById("proceeding_img_text").style.width = document.getElementById("loading_block1").clientWidth;
				document.getElementById("proceeding_img_text").style.marginLeft = "175px";
			}
			--seconds;
			setTimeout("LoadingLocalProgress("+seconds+");", 1000);
		}
		else{
			document.getElementById("proceeding_img_text").innerHTML = "完成";
			y = 0;
				setTimeout("hideSSLoadingBar();",1000);
				refreshpage();
		}
	}
}

function reload_Soft_Center(){
	location.href = "/Main_Soft_center.asp";
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
					<div id="loading_block2" style="margin:10px auto; width:85%;">进度条走动过程中请勿刷新网页，请稍后...</div>
				</td>
			</tr>
		</table>
	</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=ddnsto_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_ddnsto.asp">
	<input type="hidden" name="next_page" value="Module_ddnsto.asp">
	<input type="hidden" name="group_id" value="">
	<input type="hidden" name="modified" value="0">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="action_wait" value="8">
	<input type="hidden" name="first_time" value="">
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
	<input type="hidden" id="ddnsto_enable" name="ddnsto_enable" value='<% dbus_get_def("ddnsto_enable", "0"); %>'/>
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top"><div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top"><div>&nbsp;</div>
										<div class="formfonttitle">软件中心 - ddnsto内网穿透</div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote">
											<li>ddnsto内网穿透是koolshare小宝开发的，支持http2的快速穿透。</br>
											<li>你需要先到<a id="gfw_number" href="https://ddns.to" target="_blank"><i><u>【https://ddns.to】</u></i></a>注册帐号，然后在本插件内填入帐号和密码，再登录<a id="gfw_number" href="https://ddns.to" target="_blank"><i><u>【https://ddns.to】</u></i></a>设置穿透。</br>
										</div>
										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
												<tr>
													<td colspan="2">ddnsto - 高级设置</td>
												</tr>
											</thead>
                                        	<tr id="switch_tr">
                                        	    <th>
                                        	        <label>开关</label>
                                        	    </th>
                                        	    <td colspan="2">
                                        	        <div claddnsto="switch_field" style="display:table-cell;float: left;">
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
                                        	    </td>
                                        	</tr>
											<tr>
												<th>ddnsto 账号</th>
												<td>
													<input style="background-image: none;background-color: #576d73;border:1px solid gray" type="text" class="input_ss_table" id="ddnsto_name" name="ddnsto_name" maxlength="100" value="">
												</td>
											</tr>
											<tr>
												<th>ddnsto 密码</th>
													<td>
														<input type="password" class="input_ss_table" id="ddnsto_password" name="ddnsto_password" maxlength="100" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
												</td>
											</tr>
											<tr id="rule_update_switch">
												<th>管理/帮助</th>
												<td>
													<input class="kp_btn" id="ddnsto_website" style="cursor:pointer;" type="submit" value="ddns.to" />
													<input class="kp_btn" onclick="openShutManager(this,'NoteBox',false,'关闭使用说明','ddnsto使用说明') " style="cursor:pointer;" type="submit" value="帮助信息" />
												</td>
											</tr>
										</table>

										<div id="warning" style="font-size:14px;margin:20px auto;"></div>
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交" />
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div id="NoteBox" style="display:none">
											<li> ddnsto内网穿透目前处于测试阶段，仅提供给koolshare固件用户使用，提供路由界面的穿透，请勿用于反动、不健康等用途；</li>
											<li> 例如局域网ip是192.168.2.1，需要用 <i>https://xiaobao.ddns.to/</i> 作为ddns域名，则设置域名前缀为 <i>xiaobao</i>，主机地址为 <i>http://192.168.2.1</i>；</li>
											<li> 远程命令建议安装并使用<a href="/#Module_shellinabox.asp" target="_blank"> shellinabox </a>插件，并设置<i> xiaobao-cmd </i>为二级域名，并添加 <i>http://192.168.2.1:4200</i> 目标主机地址。</li>
										</div>
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

