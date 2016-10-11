<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>shadowsocks - 账号信息配置</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/dbconf?p=ss&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>

<style>
.Bar_container {
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
#ss_node_edit {
	background: url(/images/New_ui/ss_list.png);
	background-position: 0px 0px;
	width: 30px;
	height: 35px;
}
.show-btn1, .show-btn2, .show-btn3, .show-btn4, .show-btn5, .show-btn6 {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #76a0ba  0%, #688292 100%); /* W3C */
	background: #576d73;
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.45601%;
}
.active {
	background: linear-gradient(to bottom, #61b5de  0%, #279fd9 100%); /* W3C */
	background: #2f3a3e;
}
input[type=button]:focus {
	outline: none;
}
.contentM_qis {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	z-index: 200;
	background-color:#2B373B;
	margin-left: 50px;
	top: 290px;
	width:650px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	display:none;
}


.QISform_wireless {
	width:600px;
	font-size:12px;
	color:#FFFFFF;
	margin-top:10px;
	*margin-left:10px;
}
.QISform_wireless thead {
	font-size:15px;
	line-height:20px;
	color:#FFFFFF;
}
.QISform_wireless th {
	padding-left:10px;
	*padding-left:30px;
	font-size:12px;
	font-weight:bolder;
	color: #FFFFFF;
	text-align:left;
}
.vpnClientTitle_td_unclick {
	background-color: #000;
	height: 30px;
	cursor: pointer;
	border: 1px solid #222;
}
.vpnClientTitle_td_click {
	background-color: #4D595D;
	height: 30px;
	cursor: pointer;
	border: 1px solid #222;
}

/* Oculta la scroll-bar pero sigue permitiendo hacer scroll con el </li> */
#ss_node_list_table_td { -ms-overflow-style: none; overflow: auto; } /* for IE hide scrollbar on ss node ta */
#ss_node_list_table_td::-webkit-scrollbar {
    width: 0px;  /* remove scrollbar space */
    background: transparent;  /* optional: just make scrollbar invisible */
}
.FormTable1{
	table-layout:fixed;
	width:748px;
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
	border: 1px solid #000000;
	border-collapse: collapse;
}
.FormTable1 th{
	table-layout:fixed;
	overflow:hidden;
	font-family:Arial, Helvetica, sans-serif;
	background-color:#1F2D35;
	color:#FFFFFF	;	/*Viz add*/
	font-weight:normal;
	text-align: center;
	line-height:15px;
	height: 30px;
	font-size:12px;
	padding-left: 5px;
	border: 1px solid #222;
	border-collapse: collapse;
	background:#2F3A3E;
}

.FormTable1 td{
	table-layout:fixed;
	overflow:hidden;
	height: 30px;
	padding-left: 5px;
	background-color:#475A5F;
	text-align: center;
	border: 1px solid #222;
	border-collapse: collapse;
	word-wrap:break-word;
}


.SimpleNote { padding:5px 10px;}
.KoolshareBottom {
    width: 230px;
    height: 100px;
    background: url(/images/New_ui/koolshare.png) 0px 3px no-repeat;
    text-align: left;
	padding-left:120px;
	margin-top:50px;
	float:right;
}
#iframe1{
   font-family: sans-serif;
   color: red;
}
.FormTable thead td{
	color: #FFF;
	font-size:12px;
	background-color:#4D595D;
	text-align:left;
	font-weight:bolder;
	border: 0px solid #222;
	padding: 3px;
	padding-left: 10px;
	border-collapse: collapse;
 	background: #92A0A5; /* Old browsers */
	background: -moz-linear-gradient(top, #92A0A5  0%, #66757C 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#92A0A5 ), color-stop(100%,#66757C)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #92A0A5  0%, #66757C 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #92A0A5 0%, #66757C 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #92A0A5  0%, #66757C 100%); /* IE10+ */
	background: linear-gradient(to bottom, #92A0A5  0%, #66757C 100%); /* W3C */
}
</style>
<script>
var socks5 = 0
var $j = jQuery.noConflict();
var over_var = 0;
var isMenuopen = 0;
var $G = function(id) {
    return document.getElementById(id);
};
String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}
var refreshRate = 5;
function init() {
    show_menu(menu_hook);
    version_show();
    buildswitch();
    //refresh_table();
    toggle_func();
    toggle_switch();
    detect_kcptun();
    refreshRate = getRefresh();
    for (var field in db_ss) {
        $j('#'+field).val(db_ss[field]);
    }
    if (typeof db_ss != "undefined") {
        update_ss_ui(db_ss);
        loadAllConfigs();
    } else {
        $G("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
    }
	var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_dnsmasq", "ss_redchn_wan_white_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_ip", "ss_redchn_wan_black_domain", "ss_basic_black_lan", "ss_basic_white_lan","ss_ipset_black_domain_web", "ss_ipset_white_domain_web", "ss_ipset_dnsmasq", "ss_ipset_black_ip", "ss_game_dnsmasq", "ss_gameV2_dnsmasq"];
	for (var i = 0; i < temp_ss.length; i++) {
		temp_str = $G(temp_ss[i]).value;
			$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
	}
    setTimeout("get_ss_status_data()", 1000);
    var jffs2_scripts = '<% nvram_get("jffs2_scripts"); %>';
	if(jffs2_scripts == "0"){
		$G("warn").style.display = "";
		$j("#warn").html("<i>发现Enable JFFS custom scripts and configs选项未开启！</br></br>请开启并重启路由器后才能正常使用SS。<a href='/Advanced_System_Content.asp'><em><u> 前往设置 </u></em></a> </i>");
		document.form.ss_basic_enable.value = 0;
		inputCtrl(document.form.switch,0);
	}
	var retArea = $G('log_content');
	retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
}

function detect_kcptun(){
    var kcptun_mode = '<% nvram_get("KCP_mode"); %>';
	if(kcptun_mode != "0" && kcptun_mode != ''){
		$G('ss_status1').style.display = "none";
		$G('tablet_show').style.display = "none";
		$G('basic_show').style.display = "none";
		$G('apply_button').style.display = "none";
		$G('warn1').style.display = "";
		document.form.ss_basic_enable.value = 0;
		inputCtrl(document.form.switch,0);
	}
}

function onSubmitCtrl() {
	ssmode = $G("ss_basic_mode").value;
	ssaction = $G("ss_basic_action").value;

    if (validForm()) {
        if (0 == node_global_max) {
            var obj = ssform2obj();
            ss_node_object("1", obj, true,
            function(a) {
			if(ssaction == 1){
				if (ssmode == "0"){
					showSSLoadingBar(4);
				} else {
					showSSLoadingBar(4);
				}
			}else if(ssaction == 2 || ssaction == 3 || ssaction == 4){
					showSSLoadingBar(2);
			}
        	updateOptions();
            });
        } else {
            var node_sel = $j('#ssconf_basic_node').val();
            var obj = ssform2obj();
            ss_node_object(node_sel, obj, true,
            function(a) {
			if(ssaction == 1){
				if (ssmode == "0"){
					showSSLoadingBar(4);
				} else {
					showSSLoadingBar(4);
				}
			}else if(ssaction == 2 || ssaction == 3 || ssaction == 4){
				showSSLoadingBar(2);
			}
    		updateOptions();
            });
        }
    }
}


function updateOptions() {
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=ss";
	document.form.SystemCmd.value = "ss_config.sh";
	document.form.submit();
}

function done_validating(action) {
	return true;
}

function save_ss_method(m) {
    var o = $G("ss_basic_method");
    for (var c = 0; c < o.length; c++) {
        if (o.options[c].value == m) {
            o.options[c].selected = true;
            break;
        }
    }
}

function update_ss_ui(obj) {
	for (var field in obj) {
		var el = $G(field);
		if (field == "ss_basic_method") {
			continue;
		} else if (field == "ss_basic_onetime_auth") {
			if (obj[field] != "1") {
				$j("#ss_basic_onetime_auth").val("0");
			} else {
				$j("#ss_basic_onetime_auth").val("1");
			}
			continue;
		} else if (field == "ss_basic_rss_protocol") {
			if (obj[field] != "origin" && obj[field] != "verify_simple" &&  obj[field] != "auth_simple" && obj[field] != "auth_sha1" && obj[field] != "verify_sha1" && obj[field] != "auth_sha1_v2" && obj[field] != "auth_sha1_v4" ) {
				$j("#ss_basic_rss_protocol").val("origin");
			} else {
				$j("#ss_basic_rss_protocol").val(obj.ss_basic_rss_protocol);
			}
			continue;
		} else if (field == "ss_basic_rss_obfs") {
			if (obj[field] != "plain" && obj[field] != "http_simple" &&  obj[field] != "random_head"  && obj[field] != "tls1.2_ticket_auth" ) {
				$j("#ss_basic_rss_obfs").val("plain");
			} else {
				$j("#ss_basic_rss_obfs").val(obj.ss_basic_rss_obfs);
			}
			continue;
		} else if (field == "ss_basic_rss_obfs_param") {
			if (obj[field] == "undefied") {
				$j("#ss_basic_rss_obfs_param").val("");
			} else {
				$j("#ss_basic_rss_obfs_param").val(obj.ss_basic_rss_obfs_param);
			}
			continue;
		} else if (el != null && el.getAttribute("type") == "checkbox") {
			if (obj[field] != "1") {
				el.checked = false;
				$G("hd_" + field).value = "0";
			} else {
				el.checked = true;
				$G("hd_" + field).value = "1";
			}
			continue;
		}
		if (el != null) {
			el.value = obj[field];
		}
	}
	$j("#ss_basic_method").val(obj.ss_basic_method);
}

function validForm() {
	var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_dnsmasq", "ss_redchn_wan_white_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_ip", "ss_redchn_wan_black_domain", "ss_basic_black_lan", "ss_basic_white_lan","ss_ipset_black_domain_web", "ss_ipset_white_domain_web", "ss_ipset_dnsmasq", "ss_ipset_black_ip", "ss_game_dnsmasq", "ss_gameV2_dnsmasq"];
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

function update_visibility_main() {
	ssmode = document.form.ss_basic_mode.value;
	ssenable = document.form.ss_basic_enable.value;
	crst = document.form.ss_basic_chromecast.value;
	sru = document.form.ss_basic_rule_update.value;
	slc = document.form.ss_basic_lan_control.value;
	std = readCookie("ss_table_detail");
	srp = document.form.ss_basic_rss_protocol.value;
	sro = document.form.ss_basic_rss_obfs.value;
	sur = document.form.hd_ss_basic_use_rss.value;
	suk = document.form.hd_ss_basic_use_kcp.value;
	if (srp == "origin"){
		$j("#ss_basic_rss_protocol_alert").html("原版协议");
	} else if (srp == "verify_simple"){
		$j("#ss_basic_rss_protocol_alert").html("带校验的协议");
	} else if (srp == "verify_deflate"){
		$j("#ss_basic_rss_protocol_alert").html("带压缩的协议");
	} else if (srp == "verify_sha1"){
		$j("#ss_basic_rss_protocol_alert").html("带验证抗CCA攻击的协议可兼容libev的OTA");
	} else if (srp == "auth_simple"){
		$j("#ss_basic_rss_protocol_alert").html("带验证抗重放攻击的协议");
	} else if (srp == "auth_sha1"){
		$j("#ss_basic_rss_protocol_alert").html("抗重放、CCA攻击协议");
	} else if (srp == "auth_sha1_v2"){
		$j("#ss_basic_rss_protocol_alert").html("抗重放、CCA攻击升级版协议");
	} else if (srp == "auth_sha1_v4"){
		$j("#ss_basic_rss_protocol_alert").html("");
	}

	if (sro == "plain"){
		$j("#ss_basic_rss_obfs_alert").html("不混淆");
	} else if (sro == "http_simple"){
		$j("#ss_basic_rss_obfs_alert").html("伪装为http协议");
	} else if (sro == "random_head"){
		$j("#ss_basic_rss_obfs_alert").html("发送一个随机包再通讯的协议");
	} else if (sro == "tls1.2_ticket_auth"){
		$j("#ss_basic_rss_obfs_alert").html("模拟TLS1.2，强烈推荐");
	}
	
	if (ssmode == "0"){
		$j("#mode_state").html("SS运行状态");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>shadowsocks 开关</a>");
		$j("#ss_title").html("shadowsocks - 账号信息配置");
	} else if (ssmode == "1"){
		$j("#mode_state").html("SS运行状态【gfwlist模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>shadowsocks 开关</a>");
		$j("#ss_title").html("shadowsocks - 账号信息配置");
	} else if (ssmode == "2"){
		$j("#mode_state").html("SS运行状态【大陆白名单模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>shadowsocks 开关</a>");
		$j("#ss_title").html("shadowsocks - 账号信息配置");
	} else if (ssmode == "3"){
		$j("#mode_state").html("SS运行状态【游戏模式】");
		$j("#head_illustrate").html("<i>说明：</i><a href='http://koolshare.cn/thread-4519-1-1.html' target='_blank'><i>&nbsp;使用游戏模式，账号必须需支持UDP转发&nbsp;&nbsp;<u>FAQ</u></i></a>");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>shadowsocks 开关</a>");
		$j("#ss_title").html("shadowsocks - 账号信息配置");
	} else if (ssmode == "4"){
		$j("#mode_state").html("SS运行状态【游戏模式V2】");
		$j("#head_illustrate").html("<i>说明：</i>游戏模式V2需要架设自己的游戏模式V2服务器才能使用。&nbsp;&nbsp;<a href='http://koolshare.io/koolgame/latest/' target='_blank'><i><u>服务器端下载</u></i></a>&nbsp;&nbsp;<a style='margin-left: 20px;' href='https://koolshare.cn/thread-38263-1-1.html' target='_blank'><i><u>&nbsp;游戏模式v2服务器一键安装脚本</u></i></a>");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>游戏模式V2 开关</a>");
		$j("#ss_title").html("游戏模式V2 - 账号信息配置");
	} else if (ssmode == "5"){
		$j("#mode_state").html("SS运行状态【全局模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(10)'>shadowsocks 开关</a>");
		$j("#ss_title").html("shadowsocks - 账号信息配置");
	}
	showhide("show_btn3", (ssmode == "1" || ssmode == "2" ));
	showhide("ss_state1", (ssmode == "0"));
	showhide("ss_state2", (ssmode !== "0"));
	showhide("ss_state3", (ssmode !== "0"));
	showhide("ss_koolgame_udp_tr", (ssmode == "4"));

	showhide("onetime_auth", (sur !== "1" && ssmode!== "4"));
	showhide("SSR_name", (ssmode!== "4"));
	showhide("KCP_name", (ssmode!== "4"));
	showhide("ss_basic_rss_protocol_tr", (sur == "1" && ssmode!== "4"));
	showhide("ss_basic_rss_obfs_tr", (sur == "1" && ssmode!== "4"));
	showhide("ss_basic_ticket_tr", (sur == "1" && ssmode!== "4" && document.form.ss_basic_rss_obfs.value == "tls1.2_ticket_auth" || document.form.ss_basic_rss_obfs.value == "http_simple"));

	showhide("ss_basic_kcp_port_tr", (suk == "1" && ssmode!== "4" && ssmode!== "3" ));
	showhide("ss_basic_kcp_parameter_tr", (suk == "1" && ssmode!== "4" && ssmode!== "3" ));

}

function update_visibility_tab4(){
	ssmode = document.form.ss_basic_mode.value;
	crst = document.form.ss_basic_chromecast.value;
	sru = document.form.ss_basic_rule_update.value;
	slc = document.form.ss_basic_lan_control.value;
	showhide("update_rules", (ssmode !== "0"));
	showhide("chromecast1", (crst == "0"));
	showhide("gfw_number", (ssmode == "1"));
	showhide("chn_number", (ssmode == "2" || ssmode == "3"));
	showhide("cdn_number", (ssmode == "2" || ssmode == "3"));
	showhide("ss_basic_rule_update_time", (sru == "1"));
	showhide("update_choose", (sru == "1"));
	showhide("ss_basic_black_lan", (slc == "1"));
	showhide("ss_basic_white_lan", (slc == "2"));
}

function update_visibility_tab2_redchn(){
	rdc = document.form.ss_redchn_dns_china.value;
	rdf = document.form.ss_redchn_dns_foreign.value;
	rs = document.form.ss_redchn_sstunnel.value
	rcc = document.form.ss_redchn_chinadns_china.value
	rcf = document.form.ss_redchn_chinadns_foreign.value
	srpm= document.form.ss_redchn_pdnsd_method.value
	showhide("redchn_show_isp_dns", (rdc == "1"));
	showhide("ss_redchn_dns_china_user", (rdc == "5"));
	showhide("ss_redchn_opendns", (rdf == "1"));
	showhide("ss_redchn_sstunnel", (rdf == "2"));
	showhide("redchn_chinadns_china", (rdf == "3"));
	showhide("redchn_chinadns_foreign", (rdf == "3"));
	showhide("redchn_pdnsd_up_stream_tcp", (rdf == "6" && srpm == "2"));
	showhide("redchn_pdnsd_up_stream_udp", (rdf == "6" && srpm == "1"));
	showhide("ss_redchn_pdnsd_udp_server_dns2socks", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 1));
	showhide("ss_redchn_pdnsd_udp_server_dnscrypt", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 2));
	showhide("ss_redchn_pdnsd_udp_server_ss_tunnel", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 3));
	showhide("ss_redchn_pdnsd_udp_server_ss_tunnel_user", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 3 && document.form.ss_redchn_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("redchn_pdnsd_cache", (rdf == "6"));
	showhide("redchn_pdnsd_method", (rdf == "6"));
	showhide("ss_redchn_sstunnel_user", ((rdf == "2") && (rs == "4")));
	showhide("ss_redchn_chinadns_china_user", (rcc == "4"));
	showhide("ss_redchn_chinadns_foreign_user", (rcf == "4"));
	showhide("ss_redchn_dns2socks_user", (rdf == "4"));
	generate_options();
}

function update_visibility_tab2_ipset(){
	icd = document.form.ss_ipset_cdn_dns.value;
    ifd = document.form.ss_ipset_foreign_dns.value;
    it = document.form.ss_ipset_tunnel.value;
    sipm= document.form.ss_ipset_pdnsd_method.value
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
	showhide("ipset_pdnsd_up_stream_tcp", (ifd == "4" && sipm == "2"));
	showhide("ipset_pdnsd_up_stream_udp", (ifd == "4" && sipm == "1"));
	showhide("ss_ipset_pdnsd_udp_server_dns2socks", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 1));
	showhide("ss_ipset_pdnsd_udp_server_dnscrypt", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 2));
	showhide("ss_ipset_pdnsd_udp_server_ss_tunnel", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 3));
	showhide("ss_ipset_pdnsd_udp_server_ss_tunnel_user", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 3 && document.form.ss_ipset_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("ipset_pdnsd_cache", (ifd == "4"));
	showhide("ipset_pdnsd_method", (ifd == "4"));
	generate_options();
}

