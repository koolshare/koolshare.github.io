<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 虚拟内存</title>
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
<script type="text/javascript" src="/dbconf?p=swap_&v=<% uptime(); %>"></script>
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
    write_usb_status();
    setTimeout("write_usb_status()", 1500);
    setTimeout("check_usb()", 500);
}


function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	var mode = document.getElementById("swap_size").value;
	if (mode == "1"){
		show_swap_LoadingBar(20);
	} else if (mode == "2"){
		show_swap_LoadingBar(40);
	} else if (mode == "3"){
		show_swap_LoadingBar(80);
	}
	document.form.SystemCmd.value = "swap_load.sh";
	document.form.submit();
}

function check_usb(){
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "swap_check.sh";
    document.form.submit();
}

function unload_swap(){
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "swap_unload.sh";
    showLoading(5);
    refreshpage(5);
    document.form.submit();
}

function write_usb_status(){
	$j.ajax({
	type: "get",
	url: "dbconf?p=swap_",
	dataType: "script",
	success: function() {
	var usb_type = db_swap_['swap_usb_type'];
	var usb_path = db_swap_['swap_usb_disk'];
	if(typeof db_swap_['swap_warnning'] == "undefined" ){
		$j("#warn").html("<i>正在检查USB磁盘..</i>");$j("#warn").html("<i>正在检查USB磁盘..</i>");
		document.getElementById('cmdBtn').style.display = "none";
		document.getElementById('cmdBtn1').style.display = "";
	}else{
		if(db_swap_['swap_warnning'] == "1" ){
			$j("#warn").html("<i>没有找到可用的USB磁盘！</i>");
			document.getElementById('cmdBtn').style.display = "none";
			document.getElementById('cmdBtn1').style.display = "";
		}else if(db_swap_['swap_warnning'] == "2" ){
			$j("#warn").html("<i>USB磁盘"+usb_type+"格式不符合要求!</i>");
			document.getElementById('cmdBtn').style.display = "none";
			document.getElementById('cmdBtn1').style.display = "";
		}else if(db_swap_['swap_warnning'] == "3" ){
			$j("#warn").html("<i>检测到"+usb_type+"格式磁盘"+usb_path+",可以创建虚拟内存!</i>");
			document.getElementById('cmdBtn').style.display = "";
			document.getElementById('cmdBtn1').style.display = "none";
			document.getElementById('swap_size_tr').style.display = "";
			document.getElementById('swap_usage_tr').style.display = "none";
		}else if(db_swap_['swap_warnning'] == "4" ){
			$j("#warn").html("<i>已经挂载虚拟内存!&nbsp;&nbsp;&nbsp;&nbsp;虚拟文件："+usb_path+"/swapfile</i>");
			document.getElementById('cmdBtn').style.display = "none";
			document.getElementById('cmdBtn1').style.display = "";
			document.getElementById('swap_size_tr').style.display = "none";
			document.getElementById('swap_usage_tr').style.display = "";
		}
	}
		setTimeout("write_usb_status()", 2000);
	}
		});
	}

function conf2obj(){
	$j.ajax({
	type: "get",
	url: "dbconf?p=swap_",
	dataType: "script",
	success: function(xhr) {
    var p = "swap_";
        var params = ["size"];
        for (var i = 0; i < params.length; i++) {
			if (typeof db_swap_[p + params[i]] !== "undefined") {
				$j("#swap_"+params[i]).val(db_swap_[p + params[i]]);
			}
        }
	}
	});
}


function show_swap_LoadingBar(seconds){
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
	document.getElementById("loading_block3").innerHTML = "正在设置虚拟内存 ..."
	$j("#loading_block2").html("<li><font color='#ffcc00'>设置虚拟内存需要较长时间，请耐心等待</font></li>");
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

function hideSSLoadingBar(){
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
	<form method="POST" name="form" action="/applydb.cgi?p=swap_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_swap.asp"/>
	<input type="hidden" name="next_page" value="Module_swap.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="swap_load.sh"/>
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
										<div style="float:left;" class="formfonttitle">虚拟内存</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">创建虚拟内存，让路由运行更顺畅</div>
										<div id="swap_version_status" style="padding-top:5px;margin-left:30px;margin-right:0px;margin-top:0px;float: left;"><i>当前版本：<% dbus_get_def("swap_version", "0"); %></i></div>
										<div style="padding-top:5px;margin-top:25px;margin-left:-300px;float: left;" id="NoteBox" >
											<li style="margin-top:5px;">创建虚拟内存，你需要一个空的、已经格式化成ext2|3|4格式的U盘； </li>
											<li style="margin-top:5px;">如果你通过其它方式创建了虚拟内存，可以不用使用该工具，或者删除后再使用本工具。</li>
											<li style="margin-top:5px;">建议使用游戏模式V2，aria2等应用的用户开启虚拟内存！</li>					
										</div>
																	
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">创建虚拟内存</td>
											</tr>
											</thead>											
											<tr id="swap_status">
												<th>
													<label>状态</label>
												</th>
												<td>
 													<div id="warn" id="cmdDesc"><i>检测状态中 ...</i></div>
												</td>										
											</tr>
											<tr id="swap_usage_tr">
												<th>虚拟内存使用率</th>
												<td><% sysinfo("memory.swap.used"); %> / <% sysinfo("memory.swap.total"); %>&nbsp;MB</td>
											</tr>
											<tr id="swap_size_tr">
												<th width="35%">虚拟内存大小</th>
												<td>
													<select id="swap_size" name="swap_size" style="width:auto;margin:0px 0px 0px 2px;" class="ssconfig input_option">
														<option value="1">256M</option>
														<option value="2">512M 推荐</option>
														<option value="3">1G</option>
													</select>
												</td>
											</tr>
                                    	</table>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">创建swap</button>
											<button id="cmdBtn1" class="button_gen" onclick="unload_swap()">删除swap</button>
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



