<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Shadowsocks - 游戏模式</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
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
#ss_game_dnsmasq::-webkit-input-placeholder::before {
    color:#999;
    content:"# 此处填入需要指定解析地址的域名，一行一个，格式如下：\A address=/koolshare.cn/2.2.2.2\A address=/baidu.com/3.3.3.3\A ";
    address=/example1.com/2.2.2.2,address=/example2.com/3.3.3.3
}
</style>
<script>
var socks5 = 0;
var $j = jQuery.noConflict();
var $G = function (id) {
	return document.getElementById(id);
};
String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}

function init(){
	show_menu(menu_hook);
	generate_options();
	conf_to_obj();
	update_visibility();
	show_develop_function();
}

function onSubmitCtrl(o, s) {
	if(validForm()){
		showSSLoadingBar(25);
		document.form.action_mode.value = s;
		updateOptions();
	}
}

function done_validating(action){
	return true;
}

function conf_to_obj(){
	if(typeof db_ss != "undefined") {
		for(var field in db_ss) {
			var el = document.getElementById(field);
			if(el != null) {
				el.value = db_ss[field];
			}
			var temp_ss = ["ss_game_dnsmasq"];
			for (var i = 0; i < temp_ss.length; i++) {
				temp_str = $G(temp_ss[i]).value;
				$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
			}
		}
	} else {
		document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
	}
}

function updateOptions(){
	document.form.enctype = "";
	document.form.encoding = "";
	document.form.action = "/applydb.cgi?p=ss_game_";
	document.form.SystemCmd.value = "ss_config.sh";
	document.form.submit();
}

function validForm(){
	var temp_ss = ["ss_game_dnsmasq"];
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
	if(rlt.length > 100000) {
		alert(temp_ss[i] + " 不能超过100000个字符");
		return false;
	}
		$G(temp_ss[i]).value = rlt;
	}
	return true;
}

function update_visibility(){
	gdc = document.form.ss_game_dns_china.value;
	gdf = document.form.ss_game_dns_foreign.value;
	gs = document.form.ss_game_sstunnel.value
	gcc = document.form.ss_game_chinadns_china.value
	gcf = document.form.ss_game_chinadns_foreign.value
	grpm= document.form.ss_game_pdnsd_method.value
	showhide("show_isp_dns", (gdc == "1"));
	showhide("ss_game_dns_china_user", (gdc == "5"));
	showhide("ss_game_dns_china_user_txt1", (gdc !== "5"));
	showhide("ss_game_dns_china_user_txt2", (gdc == "5"));
	showhide("ss_game_opendns", (gdf == "1"));
	showhide("ss_game_sstunnel", (gdf == "2"));
	showhide("chinadns_china", (gdf == "3"));
	showhide("chinadns_foreign", (gdf == "3"));
	showhide("ss_game_sstunnel_user", ((gdf == "2") && (gs == "4")));
	showhide("dns_plan_foreign1", (gdf == "1"));
	showhide("dns_plan_foreign2", ((gdf == "2") && (gs !== "4")));
	showhide("dns_plan_foreign3", ((gdf == "2") && (gs == "4")));
	showhide("ss_game_chinadns_china_user", (gcc == "4"));
	showhide("chinadns_china1", (gcc !== "4"));
	showhide("chinadns_china2", (gcc == "4"));
	showhide("ss_game_chinadns_foreign_user", (gcf == "4"));
	showhide("chinadns_foreign1", (gcf !== "4"));
	showhide("chinadns_foreign2", (gcf == "4"));
	showhide("ss_game_dns2socks_user", (gdf == "4"));
	showhide("dns_plan_foreign0", (gdf == "4"));
	showhide("pdnsd_up_stream_tcp", (gdf == "6" && grpm == "2"));
	showhide("pdnsd_up_stream_udp", (gdf == "6" && grpm == "1"));
	showhide("ss_game_pdnsd_udp_server_dns2socks", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 1));
	showhide("ss_game_pdnsd_udp_server_dnscrypt", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 2));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel_user", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3 && document.form.ss_game_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("pdnsd_cache", (gdf == "6"));
	showhide("pdnsd_method", (gdf == "6"));
}