function update_visibility_tab2_game(){
	gdc = document.form.ss_game_dns_china.value;
	gdf = document.form.ss_game_dns_foreign.value;
	gs = document.form.ss_game_sstunnel.value
	gcc = document.form.ss_game_chinadns_china.value
	gcf = document.form.ss_game_chinadns_foreign.value
	grpm= document.form.ss_game_pdnsd_method.value
	showhide("game_show_isp_dns", (gdc == "1"));
	showhide("ss_game_dns_china_user", (gdc == "5"));
	showhide("ss_game_opendns", (gdf == "1"));
	showhide("ss_game_sstunnel", (gdf == "2"));
	showhide("game_chinadns_china", (gdf == "3"));
	showhide("game_chinadns_foreign", (gdf == "3"));
	showhide("ss_game_sstunnel_user", ((gdf == "2") && (gs == "4")));
	showhide("ss_game_chinadns_china_user", (gcc == "4"));
	showhide("ss_game_chinadns_foreign_user", (gcf == "4"));
	showhide("ss_game_dns2socks_user", (gdf == "4"));
	showhide("game_pdnsd_up_stream_tcp", (gdf == "6" && grpm == "2"));
	showhide("game_pdnsd_up_stream_udp", (gdf == "6" && grpm == "1"));
	showhide("ss_game_pdnsd_udp_server_dns2socks", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 1));
	showhide("ss_game_pdnsd_udp_server_dnscrypt", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 2));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel_user", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3 && document.form.ss_game_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("game_pdnsd_cache", (gdf == "6"));
	showhide("game_pdnsd_method", (gdf == "6"));
	generate_options();
}

function update_visibility_tab2_gameV2(){
	g2dc = document.form.ss_gameV2_dns_china.value;
	g2df = document.form.ss_gameV2_dns_foreign.value;
	showhide("gameV2_show_isp_dns", (g2dc == "1"));
	showhide("ss_gameV2_dns_china_user", (g2dc == "5"));
	showhide("ss_gameV2_dns_china_user_txt1", (g2dc !== "5"));
	showhide("ss_gameV2_dns_china_user_txt2", (g2dc == "5"));
	generate_options();
}

function generate_options(){
	var confs = ["4armed",  "cisco(opendns)",  "cisco-familyshield",  "cisco-ipv6",  "cisco-port53",  "cloudns-can",  "cloudns-syd",  "cs-cawest",  "cs-cfi",  "cs-cfii",  "cs-ch",  "cs-de",  "cs-fr",  "cs-fr2",  "cs-rome",  "cs-useast",  "cs-usnorth",  "cs-ussouth",  "cs-ussouth2",  "cs-uswest",  "cs-uswest2",  "d0wn-bg-ns1",  "d0wn-ch-ns1",  "d0wn-de-ns1",  "d0wn-fr-ns2",  "d0wn-gr-ns1",  "d0wn-hk-ns1",  "d0wn-it-ns1",  "d0wn-lv-ns1",  "d0wn-nl-ns1",  "d0wn-nl-ns2",  "d0wn-random-ns1",  "d0wn-random-ns2",  "d0wn-ro-ns1",  "d0wn-ru-ns1",  "d0wn-tz-ns1",  "d0wn-ua-ns1",  "dnscrypt.eu-dk",  "dnscrypt.eu-dk-ipv6",  "dnscrypt.eu-nl",  "dnscrypt.eu-nl-ipv6",  "dnscrypt.org-fr",  "fvz-rec-at-vie-01",  "fvz-rec-ca-tor-01",  "fvz-rec-ca-tor-01-ipv6",  "fvz-rec-de-fra-01",  "fvz-rec-gb-brs-01",  "fvz-rec-gb-lon-01",  "fvz-rec-gb-lon-03",  "fvz-rec-hk-ztw-01",  "fvz-rec-ie-du-01",  "fvz-rec-no-osl-01",  "fvz-rec-nz-akl-01",  "fvz-rec-nz-akl-01-ipv6",  "fvz-rec-us-ler-01",  "fvz-rec-us-mia-01",  "ipredator",  "ns0.dnscrypt.is",  "okturtles",  "opennic-tumabox",  "ovpnto-ro",  "ovpnto-se",  "ovpnto-se-ipv6",  "shea-us-noads",  "shea-us-noads-ipv6",  "soltysiak",  "soltysiak-ipv6",  "yandex"];
	for(var i = 0; i < confs.length; i++) {
		$j("#ss_redchn_opendns").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
		$j("#ss_redchn_pdnsd_udp_server_dnscrypt").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
		$j("#ss_ipset_opendns").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
		$j("#ss_ipset_pdnsd_udp_server_dnscrypt").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
		$j("#ss_game_opendns").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
		$j("#ss_game_pdnsd_udp_server_dnscrypt").append("<option value='"  + confs[i] + "'>" + confs[i] + "</option>");
	}
}

function oncheckclick(obj) {
	if (obj.checked) {
		$G("hd_" + obj.id).value = "1";
	} else {
		$G("hd_" + obj.id).value = "0";
	}
}

function ssconf_node2obj(node_sel) {
    var p = "ssconf_basic";
    if (typeof db_ss[p + "_server_" + node_sel] == "undefined") {
        var obj = {
            "ss_basic_server": "",
            "ss_basic_port": "",
            "ss_basic_password": "",
            "ss_basic_method": "table",
            "ss_basic_rss_protocol": "",
            "ss_basic_rss_obfs": "",
            "ss_basic_use_rss": "",
            "ss_basic_use_kcp": "",
            "ss_basic_rss_obfs_param": "",
            "ss_basic_onetime_auth": "",
            "ss_basic_koolgame_udp": ""
        };
        return obj;
    } else {
        var obj = {};
        var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "use_kcp", "onetime_auth", "koolgame_udp"];
        for (var i = 0; i < params.length; i++) {
            obj["ss_basic_" + params[i]] = db_ss[p + "_" + params[i] + "_" + node_sel];
        }
        return obj;
    }
}

function ss_node_sel() {
    var node_sel = $G("ssconf_basic_node").value;
    var obj = ssconf_node2obj(node_sel);
    update_visibility_main();
    update_ss_ui(obj);
}

function ss_node_object(node_sel, obj, isSubmit, end) {
    var ns = {};
    var p = "ssconf_basic";
    var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "use_kcp", "onetime_auth", "koolgame_udp"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
        db_ss[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
    }
    if (isSubmit) {
        ns[p + "_node"] = node_sel;
        db_ss[p + "_node"] = node_sel;
    }
    $j.ajax({
        url: '/applydb.cgi?p=' + p,
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            end("error");
        },
        success: function(response) {
            end("ok");
        }
    });
}

function ssform2obj() {
    var obj = {};
    obj["mode"] = $G("ss_basic_mode").value;
    obj["server"] = $G("ss_basic_server").value;
    obj["port"] = $G("ss_basic_port").value;
    obj["password"] = $G("ss_basic_password").value;
    obj["method"] = $G("ss_basic_method").value;
    obj["rss_protocol"] = $G("ss_basic_rss_protocol").value;
    obj["rss_obfs"] = $G("ss_basic_rss_obfs").value;
    obj["rss_obfs_param"] = $G("ss_basic_rss_obfs_param").value;
    obj["use_rss"] = $G("hd_ss_basic_use_rss").value;
    obj["use_kcp"] = $G("hd_ss_basic_use_kcp").value;
    obj["onetime_auth"] = $G("ss_basic_onetime_auth").value;
    obj["koolgame_udp"] = $G("ss_basic_koolgame_udp").value;
    return obj;
}


