<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Shadowsocks - gfwlist模式</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css"/>
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
#ss_ipset_black_domain_web::-webkit-input-placeholder::before {
    color:#999;
    content:"# 此处填入需要强制走ss的域名，一行一个，格式如下：\A koolshare.cn\A baidu.cn\A # 默认已经由gfwlist提供了上千条被墙域名，请勿重复添加!\A";
}
#ss_ipset_address::-webkit-input-placeholder::before {
    color:#999;
    content:"# 此处填入需要指定解析地址的域名，一行一个，格式如下：\A address=/koolshare.cn/2.2.2.2\A address=/baidu.com/3.3.3.3\A ";
    address=/example1.com/2.2.2.2,address=/example2.com/3.3.3.3
}
</style>
<script>
var socks5 = 0
var $j = jQuery.noConflict();
var $G = function (id) {
	return document.getElementById(id);
};
	
function onSubmitCtrl(o, s) {
	if(validForm() && validForm2()){
		showSSLoadingBar(10);
		document.form.action_mode.value = s;
		updateOptions();
	}
}

function done_validating(action){
	return true;
}

String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}
function init(){
	show_menu(menu_hook);
	conf_to_obj();
	update_visibility()
}

function conf_to_obj(){
	if(typeof db_ss != "undefined") {
		for(var field in db_ss) {
			var el = document.getElementById(field);
			if(el != null) {
				el.value = db_ss[field];
			}
		}
		var temp_ss = ["ss_ipset_black_domain_web"];
		for (var i = 0; i < temp_ss.length; i++) {
			temp_str = $G(temp_ss[i]).value;
			$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
		}
		var temp_ss2 = ["ss_ipset_address"];
		for (var j = 0; j < temp_ss2.length; j++) {
			temp_str2 = $G(temp_ss2[j]).value;
			$G(temp_ss2[j]).value = temp_str2.replaceAll(",","\n");
		}
	} else {
		document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
	}
}

function updateOptions(){
	document.form.enctype = "";
	document.form.encoding = "";
	document.form.action = "/applydb.cgi?p=ss_ipset_";
	document.form.SystemCmd.value = "ssconfig ipset";
	document.form.submit();
}

