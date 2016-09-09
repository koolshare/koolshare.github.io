<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>kcptun</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/dbconf?p=KCP&v=<% uptime(); %>"></script>
<style type="text/css">
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
.input_KCP_table{
	margin-left:2px;
	padding-left:0.4em;
	height:21px;
	width:158.2px;
	line-height:23px \9;	/*IE*/
	font-size:13px;
	font-family:'Courier New', Courier, mono;
	background-image:none;
	background-color: #576d73;
	border:1px solid gray;
	color:#FFFFFF;
}
.show-btn1,
.show-btn2,
.show-btn3,
.show-btn4{
    border: 1px solid #222;
    background: #576d73;
    color: #fff;
    padding: 10px 3.75px;
    border-radius: 5px 5px 0px 0px;
    width:8.45601%;
}
.active{
    background: #2f3a3e;
}
input[type=button]:focus {
    outline: none;
}
</style>
<script>
var $j = jQuery.noConflict();
var _responseLen;
var noChange = 0;
var over_var = 0;
var isMenuopen = 0;
var $G = function(id) {
    return document.getElementById(id);
};
String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}

function init() {
    show_menu();
    generate_options();
    version_show();
    buildswitch();
    $j('.show-btn1').addClass('active');
    $j("#cmdBtn").html("应用所有设置");
    //document.getElementById("kcp_show").style.display = "";
	//document.getElementById("gfwlist_dns").style.display = "none";
	//document.getElementById("gfwlist_dns_message").style.display = "none";
	//document.getElementById("gfwlist_list").style.display = "none";
	//document.getElementById("gfwlist_list_message").style.display = "none";
	//document.getElementById("chn_dns").style.display = "none";
	//document.getElementById("chn_dns_message").style.display = "none";
	//document.getElementById("chn_list").style.display = "none";
	//document.getElementById("chn_list_message").style.display = "none";
	toggle_func();
    for (var field in db_KCP) {
		$j('#'+field).val(db_KCP[field]);
	}
    if (typeof db_KCP != "undefined") {
        update_KCP_ui(db_KCP);
    } else {
        document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
    }
    var jffs2_scripts = '<% nvram_get("jffs2_scripts"); %>';
	if(jffs2_scripts == "0"){
		$j("#warn").html("<i>发现Enable JFFS custom scripts and configs选项未开启！</br></br>请开启并重启路由器后才能正常使用SS。<a href='/Advanced_System_Content.asp'><em><u> 前往设置 </u></em></a> </i>");
		document.form.kcptun.value = 0;
		inputCtrl(document.form.switch,0);
	}
	detect_ss();
	toggle_switch();
	update_visibility();
	setTimeout("checkKCPStatus();", 1000);
}

function pass_checked(obj){
	switchType(obj, document.form.show_pass.checked, true);
}

function detect_ss(){

    var ss_mode = '<% nvram_get("ss_mode"); %>';
	if(ss_mode != "0" && ss_mode != ''){
		document.getElementById('KCP_status1').style.display = "none";
		//document.getElementById('KCP_maitain').style.display = "none";
		document.getElementById('basic_show').style.display = "none";
		document.getElementById('kcp_show').style.display = "none";
		document.getElementById('gfwlist_dns').style.display = "none";
		document.getElementById('gfwlist_list').style.display = "none";
		document.getElementById('chn_dns').style.display = "none";
		document.getElementById('chn_list').style.display = "none";
		document.getElementById('add_fun').style.display = "none";
		document.getElementById('policy').style.display = "none";
		document.getElementById('warn1').style.display = "";
		document.getElementById('cmdBtn').style.display = "none";
		document.form.KCP_basic_enable.value = 0;
		inputCtrl(document.form.switch,0);
		}
}

function go_settings(){
location.href = "/Advanced_System_Content.asp";
}
function onSubmitCtrl() {
	KCPmode = document.getElementById("KCP_basic_policy").value;
	KCPaction = document.getElementById("KCP_basic_action").value;
	global_status_enable=false;
	checkKCPStatus();
	setTimeout("checkKCPStatus();", 50000); //make sure KCP_status do not update during reloading
	if (KCPaction == "0"){
		if (KCPmode == "1"){
			showKCPLoadingBar(5);
		} else if (KCPmode == "2"){
			showKCPLoadingBar(5);
		}
	} else if (KCPaction == "1" || KCPaction == "2" || KCPaction == "3" ){
		showKCPLoadingBar(2);
	}
	updateOptions();
}


function updateOptions() {
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=KCP";
	document.form.SystemCmd.value = "kcp_config.sh";
	if (validForm()){
		document.form.submit();
	}
}