function getAllConfigs() {
    var dic = {};
    node_global_max = 0;
    for (var field in db_ss) {
        names = field.split("_");
        dic[names[names.length - 1]] = 'ok';
    }
    confs = {};
    var p = "ssconf_basic";
    var params = ["name", "server", "port", "password", "method"];
    for (var field in dic) {
        var obj = {};
        if (typeof db_ss[p + "_name_" + field] == "undefined") {
            obj["name"] = '节点' + field;
        } else {
            obj["name"] = db_ss[p + "_name_" + field];
        }
        
        if (typeof db_ss[p + "_ping_" + field] == "undefined") {
            obj["ping"] = '';
        } else if (db_ss[p + "_ping_" + field] == "failed") {
	        obj["ping"] = '<font color="#FFCC00">failed</font>';
	    } else {
            obj["ping"] = parseFloat(db_ss[p + "_ping_" + field].split(" ")[0]).toPrecision(3) + " ms / " + parseFloat(db_ss[p + "_ping_" + field].split(" ")[3]) + "%";
        }
        
        if (typeof db_ss[p + "_webtest_" + field] == "undefined") {
            obj["webtest"] = '';
        } else {
	        var time_total = parseFloat(db_ss[p + "_webtest_" + field].split(":")[0]).toFixed(2);
	        if (time_total == 0.00){
		        obj["webtest"] = '<font color=#FFCC00">failed</font>';
	        }else{
		         obj["webtest"] = parseFloat(db_ss[p + "_webtest_" + field].split(":")[0]).toFixed(2) + " s";
	        }
        }
        
		if (typeof db_ss[p + "_mode_" + field] == "undefined"){
			obj["mode"] = '';
		}else {
            obj["mode"] = db_ss[p + "_mode_" + field];
        }

        if (typeof db_ss[p + "_onetime_auth_" + field] == "undefined"){
			obj["onetime_auth"] = '';
		}else {
            obj["onetime_auth"] = db_ss[p + "_onetime_auth_" + field];
        }
        
        if (typeof db_ss[p + "_koolgame_udp_" + field] == "undefined"){
			obj["koolgame_udp"] = '';
		}else {
            obj["koolgame_udp"] = db_ss[p + "_koolgame_udp_" + field];
        }
        if (typeof db_ss[p + "_use_rss_" + field] == "undefined"){
			obj["use_rss"] = '';
		}else {
            obj["use_rss"] = db_ss[p + "_use_rss_" + field];
        }
        if (typeof db_ss[p + "_use_kcp_" + field] == "undefined"){
			obj["use_kcp"] = '';
		}else {
            obj["use_kcp"] = db_ss[p + "_use_kcp_" + field];
        }
        
        if (typeof db_ss[p + "_rss_protocol_" + field] == "undefined"){
			obj["rss_protocol"] = '';
		}else {
            obj["rss_protocol"] = db_ss[p + "_rss_protocol_" + field];
        }
        
        if (typeof db_ss[p + "_rss_obfs_" + field] == "undefined"){
			obj["rss_obfs"] = '';
		}else {
            obj["rss_obfs"] = db_ss[p + "_rss_obfs_" + field];
        }
        
        if (typeof db_ss[p + "_rss_obfs_param_" + field] == "undefined"){
			obj["rss_obfs_param"] = '';
		}else {
            obj["rss_obfs_param"] = db_ss[p + "_rss_obfs_param_" + field];
        }

        for (var i = 1; i < params.length; i++) {
            var ofield = p + "_" + params[i] + "_" + field;
            if (typeof db_ss[ofield] == "undefined") {
                obj = null;
                break;
            }
            obj[params[i]] = db_ss[ofield];
        }
        if (obj != null) {
            var node_i = parseInt(field);
            if (node_i > node_global_max) {
                node_global_max = node_i;
            }
            obj["node"] = field;
            confs[field] = obj;
        }
    }
    return confs;    
}



function loadBasicOptions(confs) {
    var option = $j("#ssconf_basic_node");
    option.find('option').remove().end();
    for (var field in confs) {
        var c = confs[field];
        option.append($j("<option>", {
            value: field,
            text: c.name
        }));
    }
    if (node_global_max > 0) {
        var node_sel = "1";
        if (typeof db_ss.ssconf_basic_node != "undefined") {
            node_sel = db_ss.ssconf_basic_node;
        }
        option.val(node_sel);
        ss_node_sel();
    }
}

function loadAllConfigs() {
    confs = getAllConfigs();
    loadBasicOptions(confs);
}

function show_ss_node_info(){ //进入节点显示，编辑页面
		//checkTime = 1;
		//setTimeout("refresh_ss_node_list()", 2000);
		$G("tablet_show").style.display = "none";
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("apply_button").style.display = "none";
		$G("line_image1").style.display = "none";
		//$G("ss_node_list_table_th").style.display = "";
		$G("ss_node_list_table_td").style.display = "";
		$G("ss_node_list_table_btn").style.display = "";
		$G("KoolshareBottom_div").style.display = "none";
		refresh_table();
}
function ss_node_info_return(){ //退出节点页面，进入主面板
		cancel_add_rule(); //隐藏节点编辑面板
		$G("tablet_show").style.display = "";
		$G("basic_show").style.display = "";
		$G("apply_button").style.display = "";
		$G("line_image1").style.display = "";
		$G("ss_node_list_table_th").style.display = "none";
		$G("ss_node_list_table_td").style.display = "none";
		$G("ss_node_list_table_btn").style.display = "none";
		$G("KoolshareBottom_div").style.display = "";
		updateSs_node_listView(); //更新主面板内的节点
		checkTime = 2001; //停止节点页面刷新
}


function updateSs_node_listView(){
    $j.ajax({
        url: '/dbconf?p=ss',
        dataType: 'html',
        error: function(xhr) {            
	        },
        success: function(response) {
            $j.globalEval(response);
            loadAllConfigs();
        }
    });
}

function Add_profile(){ //点击节点页面内添加节点动作
	checkTime = 2001; //停止节点页面刷新
	tabclickhandler(0); //默认显示添加ss节点
	document.form.ss_node_table_name.value = "";
	document.form.ss_node_table_server.value = "";
	document.form.ss_node_table_port.value = "";
	document.form.ss_node_table_password.value = "";
	document.form.ss_node_table_rss_obfs_param.value = "";
	document.form.ss_node_table_method.value = "aes-256-cfb";
	document.form.ss_node_table_mode.value = "1";
	document.form.ss_node_table_onetime_auth.value = "0";
	document.form.ss_node_table_rss_protocol.value = "origin";;
	document.form.ss_node_table_rss_obfs.value = "plain";
	document.form.ss_node_table_koolgame_udp.value = "0";
	$G("cancelBtn").style.display = "";
	$G("ssTitle").style.display = "";
	$G("ssrTitle").style.display = "";
	$G("gamev2Title").style.display = "";
	$G("add_node").style.display = "";
	$G("edit_node").style.display = "none";
	$G("continue_add").style.display = "";
	$G("vpnc_settings").style.position = "fixed";
    $j("#vpnc_settings").fadeIn(200);
}
function cancel_add_rule(){ //点击添加节点面板上的返回
	//$j("#vpnc_settings").fadeOut(0);
	$G("vpnc_settings").style.display = "none";
}

var save_flag = "";	//type of Saving profile
function tabclickhandler(_type){
	$G('ssTitle').className = "vpnClientTitle_td_unclick";
	$G('ssrTitle').className = "vpnClientTitle_td_unclick";
	$G('gamev2Title').className = "vpnClientTitle_td_unclick";
	if(_type == 0){
		save_flag = "shadowsocks";
		generate_options1(0);
		document.form.vpnc_type.value = "shadowsocks";
		$G('ssTitle').className = "vpnClientTitle_td_click";
		$G('ota_support').style.display = "";
		$G('ssr_protocol_tr').style.display = "none";
		$G('ssr_obfs_tr').style.display = "none";
		$G('ssr_obfs_param_tr').style.display = "none";
		$G('gameV2_udp_tr').style.display = "none";
	} else if(_type == 1){
		save_flag = "shadowsocksR";
		generate_options1(0);
		document.form.vpnc_type.value = "shadowsocksR";
		$G('ssrTitle').className = "vpnClientTitle_td_click";
		$G('ota_support').style.display = "none";
		$G('ssr_protocol_tr').style.display = "";
		$G('ssr_obfs_tr').style.display = "";
		$G('ssr_obfs_param_tr').style.display = "";
		$G('gameV2_udp_tr').style.display = "none";
	} else if(_type == 2){
		save_flag = "gameV2";
		generate_options1(1);
		document.form.vpnc_type.value = "gameV2";
		$G('gamev2Title').className = "vpnClientTitle_td_click";
		$G('ota_support').style.display = "none";
		$G('ssr_protocol_tr').style.display = "none";
		$G('ssr_obfs_tr').style.display = "none";
		$G('ssr_obfs_param_tr').style.display = "none";
		$G('gameV2_udp_tr').style.display = "";
	}
	return save_flag;
}

function generate_options1(w){ //为节点添加面板增加模式选择选项
	var obj=$G('ss_node_table_mode');
	$j("#ss_node_table_mode option[value='1']").remove();
	$j("#ss_node_table_mode option[value='2']").remove();
	$j("#ss_node_table_mode option[value='3']").remove();
	$j("#ss_node_table_mode option[value='4']").remove();
	$j("#ss_node_table_mode option[value='5']").remove();
	if(w == 0){
		$j("#ss_node_table_mode").append("<option value='1'>【1】 gfwlist模式</option>");
		$j("#ss_node_table_mode").append("<option value='2'>【2】 大陆白名单模式</option>");
		$j("#ss_node_table_mode").append("<option value='3'>【3】 游戏模式</option>");
		$j("#ss_node_table_mode").append("<option value='5'>【5】 全局代理模式</option>");
	} else if (w == 1){
		$j("#ss_node_table_mode").append("<option value='4'>【4】 游戏模式V2</option>");
	}
}

function add_ss_node_conf(flag){ //点击添加按钮动作
    var ns = {};
    var p = "ssconf_basic";
    node_global_max += 1;	
	var params1 = ["name", "server", "mode",  "port", "password", "method", "onetime_auth"];//for ss
	var params2 = ["name", "server", "mode",  "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param"];//for ssr
	var params3 = ["name", "server", "mode",  "port", "password", "method", "koolgame_udp"];//for ssr
	if(flag == 'shadowsocks'){
    	for (var i = 0; i < params1.length; i++) {
    	    ns[p + "_" + params1[i] + "_" + node_global_max] = $j('#ss_node_table' + "_" + params1[i]).val();
    	    ns[p + "_use_rss_" + node_global_max] = 0;
    	}
	}else if(flag == 'shadowsocksR'){
    	for (var i = 0; i < params2.length; i++) {
    	    ns[p + "_" + params2[i] + "_" + node_global_max] = $j('#ss_node_table' + "_" + params2[i]).val();
    	    ns[p + "_use_rss_" + node_global_max] = 1;
    	}
	}else if(flag == 'gameV2'){
    	for (var i = 0; i < params3.length; i++) {
    	    ns[p + "_" + params3[i] + "_" + node_global_max] = $j('#ss_node_table' + "_" + params3[i]).val();
    	    ns[p + "_use_rss_" + node_global_max] = 0;
    	}
	}
    $j.ajax({
        url: '/applydb.cgi?p=ssconf_basic',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            refresh_table();
            //尝试将table拉动到最下方
            var nodeaera = $G('ss_node_list_table_td');
			nodeaera.scrollTop = nodeaera.scrollHeight;
			document.form.ss_node_table_server.value = ""; //选择连续添加的时候，只清空服务器一栏
			if(($G("continue_add_box").checked) == false){ //不选择连续添加的时候，清空其他数据
				document.form.ss_node_table_name.value = "";
				document.form.ss_node_table_port.value = "";
				document.form.ss_node_table_password.value = "";
				document.form.ss_node_table_rss_obfs_param.value = "";
				document.form.ss_node_table_method.value = "aes-256-cfb";
				document.form.ss_node_table_mode.value = "1";
				document.form.ss_node_table_onetime_auth.value = "0";
				document.form.ss_node_table_rss_protocol.value = "origin";
				document.form.ss_node_table_rss_obfs.value = "plain";
				document.form.ss_node_table_koolgame_udp.value = "0";
				//updateSs_node_listView();
			}
        }
    });
}

function refresh_table() {
	$j.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr){
		},
		success: function(response){
			$j.globalEval(response);
			$j("#ss_node_list_table_main").find("tr:gt(0)").remove();
			$j('#ss_node_list_table_main tr:last').after(refresh_html());
		}
	});
}