function generate_options(){
	var confs = ["4armed",  "cisco(opendns)",  "cisco-familyshield",  "cisco-ipv6",  "cisco-port53",  "cloudns-can",  "cloudns-syd",  "cs-cawest",  "cs-cfi",  "cs-cfii",  "cs-ch",  "cs-de",  "cs-fr",  "cs-fr2",  "cs-rome",  "cs-useast",  "cs-usnorth",  "cs-ussouth",  "cs-ussouth2",  "cs-uswest",  "cs-uswest2",  "d0wn-bg-ns1",  "d0wn-ch-ns1",  "d0wn-de-ns1",  "d0wn-fr-ns2",  "d0wn-gr-ns1",  "d0wn-hk-ns1",  "d0wn-it-ns1",  "d0wn-lv-ns1",  "d0wn-nl-ns1",  "d0wn-nl-ns2",  "d0wn-random-ns1",  "d0wn-random-ns2",  "d0wn-ro-ns1",  "d0wn-ru-ns1",  "d0wn-tz-ns1",  "d0wn-ua-ns1",  "dnscrypt.eu-dk",  "dnscrypt.eu-dk-ipv6",  "dnscrypt.eu-nl",  "dnscrypt.eu-nl-ipv6",  "dnscrypt.org-fr",  "fvz-rec-at-vie-01",  "fvz-rec-ca-tor-01",  "fvz-rec-ca-tor-01-ipv6",  "fvz-rec-de-fra-01",  "fvz-rec-gb-brs-01",  "fvz-rec-gb-lon-01",  "fvz-rec-gb-lon-03",  "fvz-rec-hk-ztw-01",  "fvz-rec-ie-du-01",  "fvz-rec-no-osl-01",  "fvz-rec-nz-akl-01",  "fvz-rec-nz-akl-01-ipv6",  "fvz-rec-us-ler-01",  "fvz-rec-us-mia-01",  "ipredator",  "ns0.dnscrypt.is",  "okturtles",  "opennic-tumabox",  "ovpnto-ro",  "ovpnto-se",  "ovpnto-se-ipv6",  "shea-us-noads",  "shea-us-noads-ipv6",  "soltysiak",  "soltysiak-ipv6",  "yandex"];
	var obj=document.getElementById('ss_game_opendns'); 
	var obj1=document.getElementById('ss_game_pdnsd_udp_server_dnscrypt'); 
	for(var i = 0; i < confs.length; i++) {
		obj.options.add(new Option(confs[i],confs[i]));
		obj1.options.add(new Option(confs[i],confs[i]));
	}
}