function validForm(){
	var temp_ss = ["KCP_basic_black_lan", "KCP_basic_white_lan", "KCP_gfwlist_dnsmasq", "KCP_gfwlist_white_domain_web", "KCP_gfwlist_black_domain_web" , "KCP_gfwlist_black_ip", "KCP_chnmode_isp_website_web", "KCP_chnmode_dnsmasq", "KCP_chnmode_wan_white_ip", "KCP_chnmode_wan_white_domain", "KCP_chnmode_wan_black_ip", "KCP_chnmode_wan_black_domain"];
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

function done_validating(action) {
	return true;
}

function update_KCP_ui(obj) {
	for (var field in obj) {
		var el = document.getElementById(field);
		if (field == "KCP_basic_method") {
			continue;
		} else if (el != null && el.getAttribute("type") == "checkbox") {
			if (obj[field] != "1") {
				el.checked = false;
				document.getElementById("hd_" + field).value = "0";
			} else {
				el.checked = true;
				document.getElementById("hd_" + field).value = "1";
			}
			continue;
		}
			var temp_ss = ["KCP_basic_black_lan", "KCP_basic_white_lan", "KCP_gfwlist_dnsmasq", "KCP_gfwlist_white_domain_web", "KCP_gfwlist_black_domain_web" , "KCP_gfwlist_black_ip", "KCP_chnmode_isp_website_web", "KCP_chnmode_dnsmasq", "KCP_chnmode_wan_white_ip", "KCP_chnmode_wan_white_domain", "KCP_chnmode_wan_black_ip", "KCP_chnmode_wan_black_domain"];
			for (var i = 0; i < temp_ss.length; i++) {
				temp_str = $G(temp_ss[i]).value;
				$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
			}
		if (el != null) {
			el.value = obj[field];
		}
	}
	$j("#KCP_basic_method").val(obj.KCP_basic_method);
}


function oncheckclick(obj) {
	if (obj.checked) {
		document.getElementById("hd_" + obj.id).value = "1";
	} else {
		document.getElementById("hd_" + obj.id).value = "0";
	}
}

var global_status_enable = true;

function checkKCPStatus() {
	get_ss_state();
	if (db_KCP['KCP_basic_enable'] !== "0") {
	    if(!global_status_enable) {//not enabled
			setTimeout("checkKCPStatus();", 500000);
		    return;
	    }
		$j.ajax({
		url: '/ss_status',
		dataType: "html",
        error: function(xhr) {
            setTimeout("checkKCPStatus();", 5000);
        },
		success: function() {
			if (db_ss_basic_state['ss_basic_state_foreign'] == undefined){
				document.getElementById("KCP_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
        		document.getElementById("KCP_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
        		setTimeout("checkKCPStatus();", 5000);
			} else {
				$j('#KCP_state2').html("国外连接 - " + db_ss_basic_state['ss_basic_state_foreign']);
				$j('#KCP_state3').html("国内连接 - " + db_ss_basic_state['ss_basic_state_china']);
        		setTimeout("checkKCPStatus();", 5000);
    		}
		}
		});
	} else {
		document.getElementById("KCP_state2").innerHTML = "国外连接 - " + "Waiting...";
        document.getElementById("KCP_state3").innerHTML = "国内连接 - " + "Waiting...";
	}
}


function get_ss_state(){
		$j.ajax({
		type: "get",
		url: "/dbconf?p=ss_basic_state",
		dataType: "script",
		success: function() {
		}
		});
	}

function version_show(){
    $j.ajax({
        url: 'http://koolshare.ngrok.wang:5000/kcptun/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {        
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
	            if(res["version"] == db_KCP["KCP_basic_version"]){
		        	$j("#KCP_version_show").html("<i>当前版本：" + res["version"]);
	       		}else if(res["version"] != db_KCP["KCP_basic_version"]) {
                    $j("#KCP_version_show").html("<i>有新版本：" + res.version);
		        }
            }
        }
    });
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function update_visibility() {
	KCPmode = document.form.KCP_basic_policy.value;
	KCPenable = document.form.KCP_basic_enable.value;
	crst = document.form.KCP_basic_chromecast.value;
	slc = document.form.KCP_basic_lan_control.value;
	showhide("KCP_state2", (KCPmode !== "0"));
	showhide("KCP_state3", (KCPmode !== "0"));
	showhide("chromecast1", (crst == "0"));
	showhide("guardian1", (document.form.KCP_basic_guardian.value == "0"));
	showhide("KCP_basic_black_lan", (slc == "1"));
	showhide("KCP_basic_white_lan", (slc == "2"));
    icd = document.form.KCP_gfwlist_cdn_dns.value;
    ifd = document.form.KCP_gfwlist_foreign_dns.value;
    sipm= document.form.KCP_gfwlist_pdnsd_method.value
    showhide("show_isp_dns_gfwlist", (icd == "1"));
    showhide("KCP_gfwlist_cdn_dns_user", (icd == "5"));
    showhide("KCP_gfwlist_opendns", (ifd == "0"));
    showhide("KCP_gfwlist_dns2socks_user", (ifd == "2"));
	showhide("pdnsd_up_stream_tcp_gfwlist", (ifd == "4" && sipm == "2"));
	showhide("pdnsd_up_stream_udp_gfwlist", (ifd == "4" && sipm == "1"));
	showhide("KCP_gfwlist_pdnsd_udp_server_dns2socks", (ifd == "4" && sipm == "1" && document.form.KCP_gfwlist_pdnsd_udp_server.value == 1));
	showhide("KCP_gfwlist_pdnsd_udp_server_dnscrypt", (ifd == "4" && sipm == "1" && document.form.KCP_gfwlist_pdnsd_udp_server.value == 2));
	showhide("pdnsd_cache_gfwlist", (ifd == "4"));
	showhide("pdnsd_method_gfwlist", (ifd == "4"));
	rdc = document.form.KCP_chnmode_dns_china.value;
	rdf = document.form.KCP_chnmode_dns_foreign.value;
	rcc = document.form.KCP_chnmode_chinadns_china.value
	rcf = document.form.KCP_chnmode_chinadns_foreign.value
	srpm= document.form.KCP_chnmode_pdnsd_method.value
	showhide("show_isp_dns_chnmode", (rdc == "1"));
	showhide("KCP_chnmode_dns_china_user", (rdc == "5"));
	showhide("KCP_chnmode_opendns", (rdf == "1"));
	showhide("chinadns_china", (rdf == "3"));
	showhide("chinadns_foreign", (rdf == "3"));
	showhide("pdnsd_up_stream_tcp_chnmode", (rdf == "6" && srpm == "2"));
	showhide("pdnsd_up_stream_udp_chnmode", (rdf == "6" && srpm == "1"));
	showhide("KCP_chnmode_pdnsd_udp_server_dns2socks", (rdf == "6" && srpm == "1" && document.form.KCP_chnmode_pdnsd_udp_server.value == 1));
	showhide("KCP_chnmode_pdnsd_udp_server_dnscrypt", (rdf == "6" && srpm == "1" && document.form.KCP_chnmode_pdnsd_udp_server.value == 2));
	showhide("pdnsd_cache_chnmode", (rdf == "6"));
	showhide("pdnsd_method_chnmode", (rdf == "6"));
	showhide("KCP_chnmode_chinadns_china_user", (rcc == "4"));
	showhide("KCP_chnmode_chinadns_foreign_user", (rcf == "4"));
	showhide("KCP_chnmode_dns2socks_user", (rdf == "4"));
	generate_options();
}


function generate_options(){
	var confs = ["4armed",  "cisco(opendns)",  "cisco-familyshield",  "cisco-ipv6",  "cisco-port53",  "cloudns-can",  "cloudns-syd",  "cs-cawest",  "cs-cfi",  "cs-cfii",  "cs-ch",  "cs-de",  "cs-fr",  "cs-fr2",  "cs-rome",  "cs-useast",  "cs-usnorth",  "cs-ussouth",  "cs-ussouth2",  "cs-uswest",  "cs-uswest2",  "d0wn-bg-ns1",  "d0wn-ch-ns1",  "d0wn-de-ns1",  "d0wn-fr-ns2",  "d0wn-gr-ns1",  "d0wn-hk-ns1",  "d0wn-it-ns1",  "d0wn-lv-ns1",  "d0wn-nl-ns1",  "d0wn-nl-ns2",  "d0wn-random-ns1",  "d0wn-random-ns2",  "d0wn-ro-ns1",  "d0wn-ru-ns1",  "d0wn-tz-ns1",  "d0wn-ua-ns1",  "dnscrypt.eu-dk",  "dnscrypt.eu-dk-ipv6",  "dnscrypt.eu-nl",  "dnscrypt.eu-nl-ipv6",  "dnscrypt.org-fr",  "fvz-rec-at-vie-01",  "fvz-rec-ca-tor-01",  "fvz-rec-ca-tor-01-ipv6",  "fvz-rec-de-fra-01",  "fvz-rec-gb-brs-01",  "fvz-rec-gb-lon-01",  "fvz-rec-gb-lon-03",  "fvz-rec-hk-ztw-01",  "fvz-rec-ie-du-01",  "fvz-rec-no-osl-01",  "fvz-rec-nz-akl-01",  "fvz-rec-nz-akl-01-ipv6",  "fvz-rec-us-ler-01",  "fvz-rec-us-mia-01",  "ipredator",  "ns0.dnscrypt.is",  "okturtles",  "opennic-tumabox",  "ovpnto-ro",  "ovpnto-se",  "ovpnto-se-ipv6",  "shea-us-noads",  "shea-us-noads-ipv6",  "soltysiak",  "soltysiak-ipv6",  "yandex"];
	var obj=document.getElementById('KCP_gfwlist_opendns'); 
	var obj1=document.getElementById('KCP_gfwlist_pdnsd_udp_server_dnscrypt');
	var obj2=document.getElementById('KCP_chnmode_opendns');
	var obj3=document.getElementById('KCP_chnmode_pdnsd_udp_server_dnscrypt');
	for(var i = 0; i < confs.length; i++) {
		obj.options.add(new Option(confs[i],confs[i]));
		obj1.options.add(new Option(confs[i],confs[i]));
		obj2.options.add(new Option(confs[i],confs[i]));
		obj3.options.add(new Option(confs[i],confs[i]));
	}
}

function show_log_info(){
	document.getElementById("basic_show").style.display = "none";
	document.getElementById("add_fun").style.display = "none";
	document.getElementById("apply_button").style.display = "none";
	document.getElementById("log_content").style.display = "";
	document.getElementById("return_button").style.display = "";
	checkCmdRet();
}
function return_basic(){
	document.getElementById("basic_show").style.display = "";
	document.getElementById("add_fun").style.display = "";
	document.getElementById("apply_button").style.display = "";
	document.getElementById("log_content").style.display = "none";
	document.getElementById("return_button").style.display = "none";
}

var _responseLen;
var noChange = 0;
var retArea = document.getElementById('log_content');

function checkCmdRet(){

	$j.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
			},
		success: function(response){
			var retArea = document.getElementById("log_content1");
			if(response.search("XU6J03M6") != -1){
				document.getElementById("loadingIcon").style.display = "none";
				retArea.value = response.replace("XU6J03M6", " ");
				//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
				retArea.scrollTop = retArea.scrollHeight;
				return false;
			}
			
			if(_responseLen == response.length)
				noChange++;
			else
				noChange = 0;
				
			if(noChange > 10){
				document.getElementById("loadingIcon").style.display = "none";
				//retArea.scrollTop = retArea.scrollHeight;
				setTimeout("checkCmdRet();", 1000);
			}else{
				document.getElementById("loadingIcon").style.display = "";
				setTimeout("checkCmdRet();", 1000);
			}
			
			retArea.value = response;
			//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

function buildswitch(){
	$j("#switch").click(
	function(){
		var KCPmode = document.getElementById("KCP_basic_policy").value;
		if(document.getElementById('switch').checked){
			document.form.action_mode.value = ' Refresh ';
			document.getElementById('KCP_basic_enable').value = 1;
			document.getElementById("policy").style.display = "";
			document.getElementById("KCP_status1").style.display = "";
			document.getElementById("basic_show").style.display = "";
			document.getElementById("kcp_show").style.display = "";
			document.getElementById("apply_button").style.display = "";
			$j("#cmdBtn").html("应用所有设置");
		}else{
			document.form.KCP_basic_enable.value = 0;
			//showKCPLoadingBar(8);
			document.form.action_mode.value = ' Refresh ';
			document.form.action = "/applydb.cgi?p=KCP";
			document.form.SystemCmd.value = "kcp_config.sh";
			//if (validForm()){
			//	document.form.submit();
			//}
			document.getElementById("switch").checked = false;
			document.getElementById("policy").style.display = "none";
			document.getElementById("KCP_status1").style.display = "none";
			document.getElementById("basic_show").style.display = "none";
			document.getElementById("kcp_show").style.display = "none";
			document.getElementById("add_fun").style.display = "none";
			$j("#cmdBtn").html("关闭kcptun");
		}
	});
}

function toggle_switch(){
	if (db_KCP['KCP_basic_enable'] == "1"){
		document.getElementById("switch").checked = true;
    	update_visibility();
	} else {
		document.getElementById("switch").checked = false;
		document.getElementById("policy").style.display = "none";
		document.getElementById("KCP_status1").style.display = "none";
		document.getElementById("basic_show").style.display = "none";
		document.getElementById("kcp_show").style.display = "none";
		document.getElementById("add_fun").style.display = "none";
		document.getElementById("apply_button").style.display = "none";
	}
}

function toggle_func(){
	KCPmode = document.form.KCP_basic_policy.value;
	KCPenable = document.form.KCP_basic_enable.value;
	document.form.KCP_basic_action.value = 0;
	$j(".show-btn1").click(
	function(){
		$j('.show-btn1').addClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		$j("#cmdBtn").html("应用所有设置");
		//document.form.action_mode.value = ' Refresh ';
		document.form.KCP_basic_action.value = 0;
		document.getElementById("KCP_basic_policy").disabled = false;
		document.getElementById("kcp_show").style.display = "";
		document.getElementById("gfwlist_dns").style.display = "none";
		document.getElementById("gfwlist_dns_message").style.display = "none";
		document.getElementById("gfwlist_list").style.display = "none";
		document.getElementById("gfwlist_list_message").style.display = "none";
		document.getElementById("chn_dns").style.display = "none";
		document.getElementById("chn_dns_message").style.display = "none";
		document.getElementById("chn_list").style.display = "none";
		document.getElementById("chn_list_message").style.display = "none";
		document.getElementById("add_fun").style.display = "none";
		update_visibility()
	});
		$j(".show-btn2").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').addClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		if(KCPenable == "1"){
			$j("#cmdBtn").html("应用DNS设置");
			document.form.KCP_basic_action.value = 1;
			document.getElementById("KCP_basic_policy").disabled = true;
		} else {
			$j("#cmdBtn").html("应用所有设置");
			document.form.KCP_basic_action.value = 0;
		}
		document.getElementById("kcp_show").style.display = "none";
		if(KCPmode == "1"){
			document.getElementById("gfwlist_dns").style.display = "";
			document.getElementById("gfwlist_dns_message").style.display = "";
			document.getElementById("gfwlist_list").style.display = "none";
			document.getElementById("gfwlist_list_message").style.display = "none";
			document.getElementById("chn_dns").style.display = "none";
			document.getElementById("chn_dns_message").style.display = "none";
			document.getElementById("chn_list").style.display = "none";
			document.getElementById("chn_list_message").style.display = "none";
			document.getElementById("add_fun").style.display = "none";
		} else if (KCPmode == "2"){
			document.getElementById("gfwlist_dns").style.display = "none";
			document.getElementById("gfwlist_dns_message").style.display = "none";
			document.getElementById("gfwlist_list").style.display = "none";
			document.getElementById("gfwlist_list_message").style.display = "none";
			document.getElementById("chn_dns").style.display = "";
			document.getElementById("chn_dns_message").style.display = "";
			document.getElementById("chn_list").style.display = "none";
			document.getElementById("chn_list_message").style.display = "none";
			document.getElementById("add_fun").style.display = "none";
		}
	});
	$j(".show-btn3").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').addClass('active');
		$j('.show-btn4').removeClass('active');
		if(KCPenable == "1"){
			$j("#cmdBtn").html("应用黑白名单设置");
			document.form.KCP_basic_action.value = 2;
			document.getElementById("KCP_basic_policy").disabled = true;
		} else {
			$j("#cmdBtn").html("应用所有设置");
			document.form.KCP_basic_action.value = 0;
		}
		document.getElementById("kcp_show").style.display = "none";
		if(KCPmode == "1"){
			document.getElementById("gfwlist_dns").style.display = "none";
			document.getElementById("gfwlist_dns_message").style.display = "none";
			document.getElementById("gfwlist_list").style.display = "";
			document.getElementById("gfwlist_list_message").style.display = "";
			document.getElementById("chn_dns").style.display = "none";
			document.getElementById("chn_dns_message").style.display = "none";
			document.getElementById("chn_list").style.display = "none";
			document.getElementById("chn_list_message").style.display = "none";
			document.getElementById("add_fun").style.display = "none";
		} else if (KCPmode == "2"){
			document.getElementById("gfwlist_dns").style.display = "none";
			document.getElementById("gfwlist_list").style.display = "none";
			document.getElementById("chn_dns").style.display = "none";
			document.getElementById("chn_dns_message").style.display = "none";
			document.getElementById("chn_list").style.display = "";
			document.getElementById("chn_list_message").style.display = "";
			document.getElementById("add_fun").style.display = "none";
		}
			update_visibility()
	});
	$j(".show-btn4").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').addClass('active');
		if(KCPenable == "1"){
			$j("#cmdBtn").html("应用附加功能设置");
			document.form.KCP_basic_action.value = 3;
			document.getElementById("KCP_basic_policy").disabled = true;
		} else {
			$j("#cmdBtn").html("应用所有设置");
			document.form.KCP_basic_action.value = 0;
		}
		document.getElementById("kcp_show").style.display = "none";
		if(KCPmode == "1"){
			document.getElementById("gfwlist_dns").style.display = "none";
			document.getElementById("gfwlist_dns_message").style.display = "none";
			document.getElementById("gfwlist_list").style.display = "none";
			document.getElementById("gfwlist_list_message").style.display = "none";
			document.getElementById("chn_dns").style.display = "none";
			document.getElementById("chn_dns_message").style.display = "none";
			document.getElementById("chn_list").style.display = "none";
			document.getElementById("chn_list_message").style.display = "none";
			document.getElementById("add_fun").style.display = "";
		} else if (KCPmode == "2"){
			document.getElementById("gfwlist_dns").style.display = "none";
			document.getElementById("gfwlist_list").style.display = "none";
			document.getElementById("chn_dns").style.display = "none";
			document.getElementById("chn_dns_message").style.display = "none";
			document.getElementById("chn_list").style.display = "none";
			document.getElementById("chn_list_message").style.display = "none";
			document.getElementById("add_fun").style.display = "";
		}
			update_visibility()
	});
}