function refresh_html() {
	confs = getAllConfigs();
	var n = 0; for(var i in confs){n++;} //获取节点的数目
	if(eval(n) > "13"){ //当节点数目大于12个的时候，显示为overflow，节点可以滚动
		if(isFirefox=navigator.userAgent.indexOf("Firefox")>0){ 
			$G("ss_node_list_table_th").style.top = "354px";
			$G("ss_node_list_table_td").style.top = "394px";
			$G("ss_node_list_table_td").style.bottom = "-108px";
			$G("ss_node_list_table_btn").style.bottom = "-290px";
		}
		$G("ss_node_list_table_th").style.display = "";
		$G("ss_node_list_table_td").style.overflow = "auto";
		$G("ss_node_list_table_td").style.position = "absolute";
		$G("ss_node_list_table_btn").style.position = "absolute";
		$G("ss_node_list_table_main").style.margin = "0px 0px 0px 0px";
		$G("hide_when_folw").style.display = "none";
	}else{
		$G("ss_node_list_table_th").style.display = "none";
		$G("ss_node_list_table_td").style.overflow = "visible";
		$G("ss_node_list_table_td").style.position = "static";
		$G("ss_node_list_table_btn").style.position = "static";
		$G("ss_node_list_table_main").style.margin = "6px 0px 0px 0px";
		$G("hide_when_folw").style.display = "";
	}
	var html = '';
    for (var field in confs) {
        var c = confs[field];
    	html = html + '<tr>';
    	if(c["mode"] == 1){
		    html = html + '<td style="width:45px;"><img src="/res/gfw.png"th/></td>';
    	}else if(c["mode"] == 2){
		    html = html + '<td style="width:45px;"><img src="/res/chn.png"th/></td>';
    	}else if(c["mode"] == 3){
		    html = html + '<td style="width:45px;"><img src="/res/game.png"th/></td>';
    	}else if(c["mode"] == 4){
		    html = html + '<td style="width:45px;"><img src="/res/gameV2.png"th/></td>';
    	}else if(c["mode"] == 5){
		    html = html + '<td style="width:45px;"><img src="/res/all.png"th/></td>';
    	}else{
		    html = html + '<td style="width:45px;"></td>';
    	}
    	html = html + '<td id="ss_node_name_' + c["node"] + '" style="width:85px;">' + c["name"] + '</td>';
    	html = html + '<td id="ss_node_server_' + c["node"] + '" style="width:85px;">' + c["server"] + '</td>';
    	html = html + '<td id="ss_node_port_' + c["node"] + '" style="width:37px;">' + c["port"] + '</td>';
    	html = html + '<td id="ss_node_method_' + c["node"] + '" style="width:75px;">' + c["method"] + '</td>';
		html = html + '<td class="data_ping" id="ss_node_ping_' + c["node"] + '" style="width:78px;" id="ping_test_td_' + c["node"] + '" style="text-align: center;">' + c["ping"] + '</td>';
		if(c["mode"] == 4){
   			html = html + '<td class="data_webtest" id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' +c["node"] + '">' + '不支持' + '</td>';
		}else{
			html = html + '<td class="data_webtest" id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' +c["node"] + '">' + c["webtest"] + '</td>';
		}
    	html = html + '<td style="width:33px;">'
    	html = html + '<input style="margin-left:-3px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="return edit_conf_table(this);" value="">'
    	html = html + '</td>';
    	html = html + '<td style="width:33px;">'
    	if((c["node"]) == db_ss["ssconf_basic_node"]){
    		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="remove_running_node(this);" value="">'
		}else{
    		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="return remove_conf_table(this);" value="">'
		}
    	html = html + '</td>';
    	html = html + '<td style="width:85px;">'
    	if((c["node"]) == db_ss["ssconf_basic_node"]){
    		if(c["use_rss"] == "1"){
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #f072a5;" onclick="apply_Running_node(this);" value="Running">'
			}else{
				if(c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1"){
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #33CC33;" onclick="apply_Running_node(this);" value="Running">'
				}else{
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #00CCFF;" onclick="apply_Running_node(this);" value="Running">'
				}
			}
    	} else {
    		if(c["use_rss"] == "1"){
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #f072a5;" onclick="apply_this_ss_node(this);" value="Apply">'
			}else{
				if(c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1"){
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #33CC33;" onclick="apply_this_ss_node(this);" value="Apply">'
				}else{
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #00CCFF;" onclick="apply_this_ss_node(this);" value="Apply">'
				}
			} 
    	}
    	html = html + '</td>';
    	html = html + '</tr>';
    }
    return html;
}
var node_nu;
function apply_Running_node(){
	alert("这个节点正在运行，你要干嘛？")
}
function remove_running_node(){
	alert("人家正在为你工作，你就要抛弃我？不干！")
}

function apply_this_ss_node(s) { //应用此节点
	cancel_add_rule(); //隐藏节点编辑面板
	$G("tablet_show").style.display = "";
	$G("basic_show").style.display = "";
	$G("apply_button").style.display = "";
	$G("line_image1").style.display = "";
	$G("ss_node_list_table_th").style.display = "none";
	$G("ss_node_list_table_td").style.display = "none";
	$G("ss_node_list_table_btn").style.display = "none";
	$G("KoolshareBottom_div").style.display = "";
    confs = getAllConfigs();
    var option = $j("#ssconf_basic_node");
    option.find('option').remove().end();
    for (var field in confs) {
        var c = confs[field];
        option.append($j("<option>", {
            value: field,
            text: c.name
        }));
    }
    if (node_global_max > 0) {
        var node_sel = "1";
        if (typeof db_ss.ssconf_basic_node != "undefined") {
            node_sel = db_ss.ssconf_basic_node;
        }
        option.val(node_sel);
        //ss_node_sel();
    }

	
	//updateSs_node_listView(); //更新主面板内的节点
	checkTime = 2001; //停止节点页面刷新
    //ss_node_info_return();
    var node = $j(s).attr("id");
    var nodes = node.split("_");
    node = nodes[nodes.length - 1];
    var node_sel = node;
    var obj = ssconf_node2obj(node_sel);
    $G("ssconf_basic_node").value = node;
    update_ss_ui(obj);
    update_visibility_main();
}

function hide_text() {
	$j.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr){
		},
		success: function(response){
			$j.globalEval(response);
    		var reg = /^[\u4E00-\u9FA5]+$/;   
    		if(($G("ss_node_server_" + node_global_max).innerHTML) == "你猜"+ node_global_max){ //服务器一栏不可能有中文，因此判断中文字符
	    		$j("#ss_node_list_table_main").find("tr:gt(0)").remove();
				$j('#ss_node_list_table_main tr:last').after(refresh_html());
			}else{
				$j("#ss_node_list_table_main").find("tr:gt(0)").remove();
				$j('#ss_node_list_table_main tr:last').after(refresh_html1());
			}
		}
	});
}

function refresh_html1() {
	confs = getAllConfigs();
	var n = 0; for(var i in confs){n++;} //获取节点的数目
	var random = parseInt(Math.random()*7);
	var phrase = ["看你妹", "你猜", "你猜不到", "我是马赛克", "我是节点", "火星节点", "引力波节点"];
	if(eval(n) > "12"){ //当节点数目大于12个的时候，显示为overflow，节点可以滚动
		$G("ss_node_list_table_td").style.overflow = "auto";
		$G("ss_node_list_table_td").style.position = "absolute";
		$G("ss_node_list_table_btn").style.position = "absolute";
		$G("ss_node_list_table_main").style.margin = "0px 0px 0px 0px";
		$G("hide_when_folw").style.display = "none";
		$G("ss_node_list_table_th").style.display = "";
	}else{
		$G("ss_node_list_table_td").style.overflow = "visible";
		$G("ss_node_list_table_td").style.position = "static";
		$G("ss_node_list_table_btn").style.position = "static";
		$G("ss_node_list_table_btn").style.width = "747px";
		$G("ss_node_list_table_main").style.margin = "6px 0px 0px 0px";
		$G("hide_when_folw").style.display = "";
		$G("ss_node_list_table_th").style.display = "none";
	}
	var html = '';
    for (var field in confs) {
        var c = confs[field];
    	html = html + '<tr>';
    	if(c["mode"] == 1){
		    html = html + '<td style="width:45px;"><img src="/res/gfw.png"th/></td>';
    	}else if(c["mode"] == 2){
		    html = html + '<td style="width:45px;"><img src="/res/chn.png"th/></td>';
    	}else if(c["mode"] == 3){
		    html = html + '<td style="width:45px;"><img src="/res/game.png"th/></td>';
    	}else if(c["mode"] == 4){
		    html = html + '<td style="width:45px;"><img src="/res/gameV2.png"th/></td>';
    	}else if(c["mode"] == 5){
		    html = html + '<td style="width:45px;"><img src="/res/all.png"th/></td>';
    	}else{
		    html = html + '<td style="width:45px;"></td>';
    	}
    	html = html + '<td id="ss_node_name_' + c["node"] + '" style="width:85px;">' + phrase[random] + c["node"] + '</td>';
    	html = html + '<td id="ss_node_server_' + c["node"] + '" style="width:85px;">你猜' + c["node"] + '</td>';
    	html = html + '<td id="ss_node_port_' + c["node"] + '" style="width:37px;">23333</td>';
    	html = html + '<td id="ss_node_method_' + c["node"] + '" style="width:75px;">666666</td>';
		html = html + '<td id="ss_node_ping_' + c["node"] + '" style="width:78px;" id="ping_test_td_' + c["node"] + '" style="text-align: center;">' + c["ping"] + '</td>';
		if(c["mode"] == 4){
   			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' +c["node"] + '">' + '不支持' + '</td>';
		}else{
			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' +c["node"] + '">' + c["webtest"] + '</td>';
		}
    	html = html + '<td style="width:33px;">'
    	html = html + '<input style="margin-left:-3px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="return edit_conf_table(this);" value="">'
    	html = html + '</td>';
    	html = html + '<td style="width:33px;">'
    	if((c["node"]) == db_ss["ssconf_basic_node"]){
    		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="remove_running_node(this);" value="">'
		}else{
    		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="return remove_conf_table(this);" value="">'
		}
    	html = html + '</td>';
    	html = html + '<td style="width:85px;">'
    	if((c["node"]) == db_ss["ssconf_basic_node"]){
    		if(c["use_rss"] == "1"){
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #f072a5;" onclick="apply_Running_node(this);" value="Running">'
			}else{
				if(c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1"){
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #33CC33;" onclick="apply_Running_node(this);" value="Running">'
				}else{
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #00CCFF;" onclick="apply_Running_node(this);" value="Running">'
				}
			}
    	} else {
    		if(c["use_rss"] == "1"){
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #f072a5;" onclick="apply_this_ss_node(this);" value="Apply">'
			}else{
				if(c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1"){
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #33CC33;" onclick="apply_this_ss_node(this);" value="Apply">'
				}else{
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="button_gen_short" style="color: #00CCFF;" onclick="apply_this_ss_node(this);" value="Apply">'
				}
			} 
    	}
    	html = html + '</td>';
    	html = html + '</tr>';
    }
    return html;
}

function remove_conf_table(o) { //删除节点功能
    var id = $j(o).attr("id");
    var ids = id.split("_");
    var p = "ssconf_basic";
    id = ids[ids.length - 1];
    var ns = {};
    var params = ["name", "server", "mode",  "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "use_kcp", "onetime_auth", "koolgame_udp", "ping", "web_test"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + id] = "";
    }
    $j.ajax({
        url: '/applydb.cgi?use_rm=1&p=ssconf_basic',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            refresh_table();
            //updateSs_node_listView();
        }
    });
}

function edit_conf_table(o){ //编辑节点功能，显示编辑面板
	checkTime = 2001; //编辑节点时停止可能在进行的刷新
    var id = $j(o).attr("id");
    var ids = id.split("_");
    var p = "ssconf_basic";
    confs = getAllConfigs();
    id = ids[ids.length - 1];
	var c = confs[id];
	document.form.ss_node_table_name.value = c["name"];
	document.form.ss_node_table_server.value = c["server"];
	document.form.ss_node_table_port.value = c["port"];
	document.form.ss_node_table_password.value = c["password"];
	document.form.ss_node_table_method.value = c["method"];
	document.form.ss_node_table_onetime_auth.value = c["onetime_auth"];
	document.form.ss_node_table_rss_obfs_param.value = c["rss_obfs_param"];
	document.form.ss_node_table_rss_protocol.value = c["rss_protocol"];
	document.form.ss_node_table_rss_obfs.value = c["rss_obfs"];
	document.form.ss_node_table_koolgame_udp.value = c["koolgame_udp"];
	$G("cancelBtn").style.display = "";
	$G("add_node").style.display = "none";
	$G("edit_node").style.display = "";
	$G("continue_add").style.display = "none";
	if(c["use_rss"] == "1"){ //判断节点为SSR
		$j("#vpnc_settings").fadeIn(200);
		$G("ssTitle").style.display = "none";
		$G("ssrTitle").style.display = "";
		$G("gamev2Title").style.display = "none";
		$j("#ssrTitle").html("编辑SSR账号");
		tabclickhandler(1);
		document.form.ss_node_table_mode.value = c["mode"];
	}else{
		if(c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1"){ //判断节点为游戏模式V2
			$j("#vpnc_settings").fadeIn(200);
			$G("ssTitle").style.display = "none";
			$G("ssrTitle").style.display = "none";
			$G("gamev2Title").style.display = "";
			$j("#gamev2Title").html("编辑GameV2账号");
			tabclickhandler(2);
			document.form.ss_node_table_mode.value = c["mode"];
		}else{ //判断节点为SS
			$j("#vpnc_settings").fadeIn(200);
			$G("ssTitle").style.display = "";
			$G("ssrTitle").style.display = "none";
			$G("gamev2Title").style.display = "none";
			$j("#ssTitle").html("编辑SS账号");
			tabclickhandler(0);
			document.form.ss_node_table_mode.value = c["mode"];
		}
	}
	myid=id; //返回ID号
}
var myid;

function edit_ss_node_conf(flag){ //编辑节点功能，数据重写
    var ns = {};
    var p = "ssconf_basic";	
	var params1 = ["name", "server", "mode",  "port", "password", "method", "onetime_auth"];//for ss
	var params2 = ["name", "server", "mode",  "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param"];//for ssr
	var params3 = ["name", "server", "mode",  "port", "password", "method", "koolgame_udp"];//for ssr
	if(flag == 'shadowsocks'){
    	for (var i = 0; i < params1.length; i++) {
    	    ns[p + "_" + params1[i] + "_" + myid] = $j('#ss_node_table' + "_" + params1[i]).val();
    	    ns[p + "_use_rss_" + myid] = 0;
    	}
	}else if(flag == 'shadowsocksR'){
    	for (var i = 0; i < params2.length; i++) {
    	    ns[p + "_" + params2[i] + "_" + myid] = $j('#ss_node_table' + "_" + params2[i]).val();
    	    ns[p + "_use_rss_" + myid] = 1;
    	}
	}else if(flag == 'gameV2'){
    	for (var i = 0; i < params3.length; i++) {
    	    ns[p + "_" + params3[i] + "_" + myid] = $j('#ss_node_table' + "_" + params3[i]).val();
    	    ns[p + "_use_rss_" + myid] = 0;
    	}
	}
    $j.ajax({
        url: '/applydb.cgi?p=ssconf_basic',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            refresh_table();
			document.form.ss_node_table_name.value = "";
			document.form.ss_node_table_server.value = "";
			document.form.ss_node_table_port.value = "";
			document.form.ss_node_table_password.value = "";
			document.form.ss_node_table_rss_obfs_param.value = "";
			document.form.ss_node_table_method.value = "aes-256-cfb";
			document.form.ss_node_table_mode.value = "1";
			document.form.ss_node_table_onetime_auth.value = "0";
			document.form.ss_node_table_rss_protocol.value = "origin";
			document.form.ss_node_table_rss_obfs.value = "plain";
			document.form.ss_node_table_koolgame_udp.value = "0";
        }
    });
    $j("#vpnc_settings").fadeOut(200);
}