function validForm(){
	var temp_ss = ["ss_ipset_black_domain_web"];
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

function validForm2(){
	var temp_ss = ["ss_ipset_address"];
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

function update_visibility() {
    icd = document.form.ss_ipset_cdn_dns.value;
    ifd = document.form.ss_ipset_foreign_dns.value;
    it = document.form.ss_ipset_tunnel.value;
    showhide("ss_ipset_cdn_dns_user", (icd == "5"));
    showhide("china_dns1", (icd !== "5"));
    showhide("ss_ipset_opendns", (ifd == "0"));
    showhide("ss_ipset_foreign_dns1", (ifd == "2"));
    showhide("ss_ipset_foreign_dns2", (ifd == "0"));
    showhide("ss_ipset_tunnel", (ifd == "1"));
    showhide("ss_ipset_foreign_dns3", (ifd == "1"));
    showhide("ss_ipset_tunnel_user", ((ifd == "1") && (it == "4")));
    showhide("ss_ipset_dns2socks_user", (ifd == "2"));
    showhide("DNS2SOCKS1", (ifd == "2"));
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
<input type="hidden" name="current_page" value="Main_SsIpset_Content.asp">
<input type="hidden" name="next_page" value="Main_SsIpset_Content.asp">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="8">
<input type="hidden" name="first_time" value="">
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="1" />
<input type="hidden" id="ss_basic_mode" name="ss_basic_mode" value="1" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
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
								<td bgcolor="#4D595D" colspan="3" valign="top"><div>&nbsp;</div>
									<div class="formfonttitle">Shadowsocks - Gfwlist模式</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="SimpleNote"><i>说明：</i>当你在基本设置中选择了<font color="#ffcc00">【Gfwlist模式】</font>，你可以在此页面进行高级设置。</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">Shadowsocks - ipset - 高级设置</td>
											</tr>
											</thead>
											<tr>
												<th id="china_dns" width="20%">选择国内DNS</th>
												<td>
													<select id="ss_ipset_cdn_dns" name="ss_ipset_cdn_dns" class="input_option" onclick="update_visibility();" >
														<option value="1">运营商DNS【自动获取】</option>
														<option value="2">阿里DNS1【223.5.5.5】</option>
														<option value="3">阿里DNS2【223.6.6.6】</option>
														<option value="4">114DNS【114.114.114.114】</option>
														<option value="6">百度DNS【180.76.76.76】</option>
														<option value="7">cnnic DNS【1.2.4.8】</option>
														<option value="8">dnspod DNS【119.29.29.29】</option>
														<option value="5">自定义</option>
													</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_cdn_dns_user" name="ss_ipset_cdn_dns_user" maxlength="100" value="">
														<span id="china_dns1">默认：运营商DNS【自动获取】</span>
														<br/>
														<span id="china_dns1">选择国内DNS解析gfwlist之外的域名</span>
												</td>
											</tr>
											<tr>
												<th width="20%">选择国外DNS</th>
												<td>
													<select id="ss_ipset_foreign_dns" name="ss_ipset_foreign_dns" class="input_option" onclick="update_visibility();" >
														<option value="2">DNS2SOCKS</option>
														<option value="0">dnscrypt-proxy</option>
														<option value="1">ss-tunnel</option>
														<option value="3">Pcap_DNSProxy</option>
													</select>
													<select id="ss_ipset_opendns" name="ss_ipset_opendns" class="input_option">
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
													<select id="ss_ipset_tunnel" name="ss_ipset_tunnel" class="input_option" onclick="update_visibility();" >
														<option value="1">OpenDNS [208.67.220.220]</option>
														<option value="2">Goole DNS1 [8.8.8.8]</option>
														<option value="3">Goole DNS2 [8.8.4.4]</option>
														<option value="4">自定义</option>
													</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_tunnel_user" name="ss_ipset_tunnel_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_dns2socks_user" name="ss_ipset_dns2socks_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="8.8.8.8:53">
														<span id="ss_ipset_foreign_dns1">默认：DNS2SOCKS</span> <br/>
														<span id="DNS2SOCKS1">启用DNS2SOCKS后会自动开启SOCKS5</span>
														<span id="ss_ipset_foreign_dns2">用dnscrypt-proxy加密解析gfwlist中的<% nvram_get("ss_ipset_numbers"); %>条域名</span>
														<span id="ss_ipset_foreign_dns3">
															ss-tunnel通过udp转发将DNS交给SS服务器解析gfwlist中的<% nvram_get("ss_ipset_numbers"); %>条域名<br/>！！ss-tunnel需要ss账号支持udp转发才能使用！！
														</span>
												</td>
											</tr>
											<tr>
												<th width="20%">域名黑名单
													<br/>
													<br/>
													<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank">
														<u>查看默认添加的<% nvram_get("ss_ipset_numbers"); %>条域名黑名单(gfwlist)</u>
													</a>
												</th>
												<td>
													<textarea placeholder=" " rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_black_domain_web" name="ss_ipset_black_domain_web" title=""></textarea>
												</td>
											</tr>
											<tr>
												<th width="20%">自定义hosts</th>
												<td>
													<textarea placeholder=" " rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_address" name="ss_ipset_address" title=""></textarea>
												</td>
											</tr>
										</table>
									<div class="apply_gen">
										<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交" >
									</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="SimpleNote">
										<button onclick="openShutManager(this,'NoteBox',false,'点击关闭详细说明','点击查看详细说明') " class="NoteButton">点击查看详细说明</button>
									</div>
									<div id="NoteBox" style="display:none">
										<h3>选择国内DNS：</h3>
											<p>将用此处定义的国内DNS解析gfwlist以外的网址，包括全部国内网址和国外位被墙的网址。</p>
										<h3>选择国外DNS：</h3>
											<p>这里你需要先选择用于DNS解析的程序，再由选择程序中定义的DNSDNS解析gfwlist中的网址名单。</p>
										<blockquote>
										<h4>● DNS2SOCKS </h4>
											<p> 作用是将 DNS请求通过一个SOCKS隧道转发到DNS服务器，和下文中ss-tunnel类似，不过DNS2SOCKS是利用了SOCK5隧道代理，ss-tunnel是利用了加密UDP；该DNS方案不受到ss服务是否支持udp限制，不受到运营商是否封Opendns限制，只要能建立socoks5链接，就能使用。</p>
										<h4>● dnscrypt-proxy </h4>
											<p> 原理是通过加密连接到支持该程序的国外DNS服务器，由这些DNS服务器解析出gfwlist中域名的IP地址，但是解析出的IP地址离SS服务器的距离随机，国外CDN较弱。</p>
										<h4>● ss-tunnel </h4>
											<p> 原理是将DNS请求，通过ss-tunnel利用UDP发送到ss服务器上，由ss服务器向你定义的DNS服务器发送解析请求，解析出gfwlist中域名的IP地址，这种方式解析出来的IP地址会距离ss服务器更近，具有较强的CDN效果</p>
											<p> 若果你的账号不支持UDP转发，默认提供OpenDNS方式，请保留默认选项即可。</p>
										</blockquote>
										<h4> 当前gfwlist域名数量：</h4>
											<p>如果你使用本模式,那么这里会正确的显示当前已经被路由器使用的域名黑名单条目数量。</p>
										<h4> gfwlist自动更新：</h4>
											<p>更新文件托管在github上，默认每天凌晨4点会检测一次是否有更新，如果有更新，则会自动下载最新的gfwlist文件，并且自动重启ss服务器。</p>
											<p>同时也欢迎你到 <a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank"><i><u>https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf</u></i></a> 我们的维护项目中提交你的gfwlist名单。</p>
										<h3>域名黑名单：</h3>
											<p>在此处填入的域名将会被加入到gfwlist中，并且强制走ss流量，在自定义域名前你可以去我们的github项目中查看你要添加的域名是否已经被添加到gfwlist中。此处的添加格式请参照示例。</p>
										<h3> 自定义host：</h3>
											<p>指定的域名用指定的ip地址访问，比如能这个功能给你的PS4加速，而且当ip地址为127.0.0.1时，可以达到广告屏蔽的效果，格式见默认值。</p>
									</div>
									<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
									<div class="KoolshareBottom">
										论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
										博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
										Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
										Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> </a>, Web by： <i>Xiaobao</i>
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