function showKCPLoadingBar(seconds){
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
		LoadingKCPProgress(seconds);
}


function LoadingKCPProgress(seconds){
	document.getElementById("LoadingBar").style.visibility = "visible";

	if (document.form.KCP_basic_enable.value == 0){
		document.getElementById("loading_block3").innerHTML = "KCP服务关闭中 ..."
		$j("#loading_block2").html("<li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>KCP工作有问题？请来我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>反应问题...</font></li>");
	} else {
		if (document.form.KCP_basic_action.value == 0){
			if (document.form.KCP_basic_policy.value == 1){
				document.getElementById("loading_block3").innerHTML = "kcptun - gfwlist模式启用中 ..."
				$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>建议开启虚拟交换内存后使用kcptun模式~</font></li><li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>欢迎到我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>交流...</font></li>");
			} else if (document.form.KCP_basic_policy.value == 2){
				document.getElementById("loading_block3").innerHTML = "kcptun - 大陆白名单模式启用中 ..."
				$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>建议开启虚拟交换内存后使用kcptun模式~</font></li><li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>欢迎到我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>交流...</font></li>");
			}
		} else if (document.form.KCP_basic_action.value == 1){
			document.getElementById("loading_block3").innerHTML = "快速重启DNS服务 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，DNS即可生效~</font></li>");
		} else if (document.form.KCP_basic_action.value == 2){
			document.getElementById("loading_block3").innerHTML = "快速应用黑白名单 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，黑白名单即可生效~</font></li>");
		} else if (document.form.KCP_basic_action.value == 3){
			document.getElementById("loading_block3").innerHTML = "快速应用附加功能 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，附加功能即可生效~</font></li>");
		}
	}
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
			setTimeout("LoadingKCPProgress("+seconds+");", 1000);
		}
		else{
			document.getElementById("proceeding_img_text").innerHTML = "完成";
			y = 0;
				setTimeout("hideKCPLoadingBar();",1000);
				refreshpage()
		}
	}
}

