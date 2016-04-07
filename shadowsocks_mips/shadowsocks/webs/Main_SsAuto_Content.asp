<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Shadowsocks - Redsocks2</title>
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
var socks5 = 0;
var $j = jQuery.noConflict();
var $G = function (id) {
	return document.getElementById(id);
};

function onSubmitCtrl(o, s) {
	//if(validForm() && validForm2() && validForm3()){
	if(validForm()){
		showSSLoadingBar(25);
		document.form.action_mode.value = s;
		updateOptions();
	}
}

function done_validating(action){
refreshpage(25);
}

String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}
function init(){
	show_menu(menu_hook);
	if(typeof db_ss != "undefined") {
		for(var field in db_ss) {
			var el = document.getElementById(field);
				if(el != null) {
				el.value = db_ss[field];
			}
			var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_wan_white_ip", "ss_redchn_wan_black_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_domain", "ss_redchn_dnsmasq"];
			for (var i = 0; i < temp_ss.length; i++) {
				temp_str = $G(temp_ss[i]).value;
				$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
			}
		}
	} else {
		document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
	}
	update_visibility()
}
function updateOptions(){
	document.form.enctype = "";
	document.form.encoding = "";
	document.form.action = "/applydb.cgi?p=ss_redchn_";
	document.form.SystemCmd.value = "ss_config.sh";
	document.form.submit();
}

function validForm(){
	var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_wan_white_ip", "ss_redchn_wan_black_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_domain" , "ss_redchn_dnsmasq"];
	for(var i = 0; i < temp_ss.length; i++) {
		var temp_str = $G(temp_ss[i]).value;
		if(temp_str == "") {
			continue;
		}
		var lines = temp_str.split("\n");
		var rlt = "";
		for(var j = 0; j < lines.length; j++) {
			var nstr = lines[j].trim();
			if(nstr != "") {
				rlt = rlt + nstr + ",";
			}
		}
		if(rlt.length > 0) {
			rlt = rlt.substring(0, rlt.length-1);
		}
		if(rlt.length > 10000) {
			alert(temp_ss[i] + " 不能超过10000个字符");
			return false;
		}
		$G(temp_ss[i]).value = rlt;
		
	}	
	return true;
}

