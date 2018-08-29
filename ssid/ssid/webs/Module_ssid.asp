<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 中文SSID</title>
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
<script type="text/javascript" src="/dbconf?p=ssid_&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
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
</style>
<script>
function init() {
	show_menu();
	conf2obj();
    version_show();
    setTimeout("version_show()", 3000);
}

function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	show_ssid_LoadingBar(20);
	document.form.submit();
}

function conf2obj(){
	$j.ajax({
	type: "get",
	url: "dbconf?p=ssid_",
	dataType: "script",
	success: function(xhr) {
    var p = "ssid_";
        var params = ["24", "50"];
        for (var i = 0; i < params.length; i++) {
			if (typeof db_ssid_[p + params[i]] !== "undefined") {
				$j("#ssid_"+params[i]).val(db_ssid_[p + params[i]]);
			}
        }
	}
	});
}

function version_show(){
	$j("#ssid_version_status").html("<i>当前版本：" + db_ssid_['ssid_version']);

    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/ssid/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#ssid_version_status").html("<i>当前版本：" + obj.version);
		if(obj.version != db_ssid_["ssid_version"]) {
			$j("#ssid_version_status").html("<i>有新版本：" + obj.version);
		}
            }
        }
    });
}


function show_ssid_LoadingBar(seconds){
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
		blockmarginLeft= (winWidth*0.3)+winPadding;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.3+document.body.scrollLeft;	

	}
	
	if(winHeight >660)
		winHeight = 660;
	
	blockmarginTop= winHeight*0.3			
	
	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop+"px";
	// marked by Jerry 2012.11.14 using CSS to decide the margin
	document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft+"px";

	
	/*blockmarginTop = document.documentElement.scrollTop + 200;
	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop+"px";*/

	document.getElementById("LoadingBar").style.width = winW+"px";
	document.getElementById("LoadingBar").style.height = winH+"px";
	
	loadingSeconds = seconds;
	progress = 100/loadingSeconds;
	y = 0;
	LoadingProgress(seconds);
}

function LoadingProgress(seconds){
	document.getElementById("LoadingBar").style.visibility = "visible";
	document.getElementById("loading_block3").innerHTML = "正在开始装逼..."
	$j("#loading_block2").html("<li><font color='#ffcc00'>中文SSID可能会导致某些设备无法正常连接；</font></li>");
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
			setTimeout("LoadingProgress("+seconds+");", 1000);
		}
		else{
			document.getElementById("proceeding_img_text").innerHTML = "完成";
			y = 0;
				setTimeout("hideLoadingBar();",1000);
				refreshpage()
		}
	}
}

function hideLoadingBar(){
	document.getElementById("LoadingBar").style.visibility = "hidden";
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
			
			<div id="loading_block2" style="margin:10px auto; width:85%;">此期间请勿访问屏蔽网址，以免污染DNS进入缓存</div>
			</td>
		</tr>
	</table>
	</div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=ssid_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_ssid.asp"/>
	<input type="hidden" name="next_page" value="Module_ssid.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ssid_config.sh"/>
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
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">中文SSID</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">中文SSID，然并卵~</div>
										<div id="ssid_version_status" style="padding-top:5px;margin-left:30px;margin-right:0px;margin-top:0px;float: left;"><i>当前版本：<% dbus_get_def("ssid_version", "0"); %></i></div>
										<div style="padding-top:5px;margin-top:25px;margin-left:-230px;float: left;" id="NoteBox" >
											<li style="margin-top:5px;">在此页面，你可以修改你的无线SSID名为中文； </li>
											<li style="margin-top:5px;">中文SSID可能会导致某些设备无法正常连接;</li>
											<li style="margin-top:5px;">暂时不支持设置访客Wi-Fi网络;</li>
											<li style="margin-top:5px;">设置中文SSID不会导致设备重启;</li>
											<li style="margin-top:5px;">装逼虽好，可不要贪装哦~</li>					
										</div>
																	
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">设置SSID</td>
											</tr>
											</thead>											
											<tr id="ssid_24_tr">
												<th width="35%">2.4G SSID</th>
												<td>
													<input type="text" name="ssid_24" id="ssid_24" class="ssconfig input_ss_table" maxlength="100" value="<% nvram_get("wl0_ssid"); %>"></input>
												</td>
											</tr>
											<tr id="ssid_50_tr">
												<th width="35%">5G SSID</th>
												<td>
													<input type="text" name="ssid_50" id="ssid_50" class="ssconfig input_ss_table" maxlength="100" value="<% nvram_get("wl1_ssid"); %>"></input>
												</td>
											</tr>
                                    	</table>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">开始装逼</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="KoolshareBottom">
											<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											后台技术支持： <i>Xiaobao</i> <br/>
											Shell, Web by： <i>Sadoneli</i><br/>
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