function show_develop_function(){
	if (db_ss['ss_basic_user'] == undefined){
		var obj2=document.getElementById('ss_game_dns_foreign');
    	obj2.options.remove(5);
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
<form method="post" name="form" action="/applydb.cgi?p=ss_game_" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_SsGame_Content.asp"/>
<input type="hidden" name="next_page" value="Main_SsGame_Content.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="8"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="1" />
<input type="hidden" id="ss_basic_mode" name="ss_basic_mode" value="3" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value=""/>
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
									<div class="formfonttitle">Shadowsocks - 游戏模式</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="SimpleNote"><i>说明：</i>当你在基本设置中选择了<i>游戏模式</i>，你可以在此页面进行高级设置。</br>请务必确认你的shadowsocks账号支持<i>UDP转发</i>，如果你的账号不支持UDP转发启用了该模式，所有连接国外的UDP链接都将失效。</br>如果你需要实现<b>NAT2</b>，请配置python版本的shadowsocks服务端，版本号需大于或等于2.6.11</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<table id="ss_game_table"width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">Shadowsocks - 游戏模式 - 高级设置</td>
											</tr>
											</thead>
											<tr id="dns_plan_china">
											<th width="20%">选择国内DNS</th>
												<td>
													<select id="ss_game_dns_china" name="ss_game_dns_china" class="input_option" onclick="update_visibility();" >
														<option value="1">运营商DNS【自动获取】</option>
														<option value="2">阿里DNS1【223.5.5.5】</option>
														<option value="3">阿里DNS2【223.6.6.6】</option>
														<option value="4">114DNS【114.114.114.114】</option>
														<option value="6">百度DNS【180.76.76.76】</option>
														<option value="7">cnnic DNS【1.2.4.8】</option>
														<option value="8">dnspod DNS【119.29.29.29】</option>
														<option value="5">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_dns_china_user" name="ss_game_dns_china_user" maxlength="100" value=""></input>
													<span id="show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
													<span id="ss_game_dns_china_user_txt1">默认：运营商DNS【用于解析国内6000+个域名】</span> 
													<span id="ss_game_dns_china_user_txt2">确保你自定义输入的国内DNS在chnroute中</span>
												</td>
											</tr>
											<tr id="dns_plan_foreign">
											<th width="20%">选择国外DNS</th>
												<td>
													<select id="ss_game_dns_foreign" name="ss_game_dns_foreign" class="input_option" onclick="update_visibility();" >
														<option value="4">DNS2SOCKS</option>
														<option value="1">dnscrypt-proxy</option>
														<option value="2">ss-tunnel</option>
														<option value="3">ChinaDNS（CDN最优）</option>
														<option value="5">PcapDNSProxy</option>
														<option value="6">pdnsd</option>
													</select>
													<select id="ss_game_opendns" name="ss_game_opendns" class="input_option"></select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_dns2socks_user" name="ss_game_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
													<select id="ss_game_sstunnel" name="ss_game_sstunnel" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Goole DNS1 [8.8.8.8]</option>
														<option value="3">Goole DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_sstunnel_user" name="ss_game_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													<br/>
														<span id="dns_plan_foreign0">默认：DNS2SOCKS，用以解析国内6000+域名以外的国内域名和国外域名</span>
														<span id="dns_plan_foreign1">用dnscrypt-proxy解析国内6000+域名以外的国内域名和国外域名</span>
														<span id="dns_plan_foreign2">选择由ss-tunnel通过udp转发给SS服务器解析的DNS，默认【Goole DNS1】</span>
														<span id="dns_plan_foreign3">在上面自定义由ss-tunnel通过udp转发给SS服务器解析的DNS</span>
												</td>
											</tr>
											<tr id="chinadns_china">
											<th width="20%">ChinaDNS国内DNS</th>
												<td>
													<select id="ss_game_chinadns_china" name="ss_game_chinadns_china" class="input_option" onclick="update_visibility();" >
														<option value="1">阿里DNS1【223.5.5.5】</option>
														<option value="2">阿里DNS2【223.6.6.6】</option>
														<option value="3">114DNS【114.114.114.114】</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_china_user" name="ss_game_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													<br/>
														<span id="chinadns_china1">默认：阿里DNS1【用于解析国内6000+个域名以外的域名】</span> <span id="chinadns_china2">自定义国内DNS【用于解析国内6000+个域名以外的域名】</span>
												</td>
											</tr>
											<tr id="chinadns_foreign">
											<th width="20%">ChinaDNS国外DNS</th>
												<td>
													<select id="ss_game_chinadns_foreign" name="ss_game_chinadns_foreign" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Google DNS1 [8.8.8.8]</option>
														<option value="3">Google DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_foreign_user" name="ss_game_chinadns_foreign_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
														<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> 
														<br/>
														<span id="chinadns_foreign1">默认：Google DNS1【用于解析国外域名】</span> <span id="chinadns_foreign2">右侧输入框输入自定义国外【用于解析国外域名】</span>
												</td>
											</tr>
											<tr id="pdnsd_method">
												<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
												<td>
													<select id="ss_game_pdnsd_method" name="ss_game_pdnsd_method" class="input_option" onclick="update_visibility();" >
														<option value="1" selected >仅udp查询</option>
														<option value="2">仅tcp查询</option>
													</select>
												</td>
											</tr>
											<tr id="pdnsd_up_stream_tcp">
												<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
												<td>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_ip" name="ss_game_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
													：
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_port" name="ss_game_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
													
													<span id="pdnsd1">请填写支持TCP查询的DNS服务器</span>
												</td>
											</tr>
											<tr id="pdnsd_up_stream_udp">
												<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
												<td>
													<select id="ss_game_pdnsd_udp_server" name="ss_game_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
														<option value="1">DNS2SOCKS</option>
														<option value="2">dnscrypt-proxy</option>
														<option value="3">ss-tunnel</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_dns2socks" name="ss_game_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
													<select id="ss_game_pdnsd_udp_server_dnscrypt" name="ss_game_pdnsd_udp_server_dnscrypt" class="input_option"></select>
													<select id="ss_game_pdnsd_udp_server_ss_tunnel" name="ss_game_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Goole DNS1 [8.8.8.8]</option>
														<option value="3">Goole DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_ss_tunnel_user" name="ss_game_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
												</td>
											</tr>
											<tr id="pdnsd_cache">
												<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
												<td>
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_min" name="ss_game_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
													→
													<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_max" name="ss_game_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
													
													<span id="pdnsd1">填写最小TTL时间与最长TTL时间</span>
												</td>
											</tr>
											<tr>
											<th width="20%">自定义dnsmasq</th>
												<td>
													<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_game_dnsmasq" name="ss_game_dnsmasq" title=""></textarea>
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
										<h2>特别注意事项</h2>
										<p>游戏模式支持UDP代理且能实现NAT2，但是你必须确保你的SS服务器端是python版本的<a href="https://github.com/shadowsocks/shadowsocks" target="_blank"><i><u>Shadowsocks</u></i></a></p>
										<p>版本号必须大于或等于 2.6.11；如果低于此版本，你将获得NAT3。</p>
										<h2>游戏模式介绍</h2>
										<p><i>● </i>喜欢玩游戏的朋友有福了，该游戏模式能将到国外服务器的连接转到shadowsocks代理，并同时支持TCP和UDP，使用该模式时，所有到国外的地址（chnroue外）的TCP+UDP都会经过shadowsocks，而国内的地址仍然走国内。而且，你的NAT类型会成为NAT2，不管你是否是大内网IP。</p>
										<p> <i>● </i>如果你是主机玩家，并在该模式下载游戏，那么如果下载服务器是国外的，你也能通过ss加速，前提是你有一个速度非常快的ss账号，如果你ss账号流量有限，不想让游戏下载经过ss，那么推荐你在下载游戏的时候使用gfwlist模式，gfwlist的黑名单都是针对被墙域名设计，游戏服务器不会在此列表中，所以用gfwlist模式下载游戏是走国内直连。</p>
										<p> <i>● </i>虽然此处提供了自定义dnsmasq功能，但是不是很建议建议你将你从网上得到的游戏加速dnsmasq填入其中，网上爱好者整理的dnsmasq列表是针对国内直连下载加速的，不过如果你对你的ss服务器有自信，那么你也可以设置，因为这些dnsmasq地址都是国外地址，用ss下载应该也能达到加速的目的。</p>
										<p> <i>● </i>游戏模式提供了丰富的DNS设置选项，你可以花点时间研究下，获得最佳的解析效果，主机游戏玩家可以通过优化国外DNS获得离ss服务器较近的游戏服务器，从而获得最佳的游戏体验。</p>
										<p> <i>● </i>如果你玩steam游戏，例如dota2外服，因为dota2在启动客户端时是走tcp连接的，所以在连接国外游戏服务器的时候，会经过shadowsocks代理，而匹配成功后，客户端会以UDP连接的方式和国外服务器持续沟通，这些UDP流量也会经过shadowsocks代理；而当你切换回国服时，即使你还处在游戏模式，到服务器的TCP+UDP链接将直接链接而不是经过shadowsocks。</p>
										<p> <i>● </i>要实现上面这些，你需要所要做的就是准备一个低延迟的并且支持UDP转发的shadowsocks账号。</p>
										<h2>功能介绍：</h2>
										<h3>选择国内DNS：</h3>
										<p>将用此处定义的国内DNS解析国内6000+个域名，你可以到 <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"><i><u>github.com/koolshare/koolshare.github.io</u></i></a> 参与维护这个列表。</p>
										<h3> 选择国外DNS：</h3>
										<p>这里你需要先选择用于DNS解析的程序，再由选择程序中定义的DNSDNS解析gfwlist中的网址名单。</p>
										<blockquote>
										<h4>● DNS2SOCKS </h4>
										<p> 作用是将 DNS请求通过一个SOCKS隧道转发到DNS服务器，和下文中ss-tunnel类似，不过DNS2SOCKS是利用了SOCK5隧道代理，ss-tunnel是利用了加密UDP；该DNS方案不受到ss服务是否支持udp限制，不受到运营商是否封Opendns限制，只要能建立socoks5链接，就能使用。</p>
										<h4>● dnscrypt-proxy </h4>
										<p> 原理是通过加密连接到支持该程序的国外DNS服务器，由这些DNS服务器解析出gfwlist中域名的IP地址，但是解析出的IP地址离SS服务器的距离随机，国外CDN较弱。</p>
										<p>
										<h4>● ss-tunnel </h4>
										</p>
										<p> 原理是将DNS请求，通过ss-tunnel利用UDP发送到ss服务器上，由ss服务器向你定义的DNS服务器发送解析请求，解析出gfwlist中域名的IP地址，这种方式解析出来的IP地址会距离ss服务器更近，具有较强的CDN效果。如果你的账号不支持UDP转发，默认提供OpenDNS方式，请保留默认选项即可。</p>
										<h4> ● ChinaDNS</h4>
										<p>原理是通过DNS并发查询，同时将你要请求的域名同时向国内和国外DNS发起查询，然后用ChinaDNS内置的双向过滤+指针压缩功能来过滤掉污染ip，双向过滤保证了国内地址都用国内域名查询，因此使用ChinaDNS能够获得最佳的国内CDN效果，这里ChinaDNS国内服务器的选择是有要求的，这个DNS的ip地址必须在chnroute定义的IP段内，同理你选择或者自定义的国外DNS必须在chnroute定义的IP段外，所以比如你在国内DNS处填写你的上级路由器的ip地址，类似192.168.1.1这种，会被ChinaDNS判断为国外IP地址,从而使得双向过滤功能失效，国外DNS解析的IP地址就会进入DNS缓存。</p>
										</blockquote>
										<h3> 自定义dnsmasq：</h3>
										<p>此处你将能够添加你自定义的dnsmasq，格式参照已经添加的例子。 </p>
									</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="KoolshareBottom">论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
									博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
									Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
									Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> </a>, Web by： <i>Xiaobao</i> </div>
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