function hideKCPLoadingBar(){
	document.getElementById("LoadingBar").style.visibility = "hidden";
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
<form method="post" name="form" action="/applydb.cgi?p=KCP" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_kcp.asp"/>
<input type="hidden" name="next_page" value="Module_kcp.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="25"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" id="KCP_basic_enable" name="KCP_basic_enable" value="0" />
<input type="hidden" id="KCP_basic_action" name="KCP_basic_action" value="0" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value=""/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<!--=====Beginning of Main Menu=====-->
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
			<!--=====Beginning of Main Content=====-->
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" id="table_for_all" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle" id="KCP_title">kcptun</div>
										
										<div style="float:right; width:15px; height:25px;margin-top:-20px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote" id="head_illustrate"><i>说明：</i>请在下面的<em>kcptun信息</em>表格中填入你的kcptun账号相关信息，点击提交后就能使用代理服务。</br><li>kcptun不等于shadowsocks，你需要自己架设kcptun服务器才能使用。</li><li>建议使用虚拟内存，以确保kcptun更好的运行。&nbsp;&nbsp;<a href='http://koolshare.cn/thread-45023-1-5.html'target='_blank'><i><u>点击了解kcptun</u></i></a>&nbsp;&nbsp;<a style='margin-left: 20px;' href='http://koolshare.cn/thread-45462-1-2.html' target='_blank'><i><u>&nbsp;kcptun服务器端一键安装脚本</u></i></a></div>
										<div id="warn" style="margin-top: 20px;text-align: center;font-size: 18px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:-20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="KCP_switch_table">
											<thead>
											<tr>
												<td colspan="2">开关</td>
											</tr>
											</thead>
											<tr>
											<th id="KCP_switch">kcptun 开关</th>
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
													<div id="KCP_version_show" style="padding-top:5px;margin-left:330px;margin-top:0px;"><i>当前版本：<% dbus_get_def("KCP_basic_version", "未知"); %></i></div>
												</td>

												<tr id ="policy">
													<th width="35%">策略</th>
													<td>
														<select id="KCP_basic_policy" name="KCP_basic_policy" style="width:164px;margin:0px 0px 0px 2px;" class="KCPconfig input_option" onclick="update_visibility();">
															<option value="1">GFWlist模式</option>
															<option value="2">大陆白名单模式</option>
														</select>
													</td>
												</tr>
											</tr>
                                    	</table>
									<div id="KCP_status1">
										<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
											<tr id="KCP_state">
											<th id="mode_state" width="35%">kcptun运行状态</th>
												<td>
													<a>
														<span id="KCP_state2">国外连接 - Waiting...</span>
														<br/>
														<span id="KCP_state3">国内连接 - Waiting...</span>
													</a>
												</td>
											</tr>
										</table>
									</div>
									<div id="basic_show">
										<table style="margin:10px 0px 0px 0px;border-collapse:collapse"  width="100%" height="37px">
									        <tr width="235px">
                                                <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                                    <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="账号设置"/>
                                                    <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="DNS设置"/>
                                                    <input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="黑白名单"/>
                                                    <input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="附加功能"/>
                                                </td>
                                            </tr>
										</table>
									</div>
									<div id="kcp_show">
										<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
											<tr id="server_tr">
												<th width="35%">服务器地址</th>
												<td>
													<input type="text" class="input_KCP_table" id="KCP_basic_server" name="KCP_basic_server" maxlength="100" value=""/>
												</td>
											</tr>
											<tr id="port_tr">
												<th width="35%">服务器端口</th>
												<td>
													<input type="text" class="input_KCP_table" id="KCP_basic_port" name="KCP_basic_port" maxlength="100" value="" />

												</td>
											</tr>
											<tr id="passsord_tr">
												<th width="35%">密码（key）</th>
												<td>
													<input type="password" name="KCP_basic_password" id="KCP_basic_password" class="KCPconfig input_KCP_table" maxlength="100" value=""></input>
													<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.KCP_basic_password);">
														显示密码
													</div>
												</td>
											</tr>

											<tr id="crypte_tr">
												<th width="35%">加密（crypt）</th>
												<td>
													<select id="KCP_basic_crypt" name="KCP_basic_crypt" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
														<option value="aes" selected="">aes</option>
														<option value="aes-128">aes-128</option>
														<option value="aes-192">aes-192</option>
														<option value="salsa20">salsa20</option>
														<option value="blowfish">blowfish</option>
														<option value="twofish">twofish</option>
														<option value="cast5">cast5</option>
														<option value="3des">3des</option>
														<option value="tea">tea</option>
														<option value="xtea">xtea</option>
														<option value="xor">xor</option>
														<option value="none">none</option>
													</select>
												</td>
											</tr>
											<tr id="mode_tr">
												<th width="35%">模式（mode）</th>
												<td>
													<select id="KCP_basic_mode" name="KCP_basic_mode" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
														<option class="content_input_fd" value="normal">normal</option>
														<option class="content_input_fd" value="fast">fast</option>
														<option class="content_input_fd" value="fast2" selected="">fast2</option>
														<option class="content_input_fd" value="fast3">fast3</option>
													</select>
												</td>
											</tr>

											<tr id="nocomp_tr">
												<th width="35%">禁用压缩（nocomp）</th>
												<td>
													<select id="KCP_basic_nocomp" name="KCP_basic_nocomp" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
														<option class="content_input_fd" value="true">true</option>
														<option class="content_input_fd" value="false" selected="">false</option>
													</select>
												</td>
											</tr>

											<tr id="conn_tr">
												<th width="35%">连接数（conn）</th>
												<td>
													<input type="text" name="KCP_basic_conn" id="KCP_basic_conn" class="input_KCP_table" maxlength="100" value="1"></input>
												</td>
											</tr>


											<tr id="mtu_tr">
												<th width="35%">mtu</th>
												<td>
													<input type="text" name="KCP_basic_mtu" id="KCP_basic_mtu" class="input_KCP_table" maxlength="100" value="1350"></input>
												</td>
											</tr>

											<tr id="sndwnd_tr">
												<th width="35%">sndwnd</th>
												<td>
													<input type="text" name="KCP_basic_sndwnd" id="KCP_basic_sndwnd" class="input_KCP_table" maxlength="100" value="128"></input>
												</td>
											</tr>


											<tr id="rcvwnd _tr">
												<th width="35%">rndwnd</th>
												<td>
													<input type="text" name="KCP_basic_rndwnd" id="KCP_basic_rndwnd" class="input_KCP_table" maxlength="100" value="1024"></input>
												</td>
											</tr>

											<tr id="sdcp _tr">
												<th width="35%">dscp</th>
												<td>
													<input type="text" name="KCP_basic_dscp" id="KCP_basic_dscp" class="input_KCP_table" maxlength="100" value="0"></input>
												</td>
											</tr>
											
										</table>
									</div>

										<div id="gfwlist_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th id="china_dns" width="20%">选择国内DNS</th>
													<td>
														<select id="KCP_gfwlist_cdn_dns" name="KCP_gfwlist_cdn_dns" class="input_option" onclick="update_visibility();" >
															<option value="1" selected="">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
															<input type="text" class="input_KCP_table" id="KCP_gfwlist_cdn_dns_user" name="KCP_gfwlist_cdn_dns_user" maxlength="100" value="">
															<span id="show_isp_dns_gfwlist">【<% nvram_get("wan0_dns"); %>】</span>
													</td>
												</tr>
												<tr>
													<th width="20%">选择国外DNS</th>
													<td>
														<select id="KCP_gfwlist_foreign_dns" name="KCP_gfwlist_foreign_dns" class="input_option" onclick="update_visibility();" >
															<option value="2">DNS2SOCKS</option>
															<option value="0">dnscrypt-proxy</option>
															<option value="3">Pcap_DNSProxy</option>
															<option value="4">pdnsd</option>
														</select>
														<select id="KCP_gfwlist_opendns" name="KCP_gfwlist_opendns" class="input_option"></select>
															<input type="text" class="input_KCP_table" id="KCP_gfwlist_dns2socks_user" name="KCP_gfwlist_dns2socks_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="208.67.220.220:53">
															</span>
													</td>
												</tr>
												<tr id="pdnsd_method_gfwlist">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="KCP_gfwlist_pdnsd_method" name="KCP_gfwlist_pdnsd_method" class="input_option" onclick="update_visibility();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_tcp_gfwlist">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
													<td>
														<input type="text" class="input_KCP_table" id="KCP_gfwlist_pdnsd_server_ip" name="KCP_gfwlist_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="input_KCP_table" id="KCP_gfwlist_pdnsd_server_port" name="KCP_gfwlist_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_udp_gfwlist">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
													<td>
														<select id="KCP_gfwlist_pdnsd_udp_server" name="KCP_gfwlist_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															
														</select>
														<input type="text" class="input_KCP_table" id="KCP_gfwlist_pdnsd_udp_server_dns2socks" name="KCP_gfwlist_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="208.67.220.220:53">
														<select id="KCP_gfwlist_pdnsd_udp_server_dnscrypt" name="KCP_gfwlist_pdnsd_udp_server_dnscrypt" class="input_option"></select>
													</td>
												</tr>
												<tr id="pdnsd_cache_gfwlist">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
													<td>
														<input type="text" class="input_KCP_table" id="KCP_gfwlist_pdnsd_server_cache_min" name="KCP_gfwlist_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="input_KCP_table" id="KCP_gfwlist_pdnsd_server_cache_max" name="KCP_gfwlist_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
													
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
bogus-nxdomain=220.250.64.18
" rows=8 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_gfwlist_dnsmasq" name="KCP_gfwlist_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>
 										<div id="gfwlist_dns_message" style="display: none;margin-top: 10px;text-align: left;margin-bottom: 20px;"class="formfontdesc" >*点击<i>应用DNS设置</i>按钮，快速重启gfwlist模式的DNS服务</div>

										<div id="gfwlist_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="20%">域名白名单</th>
													<td>
														<textarea placeholder="# 此处填入不需要走kcptun的域名，一行一个，格式如下：