function update_visibility(){
	rdc = document.form.ss_redchn_dns_china.value;
	rdf = document.form.ss_redchn_dns_foreign.value;
	rs = document.form.ss_redchn_sstunnel.value
	rcc = document.form.ss_redchn_chinadns_china.value
	rcf = document.form.ss_redchn_chinadns_foreign.value
	showhide("show_isp_dns", (rdc == "1"));
	showhide("ss_redchn_dns_china_user", (rdc == "5"));
	showhide("ss_redchn_dns_china_user_txt1", (rdc !== "5"));
	showhide("ss_redchn_dns_china_user_txt2", (rdc == "5"));
	showhide("ss_redchn_opendns", (rdf == "1"));
	showhide("ss_redchn_sstunnel", (rdf == "2"));
	showhide("chinadns_china", (rdf == "3"));
	showhide("chinadns_foreign", (rdf == "3"));
	showhide("ss_redchn_sstunnel_user", ((rdf == "2") && (rs == "4")));
	showhide("dns_plan_foreign1", (rdf == "1"));
	showhide("dns_plan_foreign2", ((rdf == "2") && (rs !== "4")));
	showhide("dns_plan_foreign3", ((rdf == "2") && (rs == "4")));
	showhide("ss_redchn_chinadns_china_user", (rcc == "4"));
	showhide("chinadns_china1", (rcc !== "4"));
	showhide("chinadns_china2", (rcc == "4"));
	showhide("ss_redchn_chinadns_foreign_user", (rcf == "4"));
	showhide("chinadns_foreign1", (rcf !== "4"));
	showhide("chinadns_foreign2", (rcf == "4"));
	showhide("ss_redchn_dns2socks_user", (rdf == "4"));
	showhide("dns_plan_foreign0", (rdf == "4"));
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
	<input type="hidden" name="current_page" value="Main_SsAuto_Content.asp">
	<input type="hidden" name="next_page" value="Main_SsAuto_Content.asp">
	<input type="hidden" name="group_id" value="">
	<input type="hidden" name="modified" value="0">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="action_wait" value="8">
	<input type="hidden" name="first_time" value="">
	<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="1" />
	<input type="hidden" id="ss_basic_mode" name="ss_basic_mode" value="2" />
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div></td>
			<td valign="top"><div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Redsocks2 - 大陆白名单模式设置</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote"><i>说明：</i>此页面是为高级用户准备，若小白不懂，请勿随意选择和输入。</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">域名解析高级设置</td>
											</tr>
											</thead>
											<tr id="dns_plan_china">
												<th width="20%">选择国内DNS</th>
												<td>
													<select id="ss_redchn_dns_china" name="ss_redchn_dns_china" class="input_option" onclick="update_visibility();" >
														<option value="1">运营商DNS【自动获取】</option>
														<option value="2">阿里DNS1【223.5.5.5】</option>
														<option value="3">阿里DNS2【223.6.6.6】</option>
														<option value="4">114DNS【114.114.114.114】</option>
														<option value="6">百度DNS【180.76.76.76】</option>
														<option value="7">cnnic DNS【1.2.4.8】</option>
														<option value="8">dnspod DNS【119.29.29.29】</option>
														<option value="5">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_redchn_dns_china_user" name="ss_redchn_dns_china_user" maxlength="100" value="">
													<span id="show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
													<span id="ss_redchn_dns_china_user_txt1">默认：运营商DNS【用于解析国内6000+个域名】</span>
													<span id="ss_redchn_dns_china_user_txt2">确保你自定义输入的国内DNS在chnroute中</span>
												</td>
											</tr>
											<tr id="dns_plan_foreign">
												<th width="20%">选择国外DNS</th>
												<td>
													<select id="ss_redchn_dns_foreign" name="ss_redchn_dns_foreign" class="input_option" onclick="update_visibility();" >
														<option value="4">DNS2SOCKS</option>
														<option value="1">dnscrypt-proxy</option>
														<option value="2">ss-tunnel</option>
														<option value="3">ChinaDNS</option>
													</select>
													<select id="ss_redchn_opendns" name="ss_redchn_opendns" class="input_option">
														<option value="opendns">OpenDNS1</option>
														<option value="cisco-familyshield">OpenDNS2</option>
														<option value="cisco-port53">OpenDNS3</option>
														<option value="cloudns-can">cloudns-can</option>
														<option value="cloudns-syd">cloudns-syd</option>
														<option value="d0wn-sg-ns1">d0wn-sg-ns1</option>
														<option value="ipredator">ipredator</option>
														<option value="okturtles">okturtles</option>
														<option value="opennic-fvz-rec-hk-nt-01">opennic-hk</option>
														<option value="opennic-fvz-rec-jp-tk-01">opennic-jp</option>
														<option value="opennic-fvz-rec-sg-ea-01">opennic-sg</option>
														<option value="ovpnto-lat">ovpnto-lat</option>
														<option value="ovpnto-ro">ovpnto-ro</option>
														<option value="ovpnto-se">ovpnto-se</option>
														<option value="soltysiak">soltysiak</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_redchn_dns2socks_user" name="ss_redchn_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
													<select id="ss_redchn_sstunnel" name="ss_redchn_sstunnel" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Goole DNS1 [8.8.8.8]</option>
														<option value="3">Goole DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_redchn_sstunnel_user" name="ss_redchn_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													<br/>
													<span id="dns_plan_foreign0">默认：DNS2SOCKS，用以解析国内6000+域名以外的国内域名和国外域名</span>
													<span id="dns_plan_foreign1">用dnscrypt-proxy解析国内6000+域名以外的国内域名和国外域名</span>
													<span id="dns_plan_foreign2">选择由ss-tunnel通过udp转发给SS服务器解析的DNS，默认【Goole DNS1】<br/>！！ss-tunnel需要ss账号支持udp转发才能使用！！</span>
													<span id="dns_plan_foreign3">在上面自定义由ss-tunnel通过udp转发给SS服务器解析的DNS</span>
												</td>
											</tr>
											<tr id="chinadns_china">
												<th width="20%">ChinaDNS国内DNS</th>
												<td>
													<select id="ss_redchn_chinadns_china" name="ss_redchn_chinadns_china" class="input_option" onclick="update_visibility();" >
														<option value="1">阿里DNS1【223.5.5.5】</option>
														<option value="2">阿里DNS2【223.6.6.6】</option>
														<option value="3">114DNS【114.114.114.114】</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_china_user" name="ss_redchn_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													<br/>
													<span id="chinadns_china1">默认：阿里DNS1【用于解析国内6000+个域名以外的域名】</span>
													<span id="chinadns_china2">自定义国内DNS【用于解析国内6000+个域名以外的域名】</span>
												</td>
											</tr>
											<tr id="chinadns_foreign">
												<th width="20%">ChinaDNS国外DNS</th>
												<td>
													<select id="ss_redchn_chinadns_foreign" name="ss_redchn_chinadns_foreign" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Google DNS1 [8.8.8.8]</option>
														<option value="3">Google DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_foreign_user" name="ss_redchn_chinadns_foreign_user" maxlength="100" value="">
													<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> <br/>
													<span id="chinadns_foreign1">默认：Google DNS1【用于解析国外域名】<br/>！！ss-tunnel需要ss账号支持udp转发才能使用！！</span> <span id="chinadns_foreign2">右侧输入框输入自定义国外【用于解析国外域名】</span>
												</td>
											</tr>
											<tr>
												<th width="20%">自定义需要CDN加速网站
													<br/>
													<br/>
													<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/cdn.txt" target="_blank"><font color="#ffcc00"><u>查看默认添加的<% nvram_get("cdn_numbers"); %>条国内域名</u></font></a>
												</th>
												<td>
													<textarea placeholder="# 填入需要强制用国内DNS解析的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经添加了1万多条国内域名，请勿重复添加！
# 注意：不支持通配符！" cols="50" rows="8" id="ss_redchn_isp_website_web" name="ss_redchn_isp_website_web" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
										</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">白名单控制</td>
											</tr>
											</thead>
											<tr>
												<th width="20%">IP白名单<br>
													<br>
													<font color="#ffcc00">添加不需要走代理的外网ip地址</font>
												</th>
												<td>
													<textarea placeholder="# 填入不需要走代理的外网ip地址，一行一个，格式（IP/CIDR）如下
2.2.2.2
3.3.3.3
4.4.4.4/24
# 因为默认大陆的ip都不会走SS，所以此处填入国外IP/CIDR更有意义！" cols="50" rows="8" id="ss_redchn_wan_white_ip" name="ss_redchn_wan_white_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
											<tr>
												<th width="20%">域名白名单<br>
													<br>
													<font color="#ffcc00">添加不需要走代理的域名</font>
												</th>
												<td>
													<textarea placeholder="# 填入不需要走代理的域名，一行一个，格式如下：
google.com
facebook.com
# 因为默认大陆的ip都不会走SS，所以此处填入国外域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="8" id="ss_redchn_wan_white_domain" name="ss_redchn_wan_white_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
										</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">黑名单控制</td>
											</tr>
											</thead>
											<tr>
												<th width="20%">IP黑名单<br>
													<br>
													<font color="#ffcc00">添加需要强制走代理的外网ip地址</font>
												</th>
												<td>
													<textarea placeholder="# 填入需要强制走代理的外网ip地址，一行一个，格式（IP/CIDR）如下：
5.5.5.5
6.6.6.6
7.7.7.7/8
# 因为默认大陆以外ip都会走SS，所以此处填入国内IP/CIDR更有意义！" cols="50" rows="8" id="ss_redchn_wan_black_ip" name="ss_redchn_wan_black_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
											<tr>
												<th width="20%">域名黑名单<br>
													<br>
													<font color="#ffcc00">添加需要强制走代理的域名</font>
												</th>
												<td>
													<textarea placeholder="# 填入需要强制走代理的域名，一行一个，格式如下：
baidu.com
taobao.com
# 因为默认大陆以外的ip都会走SS，所以此处填入国内域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="8" id="ss_redchn_wan_black_domain" name="ss_redchn_wan_black_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
										</table>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">自定义dnsmasq</td>
											</tr>
											</thead>
											<tr>
											<th width="20%">自定义dnsmasq</th>
												<td>
													<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="ss_redchn_dnsmasq" name="ss_redchn_dnsmasq" title=""></textarea>
												</td>
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
									<h3>选择国内DNS：</h3>
									<p>将用此处定义的国内DNS解析国内6000+个域名，你可以到 <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"><font color="#ffcc00"><u>github.com/koolshare/koolshare.github.io</u></font></a> 参与维护这个列表。</p>
									<h3>选择国外DNS：</h3>
									<p> 这里你需要先选择用于DNS解析的程序，再由选择程序中定义的DNS解析gfwlist中的网址名单。</p>
									<blockquote>
									<h4>● DNS2SOCKS </h4>
									<p> 作用是将 DNS请求通过一个SOCKS隧道转发到DNS服务器，和下文中ss-tunnel类似，不过DNS2SOCKS是利用了SOCK5隧道代理，ss-tunnel是利用了加密UDP；该DNS方案不受到ss服务是否支持udp限制，不受到运营商是否封Opendns限制，只要能建立socoks5链接，就能使用。</p>
									<h4>● dnscrypt-proxy </h4>
									<p> 原理是通过加密连接到支持该程序的国外DNS服务器，由这些DNS服务器解析出gfwlist中域名的IP地址，但是解析出的IP地址离SS服务器的距离随机，国外CDN较弱。</p>
									<h4>● ss-tunnel </h4>
									<p> 原理是将DNS请求，通过ss-tunnel利用UDP发送到ss服务器上，由ss服务器向你定义的DNS服务器发送解析请求，解析出gfwlist中域名的IP地址，这种方式解析出来的IP地址会距离ss服务器更近，具有较强的CDN效果</p>
									<p> 若果你的账号不支持UDP转发，默认提供OpenDNS方式，请保留默认选项即可。</p>
									<h4>● ChinaDNS </h4>
									<p>原理是通过DNS并发查询，同时将你要请求的域名同时向国内和国外DNS发起查询，然后用ChinaDNS内置的双向过滤+指针压缩功能来过滤掉污染ip，双向过滤保证了国内地址都用国内域名查询，因此使用ChinaDNS能够获得最佳的国内CDN效果，这里ChinaDNS国内服务器的选择是有要求的，这个DNS的ip地址必须在chnroute定义的IP段内，同理你选择或者自定义的国外DNS必须在chnroute定义的IP段外，所以比如你在国内DNS处填写你的上级路由器的ip地址，类似192.168.1.1这种，会被ChinaDNS判断为国外IP地址,从而使得双向过滤功能失效，国外DNS解析的IP地址就会进入DNS缓存。</p>
									</blockquote>
									<h3>自定义需要CDN加速网站</h3>
									<p> 如果你访问国内网站速度过慢，可以将网址加入此栏，将使用你上面选择的DNS对这些域名进行解析。此处加入的DNS会强制使用你选择的国内DNS进行解析，我已经预定义了6000+个国内域名，强制使用国内DNS来进行解析，如果你要添加自己定义的，那么你可以到<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/cdn.txt" target="_blank"><font color="#ffcc00"><u> https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/cdn.txt </u></font></a>去查看你要添加的是否已经默认添加过了，同时也欢迎你在项目里提交你自己的cdn站点文件。</p>
									<h3>外网黑名单：</h3>
									<p> 添加不需要走代理的外网ip地址或ip地址段，因为已经默认已经排除了中国大陆网段，所以此处建议添加国外ip，添加同样用英文","隔开各个IP地址。</p>
									<h3>外网白名单：</h3>
									<p> 添加需要强制走代理的外网ip地址或ip地址段，因为已经排除了国外网段，所以此处建议添加国内ip。</p>
									</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="KoolshareBottom">论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
									博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
									Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
									Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> </a>, Web by： <i>Xiaobao</i> </div></td>
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