function download_SS_node() {
	location.href='ss_conf_backup.txt';
}

function upload_SS_node() {
	if ($G('ss_file').value == "") return false;
	global_ss_node_refresh = false;
	$G('ss_file_info').style.display = "none";
	$G('loadingicon').style.display = "block";
	document.form.enctype = "multipart/form-data";
	document.form.encoding = "multipart/form-data";
	document.form.action = "/ssupload.cgi?a=/tmp/ss_conf_backup.txt";
	if (validForm()){
		document.form.submit();
	}
}

function upload_ok(isok) {
	var info = $G('ss_file_info');
	if(isok==1){
		info.innerHTML="上传完成";
		setTimeout("restore_ss_conf();", 1000);
	} else {
		info.innerHTML="上传失败";
	}
	info.style.display = "block";
	$G('loadingicon').style.display = "none";
}

function restore_ss_conf() {
	checkTime = 2001;  //停止可能在进行的刷新
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=ss";
    document.form.SystemCmd.value = "ss_conf_restore.sh";
	document.form.enctype = "";
	document.form.encoding = "";
	if (validForm()){
		document.form.submit();
	}
    //setTimeout("onSubmitCtrl();", 2000);
    //refreshpage(5);
    showLoadingBar(8);
    $j("#loading_block3").html("恢复SS配置");
    $j("#loading_block2").html("<li><font color='#ffcc00'>正在恢复相关配置中...</font></li></br><li><font color='#ffcc00'>配置恢复后需要重新提交！</font></li></br><li><font color='#ffcc00'>恢复配置后将返回网络地图！</font></li>");
}

function remove_SS_node(){
	checkTime = 2001;  //停止可能在进行的刷新
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=ss";
    document.form.SystemCmd.value = "ss_conf_remove.sh";
	document.form.enctype = "";
	document.form.encoding = "";
	if (validForm()){
		document.form.submit();
	}
	//refreshpage(5);
	showLoadingBar(8);
	 $j("#loading_block3").html("清除SS配置");
	 $j("#loading_block2").html("<li><font color='#ffcc00'>正在清除所有SS配置...</font></li></br><li><font color='#ffcc00'>配置清除后将自动关闭SS...</font></li></br><li><font color='#ffcc00'>恢复配置后将返回网络地图！</font></li>");
}

function ping_test(){
	checkTime = 2001;  //停止可能在进行的刷新
    document.form.SystemCmd.value = "ss_ping.sh";
	document.form.action_mode.value = ' Refresh ';
	if (validForm()){
		document.form.submit();
		checkTime = 0;
		refresh_ss_node_list_ping();
	}
}
/*
function remove_ping(){
	checkTime = 2001;  //停止可能在进行的刷新
    document.form.SystemCmd.value = "ss_ping_remove.sh";
	document.form.action_mode.value = ' Refresh ';
	if (validForm()){
		document.form.submit();
	}
	setTimeout(refresh_table(), 3000);
}
*/
function web_test(){
	checkTime = 2001; //停止可能在进行的刷新
	//updateSs_node_listView();
	document.form.SystemCmd.value = "ss_webtest.sh";
	document.form.action_mode.value = ' Refresh ';
	if (validForm()){
		document.form.submit();
		checkTime = 0;
		refresh_ss_node_list_webtest();
	}
}
/*
function remove_web_test(){
	checkTime = 2001; //停止可能在进行的刷新
	//updateSs_node_listView();
	document.form.SystemCmd.value = "ss_webtest_remove.sh";
	document.form.action_mode.value = ' Refresh ';
	if (validForm()){
		document.form.submit();
	}
	setTimeout(refresh_table(), 3000);
}
*/
var ping_flag;
var checkTime = 0;
function refresh_ss_node_list_ping(){
	if (checkTime < 200){
		checkTime++;
		refresh_table();
		setTimeout("refresh_ss_node_list_ping()", 1000);
	}
	if (checkTime > 4){
		confs = getAllConfigs();
		var n = 0; for(var i in confs){n++;} //获取节点的数目
		var ping_flag = 0;
    	for (var field in confs) {
    	    var c = confs[field].ping;
				if(c != "" ){
					ping_flag++;
				}
			}
		if (ping_flag == eval(n)){ //当ping被填满时，停止刷新
			checkTime = 2001;
		}
	}
}

var webtest_flag;
function refresh_ss_node_list_webtest(){
	if (checkTime < 200){
		checkTime++;
		refresh_table();
		setTimeout("refresh_ss_node_list_webtest()", 3000); //ping 出结果较慢，3秒刷新一次
	}
	if (checkTime > 2){
		confs = getAllConfigs();
		var n = 0; for(var i in confs){n++;} //获取节点的数目
		var webtest_flag = 0;
    	for (var field in confs) {
    	    var c = confs[field].webtest;
				if(c != "" ){
					webtest_flag++;
				}
			}
		if (webtest_flag == eval(n)){ //当ping被填满时，停止刷新
			checkTime = 2001;
		}
	}
}




function updatelist(){
    document.form.SystemCmd.value = "ss_rule_update.sh";
	document.form.action_mode.value = ' Refresh ';
	if (validForm()){
		document.form.submit();
		//refresh_ss_node_list();
		show_log_info();
	}
}


function createCookie(name, value, days) {
    var expires;
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    } else {
        expires = "";
    }
    document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = encodeURIComponent(name) + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
    }
    return null;
}

function setRefresh(obj) {
	refreshRate = obj.value;
	cookie.set('status_restart', refreshRate, 300);
	get_ss_status_data();
}
function getRefresh() {
	val = parseInt(cookie.get('status_restart'));
	if ((val != 0) && (val != 5) && (val != 10) && (val != 15) && (val != 30) && (val != 60))
	val = 10;
	$G('refreshrate').value = val;
	return val;
}

function version_show(){
    $j.ajax({
        url: 'http://koolshare.ngrok.wang:5000/shadowsocks/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
	            if(res["version"] == db_ss["ss_basic_version_local"]){
		        	$j("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：" + db_ss['ss_basic_version_local'] + "</i></a>");
	       		}else if(res["version"] !== db_ss["ss_basic_version_local"]) {
					 if(typeof(db_ss["ss_basic_version_local"]) != "undefined") {
                    	$j("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：" + db_ss['ss_basic_version_local'] + "</i></a>");
						$j("#updateBtn").html("<i>升级到：" + res.version  + "</i>");
                	}else{
	                	$j("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：2.8.9</i></a>");
                	}
		        }
            }
        }
    });
}

function get_ss_status_data(){
	$j.ajax({
		type: "get",
		url: "dbconf?p=ss_basic_state_china,ss_basic_state_foreign,ss_basic_enable,ss_basic_dns_success",
		dataType: "script",
		success: function() {
			if(refreshRate !== 0){
				if (db_ss_basic_enable['ss_basic_enable'] == "1"){
					$j.ajax({
					url: '/ss_status',
					dataType: "html",
					success: function() {
						if (db_ss_basic_state_foreign['ss_basic_state_foreign'] == undefined || db_ss_basic_state_china['ss_basic_state_china'] == undefined){
							$G("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
        					$G("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
						} else {
							$j("#ss_state2").html("国外连接 - " + db_ss_basic_state_foreign['ss_basic_state_foreign']);
							$j("#ss_state3").html("国内连接 - " + db_ss_basic_state_china['ss_basic_state_china']);
    					}
					}
					});
				} else {
					$G("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
					$G("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
				}
			}
			if (db_ss_basic_dns_success['ss_basic_dns_success'] == "0"){
				$G('SS_IP').style.display = "";
			}else{
				$G('SS_IP').style.display = "none";
			}
			
			refreshRate = getRefresh();
			if(refreshRate !== 0){
				setTimeout("get_ss_status_data();", refreshRate * 1000);
			}
		}
	});
}

var checkNu = 0;
function get_ss_install_status(){
	if (checkNu < 1000){
		checkNu++;
		$j.ajax({
			type: "get",
			url: "dbconf?p=ss_basic_install_status",
			dataType: "script",
			success: function() {
				if (db_ss_basic_install_status['ss_basic_install_status'] == "3"){
					$G('update_button').style.display = "none";
					document.form.ss_basic_action.value = 1;
					checkNu = 1001;
					setTimeout("onSubmitCtrl();", 2000);
				} else if (db_ss_basic_install_status['ss_basic_install_status'] == "5"){
					$G('update_button').style.display = "";
				} else if (db_ss_basic_install_status['ss_basic_install_status'] == "0"){
					$G('update_button').style.display = "";
				}
				setTimeout("get_ss_install_status();", 1000);
			}
		});
	}
}

function update_ss(){
	checkNu = 0;
	get_ss_install_status();
	$G('update_button').style.display = "none";
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_update.sh";
	if (validForm()){
		document.form.submit();
	}
	show_log_info();
}
function buildswitch(){
	$j("#switch").click(
	function(){
		var ssmode = $G("ss_basic_mode").value;
		if($G('switch').checked){
			document.form.action_mode.value = ' Refresh ';
			$G('ss_basic_enable').value = 1;
			$G("ss_status1").style.display = "";
			$G("tablet_show").style.display = "";
			$G("basic_show").style.display = "";
			$G("apply_button").style.display = "";
			update_visibility_main();
		}else{
			document.form.ss_basic_enable.value = 0;
			showSSLoadingBar(5);
			document.form.action_mode.value = ' Refresh ';
			document.form.action = "/applydb.cgi?p=ss";
			document.form.SystemCmd.value = "ss_config.sh";
			if (validForm()){
				document.form.submit();
			}
			$G("ss_status1").style.display = "none";
			$G("tablet_show").style.display = "none";
			$G("basic_show").style.display = "none";
			$G("apply_button").style.display = "none";
			$G("ss_node_list_table_th").style.display = "none";
			
			
		}
	});
}

function toggle_switch(){
	if (db_ss['ss_basic_enable'] == "1"){
		$G("switch").checked = true;
    	update_visibility_main();
	} else {
		$G("switch").checked = false;
		$G("ss_status1").style.display = "none";
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";
		$G("tablet_show").style.display = "none";
		$G("apply_button").style.display = "none";
		$G("line_image1").style.display = "none";
		$G("ss_node_list_table_th").style.display = "none";
		$G("ss_node_list_table_td").style.display = "none";
		$G("ss_node_list_table_btn").style.display = "none";
		$G("log_content").style.display = "none";
		$G("log_return_button").style.display = "none";
	}
}


function toggle_func(){
	ssmode = $G("ss_basic_mode").value;
	document.form.ss_basic_action.value = 1;
	$j('.show-btn1').addClass('active');
	$j(".show-btn1").click(
	function(){
		$j('.show-btn1').addClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "";
		$G("add_fun").style.display = "none";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";	
		$G("cmdBtn").value = "提交";
		//$j("#cmdBtn").html("提交");
		document.form.ss_basic_action.value = 1;
		update_visibility_main();
	});
		$j(".show-btn2").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').addClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("cmdBtn").value = "应用DNS设定";
		//$j("#cmdBtn").html("应用DNS设定");
		document.form.ss_basic_action.value = 2;
		if (ssmode == "1"){
			$G("ipset_dns").style.display = "";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
			update_visibility_tab2_ipset();
		}else if(ssmode == "2"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
			update_visibility_tab2_redchn();
		}else if(ssmode == "3"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
			update_visibility_tab2_game();
		}else if(ssmode == "4"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
		}else if(ssmode == "5"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "";
			$G("overall_list").style.display = "none";	
			update_visibility_tab2_gameV2();
		}
	});
	$j(".show-btn3").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').addClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("cmdBtn").value = "应用黑白名单";
		//$j("#cmdBtn").html("应用黑白名单");
		document.form.ss_basic_action.value = 3;
		if (ssmode == "1"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
		}else if(ssmode == "2"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
		}else if(ssmode == "3"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
		}else if(ssmode == "4"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";
		}else if(ssmode == "5"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "";	
		}
	});
		$j(".show-btn4").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').addClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";	
		//$j("#cmdBtn").html("应用附加功能");
		$G("cmdBtn").value = "应用附加功能";
		document.form.ss_basic_action.value = 4;
		update_visibility_tab4();
	});	
}
function show_log_info(){
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";
		$G("tablet_show").style.display = "none";
		$G("apply_button").style.display = "none";
		$G("line_image1").style.display = "none";
		$G("ss_node_list_table_th").style.display = "none";
		$G("ss_node_list_table_td").style.display = "none";
		$G("ss_node_list_table_btn").style.display = "none";
		$G("log_content").style.display = "";
		$G("log_return_button").style.display = "";
		checkCmdRet();
}
function return_basic(){
		$G("tablet_show").style.display = "";
		$G("basic_show").style.display = "";
		$G("apply_button").style.display = "";
		$G("line_image1").style.display = "";
		$G("log_content").style.display = "none";
		$G("log_return_button").style.display = "none";
		$G("loading_icon").style.display = "none";
		$j('.show-btn1').addClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		//$j("#cmdBtn").html("提交");
		$G("cmdBtn").value = "提交";
		document.form.ss_basic_action.value = 1;
		update_visibility_main();
		checkNu = 1001;
}