google.com.sg
youtube.com
# 默认gfwlist以外的域名都不会走ss，故添加gfwlist内的域名才有意义!
# 屏蔽一个域名可能导致其他网址被屏蔽，例如解析结果一致的youtube.com和google.com.
# 只有域名污染，没有IP未阻断的网站，不能被屏蔽，例如twitter.com." rows=8 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_gfwlist_white_domain_web" name="KCP_gfwlist_white_domain_web" title=""></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%">域名黑名单
														<br/>
														<br/>
														<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank">
														</a>
													</th>
													<td>
														<textarea placeholder="# 此处填入需要强制走kcptun的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经由gfwlist提供了上千条被墙域名，请勿重复添加!" rows=8 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_gfwlist_black_domain_web" name="KCP_gfwlist_black_domain_web" title=""></textarea>
													</td>
												</tr>


												<tr>
													<th width="20%">IP黑名单
														<br/>
														<br/>
														<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank">
														</a>
													</th>
													<td>
														<textarea placeholder="# 此处填入需要强制走kcptun的IP或IP段（CIDR格式），一行一个，格式如下：
137.252.248.76
149.154.167.80
110.120.130.0/24
223.240.0.0/16
# 对于某些没有域名但是被墙的服务很有用处，比如telegram等!" rows=8 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_gfwlist_black_ip" name="KCP_gfwlist_black_ip" title=""></textarea>
													</td>
												</tr>

												
											</table>
										</div>
										<div id="gfwlist_list_message" style="display: none;margin-top: 10px;text-align: left;margin-bottom: 20px;"class="formfontdesc" >*点击<i>应用黑白名单设置</i>按钮，快速应用gfwlist模式的黑白名单设置</div>
										<div id="chn_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="dns_plan_china">
													<th width="20%">选择国内DNS</th>
													<td>
														<select id="KCP_chnmode_dns_china" name="KCP_chnmode_dns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_dns_china_user" name="KCP_chnmode_dns_china_user" maxlength="100" value="">
														<span id="show_isp_dns_chnmode">【<% nvram_get("wan0_dns"); %>】</span> <br/>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
													<th width="20%">选择国外DNS</th>
													<td>
														<select id="KCP_chnmode_dns_foreign" name="KCP_chnmode_dns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="4">DNS2SOCKS</option>
															<option value="1">dnscrypt-proxy</option>
															<option value="3">ChinaDNS</option>
															<option value="5">Pcap_DNSProxy</option>
															<option value="6">pdnsd</option>
														</select>
														<select id="KCP_chnmode_opendns" name="KCP_chnmode_opendns" class="input_option">
														<input type="text" class="input_KCP_table" id="KCP_chnmode_dns2socks_user" name="KCP_chnmode_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="208.67.220.220:53">
													</td>
												</tr>
												<tr id="chinadns_china">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font></th>
													<td>
														<select id="KCP_chnmode_chinadns_china" name="KCP_chnmode_chinadns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS【114.114.114.114】</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_chinadns_china_user" name="KCP_chnmode_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="chinadns_foreign">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS (DNS2SOCKS)</font></th>
													<td>
														<select id="KCP_chnmode_chinadns_foreign" name="KCP_chnmode_chinadns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Google DNS1 [8.8.8.8]</option>
															<option value="3">Google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_chinadns_foreign_user" name="KCP_chnmode_chinadns_foreign_user" maxlength="100" value="">
													</td>
												</tr>
												<tr id="pdnsd_method_chnmode">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="KCP_chnmode_pdnsd_method" name="KCP_chnmode_pdnsd_method" class="input_option" onclick="update_visibility();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_tcp_chnmode">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
													<td>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_pdnsd_server_ip" name="KCP_chnmode_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="input_KCP_table" id="KCP_chnmode_pdnsd_server_port" name="KCP_chnmode_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_udp_chnmode">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
													<td>
														<select id="KCP_chnmode_pdnsd_udp_server" name="KCP_chnmode_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
														</select>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_pdnsd_udp_server_dns2socks" name="KCP_chnmode_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="208.67.220.220:53">
														<select id="KCP_chnmode_pdnsd_udp_server_dnscrypt" name="KCP_chnmode_pdnsd_udp_server_dnscrypt" class="input_option"></select>
													</td>
												</tr>
												<tr id="pdnsd_cache_chnmode">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
													<td>
														<input type="text" class="input_KCP_table" id="KCP_chnmode_pdnsd_server_cache_min" name="KCP_chnmode_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="input_KCP_table" id="KCP_chnmode_pdnsd_server_cache_max" name="KCP_chnmode_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="pdnsd2">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
													<th width="20%">自定义需要CDN加速网站<br>
														<br>
														<font color="#ffcc00">强制域名用国内DNS解析</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制用国内DNS解析的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经添加了1万多条国内域名，请勿重复添加！