var _responseLen;
var noChange = 0;
function checkCmdRet(){

	$j.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
			},
		success: function(response){
			var retArea = $G("log_content1");
			if(response.search("XU6J03M6") != -1){
				$G("loadingIcon").style.display = "none";
				retArea.value = response.replace("XU6J03M6", " ");
				//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
				retArea.scrollTop = retArea.scrollHeight;
				//return false;
			}
			
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}

			if(noChange > 25){
				$G("loadingIcon").style.display = "none";
				//retArea.scrollTop = retArea.scrollHeight;
				//setTimeout("checkCmdRet();", 2000);
				return false;
			}else{
				$G("loadingIcon").style.display = "";
				setTimeout("checkCmdRet();", 500);
			}
			
			retArea.value = response;
			//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}
function reload_Soft_Center(){
	location.href = "/Main_Soft_center.asp";
}
/*
function setIframeSrc() {
    var s1 = "http://1212.ip138.com/ic.asp";
    var s2 = "http://x302.rashost.com/ip.php";
    var s3 = "http://ip111cn.appspot.com/";
    var iframe1 = document.getElementById('iframe1');
    var iframe2 = document.getElementById('iframe2');
    var iframe3 = document.getElementById('iframe3');
    if ( - 1 == navigator.userAgent.indexOf("MSIE")) {
        iframe1.src = s1;
        iframe2.src = s2;
        iframe3.src = s3;
    } else {
        iframe1.location = s1;
        iframe2.location = s2;
        iframe3.location = s3;
    }
}
*/
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
		
		<div id="loading_block2" style="margin:10px auto; width:85%;"></div>
		</td>
	</tr>
</table>
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=ss" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="next_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="6"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="vpnc_type" value="">
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="0" />
<input type="hidden" id="ss_basic_action" name="ss_basic_action" value="1" />
<input type="hidden" id="ss_basic_install_status" name="ss_basic_install_status" value="0" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" value=""/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<div>
<table class="content" style="margin:auto;" align="center" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<!--=====Beginning of Main Menu=====-->
		<td valign="top" width="202">
			<div id="mainMenu" style="margin-top:-171px;"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock" style="width:768px;"></div>
			
			<!--=====Beginning of Main Content=====-->
			
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" id="table_for_all" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">									
										<div>&nbsp;</div>
										<div class="formfonttitle" style="margin-top: -18px;" id="ss_title">shadowsocks - 账号信息配置</div>
										<div style="float:right; width:15px; height:0px;margin-top:-6px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div id="line1" style="margin-left:3px;margin-top:0px;margin-bottom:3px;"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote"  id="head_illustrate"><i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。</div>
										<div style="margin-top: 0px;text-align: center;font-size: 18px;margin-bottom: 0px;"class="formfontdesc" id="cmdDesc"></div>
										<div id="ss_switch_show">
											<table style="margin:0px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ss_switch_table">
												<thead>
												<tr>
													<td colspan="2">开关</td>
												</tr>
												</thead>
												<tr>
												<th id="ss_switch"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">shadowsocks 开关</a></th>
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
														<div id="update_button" style="padding-top:5px;margin-left:90px;margin-top:-38px;float: left;">
															<button id="updateBtn" class="button_gen" onclick="update_ss();">检查并更新</button>
															<a style="margin-left: 170px;" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/shadowsocks/Changelog.txt" target="_blank"><em><u>[ 更新日志 ]</u></em></a>
														</div>
														<div id="ss_version_show" style="padding-top:5px;margin-left:220px;margin-top:0px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)"><i>当前版本：<% dbus_get_def("ss_basic_version_local", "未知"); %></i></a></div>
														<div id="ss_install_show" style="padding-top:5px;margin-left:220px;margin-top:0px;"></div>	
													</td>
												</tr>
                                    		</table>
                                    	</div>
                                    	<div id="ss_status1">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_state">
												<th id="mode_state" width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">SS运行状态</a></th>
													<td>
														<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">
															<span style="display: none" id="ss_state1">尚未启用! </span>
															<span id="ss_state2">国外连接 - Waiting...</span>
															<br/>
															<span id="ss_state3">国内连接 - Waiting...</span>
														</a>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse"  width="100%" height="37px">
										        <tr width="235px">
                                    	            <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                    	                <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="账号设置"/>
                                    	                <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="DNS设定"/>
                                    	                <input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="黑白名单"/>
                                    	                <input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="附加功能"/>
                                    	                <!--
                                    	                <input id="show_btn4" class="show-btn5" style="cursor:pointer" type="button" value="kcp协议"/>
                                    	                <input id="show_btn4" class="show-btn6" style="cursor:pointer" type="button" value="负载均衡"/>
                                    	                -->
                                    	            </td>
                                    	        </tr>
											</table>
										</div>


										<div id="vpnc_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: -65px;">
											<table class="QISform_wireless" border=0 align="center" cellpadding="5" cellspacing="0">
												<tr style="height:32px;">
													<td>		
														<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0" class="vpnClientTitle">
															<tr>
													  		<td width="33%" align="center" id="ssTitle" onclick="tabclickhandler(0);">添加SS账号</td>
													  		<td width="33%" align="center" id="ssrTitle" onclick="tabclickhandler(1);">添加SSR账号</td>
													  		<td width="33%" align="center" id="gamev2Title" onclick="tabclickhandler(2);">添加GameV2账号</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td>
														<!---- vpnc_pptp/l2tp start  ---->
														<div>
														<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
															<tr>
																<th>使用模式</th>
																<td>
																	<select id="ss_node_table_mode" name="ss_node_table_mode" class="input_option" style="width:350px;margin:0px 0px 0px 2px;">
																	</select>
																</td>
															</tr>
															<tr>
																<th>节点别名</th>
																<td>
																  	<input type="text" maxlength="64" id="ss_node_table_name" name="ss_node_table_name" value="" class="input_ss_table" style="width:342px;float:left;" autocorrect="off" autocapitalize="off"></input>
																</td>
															</tr>
															<tr>
																<th>服务器地址</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_server" name="ss_node_table_server" value="" class="input_ss_table" style="width:342px;float:left;" autocorrect="off" autocapitalize="off"></input>
																</td>
															</tr>
										
															<tr>
																<th>服务器端口</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_port" name="ss_node_table_port" value="" class="input_ss_table" style="width:342px;float:left;" autocomplete="off" autocorrect="off" autocapitalize="off"></input>
																</td>
															</tr>
										
															<tr>
																<th>密码</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_password" name="ss_node_table_password" value="" class="input_ss_table" style="width:342px;float:left;" autocomplete="off" autocorrect="off" autocapitalize="off"></input>
																</td>
															</tr>
															<tr>
																<th>加密方式</th>
																<td>
																	<select id="ss_node_table_method" name="ss_node_table_method" class="input_option" style="width:350px;margin:0px 0px 0px 2px;">
																		<option value="table">table</option>
																		<option value="rc4">rc4</option>
																		<option value="rc4-md5">rc4-md5</option>
																		<option value="aes-128-cfb">aes-128-cfb</option>
																		<option value="aes-192-cfb">aes-192-cfb</option>
																		<option value="aes-256-cfb" selected>aes-256-cfb</option>
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
																		<option value="chacha20-ietf">chacha20-ietf</option>
																	</select>
																</td>	
															</tr>
															<tr id="ota_support">
																<th>OTA支持</th>
																<td>
																	<select name="ss_node_table_onetime_auth" id="ss_node_table_onetime_auth" class="input_option" style="width:350px;margin:0px 0px 0px 2px;">
																		<option value="0" selected>否</option>
																		<option value="1">是</option>
																	</select>
																</td>
															</tr>
															<tr id="ssr_protocol_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>协议 (protocol)</u></a></th>
																<td>
																	<select id="ss_node_table_rss_protocol" name="ss_node_table_rss_protocol" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
																		<option value="origin" selected>origin</option>
																		<option value="verify_simple">verify_simple</option>
																		<option value="verify_sha1">verify_sha1</option>
																		<option value="auth_simple">auth_simple</option>
																		<option value="auth_sha1">auth_sha1</option>
																		<option value="auth_sha1_v2">auth_sha1_v2</option>
																		<option value="auth_sha1_v4">auth_sha1_v4</option>
																	</select>
																</td>
															</tr>
															<tr id="ssr_obfs_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>混淆插件 (obfs)</u></a></th>
																<td>
																	<select id="ss_node_table_rss_obfs" name="ss_node_table_rss_obfs" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
																		<option value="plain">plain</option>
																		<option value="http_simple">http_simple</option>
																		<option value="random_head">random_head</option>
																		<option value="tls1.2_ticket_auth">tls1.2_ticket_auth</option>
																	</select>
																</td>
															</tr>
															<tr id="ssr_obfs_param_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/blob/master/ssr.md" target="_blank"><u>自定义参数 (obfs_param)</u></a></th>
																<td>
																	<input type="text" name="ss_node_table_rss_obfs_param" id="ss_node_table_rss_obfs_param" placeholder="cloudflare.com"  class="input_ss_table" style="width:342px;" maxlength="100" value=""></input>
																</td>
															</tr>
															<tr id="gameV2_udp_tr" >
																<th width="35%">UDP通道</th>
																<td>
																	<select id="ss_node_table_koolgame_udp" name="ss_node_table_koolgame_udp" style="width:350px;margin:0px 0px 0px 2px;" class="ssconfig input_option">
																		<option value="0">udp in udp</option>
																		<option value="1">udp in tcp</option>
																	</select>
																</td>
															</tr>
															</table>
												 		</div>
												 		<!---- vpnc_pptp/l2tp end  ---->		 			 	
													</td>
												</tr>
											</table>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" style="margin-left: 160px;" type="button" onclick="cancel_add_rule();" id="cancelBtn" value="返回">
												<input id="add_node" class="button_gen" type="button" onclick="add_ss_node_conf(save_flag);" value="添加">
												<input id="edit_node" style="display: none;" class="button_gen" type="button" onclick="edit_ss_node_conf(save_flag);" value="修改">	
												<a id="continue_add" style="display: none;margin-left: 20px;"><input id="continue_add_box" type="checkbox"  />连续添加</a>
												
											</div>	
										      <!--===================================Ending of vpnc setting Content===========================================-->			
										</div>


										
										<!--=====bacic show =====-->
										<div id="basic_show">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >

												<tr id="node_select">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">节点选择</a></th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="ssconf_basic_node" name="ssconf_basic_node" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="ss_node_sel();update_visibility_main();" >
															</select>
														</div>
														<div id="ss_node_edit" style="float:left; width:35px; height:35px;margin:-3px 0px -5px 2px;cursor:pointer" onclick="show_ss_node_info();"></div>
													</td>
												</tr>
												<tr>
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">模式</a></th>
													<td>
														<select id="ss_basic_mode" name="ss_basic_mode" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility_main();" >
															<option value="1">【1】 gfwlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="3">【3】 游戏模式</option>
															<option value="4">【4】 游戏模式V2</option>
															<option value="5">【5】 全局代理模式</option>
														</select>
														<div id="SSR_name"style="margin-left:170px;margin-top:-20px;margin-bottom:0px;">
															<input type="checkbox" id="ss_basic_use_rss" onclick="oncheckclick(this);update_visibility_main();" />
															<input type="hidden" id="hd_ss_basic_use_rss" name="ss_basic_use_rss" value="" />
															<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">使用SSR</a>
														</div>

														<div id="KCP_name"style="margin-left:250px;margin-top:-23px;margin-bottom:0px;">
															<input type="checkbox" id="ss_basic_use_kcp" onclick="oncheckclick(this);update_visibility_main();" />
															<input type="hidden" id="hd_ss_basic_use_kcp" name="ss_basic_use_kcp" value="" />
															<a>启用KCP协议</a>
														</div>
													</td>
												</tr>
												<tr id="server_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">服务器</a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_server" name="ss_basic_server" maxlength="100" value=""/>
														<div id="SS_IP"style="margin-left:170px;margin-top:-20px;margin-bottom:0px;display: none;">
															<font color="#66FF66">服务器DNS解析异常，请填写ip地址！</font>
														</div>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">服务器端口</a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_port" name="ss_basic_port" maxlength="100" value="" />
													</td>
												</tr>
												<tr id="pass_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">密码</a></th>
													<td>
														<input type="password" name="ss_basic_password" id="ss_basic_password" class="ssconfig input_ss_table" maxlength="100" value=""></input>
														<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ss_basic_password);">
															<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">显示密码</a>
														</div>
													</td>
												</tr>												
												<tr id="method_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">加密方式</a></th>
													<td>
														<select id="ss_basic_method" name="ss_basic_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="table">table</option>
															<option class="content_input_fd" value="rc4">rc4</option>
															<option class="content_input_fd" value="rc4-md5">rc4-md5</option>
															<option class="content_input_fd" value="aes-128-cfb">aes-128-cfb</option>
															<option class="content_input_fd" value="aes-192-cfb">aes-192-cfb</option>
															<option class="content_input_fd" value="aes-256-cfb" selected="">aes-256-cfb</option>
															<option class="content_input_fd" value="bf-cfb">bf-cfb</option>
															<option class="content_input_fd" value="camellia-128-cfb">camellia-128-cfb</option>
															<option class="content_input_fd" value="camellia-192-cfb">camellia-192-cfb</option>
															<option class="content_input_fd" value="camellia-256-cfb">camellia-256-cfb</option>
															<option class="content_input_fd" value="cast5-cfb">cast5-cfb</option>
															<option class="content_input_fd" value="des-cfb">des-cfb</option>
															<option class="content_input_fd" value="idea-cfb">idea-cfb</option>
															<option class="content_input_fd" value="rc2-cfb">rc2-cfb</option>
															<option class="content_input_fd" value="seed-cfb">seed-cfb</option>
															<option class="content_input_fd" value="salsa20">salsa20</option>
															<option class="content_input_fd" value="chacha20">chacha20</option>
															<option class="content_input_fd" value="chacha20-ietf">chacha20-ietf</option>
														</select>
													</td>
												</tr>
												<tr id="ss_koolgame_udp_tr" >
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">UDP通道</a></th>
													<td>
														<select id="ss_basic_koolgame_udp" name="ss_basic_koolgame_udp" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility_main();" >
															<option value="0">udp in udp</option>
															<option value="1">udp in tcp</option>
														</select>
													</td>
												</tr>
												<tr id="onetime_auth">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">一次性验证(OTA)</a></th>
													<td>
														<select id="ss_basic_onetime_auth" name="ss_basic_onetime_auth" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="0" selected>关闭</option>
															<option class="content_input_fd" value="1">开启</option>
														</select>
														<span id="ss_basic_onetime_auth_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_rss_protocol_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">协议插件（protocol）</a></th>
													<td>
														<select id="ss_basic_rss_protocol" name="ss_basic_rss_protocol" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_visibility_main();" >
															<option class="content_input_fd" value="origin">origin</option>
															<option class="content_input_fd" value="verify_simple">verify_simple</option>
															<option class="content_input_fd" value="verify_sha1">verify_sha1</option>
															<option class="content_input_fd" value="auth_simple">auth_simple</option>
															<option class="content_input_fd" value="auth_sha1">auth_sha1</option>
															<option class="content_input_fd" value="auth_sha1_v2">auth_sha1_v2</option>
															<option class="content_input_fd" value="auth_sha1_v4">auth_sha1_v4</option>
														</select>
														<span id="ss_basic_rss_protocol_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_rss_obfs_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">混淆插件 (obfs)</a></th>
													<td>
														<select id="ss_basic_rss_obfs" name="ss_basic_rss_obfs" style="width:164px;margin:0px 0px 0px 2px;" class="input_option"  onchange="update_visibility_main();" >
															<option class="content_input_fd" value="plain">plain</option>
															<option class="content_input_fd" value="http_simple">http_simple</option>
															<option class="content_input_fd" value="random_head">random_head</option>
															<option class="content_input_fd" value="tls1.2_ticket_auth">tls1.2_ticket_auth</option>
														</select>
														<span id="ss_basic_rss_obfs_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_ticket_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">自定义参数 (obfs_param)</a></th>
													<td>
														<input type="text" name="ss_basic_rss_obfs_param" id="ss_basic_rss_obfs_param" placeholder="cloudflare.com"  class="ssconfig input_ss_table" maxlength="100" value=""></input>
														<span id="ss_basic_ticket_tr_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px">不知道如何填写请留空</span>
													</td>
												</tr>
												<tr id="ss_basic_kcp_port_tr" style="display: none;">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">KCP端口</a></th>
													<td>
														<input type="text" name="ss_basic_kcp_port" id="ss_basic_kcp_port"  class="ssconfig input_ss_table" maxlength="200" value=""></input>
													</td>
												</tr>
												<tr id="ss_basic_kcp_parameter_tr" style="display: none;">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">KCP参数</a></th>
													<td>
														<input type="text" name="ss_basic_kcp_parameter" id="ss_basic_kcp_parameter"  class="ssconfig input_ss_table" style="width:450px" maxlength="200" value="--crypt none --mode fast2 --mtu 1350 --nocomp --dscp 46"></input>
													</td>
												</tr>
											</table>
										</div>
										
										<div id="ss_node_list_table_th" style="display: none; position: absolute; top: 202px; width: 98.8%;">
											<table style="margin:0px 0px 0px 0px;table-layout:fixed;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable1">
												<tr height="40px">
													<th style="width:45px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">模式</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">节点名称</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">服务器地址</a></th>
													<th style="width:37px;">端口</th>
													<th style="width:75px;">加密方式</th>
													<th style="width:78px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">ping/丢包</a></th>
													<th style="width:36px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">延迟</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">编辑</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">删除</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">使用</a></th>
												</tr>
											</table>
										</div>
										
										<div id="ss_node_list_table_td"  style="display: none; position: static; top: 242px; bottom: 183px; width: 98.8%; overflow: visible">
											<table id="ss_node_list_table_main" style="margin:0px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable1">
												<tr id="hide_when_folw" height="40px" style="display: none;">
													<th style="width:45px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">模式</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">节点名称</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">服务器地址</a></th>
													<th style="width:37px;">端口</th>
													<th style="width:75px;">加密方式</th>
													<th style="width:78px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">ping/丢包</a></th>
													<th style="width:36px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">延迟</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">编辑</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">删除</a></th>
													<th style="width:85px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">使用</a></th>
												</tr>
											</table>
										</div>
										<div id="ss_node_list_table_btn" style="display: none;position: static;width: 747px; bottom: 0px;">
											<table style="margin:7px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th style="width:20%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">导出恢复</a></th>
													<td>
														<input type="button" class="button_gen" onclick="download_SS_node();" value="导出配置">
														<input type="button" class="button_gen" onclick="remove_SS_node();" value="清空配置">
														<input type="button" id="upload_btn" class="button_gen" onclick="upload_SS_node();" value="恢复配置">

														<input style="color:#FFCC00;*color:#000;width: 200px;" id="ss_file" type="file" name="file">
														<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
														<span id="ss_file_info" style="display:none;">完成</span>
													</td>
												</tr>
												<tr>
													<th style="width:20%;">ping测试</th>
													<td>
														<!--<input class="button_gen" onClick="remove_ping()" type="button" value="移除ping"/>-->
														<input class="button_gen" onClick="ping_test()" type="button" value="ping测试"/>
														<select id="ssconf_basic_Ping_Method" name="ssconf_basic_Ping_Method" style="width:300px;margin:0px 0px 0px 2px;" class="input_option">
															<option class="content_input_fd" value="1">单线ping(10次/节点)</option>
															<option class="content_input_fd" value="2">并发ping(10次/节点)</option>
															<option class="content_input_fd" value="3">并发ping(20次/节点)</option>
															<option class="content_input_fd" value="4">并发ping(50次/节点)</option>
														</select>
													</td>
												</tr>
												<tr>
													<th style="width:20%;">web测试</th>
													<td>
														<!--<input class="button_gen" onClick="remove_test()" type="button" value="移除web测试"/>-->
														<input class="button_gen" onClick="web_test()" type="button" value="web测试"/>
														<select id="ssconf_basic_test_domain" name="ssconf_basic_test_domain" style="width:300px;margin:0px 0px 0px 2px;" class="input_option">
															<option class="content_input_fd" value="https://www.google.com/">google.com</option>
															<option class="content_input_fd" value="https://www.youtube.com/">youtube.com</option>
														</select>
													</td>
												</tr>
											</table>
											<table>
												<tr>
													<td>
														<div id="node_return_button" class="apply_gen" style="margin-left: 105px;;float: left;">
															<input type="button" class="button_gen" onclick="ss_node_info_return();" value="返回">
															<input class="button_gen" id="returnBtn" onClick="hide_text()" type="button" value="黑科技按钮"/>
															<input class="button_gen" onClick="Add_profile()" type="button" value="添加节点"/>
														</div>
													</td>
												</tr>
											</table>
										</div>
									

										<!--=====gfwlist_dns=====-->
										<div id="ipset_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th id="china_dns" width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">选择国内DNS</a></th>
													<td>
														<select id="ss_ipset_cdn_dns" name="ss_ipset_cdn_dns" class="input_option" onclick="update_visibility_tab2_ipset();" >
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
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">选择国外DNS</a></th>
													<td>
														<select id="ss_ipset_foreign_dns" name="ss_ipset_foreign_dns" class="input_option" onclick="update_visibility_tab2_ipset();" >
															<option value="2">DNS2SOCKS</option>
															<option value="0">dnscrypt-proxy</option>
															<option value="1">ss-tunnel</option>
															<option value="3">Pcap_DNSProxy</option>
															<option value="4">pdnsd</option>
														</select>
														<select id="ss_ipset_opendns" name="ss_ipset_opendns" class="input_option"></select>
														<select id="ss_ipset_tunnel" name="ss_ipset_tunnel" class="input_option" onclick="update_visibility_tab2_ipset();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
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
												<tr id="ipset_pdnsd_method">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(29)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></a></th>
													<td>
														<select id="ss_ipset_pdnsd_method" name="ss_ipset_pdnsd_method" class="input_option" onclick="update_visibility_tab2_ipset();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="ipset_pdnsd_up_stream_tcp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_ip" name="ss_ipset_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_port" name="ss_ipset_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="ipset_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="ipset_pdnsd_up_stream_udp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(31)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></a></th>
													<td>
														<select id="ss_ipset_pdnsd_udp_server" name="ss_ipset_pdnsd_udp_server" class="input_option" onclick="update_visibility_tab2_ipset();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
															
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_udp_server_dns2socks" name="ss_ipset_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_ipset_pdnsd_udp_server_dnscrypt" name="ss_ipset_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_ipset_pdnsd_udp_server_ss_tunnel" name="ss_ipset_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility_tab2_ipset();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_udp_server_ss_tunnel_user" name="ss_ipset_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="ipset_pdnsd_cache">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(32)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_cache_min" name="ss_ipset_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_cache_max" name="ss_ipset_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="ipset_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">自定义dnsmasq</a></th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18
# 如果填入了错误的格式，可能会导致页面错乱，请用命令：dbus remove ss_ipset_dnsmasq，手动清除此项配置。" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_dnsmasq" name="ss_ipset_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====redchn_dns=====-->
										<div id="redchn_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="redchn_dns_plan_china">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">选择国内DNS</a></th>
													<td>
														<select id="ss_redchn_dns_china" name="ss_redchn_dns_china" class="input_option" onclick="update_visibility_tab2_redchn();" >
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
														<span id="redchn_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">选择国外DNS</a></th>
													<td>
														<select id="ss_redchn_dns_foreign" name="ss_redchn_dns_foreign" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="4">DNS2SOCKS</option>
															<option value="1">dnscrypt-proxy</option>
															<option value="2">ss-tunnel</option>
															<option value="3">ChinaDNS</option>
															<option value="5">Pcap_DNSProxy</option>
															<option value="6">pdnsd</option>
														</select>
														<select id="ss_redchn_opendns" name="ss_redchn_opendns" class="input_option"></select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_dns2socks_user" name="ss_redchn_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_redchn_sstunnel" name="ss_redchn_sstunnel" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_sstunnel_user" name="ss_redchn_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													</td>
												</tr>
												<tr id="redchn_chinadns_china">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(27)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font></a></th>
													<td>
														<select id="ss_redchn_chinadns_china" name="ss_redchn_chinadns_china" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS【114.114.114.114】</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_china_user" name="ss_redchn_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="redchn_chinadns_foreign">
													<th width="20%"><font color="#66FF66"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(28)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS</font></a></th>
													<td>
														<select id="ss_redchn_chinadns_foreign" name="ss_redchn_chinadns_foreign" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Google DNS1 [8.8.8.8]</option>
															<option value="3">Google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_foreign_user" name="ss_redchn_chinadns_foreign_user" maxlength="100" value="">
														<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> <br/>
													</td>
												</tr>
												<tr id="redchn_pdnsd_method">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(29)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="ss_redchn_pdnsd_method" name="ss_redchn_pdnsd_method" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="redchn_pdnsd_up_stream_tcp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_ip" name="ss_redchn_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_port" name="ss_redchn_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="redchn_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="redchn_pdnsd_up_stream_udp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(31)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></a></th>
													<td>
														<select id="ss_redchn_pdnsd_udp_server" name="ss_redchn_pdnsd_udp_server" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_udp_server_dns2socks" name="ss_redchn_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_redchn_pdnsd_udp_server_dnscrypt" name="ss_redchn_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_redchn_pdnsd_udp_server_ss_tunnel" name="ss_redchn_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility_tab2_redchn();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_udp_server_ss_tunnel_user" name="ss_redchn_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="redchn_pdnsd_cache">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(32)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_cache_min" name="ss_redchn_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_cache_max" name="ss_redchn_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="redchn_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(33)">自定义需要CDN加速名单</a></th>
													<td>
														<textarea placeholder="# 填入需要强制用国内DNS解析的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经添加了1万多条国内域名，请勿重复添加！
# 注意：不支持通配符！" cols="50" rows="7" id="ss_redchn_isp_website_web" name="ss_redchn_isp_website_web" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">自定义dnsmasq</a></th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="ss_redchn_dnsmasq" name="ss_redchn_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====game_dns=====-->
										<div id="game_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="game_dns_plan_china">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">选择国内DNS</a></th>
													<td>
														<select id="ss_game_dns_china" name="ss_game_dns_china" class="input_option" onclick="update_visibility_tab2_game();" >
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
														<span id="game_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">选择国外DNS</a></th>
													<td>
														<select id="ss_game_dns_foreign" name="ss_game_dns_foreign" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="4">DNS2SOCKS</option>
															<option value="1">dnscrypt-proxy</option>
															<option value="2">ss-tunnel</option>
															<option value="3">ChinaDNS（CDN最优）</option>
															<option value="5">PcapDNSProxy</option>
															<option value="6">pdnsd</option>
														</select>
														<select id="ss_game_opendns" name="ss_game_opendns" class="input_option"></select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_dns2socks_user" name="ss_game_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_game_sstunnel" name="ss_game_sstunnel" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_sstunnel_user" name="ss_game_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													</td>
												</tr>
												<tr id="game_chinadns_china">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(27)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font></a></th>
													<td>
														<select id="ss_game_chinadns_china" name="ss_game_chinadns_china" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS【114.114.114.114】</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_china_user" name="ss_game_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="game_chinadns_foreign">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(28)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS</font></a></th>
													<td>
														<select id="ss_game_chinadns_foreign" name="ss_game_chinadns_foreign" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Google DNS1 [8.8.8.8]</option>
															<option value="3">Google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_foreign_user" name="ss_game_chinadns_foreign_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
															<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> 
													</td>
												</tr>
												<tr id="game_pdnsd_method">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(29)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="ss_game_pdnsd_method" name="ss_game_pdnsd_method" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="game_pdnsd_up_stream_tcp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_ip" name="ss_game_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_port" name="ss_game_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="game_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="game_pdnsd_up_stream_udp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(31)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></a></th>
													<td>
														<select id="ss_game_pdnsd_udp_server" name="ss_game_pdnsd_udp_server" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_dns2socks" name="ss_game_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_game_pdnsd_udp_server_dnscrypt" name="ss_game_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_game_pdnsd_udp_server_ss_tunnel" name="ss_game_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility_tab2_game();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_ss_tunnel_user" name="ss_game_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="game_pdnsd_cache">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(32)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></a></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_min" name="ss_game_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_max" name="ss_game_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="game_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">自定义dnsmasq</a></th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_game_dnsmasq" name="ss_game_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====gameV2_dns=====-->
										<div id="gameV2_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="gameV2_dns_plan_china">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">选择国内DNS</a></th>
													<td>
														<select id="ss_gameV2_dns_china" name="ss_gameV2_dns_china" class="input_option" onclick="update_visibility_tab2_gameV2();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_gameV2_dns_china_user" name="ss_gameV2_dns_china_user" maxlength="100" value=""></input>
														<span id="gameV2_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
														<span id="ss_gameV2_dns_china_user_txt1">默认：运营商DNS【用于解析国内6000+个域名】</span> 
														<span id="ss_gameV2_dns_china_user_txt2">确保你自定义输入的国内DNS在chnroute中</span>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(47)">选择国外DNS</a></th>
													<td>
														<select id="ss_gameV2_dns_foreign" name="ss_gameV2_dns_foreign" class="input_option" onclick="update_visibility_tab2_gameV2();" >
															<option value="1" disabled selected>DNS2SS</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_gameV2_dns2ss_user" name="ss_gameV2_dns2ss_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<br/>
															<span id="dns_plan_foreign0">默认：koolgame内置DNS2SS，用以解析国内6000+域名以外的国内域名和国外域名</span>
													</td>
												</tr>
												<tr>
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">自定义dnsmasq</a></th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_gameV2_dnsmasq" name="ss_gameV2_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====overall_dns=====-->
										<div id="overall_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                    						  <tr>
                    						    <th width="10%"><b>
                    						      <center>
                    						        <a class="hintstyle" href="javascript:void(0);" onclick="openssHint(48)"><font color="#ffcc00">全局模式</font></a>
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
                    						        <b><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(49)"><font color="#ffcc00">全局模式DNS</font></a></b>
                    						      </center></th>
                    						    <td><select id="ss_overall_dns" name="ss_overall_dns" class="input_option">
                    						        <option value="0">OpenDNS方式</option>
                    						        <option value="1">UDP转发方式</option>
                    						        <option value="2">OpenDNS方式 + UDP转发方式</option>
                    						      </select>
                    						      <span>默认：OpenDNS方式 </span></td>
                    						  </tr>
                    						</table>
                    					</div>

										<!--=====ipset_list=====-->
										<div id="ipset_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(35)">域名白名单（新增）</a></th>
													<td>
														<textarea placeholder="# 此处填入不需要走ss的域名，一行一个，格式如下：