# 注意：不支持通配符！" cols="50" rows=8 id="KCP_chnmode_isp_website_web" name="KCP_chnmode_isp_website_web" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
												<th width="20%">自定义dnsmasq</th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=8 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="KCP_chnmode_dnsmasq" name="KCP_chnmode_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>
										<div id="chn_dns_message" style="display: none;margin-top: 10px;text-align: left;margin-bottom: 20px;"class="formfontdesc" >*点击<i>应用DNS设置</i>按钮，快速重启大陆白名单模式的DNS服务</div>
										<div id="chn_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
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
# 因为默认大陆的ip都不会走SS，所以此处填入国外IP/CIDR更有意义！" cols="50" rows="7" id="KCP_chnmode_wan_white_ip" name="KCP_chnmode_wan_white_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
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
# 需要清空电脑DNS缓存，才能立即看到效果。"cols="50" rows=7 id="KCP_chnmode_wan_white_domain" name="KCP_chnmode_wan_white_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
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
# 因为默认大陆以外ip都会走SS，所以此处填入国内IP/CIDR更有意义！" cols="50" rows="7" id="KCP_chnmode_wan_black_ip" name="KCP_chnmode_wan_black_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
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
# 需要清空电脑DNS缓存，才能立即看到效果。"cols="50" rows=7 id="KCP_chnmode_wan_black_domain" name="KCP_chnmode_wan_black_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
											</table>
										</div>
										
										<div id="add_fun" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >		
												<tr>
													<th>查看日志信息</th>
													<td>
														<input class="button_gen" id="logBtn" onclick="show_log_info()" type="button" value="查看日志"/>
													</td>
												</tr>

												<tr id="chromecast">
													<th width="35%">Chromecast支持</th>
													<td>
														<select id="KCP_basic_chromecast" name="KCP_basic_chromecast" class="KCPconfig input_option" onclick="update_visibility();">
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="chromecast1"> 建议开启chromecast支持 </span>
													</td>
												</tr>
												<tr id="guardian">
													<th width="35%">kcutun进程守护</th>
													<td>
														<select id="KCP_basic_guardian" name="KCP_basic_guardian" class="KCPconfig input_option" onclick="update_visibility();">
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="guardian1"> 开启后将使用perp对kcp_router进程实时守护 </span>
													</td>
												</tr>
												<tr id="KCP_sleep_tr">
													<th width="35%">开机启动延时</th>
													<td>
														<select id="KCP_basic_sleep" name="KCP_basic_sleep" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">0s</option>
															<option value="5">5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
												<tr id="KCP_lan_control">
													<th width="35%">局域网客户端控制&nbsp;&nbsp;&nbsp;&nbsp;<select id="KCP_basic_lan_control" name="KCP_basic_lan_control" class="input_KCP_table" style="width:auto;height:25px;margin-left: 0px;" onchange="update_visibility();">
															<option value="0">禁用</option>
															<option value="1">黑名单模式</option>
															<option value="2">白名单模式</option>
														</select>
													</th>
													<td>
															<textarea placeholder="填入需要限制客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_basic_black_lan" name="KCP_basic_black_lan" title=""></textarea>
															<textarea placeholder="填入仅允许的客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="KCP_basic_white_lan" name="KCP_basic_white_lan" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--log_content-->
										<div id="log_content" style="margin-top:10px;display: none;">
											<textarea cols="63" rows="30" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;"></textarea>
										</div>

										<div class="apply_gen" id="loading_icon">
											<img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif">
										</div>
										<div id="return_button" class="apply_gen" style="display: none;">
											<input class="button_gen" id="returnBtn" onClick="return_basic()" type="button" value="返回"/>
										</div>

										
										<div id="chn_list_message" style="display: none;margin-top: 10px;text-align: left;margin-bottom: 20px;"class="formfontdesc" >*点击<i>应用黑白名单设置</i>按钮，快速应用大陆白名单模式的黑白名单</div>
										<div id="apply_button"class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl()">提交</button>
										</div>
 										<div id="warn1" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"><i>你开启了shadowsocks,请先关闭后才能开启kcptun</i></div>
										<div id="line_image2" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div class="KoolshareBottom">
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