google.com.sg
youtube.com
# 默认gfwlist以外的域名都不会走ss，故添加gfwlist内的域名才有意义!
# 屏蔽一个域名可能导致其他网址被屏蔽，例如解析结果一致的youtube.com和google.com.
# 只有域名污染，没有IP未阻断的网站，不能被屏蔽，例如twitter.com." rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_white_domain_web" name="ss_ipset_white_domain_web" title=""></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(36)">域名黑名单</a></th>
													<td>
														<textarea placeholder="# 此处填入需要强制走ss的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经由gfwlist提供了上千条被墙域名，请勿重复添加!" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_black_domain_web" name="ss_ipset_black_domain_web" title=""></textarea>
													</td>
												</tr>	
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(37)">IP/CIDR黑名单</a></th>
													<td>
														<textarea placeholder="# 此处填入需要强制走kcptun的IP或IP段（CIDR格式），一行一个，格式如下：
91.108.4.0/22
91.108.56.0/24
109.239.140.0/24
67.198.55.0/24
# 对于某些没有域名但是被墙的服务很有用处，比如telegram等!" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_black_ip" name="ss_ipset_black_ip" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====redchn_list=====-->
										<div id="redchn_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(38)">IP/CIDR白名单</a><br>
														<br>
														<font color="#ffcc00">添加不需要走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的外网ip地址，一行一个，格式（IP/CIDR）如下
2.2.2.2
3.3.3.3
4.4.4.4/24
# 因为默认大陆的ip都不会走SS，所以此处填入国外IP/CIDR更有意义！" cols="50" rows="7" id="ss_redchn_wan_white_ip" name="ss_redchn_wan_white_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(39)">域名白名单</a><br>
														<br>
														<font color="#ffcc00">添加不需要走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的域名，一行一个，格式如下：
google.com
facebook.com
# 因为默认大陆的ip都不会走SS，所以此处填入国外域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_redchn_wan_white_domain" name="ss_redchn_wan_white_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(40)">IP/CIDR黑名单</a><br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的外网ip地址，一行一个，格式（IP/CIDR）如下：
5.5.5.5
6.6.6.6
7.7.7.7/8
# 因为默认大陆以外ip都会走SS，所以此处填入国内IP/CIDR更有意义！" cols="50" rows="7" id="ss_redchn_wan_black_ip" name="ss_redchn_wan_black_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(41)">域名黑名单</a><br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的域名，一行一个，格式如下：
baidu.com
taobao.com
# 因为默认大陆以外的ip都会走SS，所以此处填入国内域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_redchn_wan_black_domain" name="ss_redchn_wan_black_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====game_list=====-->
										<div id="game_list" style="display: none;">

										</div>
										
										<!--=====gameV2_list=====-->
										<div id="gameV2_list" style="display: none;">

										</div>

										<!--=====overall_list=====-->
										<div id="overall_list" style="display: none;">

										</div>

										<!--===== addon =====-->
										<div id="add_fun" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
													<th>查看日志信息</th>
													<td>
														<input class="button_gen" id="logBtn" onclick="show_log_info()" type="button" value="查看日志"/>
													</td>
												</tr>
												<tr>
													<th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(42)">状态更新间隔</a></th>
													<td>
														<select title="立即生效，无须提交" name="refreshrate" id="refreshrate" class="input_option" onchange="setRefresh(this);">
															<option value="0">不更新</option>
															<option value="5">5s</option>
															<option value="10" selected>10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
												<tr  id="gfw_number">
													<th id="gfw_nu1" width="35%">当前gfwlist域名数量</th>
													<td id="gfw_nu2">
															<% nvram_get("ipset_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf" target="_blank">
																<i><% nvram_get("update_ipset"); %></i>
														</a>
													</td>
												</tr>
												<tr  id="chn_number">
													<th id="chn_nu1" width="35%">当前大陆白名单IP段数量</th>
												<td id="chn_nu2">
													<p>
														<% nvram_get("chnroute_numbers"); %>&nbsp;行，最后更新版本：
														<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/chnroute.txt" target="_blank">
															<i><% nvram_get("update_chnroute"); %></i>
														</a>
													</p>
												</td>
												</tr>
												<tr  id="cdn_number">
													<th id="cdn_nu1" width="35%">当前国内域名数量（cdn名单）</th>
													<td id="cdn_nu2">
														<p>
														<% nvram_get("cdn_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt" target="_blank">
																<i><% nvram_get("update_cdn"); %></i>
															</a>
														</p>
													</td>
												</tr>
												<tr id="chromecast">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(43)">Chromecast支持</a></th>
													<td>
														<select id="ss_basic_chromecast" name="ss_basic_chromecast" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">禁用</option>
															<option value="1" selected>开启</option>
														</select>
															<span id="chromecast1"> 建议开启chromecast支持 </span>
													</td>
												</tr>
												<tr id="update_rules">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(44)">shadowsocks规则自动更新</a></th>
													<td>
														<select id="ss_basic_rule_update" name="ss_basic_rule_update" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
														<select id="ss_basic_rule_update_time" name="ss_basic_rule_update_time" class="ssconfig input_option" title="选择规则列表自动更新时间，更新后将自动重启SS" onchange="update_visibility_tab4();" >
															<option value="0">00:00点</option>
															<option value="1">01:00点</option>
															<option value="2">02:00点</option>
															<option value="3">03:00点</option>
															<option value="4">04:00点</option>
															<option value="5">05:00点</option>
															<option value="6">06:00点</option>
															<option value="7">07:00点</option>
															<option value="8">08:00点</option>
															<option value="9">09:00点</option>
															<option value="10">10:00点</option>
															<option value="11">11:00点</option>
															<option value="12">12:00点</option>
															<option value="13">13:00点</option>
															<option value="14">14:00点</option>
															<option value="15">15:00点</option>
															<option value="16">16:00点</option>
															<option value="17">17:00点</option>
															<option value="18">18:00点</option>
															<option value="19">19:00点</option>
															<option value="20">20:00点</option>
															<option value="21">21:00点</option>
															<option value="22">22:00点</option>
															<option value="23">23:00点</option>
														</select>
															&nbsp;
															<a id="update_choose">
																<input type="checkbox" id="ss_basic_gfwlist_update" name="a" title="选择此项应用gfwlist自动更新" onclick="oncheckclick(this);">gfwlist
																<input type="checkbox" id="ss_basic_chnroute_update" name="a2" onclick="oncheckclick(this);">chnroute
																<input type="checkbox" id="ss_basic_cdn_update" name="a3" onclick="oncheckclick(this);">CDN
																<input type="hidden" id="hd_ss_basic_gfwlist_update" name="ss_basic_gfwlist_update" value=""/>
																<input type="hidden" id="hd_ss_basic_chnroute_update" name="ss_basic_chnroute_update" value=""/>
																<input type="hidden" id="hd_ss_basic_cdn_update" name="ss_basic_cdn_update" value=""/>
															</a>
																<input id="update_now" onclick="updatelist()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="立即更新" />
													</td>
												</tr>
												<tr id="ss_lan_control">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(45)">局域网客户端控制</a>&nbsp;&nbsp;&nbsp;&nbsp;<select id="ss_basic_lan_control" name="ss_basic_lan_control" class="input_ss_table" style="width:auto;height:25px;margin-left: 0px;" onchange="update_visibility_tab4();">
															<option value="0">禁用</option>
															<option value="1">黑名单模式</option>
															<option value="2">白名单模式</option>
														</select>
													</th>
													<td>
														<textarea placeholder="填入需要限制客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_basic_black_lan" name="ss_basic_black_lan" title=""></textarea>
														<textarea placeholder="填入仅允许的客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_basic_white_lan" name="ss_basic_white_lan" title=""></textarea>
													</td>
												</tr>
												<tr id="ss_sleep_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(46)">开机启动延时</a></th>
													<td>
														<select id="ss_basic_sleep" name="ss_basic_sleep" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">0s</option>
															<option value="5">5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
												<tr id="ss_main_portal_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(50)">侧边栏入口开关</a></th>
													<td>
														<select id="ss_main_portal" name="ss_main_portal" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0" selected>关闭</option>
															<option value="1">开启</option>
														</select>
													</td>
												</tr>
											</table>
										</div>

										<!--log_content-->
										<div id="log_content" style="margin-top:10px;display: none;">
											<textarea cols="63" rows="30" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;"></textarea>
										</div>
										<div id="log_return_button" class="apply_gen" style="display: none;">
											<input class="button_gen" id="returnBtn" onClick="return_basic()" type="button" value="返回"/>
										</div>
										<div class="apply_gen" id="loading_icon">
											<img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif">
										</div>
											<!-- not for this version
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="Routing_rules_table1">
												<thead>
												<tr>
													<td colspan="2">双线双拨策略路由状态</td>
												</tr>
												</thead>
												<tr>
													<th>国内连接</th>
													<td>
														<iframe id="iframe1" src="" width="100%" height="22" scrolling="no" frameborder="0" marginheight="3" marginwidth="0"></iframe>
													</td>
												<tr>
													<th>国外连接</th>
													<td >
														<iframe id="iframe2" src="" width="100%" height="22" scrolling="no" frameborder="0" marginheight="3" marginwidth="0"></iframe>
													</td>
												<tr>
													<th>谷歌网站</th>
													<td>
														<iframe id="iframe3" src="" width="100%" height="22" scrolling="no" frameborder="0" marginheight="3" marginwidth="0"></iframe>
													</td>
												</tr>
											</table>
										</div>
										-->
										<div id="apply_button" class="apply_gen">
											<input id="cmdBtn" class="button_gen" type="button" onclick="onSubmitCtrl()" value="提交">
										</div>
										<div id="warn" style="display: none;font-size: 20px;position: static;" class="formfontdesc" id="cmdDesc"><i>你开启了kcptun,请先关闭后才能开启shadowsocks</i></div>
										<div id="warn1" style="display: none;font-size: 20px;position: static;" class="formfontdesc" id="cmdDesc"><i>你开启了kcptun,请先关闭后才能开启shadowsocks</i></div>
										<div id="line_image1" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div id ="KoolshareBottom_div" class="KoolshareBottom" style="position: static;">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
											Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> , Web by： <i>Xiaobao</i></a>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		<!--=====End of Main Content=====-->
		</td>
		<td width="10" align="center" valign="top"></td>
	</tr>
</table>
</div>
</form>
<div id="footer"></div>
</body>
</html>

