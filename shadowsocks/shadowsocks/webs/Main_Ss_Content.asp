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
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/res/shadowsocks.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>
<script type="text/javascript" src="/dbconf?p=ss&v=<% uptime(); %>"></script>
<script>
var socks5 = 0
var isMenuopen = 0;
var _responseLen;
var noChange = 0;
var noChange2 = 0;
var node_global_max = 0;
var myid;

function init() {
	show_menu(menu_hook);
	generate_options();
	buildswitch();
	toggle_switch();
	update_ss_ui(db_ss);
	loadAllConfigs();
	decode_show();
	toggle_func();
	detect_JFFS2();
	version_show();
	hook_event();
	setTimeout("get_ss_status_data()", 500);
}

function detect_JFFS2() {
	var jffs2_scripts = '<% nvram_get("jffs2_scripts"); %>';
	if (jffs2_scripts == "0") {
		E("warn").style.display = "";
		$("#warn").html("<i>发现Enable JFFS custom scripts and configs选项未开启！</br></br>请开启并重启路由器后才能正常使用SS。<a href='/Advanced_System_Content.asp'><em><u> 前往设置 </u></em></a> </i>");
		E("ss_basic_enable").checked = false;
		$("#ss_basic_enable").attr("disabled", "true");
	}
}

function hook_event() {
	$("#mode_state").attr("cursor", "pointer");
	$("#mode_state").click(
		function() {
		pop_111();
	});
}

function pop_111() {
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 2,
			shade: .7,
			scrollbar: 0,
			title: '国内外分流信息:ip111.cn',
			area: ['750px', '466px'],
			//offset: ['355px', '368px'],
			fixed: false, //不固定
			maxmin: true,
			shadeClose: 1,
			id: 'LAY_layuipro',
			btnAlign: 'c',
			content: ['http://ip111.cn/', 'no'],
		});
	});
}

function pop_changelog() {
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 2,
			shade: .7,
			//scrollbar: 0,
			title: '科学上网插件 - 更新日志',
			area: ['950px', '600px'],
			fixed: true, //不固定
			maxmin: true,
			shadeClose: 1,
			id: 'LAY_layuipro1',
			btnAlign: 'c',
			content: 'https://koolshare.ngrok.wang/shadowsocks/Changelog.txt',
		});
	});
}

function pop_help() {
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 1,
			title: false,
			closeBtn: false,
			area: '600px;',
			//offset: ['355px', '443px'],
			shade: 0.8,
			shadeClose: 1,
			scrollbar: false,
			id: 'LAY_layuipro',
			btn: ['关闭窗口'],
			btnAlign: 'c',
			moveType: 1,
			content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">\
				<b>梅林固件 - 科学上网插件 - ' + db_ss["ss_basic_version_local"] + '</b><br><br>\
				本插件是支持SS、SSR、koolgame三种客户端的科学上网、游戏加速工具。<br>\
				使用本插件中有任何问题，可以前往<a style="color:#e7bd16" target="_blank" href="https://github.com/koolshare/koolshare.github.io/issues"><u>github的issue页面</u></a>反馈~<br><br>\
				● SS/SSR一键脚本：<a style="color:#e7bd16" target="_blank" href="https://github.com/onekeyshell/kcptun_for_ss_ssr"><u>一键安装KCPTUN for SS/SSR on Linux</u></a><br>\
				● koolgame一键脚本：<a style="color:#e7bd16" target="_blank" href="https://github.com/clangcn/game-server"><u>一键安装koolgame服务器端脚本，完美支持nat2</u></a><br>\
				● 插件交流：<a style="color:#e7bd16" target="_blank" href="https://t.me/joinchat/AAAAAEC7pgV9vPdPcJ4dJw"><u>加入telegram群组</u></a><br><br>\
				我们的征途是星辰大海 ^_^</div>'
		});
	});
}

function pop_node_add() {
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 0,
			shade: 0.8,
			title: '警告',
			time: 0,
			//area: ['390px', '330px'],
			maxmin: true,
			content: '你尚未添加任何节点信息！<br /> 点击下面按钮添加节点信息！',
			btn: ['手动添加', '订阅节点', '恢复配置'],
			yes: function() {
				$("#show_btn1_1").trigger("click");
				setTimeout("pop_tip1()", 600);
				//layer.closeAll();
				layer.msg('请选择需要添加的节点类型', {
					shade: 0.2,
					time: 20000, //20s后自动关闭
					area: ['450px'],
					btn: ['添加ss节点', '添加ssr节点', '添加koolgame节点'],
					btnAlign: 'c',
					btn1: function(index, layero) {
						setTimeout("Add_profile();", 300);
						setTimeout("tabclickhandler(0);", 320);
						layer.closeAll();
					},
					btn2: function(index, layero) {
						setTimeout("Add_profile();", 300);
						setTimeout("tabclickhandler(1);", 320);
					},
					btn3: function(index, layero) {
						setTimeout("Add_profile();", 300);
						setTimeout("tabclickhandler(2);", 320);
					}
				});
			},
			btn2: function() {
				$("#show_btn4").trigger("click");
			},
			btn3: function() {
				$("#show_btn6").trigger("click");
			},
		});

	});
}

function pop_tip1() {
	layer.tips('以后需要添加节点，可以点击此按钮！', '#add_ss_node', {
		tips: [1, '#3595CC'],
		time: 0
	});
}

function save() {
	var node_sel = E("ssconf_basic_node").value
	if (!node_sel) {
		alert("你尚未定义任何节点，提交失败！");
		return false
	}
	//stop check status
	checkss = 10001;
	E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
	E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
	//remove blank before string
	E("ss_basic_server").value = $.trim($("#ss_basic_server").val());
	E("ss_basic_port").value = $.trim($("#ss_basic_port").val());
	E("ss_basic_password").value = $.trim($("#ss_basic_password").val());
	//define dbus obkect to save
	var dbus = {};
	dbus["SystemCmd"] = "ss_config.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	//key define
	var params_input = ["ssconf_basic_node", "ss_basic_mode", "ss_basic_server", "ss_basic_port", "ss_basic_method", "ss_basic_koolgame_udp", "ss_basic_ss_obfs", "ss_basic_ss_obfs_host", "ss_basic_rss_protocol", "ss_basic_rss_protocol_param", "ss_basic_rss_obfs", "ss_basic_rss_obfs_param", "ssconf_basic_ping_node", "ssconf_basic_ping_method", "ssconf_basic_test_node", "ssconf_basic_test_domain", "ss_dns_plan", "ss_dns_china", "ss_dns_china_user", "ss_dns_foreign", "ss_opendns", "ss_dns2socks_user", "ss_sstunnel", "ss_sstunnel_user", "ss_game2_dns_foreign", "ss_game2_dns2ss_user", "ss_chinadns_china", "ss_chinadns_china_user", "ss_chinadns_foreign_method", "ss_chinadns_foreign_method_user", "ss_chinadns_foreign_dns2socks", "ss_chinadns_foreign_dns2socks_user", "ss_chinadns_foreign_dnscrypt", "ss_chinadns_foreign_sstunnel", "ss_chinadns_foreign_sstunnel_user", "ss_pdnsd_method", "ss_pdnsd_server_ip", "ss_pdnsd_server_port", "ss_pdnsd_udp_server", "ss_pdnsd_udp_server_dns2socks", "ss_pdnsd_udp_server_dnscrypt", "ss_pdnsd_udp_server_ss_tunnel", "ss_pdnsd_udp_server_ss_tunnel_user", "ss_pdnsd_server_cache_min", "ss_pdnsd_server_cache_max", "ss_basic_chromecast", "ss_basic_dnslookup", "ss_basic_dnslookup_server", "ss_basic_kcp_port", "ss_basic_kcp_parameter", "ss_basic_rule_update", "ss_basic_rule_update_time", "ssr_subscribe_mode", "ssr_subscribe_obfspara", "ssr_subscribe_obfspara_val", "ss_basic_online_links_goss", "ss_basic_node_update", "ss_basic_node_update_day", "ss_basic_node_update_hr", "ss_base64_links", "ss_basic_refreshrate", "ss_basic_sleep", "ss_acl_default_port", "ss_online_action", "ss_acl_default_mode"];
	var params_check = ["ss_basic_enable", "ss_basic_use_kcp", "ss_basic_gfwlist_update", "ss_basic_chnroute_update", "ss_basic_cdn_update", "ss_basic_pcap_update"];
	var params_base64 = ["ss_basic_password", "ss_isp_website_web", "ss_dnsmasq", "ss_wan_white_ip", "ss_wan_white_domain", "ss_wan_black_ip", "ss_wan_black_domain", "ss_online_links"];
	// collect data from input
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i])) {
			dbus[params_input[i]] = E(params_input[i]).value;
		}
	}
	// collect data from checkbox
	for (var i = 0; i < params_check.length; i++) {
		dbus[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	// data need base64 encode
	for (var i = 0; i < params_base64.length; i++) {
		if (!E(params_base64[i]).value) {
			dbus[params_base64[i]] = "";
		} else {
			if (E(params_base64[i]).value.indexOf(".") != -1) {
				dbus[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
			} else {
				//乱码了
				dbus[params_base64[i]] = "";
			}
			dbus["ss_basic_password"] = Base64.encode(E("ss_basic_password").value);
		}
	}
	// write node data under using from the main pannel incase of data change
	var params = ["server", "mode", "port", "method", "ss_obfs", "ss_obfs_host", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param", "koolgame_udp"];
	for (var i = 0; i < params.length; i++) {
		dbus["ssconf_basic_" + params[i] + "_" + node_sel] = E("ss_basic_" + params[i]).value;
	}
	dbus["ssconf_basic_password_" + node_sel] = Base64.encode(E("ss_basic_password").value);
	dbus["ssconf_basic_use_kcp_" + node_sel] = E("ss_basic_use_kcp").checked ? '1' : '0';
	// collect values in acl table
	maxid = parseInt($("#ACL_table > tbody > tr:eq(-2) > td:nth-child(2) > input").attr("id").split("_")[3]);
	for ( var i = 1; i <= maxid; ++i ) {
		if (E("ss_acl_name_" + i)){
			dbus["ss_acl_name_" + i] = E("ss_acl_name_" + i).value;
			dbus["ss_acl_mode_" + i] = E("ss_acl_mode_" + i).value;
			dbus["ss_acl_port_" + i] = E("ss_acl_port_" + i).value;
		}
	}
	// adjust some value
	if (db_ss["ssconf_basic_rss_protocol_" + node_sel]) {
		console.log("use ssr");
		dbus["ssconf_basic_ss_obfs_" + node_sel] = "";
		dbus["ssconf_basic_ss_obfs_host_" + node_sel] = "";
		dbus["ssconf_basic_koolgame_udp_" + node_sel] = "";
		dbus["ss_basic_ss_obfs"] = "";
		dbus["ss_basic_ss_obfs_host"] = "";
		dbus["ss_basic_koolgame_udp"] = "";
	} else {
		if (db_ss["ssconf_basic_koolgame_udp_" + node_sel]) {
			console.log("use v2");
			dbus["ssconf_basic_ss_obfs_" + node_sel] = "";
			dbus["ssconf_basic_ss_obfs_host_" + node_sel] = "";
			dbus["ssconf_basic_rss_protocol_" + node_sel] = "";
			dbus["ssconf_basic_rss_protocol_param_" + node_sel] = "";
			dbus["ssconf_basic_rss_obfs_" + node_sel] = "";
			dbus["ssconf_basic_rss_obfs_param_" + node_sel] = "";
			dbus["ss_basic_ss_obfs"] = "";
			dbus["ss_basic_ss_obfs_host"] = "";
			dbus["ss_basic_rss_protocol"] = "";
			dbus["ss_basic_rss_protocol_param"] = "";
			dbus["ss_basic_rss_obfs"] = "";
			dbus["ss_basic_rss_obfs_param"] = "";
		} else {
			console.log("use ss");
			dbus["ssconf_basic_rss_protocol_" + node_sel] = "";
			dbus["ssconf_basic_rss_protocol_param_" + node_sel] = "";
			dbus["ssconf_basic_rss_obfs_" + node_sel] = "";
			dbus["ssconf_basic_rss_obfs_param_" + node_sel] = "";
			dbus["ssconf_basic_koolgame_udp_" + node_sel] = "";
			dbus["ss_basic_rss_protocol"] = "";
			dbus["ss_basic_rss_protocol_param"] = "";
			dbus["ss_basic_rss_obfs"] = "";
			dbus["ss_basic_rss_obfs_param"] = "";
			dbus["ss_basic_koolgame_udp"] = "";
		}
	}
	if (E("ss_basic_enable").checked) {
		if (E("ss_basic_mode").value == "1") {
			db_ss["ss_basic_action"] = "1";
		} else if (E("ss_basic_mode").value == "2") {
			db_ss["ss_basic_action"] = "2";
		} else if (E("ss_basic_mode").value == "3") {
			db_ss["ss_basic_action"] = "3";
		} else if (E("ss_basic_mode").value == "5") {
			db_ss["ss_basic_action"] = "5";
		} else if (E("ss_basic_mode").value == "6") {
			db_ss["ss_basic_action"] = "6";
		}
	} else {
		db_ss["ss_basic_action"] = "0";
	}
	push_data(dbus);
}

function push_data(obj) {
	$.ajax({
		type: "POST",
		url: '/applydb.cgi?p=ss',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(obj),
		error: function(xhr) {
			console.log("error");
		},
		success: function(response) {
			showSSLoadingBar();
			noChange2 = 0;
			setTimeout("get_realtime_log();", 500);
		}
	});
}

function decode_show() {
	var temp_ss = ["ss_isp_website_web", "ss_dnsmasq", "ss_wan_white_ip", "ss_wan_white_domain", "ss_wan_black_ip", "ss_wan_black_domain", "ss_online_links"];
	for (var i = 0; i < temp_ss.length; i++) {
		temp_str = E(temp_ss[i]).value;
		E(temp_ss[i]).value = Base64.decode(temp_str);
	}
}

function update_ss_ui(obj) {
	//console.log("update_ss_ui");
	var node_sel = obj["ssconf_basic_node"];
	//console.log(node_sel);
	for (var field in obj) {
		var el = E(field);
		if (field == "ss_basic_server" || field == "ss_basic_mode" || field == "ss_basic_port" || field == "ss_basic_password" || field == "ss_basic_method" || field == "ss_basic_ss_obfs" || field == "ss_basic_ss_obfs_host" || field == "ss_basic_koolgame_udp" || field == "ss_basic_rss_protocol" || field == "ss_basic_rss_protocol_param" || field == "ss_basic_rss_obfs" || field == "ss_basic_rss_obfs_param" || field == "ss_basic_rss_use_kcp") {
			var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param", "use_kcp", "ss_obfs", "ss_obfs_host", "koolgame_udp"];
			for (var i = 0; i < params.length; i++) {
				if (!db_ss["ssconf_basic_" + params[i] + "_" + node_sel]) {
					$("#ss_basic_" + params[i]).val("");
				} else {
					$("#ss_basic_" + params[i]).val(db_ss["ssconf_basic_" + params[i] + "_" + node_sel]);
				}
			}
			continue;
		} else if (el != null && el.getAttribute("type") == "checkbox") {
			//console.log(field)
			if (obj[field] != "1") {
				el.checked = false;
			} else {
				el.checked = true;
			}
			continue;
		}
		if (el != null) {
			el.value = obj[field];
		}
	}
	E("ss_basic_password").value = Base64.decode(E("ss_basic_password").value);
}

function update_visibility_main(r) {
	//console.log("update_visibility_main")
	var node_sel = E("ssconf_basic_node").value;
	var ssr_on = typeof(db_ss["ssconf_basic_rss_protocol_" + node_sel]) != "undefined"; //use ssr
	var koolgame_on = typeof(db_ss["ssconf_basic_koolgame_udp_" + node_sel]) != "undefined"; //use ssr
	var ssmode = E("ss_basic_mode").value;
	var suk = E("ss_basic_use_kcp").checked ? '1' : '0';

	if (db_ss["ss_basic_mode"] == "0") {
		$("#mode_state").html("运行状态");
	} else if (db_ss["ss_basic_mode"] == "1") {
		$("#mode_state").html("运行状态【gfwlist模式】");
	} else if (db_ss["ss_basic_mode"] == "2") {
		$("#mode_state").html("运行状态【大陆白名单模式】");
	} else if (db_ss["ss_basic_mode"] == "3") {
		$("#mode_state").html("运行状态【游戏模式】");
	} else if (db_ss["ss_basic_mode"] == "5") {
		$("#mode_state").html("运行状态【全局模式】");
	} else if (db_ss["ss_basic_mode"] == "6") {
		$("#mode_state").html("运行状态【回国模式】");
	}

	showhide("ss_state1", (ssmode == "0"));
	showhide("ss_state2", (ssmode != "0"));
	showhide("ss_state3", (ssmode != "0"));
	showhide("dns_plan_foreign", !koolgame_on);
	showhide("dns_plan_foreign_game2", koolgame_on);
	//---------
	//ss-libev
	if (!E("ss_basic_ss_obfs").value) {
		E("ss_basic_ss_obfs").value = "0"
	}
	showhide("ss_obfs", (ssr_on == "0" && !koolgame_on && suk != "1"));
	showhide("ss_obfs_host", (ssr_on == "0" && !koolgame_on && suk != "1" && E("ss_basic_ss_obfs").value != "0"));
	//ssr-libev
	if (r == undefined) {
		//showhide("ss_basic_rss_protocol_param_tr", (ssr_on == "1" && !koolgame_on && E("ss_basic_rss_protocol_param").value != ""));
		showhide("ss_basic_rss_protocol_param_tr", (ssr_on == "1" && !koolgame_on));
	} else if (r == 0 || r == 1 || r == 2) {
		showhide("ss_basic_rss_protocol_param_tr", (ssr_on == "1" && !koolgame_on));
	}
	showhide("ss_basic_rss_protocol_tr", (ssr_on == "1" && !koolgame_on));
	showhide("ss_basic_rss_obfs_tr", (ssr_on == "1" && !koolgame_on));
	showhide("ss_basic_ticket_tr", (ssr_on == "1" && !koolgame_on));
	//koolgame
	showhide("ss_koolgame_udp_tr", koolgame_on);
	//showhide("mode_select", !koolgame_on);
	//---------
	//游戏模式和koolgame不支持kcp加速，不显示开启kcp加速的开关
	showhide("show_btn3_1", (ssmode != "3" && E("ss_basic_ss_obfs").value == "0"));
	//节点新增编辑窗口
	if (save_flag == "shadowsocks") {
		showhide("ss_obfs_support", ($("#ss_node_table_mode").val() != "3"));
		showhide("ss_obfs_host_support", ($("#ss_node_table_mode").val() != "3" && $("#ss_node_table_ss_obfs").val() != "0"));
	}
	refresh_acl_table();
}

function update_visibility_tab4() {
	var a = E("ss_basic_rule_update").value == "1";
	var b = E("ss_basic_dnslookup").value == "1";
	var c = E("ss_basic_node_update").value == "1";
	var d = E("ssr_subscribe_obfspara").value == "2";
	showhide("ss_basic_rule_update_time", a);
	showhide("update_choose", a);
	showhide("ss_basic_dnslookup_server", b);
	showhide("ss_basic_node_update_day", c);
	showhide("ss_basic_node_update_hr", c);
	showhide("ssr_subscribe_obfspara_val", d);
}

function update_visibility_tab2() {
	var ssmode = E("ss_basic_mode").value;
	var rdc = E("ss_dns_china").value;
	var rdf = E("ss_dns_foreign").value;
	var rs = E("ss_sstunnel").value;
	var rcc = E("ss_chinadns_china").value;
	var rcfm = E("ss_chinadns_foreign_method").value;
	var srpm = E("ss_pdnsd_method").value;
	
	showhide("show_isp_dns", (rdc == "1"));
	showhide("ss_dns_china_user", (rdc == "12"));
	showhide("ss_dns2socks_user", (rdf == "1"));
	showhide("ss_sstunnel", (rdf == "2"));
	showhide("ss_sstunnel_user", ((rdf == "2") && (rs == "4")));
	showhide("ss_opendns", (rdf == "3"));
	showhide("chinadns_china", (rdf == "5"));
	showhide("chinadns_foreign", (rdf == "5"));
	showhide("ss_chinadns_china_user", (rcc == "11"));
	showhide("pdnsd_up_stream_tcp", (rdf == "4" && srpm == "2"));
	showhide("pdnsd_up_stream_udp", (rdf == "4" && srpm == "1"));
	showhide("ss_pdnsd_udp_server_dns2socks", (rdf == "4" && srpm == "1" && E("ss_pdnsd_udp_server").value == 1));
	showhide("ss_pdnsd_udp_server_dnscrypt", (rdf == "4" && srpm == "1" && E("ss_pdnsd_udp_server").value == 2));
	showhide("ss_pdnsd_udp_server_ss_tunnel", (rdf == "4" && srpm == "1" && E("ss_pdnsd_udp_server").value == 3));
	showhide("ss_pdnsd_udp_server_ss_tunnel_user", (rdf == "4" && srpm == "1" && E("ss_pdnsd_udp_server").value == 3 && E("ss_pdnsd_udp_server_ss_tunnel").value == 4));
	showhide("pdnsd_cache", (rdf == "4"));
	showhide("pdnsd_method", (rdf == "4"));
	showhide("ss_chinadns_foreign_dns2socks", (rcfm == "1"));
	showhide("ss_chinadns_foreign_dnscrypt", (rcfm == "2"));
	showhide("ss_chinadns_foreign_sstunnel", (rcfm == "3"));
	showhide("ss_chinadns_foreign_dns2socks_user", (rcfm == "1" && E("ss_chinadns_foreign_dns2socks").value == 4));
	showhide("ss_chinadns_foreign_sstunnel_user", (rcfm == "3" && E("ss_chinadns_foreign_sstunnel").value == 4));
	showhide("ss_chinadns_foreign_method_user", (rcfm == "4"));
	showhide("ss_chinadns_foreign_method_user_txt", (rcfm == "4"));
	showhide("dns_note", (ssmode == "6"));

	if (rdf == "5") {
		E("ss_dns_china").style.display = "none";
		E("ss_dns_china_user").style.display = "none";
		E("ss_isp_website_web").style.display = "none";
		E("show_isp_dns").style.display = "";
		$("#show_isp_dns").html("ChinaDNS方案自带国内cdn加速，请在ChinaDNS国内DNS选取国内DNS");
		$("#user_cdn_span").html("ChinaDNS方案自带国内cdn加速，无需定义cdn加速名单");
	} else if (rdf == "6") {
		E("ss_dns_china").style.display = "none";
		E("ss_dns_china_user").style.display = "none";
		E("ss_isp_website_web").style.display = "none";
		E("show_isp_dns").style.display = "";
		$("#show_isp_dns").html("Pcap_DNSProxy方案自带国内cdn加速，无需定义国内DNS");
		$("#user_cdn_span").html("Pcap_DNSProxy方案自带国内cdn加速，无需定义cdn加速名单");
	} else {
		E("ss_dns_china").style.display = "";
		showhide("ss_dns_china_user", (rdc == "12"));
		showhide("show_isp_dns", (rdc == "1"));
		E("ss_isp_website_web").style.display = "";
		$("#show_isp_dns").html("");
		$("#user_cdn_span").html("");
	}

	if (E("ss_dns_plan").value == "1") {
		$("#ss_dns_plan_note").html("国外dns解析gfwlist名单内的国外域名，剩下的域名用国内dns解析。");
	} else if (E("ss_dns_plan").value == "2") {
		$("#ss_dns_plan_note").html("国内dns解析cdn名单内的国内域名，剩下的域名用国外dns解析。");
	}
}

function generate_lan_list() {
	ipaddr = "<% nvram_get("
	lan_ipaddr "); %>";
	var ips = ipaddr.split(".");
	ip = ips[0] + "." + ips[1] + "." + ips[2] + ".";
	for (var i = 2; i < 255; i++) {
		$("#ss_acl_ip").append("<option value='" + ip + i + "'>" + ip + i + "</option>");
	}
}

function generate_options() {
	var confs = [
		["adguard-dns-family-ns1 ", "Adguard DNS Family Protection 1"],
		["adguard-dns-family-ns2 ", "Adguard DNS Family Protection 2"],
		["adguard-dns-ns1 ", "Adguard DNS 1"],
		["adguard-dns-ns2 ", "Adguard DNS 2"],
		["cisco ", "Cisco OpenDNS"],
		["cisco-familyshield ", "Cisco OpenDNS with FamilyShield"],
		["cisco-ipv6 ", "Cisco OpenDNS over IPv6"],
		["cisco-port53 ", "Cisco OpenDNS backward compatibility port 53"],
		["cloudns-syd ", "CloudNS Sydney"],
		["cs-cawest ", "CS Canada west DNSCrypt server"],
		["cs-cfi ", "CS cryptofree France DNSCrypt server"],
		["cs-cfii ", "CS secondary cryptofree France DNSCrypt server"],
		["cs-ch ", "CS Switzerland DNSCrypt server"],
		["cs-de ", "CS Germany DNSCrypt server"],
		["cs-fr2 ", "CS secondary France DNSCrypt server"],
		["cs-rome ", "CS Italy DNSCrypt server"],
		["cs-useast ", "CS New York City NY US DNSCrypt server"],
		["cs-usnorth ", "CS Chicago IL US DNSCrypt server"],
		["cs-ussouth ", "CS Dallas TX US DNSCrypt server"],
		["cs-ussouth2 ", "CS Atlanta GA US DNSCrypt server"],
		["cs-uswest ", "CS Seattle WA US DNSCrypt server"],
		["cs-uswest2 ", "CS Las Vegas NV US DNSCrypt server"],
		["d0wn-au-ns1 ", "OpenNIC Resolver Australia 01 - d0wn"],
		["d0wn-bg-ns1 ", "OpenNIC Resolver Bulgaria 01 - d0wn"],
		["d0wn-cy-ns1 ", "OpenNIC Resolver Cyprus 01 - d0wn"],
		["d0wn-de-ns1 ", "OpenNIC Resolver Germany 01 - d0wn"],
		["d0wn-de-ns2 ", "OpenNIC Resolver Germany 02 - d0wn"],
		["d0wn-dk-ns1 ", "OpenNIC Resolver Denmark 01 - d0wn"],
		["d0wn-fr-ns2 ", "OpenNIC Resolver France 02 - d0wn"],
		["d0wn-es-ns1 ", "OpenNIC Resolver Spain 01- d0wn"],
		["d0wn-gr-ns1 ", "OpenNIC Resolver Greece 01 - d0wn"],
		["d0wn-hk-ns1 ", "OpenNIC Resolver Hong Kong 01 - d0wn"],
		["d0wn-is-ns1 ", "OpenNIC Resolver Iceland 01 - d0wn"],
		["d0wn-lu-ns1 ", "OpenNIC Resolver Luxembourg 01 - d0wn"],
		["d0wn-lu-ns1-ipv6 ", "OpenNIC Resolver Luxembourg 01 over IPv6 - d0wn"],
		["d0wn-lv-ns1 ", "OpenNIC Resolver Latvia 01 - d0wn"],
		["d0wn-lv-ns2 ", "OpenNIC Resolver Latvia 02 - d0wn"],
		["d0wn-lv-ns2-ipv6 ", "OpenNIC Resolver Latvia 01 over IPv6 - d0wn"],
		["d0wn-nl-ns3 ", "OpenNIC Resolver Netherlands 03 - d0wn"],
		["d0wn-nl-ns3-ipv6 ", "OpenNIC Resolver Netherlands 03 over IPv6 - d0wn"],
		["d0wn-random-ns1 ", "OpenNIC Resolver Moldova 01 - d0wn"],
		["d0wn-random-ns2 ", "OpenNIC Resolver Netherlands 02 - d0wn"],
		["d0wn-ro-ns1 ", "OpenNIC Resolver Romania 01 - d0wn"],
		["d0wn-ro-ns1-ipv6 ", "OpenNIC Resolver Romania 01 over IPv6 - d0wn"],
		["d0wn-ru-ns1 ", "OpenNIC Resolver Russia 01 - d0wn"],
		["d0wn-se-ns1 ", "OpenNIC Resolver Sweden 01 - d0wn"],
		["d0wn-se-ns1-ipv6 ", "OpenNIC Resolver Sweden 01 over IPv6 - d0wn"],
		["d0wn-sg-ns1 ", "OpenNIC Resolver Singapore 01 - d0wn"],
		["d0wn-sg-ns2 ", "OpenNIC Resolver Singapore 02 - d0wn"],
		["d0wn-sg-ns2-ipv6 ", "OpenNIC Resolver Singapore 01 over IPv6 - d0wn"],
		["d0wn-tz-ns1 ", "OpenNIC Resolver Tanzania 01 - d0wn"],
		["d0wn-ua-ns1 ", "OpenNIC Resolver Ukraine 01 - d0wn"],
		["d0wn-ua-ns1-ipv6 ", "OpenNIC Resolver Ukraine 01 over IPv6 - d0wn"],
		["d0wn-uk-ns1 ", "OpenNIC Resolver United Kingdom 01 - d0wn"],
		["d0wn-uk-ns1-ipv6 ", "OpenNIC Resolver United Kingdom 01 over IPv6 - d0wn"],
		["d0wn-us-ns1 ", "OpenNIC Resolver United States of America 01 - d0wn"],
		["d0wn-us-ns1-ipv6 ", "OpenNIC Resolver United States of America 01 over IPv6 - d0wn"],
		["d0wn-us-ns2 ", "OpenNIC Resolver United States of America 02 - d0wn"],
		["d0wn-us-ns2-ipv6 ", "OpenNIC Resolver United States of America 02 over IPv6 - d0wn"],
		["dns-freedom ", "DNS Freedom"],
		["dnscrypt.eu-dk ", "DNSCrypt.eu Denmark"],
		["dnscrypt.eu-dk-ipv6 ", "DNSCrypt.eu Denmark over IPv6"],
		["dnscrypt.eu-nl ", "DNSCrypt.eu Holland"],
		["dnscrypt.eu-nl-ipv6 ", "DNSCrypt.eu Holland over IPv6"],
		["dnscrypt.org-fr ", "DNSCrypt.org France"],
		["fvz-anyone ", "Primary OpenNIC Anycast DNS Resolver"],
		["fvz-anyone-ipv6 ", "Primary OpenNIC Anycast DNS IPv6 Resolver"],
		["fvz-anytwo ", "Secondary OpenNIC Anycast DNS Resolver"],
		["fvz-anytwo-ipv6 ", "Secondary OpenNIC Anycast DNS IPv6 Resolver"],
		["ipredator ", "Ipredator.se Server"],
		["ns0.dnscrypt.is ", "ns0.dnscrypt.is in Reykjav铆k, Iceland"],
		["okturtles ", "okTurtles"],
		["opennic-tumabox ", "TumaBox"],
		["ovpnse ", "OVPN.se Integritet AB"],
		["soltysiak ", "Soltysiak"],
		["soltysiak-ipv6 ", "Soltysiak over IPv6"],
		["ventricle.us ", "Anatomical DNS"],
		["yandex ", "Yandex"]
	];
	for (var i = 0; i < confs.length; i++) {
		$("#ss_opendns").append("<option value='" + confs[i][0] + "'>" + confs[i][1] + "</option>");
		$("#ss_pdnsd_udp_server_dnscrypt").append("<option value='" + confs[i][0] + "'>" + confs[i][1] + "</option>");
		$("#ss_chinadns_foreign_dnscrypt").append("<option value='" + confs[i][0] + "'>" + confs[i][1] + "</option>");
	}
}

function ssconf_node2obj(node_sel) {
	var p = "ssconf_basic";
	var obj = {};
	var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param", "use_kcp", "ss_obfs", "ss_obfs_host", "koolgame_udp"];
	for (var i = 0; i < params.length; i++) {
		obj["ss_basic_" + params[i]] = db_ss[p + "_" + params[i] + "_" + node_sel] || "";
	}
	obj["ssconf_basic_node"] = node_sel;
	return obj;
}

function ss_node_sel() {
	var node_sel = E("ssconf_basic_node").value;
	var obj = ssconf_node2obj(node_sel);
	update_ss_ui(obj);
	update_visibility_main();
}

function getAllConfigs() {
	var dic = {};
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
			if (time_total == 0.00) {
				obj["webtest"] = '<font color=#FFCC00">failed</font>';
			} else {
				obj["webtest"] = parseFloat(db_ss[p + "_webtest_" + field].split(":")[0]).toFixed(2) + " s";
			}
		}
		if (typeof db_ss[p + "_mode_" + field] == "undefined") {
			obj["mode"] = '';
		} else {
			obj["mode"] = db_ss[p + "_mode_" + field];
		}
		if (typeof db_ss[p + "_ss_obfs_" + field] == "undefined") {
			obj["ss_obfs"] = '';
		} else {
			obj["ss_obfs"] = db_ss[p + "_ss_obfs_" + field];
		}
		if (typeof db_ss[p + "_ss_obfs_host_" + field] == "undefined") {
			obj["ss_obfs_host"] = '';
		} else {
			obj["ss_obfs_host"] = db_ss[p + "_ss_obfs_host_" + field];
		}
		if (typeof db_ss[p + "_koolgame_udp_" + field] == "undefined") {
			obj["koolgame_udp"] = '';
		} else {
			obj["koolgame_udp"] = db_ss[p + "_koolgame_udp_" + field];
		}
		if (typeof db_ss[p + "_use_kcp_" + field] == "undefined") {
			obj["use_kcp"] = '';
		} else {
			obj["use_kcp"] = db_ss[p + "_use_kcp_" + field];
		}

		if (typeof db_ss[p + "_rss_protocol_" + field] == "undefined") {
			obj["rss_protocol"] = '';
		} else {
			obj["rss_protocol"] = db_ss[p + "_rss_protocol_" + field];
		}
		if (typeof db_ss[p + "_rss_protocol_param_" + field] == "undefined") {
			obj["rss_protocol_param"] = '';
		} else {
			obj["rss_protocol_param"] = db_ss[p + "_rss_protocol_param_" + field];
		}

		if (typeof db_ss[p + "_rss_obfs_" + field] == "undefined") {
			obj["rss_obfs"] = '';
		} else {
			obj["rss_obfs"] = db_ss[p + "_rss_obfs_" + field];
		}

		if (typeof db_ss[p + "_rss_obfs_param_" + field] == "undefined") {
			obj["rss_obfs_param"] = '';
		} else {
			obj["rss_obfs_param"] = db_ss[p + "_rss_obfs_param_" + field];
		}
		if (typeof db_ss[p + "_use_lb_" + field] == "undefined") {
			obj["use_lb"] = '0';
		} else {
			obj["use_lb"] = db_ss[p + "_use_lb_" + field];
		}

		if (typeof db_ss[p + "_group_" + field] == "undefined") {
			obj["group"] = '';
		} else {
			obj["group"] = db_ss[p + "_group_" + field];
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
	var option = $("#ssconf_basic_node");
	var option1 = $("#ssconf_basic_ping_node");
	var option2 = $("#ssconf_basic_test_node");
	option.find('option').remove().end();
	option1.find('option').remove().end();
	option2.find('option').remove().end();
	
	option1.append($("<option>", {
		value: 0,
		text: "全部节点"
	}));
	option2.append($("<option>", {
		value: 0,
		text: "全部节点"
	}));
	for (var field in confs) {
		var c = confs[field];
		if (c.rss_protocol) {
			if (c.group) {
				option.append($("<option>", {
					value: field,
					text: c.use_kcp == "1" ? "【SSR+KCP】" + c.group + " - " + c.name : "【SSR】" + c.group + " - " + c.name
				}));
			} else {
				option.append($("<option>", {
					value: field,
					text: c.use_kcp == "1" ? "【SSR+KCP】" + c.name : "【SSR】" + c.name
				}));
			}
		} else {
			if (c.koolgame_udp == "0" || c.koolgame_udp == "1") {
				option.append($("<option>", {
					value: field,
					text: c.use_kcp == "1" ? "【koolgame+KCP】" + c.name : "【koolgame】" + c.name
				}));
			} else {
				option.append($("<option>", {
					value: field,
					text: c.use_kcp == "1" ? "【SS+KCP】" + c.name : "【SS】" + c.name
				}));
			}
		}
		option1.append($("<option>", {
			value: field,
			text: c.name
		}));
		option2.append($("<option>", {
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

function updateSs_node_listView() {
	$.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr) {},
		success: function(response) {
			$.globalEval(response);
			loadAllConfigs();
		}
	});
}

function Add_profile() { //点击节点页面内添加节点动作
	checkTime = 2001; //停止节点页面刷新
	tabclickhandler(0); //默认显示添加ss节点
	E("ss_node_table_name").value = "";
	E("ss_node_table_server").value = "";
	E("ss_node_table_port").value = "";
	E("ss_node_table_password").value = "";
	E("ss_node_table_method").value = "aes-256-cfb";
	E("ss_node_table_mode").value = "1";
	E("ss_node_table_ss_obfs").value = "0"
	E("ss_node_table_ss_obfs_host").value = "";
	E("ss_node_table_rss_protocol").value = "origin";
	E("ss_node_table_rss_protocol_param").value = "";
	E("ss_node_table_rss_obfs").value = "plain";
	E("ss_node_table_rss_obfs_param").value = "";
	E("ss_node_table_koolgame_udp").value = "0";
	E("cancelBtn").style.display = "";
	E("ssTitle").style.display = "";
	E("ssrTitle").style.display = "";
	E("gamev2Title").style.display = "";
	E("add_node").style.display = "";
	E("edit_node").style.display = "none";
	E("continue_add").style.display = "";
	scroll_bottoom();
	$("#vpnc_settings").fadeIn(200);
	update_visibility_main();
}

function cancel_add_rule() { //点击添加节点面板上的返回
	E("vpnc_settings").style.display = "none";
}

var save_flag = ""; //type of Saving profile
function tabclickhandler(_type) {
	E('ssTitle').className = "vpnClientTitle_td_unclick";
	E('ssrTitle').className = "vpnClientTitle_td_unclick";
	E('gamev2Title').className = "vpnClientTitle_td_unclick";
	if (_type == 0) {
		save_flag = "shadowsocks";
		E("vpnc_type").value = "shadowsocks";
		E('ssTitle').className = "vpnClientTitle_td_click";
		showhide("ss_obfs_support", ($("#ss_node_table_mode").val() != "3"));
		showhide("ss_obfs_host_support", ($("#ss_node_table_mode").val() != "3" && $("#ss_node_table_ss_obfs").val() != "0"));
		E('ssr_protocol_tr').style.display = "none";
		E('ssr_protocol_param_tr').style.display = "none";
		E('ssr_obfs_tr').style.display = "none";
		E('ssr_obfs_param_tr').style.display = "none";
		E('gameV2_udp_tr').style.display = "none";
	} else if (_type == 1) {
		save_flag = "shadowsocksR";
		E("vpnc_type").value = "shadowsocksR";
		E('ssrTitle').className = "vpnClientTitle_td_click";
		E('ss_obfs_support').style.display = "none";
		E('ss_obfs_host_support').style.display = "none";
		E('ssr_protocol_tr').style.display = "";
		E('ssr_protocol_param_tr').style.display = "";
		E('ssr_obfs_tr').style.display = "";
		E('ssr_obfs_param_tr').style.display = "";
		E('gameV2_udp_tr').style.display = "none";
	} else if (_type == 2) {
		save_flag = "gameV2";
		E("vpnc_type").value = "gameV2";
		E('gamev2Title').className = "vpnClientTitle_td_click";
		E('ss_obfs_support').style.display = "none";
		E('ss_obfs_host_support').style.display = "none";
		E('ssr_protocol_tr').style.display = "none";
		E('ssr_protocol_param_tr').style.display = "none";
		E('ssr_obfs_tr').style.display = "none";
		E('ssr_obfs_param_tr').style.display = "none";
		E('gameV2_udp_tr').style.display = "";
	}
	return save_flag;
}

function add_ss_node_conf(flag) { //点击添加按钮动作
	var ns = {};
	var p = "ssconf_basic";
	node_global_max += 1;
	var params1 = ["name", "server", "mode", "port", "method", "ss_obfs", "ss_obfs_host"]; //for ss
	var params2 = ["name", "server", "mode", "port", "method", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param"]; //for ssr
	var params3 = ["name", "server", "mode", "port", "method", "koolgame_udp"]; //for ssr
	if (flag == 'shadowsocks') {
		for (var i = 0; i < params1.length; i++) {
			ns[p + "_" + params1[i] + "_" + node_global_max] = $.trim($('#ss_node_table' + "_" + params1[i]).val());
			ns[p + "_password_" + node_global_max] = Base64.encode($.trim($("#ss_node_table_password").val()));
		}
	} else if (flag == 'shadowsocksR') {
		for (var i = 0; i < params2.length; i++) {
			ns[p + "_" + params2[i] + "_" + node_global_max] = $.trim($('#ss_node_table' + "_" + params2[i]).val());
			ns[p + "_password_" + node_global_max] = Base64.encode($.trim($("#ss_node_table_password").val()));
		}
	} else if (flag == 'gameV2') {
		for (var i = 0; i < params3.length; i++) {
			ns[p + "_" + params3[i] + "_" + node_global_max] = $.trim($('#ss_node_table' + "_" + params3[i]).val());
			ns[p + "_password_" + node_global_max] = Base64.encode($.trim($("#ss_node_table_password").val()));
		}
	}
	$.ajax({
		url: '/applydb.cgi?p=ssconf_basic',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(ns),
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			refresh_table();
			//尝试将table拉动到最下方
			setTimeout("scroll_bottoom()", 500);
				E("ss_node_table_server").value = "";
			if ((E("continue_add_box").checked) == false) { //不选择连续添加的时候，清空其他数据
				E("ss_node_table_name").value = "";
				E("ss_node_table_port").value = "";
				E("ss_node_table_password").value = "";
				E("ss_node_table_method").value = "aes-256-cfb";
				E("ss_node_table_mode").value = "1";
				E("ss_node_table_ss_obfs").value = "0"
				E("ss_node_table_ss_obfs_host").value = "";
				E("ss_node_table_rss_protocol").value = "origin";
				E("ss_node_table_rss_protocol_param").value = "";
				E("ss_node_table_rss_obfs").value = "plain";
				E("ss_node_table_rss_obfs_param").value = "";
				E("ss_node_table_koolgame_udp").value = "0";
				cancel_add_rule();
			}
		}
	});
}

function scroll_bottoom() {
	var nodeaera = E('ss_node_list_table_td');
	E('ss_node_list_table_td').scrollTop = nodeaera.scrollHeight;
}

function scroll_top() {
	var nodeaera = E('ss_node_list_table_td');
	E('ss_node_list_table_td').scrollTop = 0;
}

function refresh_table() {
	$.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr) {},
		success: function(response) {
			$.globalEval(response);
			$("#ss_node_list_table_main").find("tr:gt(0)").remove();
			$('#ss_node_list_table_main tr:last').after(refresh_html());
		}
	});
}

function refresh_html() {
	browser_compatibility1();
	confs = getAllConfigs();
	var n = 0;
	for (var i in confs) {
		n++;
	} //获取节点的数目
	if (eval(n) > "13.5") { //当节点数目大于13个的时候，显示为overflow，节点可以滚动
		if (isFirefox = navigator.userAgent.indexOf("Firefox") > 0) {
			E("ss_node_list_table_th").style.top = "396px";
			E("ss_node_list_table_td").style.top = "436px";
			E("ss_node_list_table_td").style.height = "521px";
			E("ss_node_list_table_btn").style.top = "961px";
		} else {
			E("ss_node_list_table_th").style.top = "272px";
			E("ss_node_list_table_td").style.top = "312px";
			E("ss_node_list_table_td").style.height = "521px";
			E("ss_node_list_table_btn").style.top = "837px";
		}
		E("ss_node_list_table_th").style.display = "";
		E("ss_node_list_table_td").style.overflow = "auto";
		E("ss_node_list_table_td").style.position = "absolute";
		$('#ss_node_list_table_btn').css('margin', '');
		E("ss_node_list_table_btn").style.position = "absolute";
		E("ss_node_list_table_btn").style.bottom = "13px";
		E("hide_when_folw").style.display = "none";
	} else { //当节点数量小于等于13个的是否，显示为absolute，节点不可滚动
		E("ss_node_list_table_th").style.display = "none";
		E("ss_node_list_table_th").style.top = "242px";
		$('#ss_node_list_table_td').css('height', '');
		E("ss_node_list_table_td").style.top = "282px";
		E("ss_node_list_table_td").style.margin = "-1px 0px 0px 0px";
		E("ss_node_list_table_td").style.overflow = "visible";
		E("ss_node_list_table_td").style.position = "static";
		$('#ss_node_list_table_btn').css('bottom', '');
		$('#ss_node_list_table_btn').css('top', '');
		E("ss_node_list_table_btn").style.position = "static";
		E("ss_node_list_table_btn").style.margin = "4px 0px 0px 0px";
		E("hide_when_folw").style.display = "";
	}
	var html = '';
	for (var field in confs) {
		var c = confs[field];
		html = html + '<tr style="height:40px">';
		if (c["mode"] == 1) {
			html = html + '<td style="width:40px"><img style="margin:-4px -4px -4px -4px;" src="/res/gfw.png"/></td>';
		} else if (c["mode"] == 2) {
			html = html + '<td style="width:40px"><img style="margin:-4px -4px -4px -4px;" src="/res/chn.png"/></td>';
		} else if (c["mode"] == 3) {
			html = html + '<td style="width:40px"><img style="margin:-4px -4px -4px -4px;" src="/res/game.png"/></td>';
		} else if (c["mode"] == 4) {
			html = html + '<td style="width:40px"><img style="margin:-4px -4px -4px -4px;" src="/res/gameV2.png"/></td>';
		} else if (c["mode"] == 5) {
			html = html + '<td style="width:40px"><img style="margin:-4px -4px -4px -4px;" src="/res/all.png"/></td>';
		} else {
			html = html + '<td style="width:40px"></td>';
		}
		html = html + '<td style="width:90px;" id="ss_node_name_' + c["node"] + '">' + c["name"] + '</td>';
		html = html + '<td style="width:90px;" id="ss_node_server_' + c["node"] + '"> ' + c["server"] + '</td>';
		html = html + '<td id="ss_node_port_' + c["node"] + '" style="width:37px;">' + c["port"] + '</td>';
		html = html + '<td id="ss_node_method_' + c["node"] + '" style="width:90px;"> ' + c["method"] + '</td>';
		html = html + '<td id="ss_node_ping_' + c["node"] + '" style="width:78px;" class="ping" id="ping_test_td_' + c["node"] + '" style="text-align: center;">' + c["ping"] + '</td>';
		if (c["mode"] == 4 || c["use_kcp"] == 1) {
			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;color: #FFCC33" id="web_test_td_' + c["node"] + '">' + 'null' + '</td>';
		} else {
			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' + c["node"] + '">' + c["webtest"] + '</td>';
		}
		html = html + '<td style="width:33px;">'
		html = html + '<input style="margin:-2px 0px -4px -2px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="return edit_conf_table(this);" value="">'
		html = html + '</td>';
		html = html + '<td style="width:33px;">'
		if ((c["node"]) == db_ss["ssconf_basic_node"]) {
			html = html + '<input style="margin:-2px 0px -4px -2px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="remove_running_node(this);" value="">'
		} else {
			html = html + '<input style="margin:-2px 0px -4px -2px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="return remove_conf_table(this);" value="">'
		}
		html = html + '</td>';
		html = html + '<td style="width:65px;">'
		if ((c["node"]) == db_ss["ssconf_basic_node"]) {
			if (c["rss_protocol"]) {
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #f072a5;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
			} else {
				if (c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1") {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #33CC33;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
				} else {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #00CCFF;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
				}
			}
		} else {
			if (c["rss_protocol"]) {
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #f072a5;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
			} else {
				if (c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1") {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #33CC33;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
				} else {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #00CCFF;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
				}
			}
		}
		html = html + '</td>';
		html = html + '</tr>';
	}
	return html;
}
var node_nu;

function apply_Running_node() {
	alert("这个节点正在运行，你要干嘛？")
}

function remove_running_node() {
	alert("人家正在为你工作，你就要抛弃我？不干！")
}

function apply_this_ss_node(s) { //应用此节点
	$('.show-btn1').addClass('active');
	$('.show-btn1_1').removeClass('active');
	cancel_add_rule(); //隐藏节点编辑面板
	E("tablets").style.display = "";
	E("tablet_1").style.display = "";
	E("apply_button").style.display = "";
	E("line_image1").style.display = "";
	E("ss_node_list_table_th").style.display = "none";
	E("ss_node_list_table_td").style.display = "none";
	E("ss_node_list_table_btn").style.display = "none";
	confs = getAllConfigs();
	var option = $("#ssconf_basic_node");
	option.find('option').remove().end();
	for (var field in confs) {
		var c = confs[field];
		if (c.rss_protocol) {
			option.append($("<option>", {
				value: field,
				text: "【SSR】" + c.name
			}));
		} else {
			if (c.koolgame_udp == "0" || c.koolgame_udp == "1") {
				option.append($("<option>", {
					value: field,
					text: "【koolgame】" + c.name
				}));
			} else {
				option.append($("<option>", {
					value: field,
					text: "【SS】" + c.name
				}));
			}
		}
	}
	if (node_global_max > 0) {
		var node_sel = "1";
		if (typeof db_ss.ssconf_basic_node != "undefined") {
			node_sel = db_ss.ssconf_basic_node;
		}
		option.val(node_sel);
	}

	//updateSs_node_listView(); //更新主面板内的节点
	checkTime = 2001; //停止节点页面刷新
	//ss_node_info_return();
	var node = $(s).attr("id");
	var nodes = node.split("_");
	node = nodes[nodes.length - 1];
	var node_sel = node;
	var obj = ssconf_node2obj(node_sel);
	E("ssconf_basic_node").value = node;
	update_ss_ui(obj);
	update_visibility_main();
	setTimeout("save();", 500);
}

function hide_text() {
	$.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr) {},
		success: function(response) {
			$.globalEval(response);
			var reg = /^[\u4E00-\u9FA5]+$/;
			if ((E("ss_node_server_" + node_global_max).innerHTML) == "你猜" + node_global_max) { //服务器一栏不可能有中文，因此判断中文字符
				$("#ss_node_list_table_main").find("tr:gt(0)").remove();
				$('#ss_node_list_table_main tr:last').after(refresh_html());
			} else {
				$("#ss_node_list_table_main").find("tr:gt(0)").remove();
				$('#ss_node_list_table_main tr:last').after(refresh_html_dummy());
			}
		}
	});
}

function refresh_html_dummy() {
	browser_compatibility1();
	confs = getAllConfigs();
	var n = 0;
	for (var i in confs) {
		n++;
	} //获取节点的数目
	var random = parseInt(Math.random() * 6);
	var phrase = ["koolshare", "你猜", "假节点", "我是马赛克", "我是节点", "引力波节点"];
	if (eval(n) > "13.5") { //当节点数目大于13个的时候，显示为overflow，节点可以滚动
		if (isFirefox = navigator.userAgent.indexOf("Firefox") > 0) {
			E("ss_node_list_table_th").style.top = "396px";
			E("ss_node_list_table_td").style.top = "436px";
			E("ss_node_list_table_td").style.height = "521px";
			E("ss_node_list_table_btn").style.top = "961px";
		} else {
			E("ss_node_list_table_th").style.top = "272px";
			E("ss_node_list_table_td").style.top = "312px";
			E("ss_node_list_table_td").style.height = "521px";
			E("ss_node_list_table_btn").style.top = "837px";
		}
		E("ss_node_list_table_th").style.display = "";
		E("ss_node_list_table_td").style.overflow = "auto";
		E("ss_node_list_table_td").style.position = "absolute";
		$('#ss_node_list_table_btn').css('margin', '');
		E("ss_node_list_table_btn").style.position = "absolute";
		E("ss_node_list_table_btn").style.bottom = "13px";
		E("hide_when_folw").style.display = "none";
	} else { //当节点数量小于等于13个的是否，显示为absolute，节点不可滚动
		E("ss_node_list_table_th").style.display = "none";
		E("ss_node_list_table_th").style.top = "242px";
		$('#ss_node_list_table_td').css('height', '');
		E("ss_node_list_table_td").style.top = "282px";
		E("ss_node_list_table_td").style.margin = "-1px 0px 0px 0px";
		E("ss_node_list_table_td").style.overflow = "visible";
		E("ss_node_list_table_td").style.position = "static";
		$('#ss_node_list_table_btn').css('bottom', '');
		$('#ss_node_list_table_btn').css('top', '');
		E("ss_node_list_table_btn").style.position = "static";
		E("ss_node_list_table_btn").style.margin = "4px 0px 0px 0px";
		E("hide_when_folw").style.display = "";
	}
	var html = '';
	for (var field in confs) {
		var c = confs[field];
		html = html + '<tr style="height:40px">';
		if (c["mode"] == 1) {
			html = html + '<td style="width:40px;"><img style="margin:-4px 0px -4px 0px;" src="/res/gfw.png"/></td>';
		} else if (c["mode"] == 2) {
			html = html + '<td style="width:40px"><img style="margin:-4px 0px -4px 0px;" src="/res/chn.png"/></td>';
		} else if (c["mode"] == 3) {
			html = html + '<td style="width:40px"><img style="margin:-4px 0px -4px 0px;" src="/res/game.png"/></td>';
		} else if (c["mode"] == 4) {
			html = html + '<td style="width:40px"><img style="margin:-4px 0px -4px 0px;" src="/res/gameV2.png"/></td>';
		} else if (c["mode"] == 5) {
			html = html + '<td style="width:40px"><img style="margin:-4px 0px -4px 0px;" src="/res/all.png"/></td>';
		} else {
			html = html + '<td style="width:40px"></td>';
		}
		html = html + '<td id="ss_node_name_' + c["node"] + '" style="width:90px;">' + phrase[random] + c["node"] + '</td>';
		html = html + '<td id="ss_node_server_' + c["node"] + '" style="width:90px;">你猜' + c["node"] + '</td>';
		html = html + '<td id="ss_node_port_' + c["node"] + '" style="width:37px;">23333</td>';
		html = html + '<td id="ss_node_method_' + c["node"] + '" style="width:90px;">666666</td>';
		html = html + '<td id="ss_node_ping_' + c["node"] + '" style="width:78px;" class="ping" id="ping_test_td_' + c["node"] + '" style="text-align: center;">' + c["ping"] + '</td>';
		if (c["mode"] == 4 || c["use_kcp"] == 1) {
			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;color: #FFCC33" id="web_test_td_' + c["node"] + '">' + '不支持' + '</td>';
		} else {
			html = html + '<td id="ss_node_webtest_' + c["node"] + '" style="width:36px;" id="web_test_td_' + c["node"] + '">' + c["webtest"] + '</td>';
		}
		html = html + '<td style="width:33px;">'
		html = html + '<input style="margin:-2px 0px -4px -2px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="return edit_conf_table(this);" value="">'
		html = html + '</td>';
		html = html + '<td style="width:33px;">'
		if ((c["node"]) == db_ss["ssconf_basic_node"]) {
			html = html + '<input style="margin:-2px 0px -4px -2px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="remove_running_node(this);" value="">'
		} else {
			html = html + '<input style="margin:-2px 0px -4px -2px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="return remove_conf_table(this);" value="">'
		}
		html = html + '</td>';
		html = html + '<td style="width:65px;">'
		if ((c["node"]) == db_ss["ssconf_basic_node"]) {
			if (c["rss_protocol"]) {
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #f072a5;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
			} else {
				if (c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1") {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #33CC33;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
				} else {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #00CCFF;width:66px;cursor:pointer;" onclick="apply_Running_node(this);" value="运行中">'
				}
			}
		} else {
			if (c["rss_protocol"]) {
				html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #f072a5;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
			} else {
				if (c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1") {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #33CC33;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
				} else {
					html = html + '<input id="apply_ss_node_' + c["node"] + '" type="button" class="ss_btn" style="color: #00CCFF;width:66px;cursor:pointer;" onclick="apply_this_ss_node(this);" value="应用">'
				}
			}
		}
		html = html + '</td>';
		html = html + '</tr>';
	}
	return html;
}

function remove_conf_table(o) { //删除节点功能
	var id = $(o).attr("id");
	var ids = id.split("_");
	var p = "ssconf_basic";
	id = ids[ids.length - 1];
	var ns = {};
	var params = ["name", "server", "server_ip", "mode", "port", "password", "method", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param", "use_kcp", "ss_obfs", "ss_obfs_host", "koolgame_udp", "ping", "web_test", "lbmode", "weight", "use_kcp"];
	for (var i = 0; i < params.length; i++) {
		ns[p + "_" + params[i] + "_" + id] = "";
	}
	$.ajax({
		url: '/applydb.cgi?use_rm=1&p=ssconf_basic',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(ns),
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			refresh_table();
		}
	});
}

function edit_conf_table(o) { //编辑节点功能，显示编辑面板
	checkTime = 2001; //编辑节点时停止可能在进行的刷新
	var id = $(o).attr("id");
	var ids = id.split("_");
	var p = "ssconf_basic";
	confs = getAllConfigs();
	id = ids[ids.length - 1];
	var c = confs[id];
	E("ss_node_table_name").value = c["name"];
	E("ss_node_table_server").value = c["server"];
	E("ss_node_table_port").value = c["port"];
	E("ss_node_table_password").value = Base64.decode(c["password"])
	if (c["ss_obfs"] == "") {
		E("ss_node_table_ss_obfs").value = "0";
	} else {
		E("ss_node_table_ss_obfs").value = c["ss_obfs"];
	}
	E("ss_node_table_ss_obfs_host").value = c["ss_obfs_host"];
	E("ss_node_table_rss_obfs_param").value = c["rss_obfs_param"];
	E("ss_node_table_rss_protocol").value = c["rss_protocol"];
	E("ss_node_table_rss_protocol_param").value = c["rss_protocol_param"];
	E("ss_node_table_rss_obfs").value = c["rss_obfs"];
	E("ss_node_table_koolgame_udp").value = c["koolgame_udp"];
	E("cancelBtn").style.display = "";
	E("add_node").style.display = "none";
	E("edit_node").style.display = "";
	E("continue_add").style.display = "none";
	if (c["rss_protocol"]) { //判断节点为SSR
		$("#vpnc_settings").fadeIn(200);
		E("ssTitle").style.display = "none";
		E("ssrTitle").style.display = "";
		E("gamev2Title").style.display = "none";
		$("#ssrTitle").html("编辑SSR账号");
		tabclickhandler(1);
		E("ss_node_table_mode").value = c["mode"];
	} else {
		if (c["koolgame_udp"] == "0" || c["koolgame_udp"] == "1") { //判断节点为koolgame
			$("#vpnc_settings").fadeIn(200);
			E("ssTitle").style.display = "none";
			E("ssrTitle").style.display = "none";
			E("gamev2Title").style.display = "";
			$("#gamev2Title").html("编辑koolgame账号");
			tabclickhandler(2);
			E("ss_node_table_mode").value = c["mode"];
		} else { //判断节点为SS
			$("#vpnc_settings").fadeIn(200);
			E("ssTitle").style.display = "";
			E("ssrTitle").style.display = "none";
			E("gamev2Title").style.display = "none";
			$("#ssTitle").html("编辑SS账号");
			tabclickhandler(0);
			E("ss_node_table_mode").value = c["mode"];
		}
	}
	E("ss_node_table_method").value = c["method"];
	myid = id;
}

function edit_ss_node_conf(flag) { //编辑节点功能，数据重写
	var ns = {};
	var p = "ssconf_basic";
	var params1 = ["name", "server", "mode", "port", "method", "ss_obfs", "ss_obfs_host"]; //for ss
	var params2 = ["name", "server", "mode", "port", "method", "rss_protocol", "rss_protocol_param", "rss_obfs", "rss_obfs_param"]; //for ssr
	var params3 = ["name", "server", "mode", "port", "method", "koolgame_udp"]; //for ssr
	if (flag == 'shadowsocks') {
		for (var i = 0; i < params1.length; i++) {
			ns[p + "_" + params1[i] + "_" + myid] = $('#ss_node_table' + "_" + params1[i]).val();
			ns[p + "_password_" + myid] = Base64.encode($("#ss_node_table_password").val());
		}
	} else if (flag == 'shadowsocksR') {
		for (var i = 0; i < params2.length; i++) {
			ns[p + "_" + params2[i] + "_" + myid] = $('#ss_node_table' + "_" + params2[i]).val();
			ns[p + "_password_" + myid] = Base64.encode($("#ss_node_table_password").val());
		}
	} else if (flag == 'gameV2') {
		for (var i = 0; i < params3.length; i++) {
			ns[p + "_" + params3[i] + "_" + myid] = $('#ss_node_table' + "_" + params3[i]).val();
			ns[p + "_password_" + myid] = Base64.encode($("#ss_node_table_password").val());
		}
	}
	$.ajax({
		url: '/applydb.cgi?p=ssconf_basic',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(ns),
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			refresh_table();
			E("ss_node_table_name").value = "";
			E("ss_node_table_port").value = "";
			E("ss_node_table_server").value = "";
			E("ss_node_table_password").value = "";
			E("ss_node_table_method").value = "aes-256-cfb";
			E("ss_node_table_mode").value = "1";
			E("ss_node_table_ss_obfs").value = "0"
			E("ss_node_table_ss_obfs_host").value = "";
			E("ss_node_table_rss_protocol").value = "origin";
			E("ss_node_table_rss_protocol_param").value = "";
			E("ss_node_table_rss_obfs").value = "plain";
			E("ss_node_table_rss_obfs_param").value = "";
			E("ss_node_table_koolgame_udp").value = "0";
		}
	});
	updateSs_node_listView();
	$("#vpnc_settings").fadeOut(200);
}


function download_SS_node() {
	location.href = 'ss_conf_backup.txt';
}

function upload_ss_backup() {
	if (E('ss_file').value == "") return false;
	global_ss_node_refresh = false;
	E('ss_file_info').style.display = "none";
	E('loadingicon').style.display = "block";
	document.form.enctype = "multipart/form-data";
	document.form.encoding = "multipart/form-data";
	document.form.action = "/ssupload.cgi?a=/tmp/ss_conf_backup.txt";
	document.form.submit();
}


function upload_ok(isok) {
	var info = E('ss_file_info');
	if (isok == 1) {
		info.innerHTML = "上传完成";
		setTimeout("restore_ss_conf();", 1200);
	} else {
		info.innerHTML = "上传失败";
	}
	info.style.display = "block";
	E('loadingicon').style.display = "none";
}

function restore_ss_conf() {
	checkTime = 2001; //停止可能在进行的刷新
	db_ss["ss_basic_action"] = "9";
	var dbus = {};
	dbus["SystemCmd"] = "ss_conf_restore.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	push_data(dbus);
}

function remove_SS_node() {
	checkTime = 2001; //停止可能在进行的刷新
	db_ss["ss_basic_action"] = "10";
	var dbus = {};
	dbus["SystemCmd"] = "ss_conf_remove.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	push_data(dbus);
}

function ping_test() {
	checkTime = 2001; //停止可能在进行的刷新
	var dbus = {};
	dbus["SystemCmd"] = "ss_ping.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	dbus["ssconf_basic_ping_node"] = E("ssconf_basic_ping_node").value;
	dbus["ssconf_basic_ping_method"] = E("ssconf_basic_ping_method").value;
	$.ajax({
		type: "POST",
		url: '/applydb.cgi?p=ss',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(dbus),
		success: function(response) {
			checkTime = 0;
			refresh_ss_node_list_ping();
			alert("请等待片刻，测试结果将自动显示在对应节点列表!");
		}
	});
}

function remove_ping() {
	checkTime = 2001; //停止可能在进行的刷新
	var dbus = {};
	dbus["SystemCmd"] = "ss_ping_remove.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	$.ajax({
		type: "POST",
		url: '/applydb.cgi?p=ss',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(dbus),
		success: function(response) {
			alert("请等待片刻，如果结果未清空，请手动刷新页面!");
			setTimeout("refresh_table()", 1000);
		}
	});
}

function web_test() {
	checkTime = 2001; //停止可能在进行的刷新
	var dbus = {};
	dbus["SystemCmd"] = "ss_webtest.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	dbus["ssconf_basic_test_node"] = E("ssconf_basic_test_node").value;
	dbus["ssconf_basic_test_domain"] = E("ssconf_basic_test_domain").value;
	$.ajax({
		type: "POST",
		url: '/applydb.cgi?p=ss',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(dbus),
		success: function(response) {
			checkTime = 0;
			refresh_ss_node_list_webtest();
			alert("请等待片刻，测试结果将自动显示在对应节点列表!");
		}
	});
}

function remove_test() {
	checkTime = 2001; //停止可能在进行的刷新
	var dbus = {};
	dbus["SystemCmd"] = "ss_webtest_remove.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	$.ajax({
		type: "POST",
		url: '/applydb.cgi?p=ss',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(dbus),
		success: function(response) {
			alert("请等待片刻，如果结果未清空，请手动刷新页面!");
			setTimeout("refresh_table()", 1000);
		}
	});
}

var checkTime = 0;

function refresh_ss_node_list_ping() {
	if (checkTime < 200) {
		checkTime++;
		refresh_table();
		setTimeout("refresh_ss_node_list_ping()", 1000);
	}
	if (checkTime > 4) {
		confs = getAllConfigs();
		var n = 0;
		for (var i in confs) {
			n++;
		} //获取节点的数目
		var ping_flag = 0;
		for (var field in confs) {
			var c = confs[field].ping;
			if (c != "") {
				ping_flag++;
			}
		}
		if (E("ssconf_basic_ping_node").value == "0") {
			if (ping_flag == eval(n)) { //当ping被填满时，停止刷新
				checkTime = 2001;
			}
		} else {
			if (ping_flag == "1") { //当ping被填满时，停止刷新
				checkTime = 2001;
			}
		}
	}
}

function refresh_ss_node_list_webtest() {
	if (checkTime < 200) {
		checkTime++;
		refresh_table();
		setTimeout("refresh_ss_node_list_webtest()", 3000); //ping 出结果较慢，3秒刷新一次
	}
	if (checkTime > 2) {
		confs = getAllConfigs();
		var n = 0;
		for (var i in confs) {
			n++;
		} //获取节点的数目
		var webtest_flag = 0;
		for (var field in confs) {
			var c = confs[field].webtest;
			if (c != "") {
				webtest_flag++;
			}
		}
		if (webtest_flag == eval(n)) { //当ping被填满时，停止刷新
			checkTime = 2001;
		}
	}
}

function updatelist() {
	db_ss["ss_basic_action"] = "8";
	var dbus = {};
	dbus["SystemCmd"] = "ss_rule_update.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	dbus["ss_basic_rule_update"] = E("ss_basic_rule_update").value;
	dbus["ss_basic_rule_update_time"] = E("ss_basic_rule_update_time").value;
	dbus["ss_basic_gfwlist_update"] = E("ss_basic_gfwlist_update").checked ? '1' : '0';
	dbus["ss_basic_chnroute_update"] = E("ss_basic_chnroute_update").checked ? '1' : '0';
	dbus["ss_basic_cdn_update"] = E("ss_basic_cdn_update").checked ? '1' : '0';
	dbus["ss_basic_pcap_update"] = E("ss_basic_pcap_update").checked ? '1' : '0';
	push_data(dbus);
}

function version_show() {
	$.ajax({
		url: 'https://koolshare.ngrok.wang/shadowsocks/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if (res["version"] == db_ss["ss_basic_version_local"]) {
					$("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：" + db_ss['ss_basic_version_local'] + "</i></a>");
				} else if (res["version"] != db_ss["ss_basic_version_local"]) {
					if (typeof(db_ss["ss_basic_version_local"]) != "undefined") {
						$("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：" + db_ss['ss_basic_version_local'] + "</i></a>");
						$("#updateBtn").html("<i>升级到：" + res.version + "</i>");
					} else {
						$("#ss_version_show").html("<a class='hintstyle' href='javascript:void(12);' onclick='openssHint(12)'><i>当前版本：3.3.6</i></a>");
					}
				}
			}
		}
	});
}
var checkss = 0;

function get_ss_status_data() {
	if (checkss < 10000) {
		checkss++;
		refreshRate = $("#ss_basic_refreshrate").val();
		$.ajax({
			type: "get",
			url: "/dbconf?p=ss_basic_enable,ss_basic_dns_success",
			dataType: "script",
			success: function() {
				if (refreshRate != 0) {
					if (db_ss_basic_enable['ss_basic_enable'] == "1") {
						$.ajax({
							url: '/ss_status',
							dataType: "html",
							success: function(response) {
								var arr = JSON.parse(response);
								if (arr[0] == "" || arr[1] == "") {
									E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
									E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
								} else {
									E("ss_state2").innerHTML = arr[0];
									E("ss_state3").innerHTML = arr[1];
								}
							}
						});
					} else {
						E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
						E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
					}
				}
				if (db_ss_basic_dns_success['ss_basic_dns_success'] == "0") {
					E('SS_IP').style.display = "";
					$('#SS_IP').html("<font color='#66FF66'>服务器IP地址解析异常！</font><a class='hintstyle' href='javascript:void(0);' onclick='openssHint(51)'><font color='#ffcc00'><u>查看帮助</u></font></a>");
				} else if (db_ss_basic_dns_success['ss_basic_dns_success'] == "1") {
					E('SS_IP').style.display = "";
					$('#SS_IP').html("<font color='#66FF66'>服务器IP地址解析正常！</font><a class='hintstyle' href='javascript:void(0);' onclick='openssHint(51)'><font color='#ffcc00'><u>查看说明</u></font></a>");
				}
				if (refreshRate > 0) {
					setTimeout("get_ss_status_data();", refreshRate * 1000);
				}
			}

		});
	}
}

function update_ss() {
	db_ss["ss_basic_action"] = "7";
	var dbus = {};
	dbus["SystemCmd"] = "ss_update.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	push_data(dbus);
}

function buildswitch() {
	$("#ss_basic_enable").click(
		function() {
			if (E("ss_basic_enable").checked) {
				E("ss_status1").style.display = "";
				E("tablets").style.display = "";
				E("tablet_1").style.display = "";
				E("tablet_2").style.display = "none";
				E("tablet_3").style.display = "none";
				E("tablet_3_1").style.display = "none";
				E("tablet_3_2").style.display = "none";
				E("tablet_4").style.display = "none";
				E("tablet_5").style.display = "none";
				E("tablet_6").style.display = "none";
				E("tablet_7").style.display = "none";
				$('.show-btn1').addClass('active');
				$('.show-btn1_1').removeClass('active');
				$('.show-btn2').removeClass('active');
				$('.show-btn3').removeClass('active');
				$('.show-btn3_1').removeClass('active');
				$('.show-btn3_2').removeClass('active');
				$('.show-btn4').removeClass('active');
				$('.show-btn5').removeClass('active');
				$('.show-btn6').removeClass('active');
				$('.show-btn7').removeClass('active');
				E("apply_button").style.display = "";
				update_visibility_main();
				if (node_global_max == 0) {
					pop_node_add();
				}
			} else {
				E("ss_status1").style.display = "none";
				E("tablets").style.display = "none";
				E("tablet_1").style.display = "none";
				E("tablet_2").style.display = "none";
				E("tablet_3").style.display = "none";
				E("tablet_3_1").style.display = "none";
				E("tablet_3_2").style.display = "none";
				E("tablet_4").style.display = "none";
				E("tablet_5").style.display = "none";
				E("tablet_6").style.display = "none";
				E("tablet_7").style.display = "none";
				E("ss_node_list_table_th").style.display = "none";
				E("ss_node_list_table_td").style.display = "none";
				E("ss_node_list_table_btn").style.display = "none";
				E("apply_button").style.display = "none";
				E("log_content").style.display = "none";
				if (db_ss["ss_basic_enable"] == 1) {
					var dbus = {};
					dbus["SystemCmd"] = "ss_config.sh";
					dbus["action_mode"] = " Refresh ";
					dbus["current_page"] = "Main_Ss_Content.asp";
					dbus["ss_basic_enable"] = "0";
					push_data(dbus);
				}
			}
		});
}

function toggle_switch() {
	if (db_ss['ss_basic_enable'] == "1") {
		E("ss_basic_enable").checked = true;
		//update_visibility_main();
	} else {
		E("ss_basic_enable").checked = false;
		E("ss_status1").style.display = "none";
		E("tablets").style.display = "none";
		E("tablet_1").style.display = "none";
		E("tablet_2").style.display = "none";
		E("tablet_3").style.display = "none";
		E("tablet_3_1").style.display = "none";
		E("tablet_3_2").style.display = "none";
		E("tablet_4").style.display = "none";
		E("tablet_5").style.display = "none";
		E("tablet_6").style.display = "none";
		E("tablet_7").style.display = "none";
		E("apply_button").style.display = "none";
		E("line_image1").style.display = "none";
		E("ss_node_list_table_th").style.display = "none";
		E("ss_node_list_table_td").style.display = "none";
		E("ss_node_list_table_btn").style.display = "none";
		E("log_content").style.display = "none";
	}
}

function toggle_func() {
	var ssmode = E("ss_basic_mode").value;
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			update_visibility_main();
			ss_node_info_return();
		});
	$(".show-btn1_1").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').addClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "none";
			E("ss_node_list_table_td").style.display = "";
			E("ss_node_list_table_btn").style.display = "";
			E("line_image1").style.display = "none";
			refresh_table();
			update_ping_method();
		});
	$(".show-btn2").click(
		//dns pannel
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').addClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			update_visibility_tab2();
			ss_node_info_return();
		});
	$(".show-btn3").click(
		// black_white list panel
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').addClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			showhide("ss_wan_black_ip_tr", (ssmode != "5"));
			showhide("ss_wan_black_domain_tr", (ssmode != "5"));
			E("apply_button").style.display = "";
			ss_node_info_return();
		});
	$(".show-btn3_1").click(
		// black_white list panel
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').addClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			autoTextarea(E("ss_basic_kcp_parameter"));
			ss_node_info_return();
		});
	$(".show-btn3_2").click(
		// black_white list panel
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').addClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			ss_node_info_return();
		});
	$(".show-btn4").click(
		//rule manage
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').addClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "none";
			update_visibility_tab4();
			ss_node_info_return();
		});
	$(".show-btn5").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').addClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			ss_node_info_return();
			setTimeout("showDropdownClientList('setClientIP', 'ip', 'all', 'ClientList_Block', 'pull_arrow', 'online');", 1000);
			refresh_acl_table();
			update_visibility_tab4();
		});
	$(".show-btn6").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').addClass('active');
			$('.show-btn7').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "";
			E("tablet_7").style.display = "none";
			E("apply_button").style.display = "";
			update_visibility_tab4();
			ss_node_info_return();
		});
	$(".show-btn7").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn1_1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			$('.show-btn3_1').removeClass('active');
			$('.show-btn3_2').removeClass('active');
			$('.show-btn4').removeClass('active');
			$('.show-btn5').removeClass('active');
			$('.show-btn6').removeClass('active');
			$('.show-btn7').addClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("tablet_3_1").style.display = "none";
			E("tablet_3_2").style.display = "none";
			E("tablet_4").style.display = "none";
			E("tablet_5").style.display = "none";
			E("tablet_6").style.display = "none";
			E("tablet_7").style.display = "";
			E("apply_button").style.display = "none";
			E("line_image1").style.display = "none";
			E("log_content").style.display = "";
			ss_node_info_return();
			get_log();
		});
	$("#update_log").click(
		function() {
			window.open("https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/shadowsocks/Changelog.txt");
		});
	$("#log_content2").click(
		function() {
			x = -1;
		});
}

function ss_node_info_return() {
	cancel_add_rule();
	E("ss_node_list_table_th").style.display = "none";
	E("ss_node_list_table_td").style.display = "none";
	E("ss_node_list_table_btn").style.display = "none";
	E("line_image1").style.display = "";
	//updateSs_node_listView();
	checkTime = 2001;
}

function get_log() {
	$.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',

		error: function(xhr) {
			setTimeout("get_log();", 1000);
		},
		success: function(response) {
			var retArea = E("log_content1");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}

			if (noChange > 5) {
				//retArea.value = "当前日志文件为空";
				return false;
			} else {
				setTimeout("get_log();", 200);
			}

			retArea.value = response;
			_responseLen = response.length;
		}
	});
}

function get_realtime_log() {
	$.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		error: function(xhr) {
			setTimeout("get_realtime_log();", 1000);
		},
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				x = 5;
				count_down_close();
				return true;
			} else {
				E("ok_button").style.display = "none";
			}
			if (_responseLen == response.length) {
				noChange2++;
			} else {
				noChange2 = 0;
			}
			if (noChange2 > 100) {
				hideSSLoadingBar();
				return false;
			} else {
				setTimeout("get_realtime_log();", 250);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

var x = 6;

function count_down_close() {
	if (x == "0") {
		hideSSLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function update_ping_method() {
	$("#ssconf_basic_ping_method").find('option').remove().end();
	if (E("ssconf_basic_ping_node").value == "0") {
		$("#ssconf_basic_ping_method").append("<option value='1'>单线ping(10次/节点)</option>");
		$("#ssconf_basic_ping_method").append("<option value='2'>并发ping(10次/节点)</option>");
		$("#ssconf_basic_ping_method").append("<option value='3'>并发ping(20次/节点)</option>");
		$("#ssconf_basic_ping_method").append("<option value='4'>并发ping(50次/节点)</option>");
	} else {
		$("#ssconf_basic_ping_method").append("<option value='5'>ping(10次)</option>");
		$("#ssconf_basic_ping_method").append("<option value='6'>ping(20次)</option>");
		$("#ssconf_basic_ping_method").append("<option value='7'>ping(50次)</option>");
	}
}

function reload_Soft_Center() {
	location.href = "/Main_Soft_center.asp";
}


function getACLConfigs() {
	var dict = {};
	acl_node_max = 0;
	for (var field in db_ss) {
		names = field.split("_");
		dict[names[names.length - 1]] = 'ok';
	}
	acl_confs = {};
	var p = "ss_acl";
	var params = ["ip", "port", "mode"];
	for (var field in dict) {
		var obj = {};
		if (typeof db_ss[p + "_name_" + field] == "undefined") {
			obj["name"] = db_ss[p + "_ip_" + field];
		} else {
			obj["name"] = db_ss[p + "_name_" + field];
		}
		for (var i = 0; i < params.length; i++) {
			var ofield = p + "_" + params[i] + "_" + field;
			if (typeof db_ss[ofield] == "undefined") {
				obj = null;
				break;
			}
			obj[params[i]] = db_ss[ofield];
		}
		if (obj != null) {
			var node_a = parseInt(field);
			if (node_a > acl_node_max) {
				acl_node_max = node_a;
			}
			obj["acl_node"] = field;
			acl_confs[field] = obj;
		}
	}
	return acl_confs;
}

function addTr() {
	var acls = {};
	var p = "ss_acl";
	acl_node_max += 1;
	var params = ["ip", "name", "port", "mode"];
	for (var i = 0; i < params.length; i++) {
		acls[p + "_" + params[i] + "_" + acl_node_max] = $('#' + p + "_" + params[i]).val();
	}
	$.ajax({
		url: '/applydb.cgi?p=ss_acl',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(acls),
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			confs = getAllConfigs();
			refresh_acl_table();
			E("ss_acl_name").value = ""
			E("ss_acl_ip").value = ""
		}
	});
	aclid = 0;
}

function delTr(o) {
	var id = $(o).attr("id");
	var ids = id.split("_");
	var p = "ss_acl";
	id = ids[ids.length - 1];
	var acls = {};
	var params = ["ip", "name", "port", "mode"];
	for (var i = 0; i < params.length; i++) {
		acls[p + "_" + params[i] + "_" + id] = "";
	}
	$.ajax({
		url: '/applydb.cgi?use_rm=1&p=ss_acl',
		contentType: "application/x-www-form-urlencoded",
		dataType: 'text',
		data: $.param(acls),
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			refresh_acl_table();
		}
	});
}

function refresh_acl_table(q) {
	$.ajax({
		url: '/dbconf?p=ss',
		dataType: 'html',
		error: function(xhr) {},
		success: function(response) {
			$.globalEval(response);
			$("#ACL_table").find("tr:gt(1)").remove();
			$('#ACL_table tr:last').after(refresh_acl_html());
			//write defaut rule mode when switching ss mode
			if (typeof db_ss["ss_acl_default_mode"] != "undefined") {
				if (E("ss_basic_mode").value == 1 && db_ss["ss_acl_default_mode"] == 1 || db_ss["ss_acl_default_mode"] == 0) {
					$('#ss_acl_default_mode').val(db_ss["ss_acl_default_mode"]);
				}
				if (E("ss_basic_mode").value == 2 && db_ss["ss_acl_default_mode"] == 2 || db_ss["ss_acl_default_mode"] == 0) {
					$('#ss_acl_default_mode').val(db_ss["ss_acl_default_mode"]);
				}
				if (E("ss_basic_mode").value == 3 && db_ss["ss_acl_default_mode"] == 3 || db_ss["ss_acl_default_mode"] == 0) {
					$('#ss_acl_default_mode').val(db_ss["ss_acl_default_mode"]);
				}
				if (E("ss_basic_mode").value == 5 && db_ss["ss_acl_default_mode"] == 5 || db_ss["ss_acl_default_mode"] == 0) {
					$('#ss_acl_default_mode').val(db_ss["ss_acl_default_mode"]);
				}
			}
			//write default rule port
			if (typeof db_ss["ss_acl_default_port"] != "undefined") {
				$('#ss_acl_default_port').val(db_ss["ss_acl_default_port"]);
			} else {
				$('#ss_acl_default_port').val("all");
			}
			//write dynamic table value
			for (var i = 1; i < acl_node_max + 1; i++) {
				$('#ss_acl_mode_' + i).val(db_ss["ss_acl_mode_" + i]);
				$('#ss_acl_port_' + i).val(db_ss["ss_acl_port_" + i]);
				$('#ss_acl_name_' + i).val(db_ss["ss_acl_name_" + i]);
			}
			//set default rule port to all when game mode enabled
			set_default_port();
			//after table generated and value filled, set default value for first line_image1
			$('#ss_acl_mode').val("1");
			$('#ss_acl_port').val("80,443");
		}
	});
}

function set_mode_1() {
	//set the first line of the table, if mode is gfwlist mode or game mode,set the port to all
	if ($('#ss_acl_mode').val() == 0 || $('#ss_acl_mode').val() == 3) {
		$("#ss_acl_port").val("all");
		E("ss_acl_port").readonly = "readonly";
		E("ss_acl_port").title = "不可更改，游戏模式下默认全端口";
	} else if ($('#ss_acl_mode').val() == 1) {
		$("#ss_acl_port").val("80,443");
		E("ss_acl_port").readonly = "readonly";
		E("ss_acl_port").title = "";
	} else if ($('#ss_acl_mode').val() == 2 || $('#ss_acl_mode').val() == 5) {
		$("#ss_acl_port").val("22,80,443");
		E("ss_acl_port").readonly = "";
		E("ss_acl_port").title = "";
	}
}

function set_mode_2(o) {
	var id2 = $(o).attr("id");
	var ids2 = id2.split("_");
	id2 = ids2[ids2.length - 1];
	if ($(o).val() == 0 || $(o).val() == 3) {
		$("#ss_acl_port_" + id2).val("all");
		//E("ss_acl_port_" + id2).disabled=true;
	} else if ($(o).val() == 1) {
		$("#ss_acl_port_" + id2).val("80,443");
		//E("ss_acl_port_" + id2).disabled=false;
	} else if ($(o).val() == 2) {
		$("#ss_acl_port_" + id2).val("22,80,443");
		//E("ss_acl_port_" + id2).disabled=false;
	}
}

function set_default_port() {
	if ($('#ss_acl_default_mode').val() == 3) {
		$("#ss_acl_default_port").val("all");
		E("ss_acl_default_port").readonly = "readonly";
		E("ss_acl_default_port").title = "不可更改，游戏模式下默认全端口";
	} else {
		E("ss_acl_default_port").readonly = "";
		E("ss_acl_default_port").title = "";
	}
}

function refresh_acl_html() {
	acl_confs = getACLConfigs();
	var n = 0;
	for (var i in acl_confs) {
		n++;
	} //获取节点的数目
	var code = '';
	for (var field in acl_confs) {
		var ac = acl_confs[field];
		code = code + '<tr>';
		code = code + '<td>' + ac["ip"] + '</td>';
		code = code + '<td>';
		code = code + '<input type="text" placeholder="' + ac["acl_node"] + '号机" id="ss_acl_name_' + ac["acl_node"] + '" name="ss_acl_name_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
		code = code + '</td>';
		code = code + '<td>';
		code = code + '<select id="ss_acl_mode_' + ac["acl_node"] + '" name="ss_acl_mode_' + ac["acl_node"] + '" style="width:160px;margin:0px 0px 0px 2px;" class="input_option_2" onchange="set_mode_2(this);">';
		if ($("#ss_basic_mode").val() == 6) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="6">回国模式</option>';
		} else {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="1">gfwlist模式</option>';
			code = code + '<option value="2">大陆白名单模式</option>';
			code = code + '<option value="3">游戏模式</option>';
			code = code + '<option value="5">全局代理模式</option>';
			code = code + '<option value="6">回国模式</option>';
		}
		code = code + '</select>'
		code = code + '</td>';
		code = code + '<td>';
		if (ac["mode"] == 3) {
			code = code + '<input type="text" id="ss_acl_port_' + ac["acl_node"] + '" name="ss_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" title="不可更改，游戏模式下默认全端口" readonly = "readonly" />';
		} else if (ac["mode"] == 0) {
			code = code + '<input type="text" id="ss_acl_port_' + ac["acl_node"] + '" name="ss_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" title="不可更改，不通过SS下默认全端口" readonly = "readonly" />';
		} else {
			code = code + '<input type="text" id="ss_acl_port_' + ac["acl_node"] + '" name="ss_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
		}
		code = code + '</td>';
		code = code + '<td>';
		code = code + '<input style="margin: -3px 0px -5px 6px;" id="acl_node_' + ac["acl_node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">'
		code = code + '</td>';
		code = code + '</tr>';
	}
	code = code + '<tr>';
	if (n == 0) {
		code = code + '<td>所有主机</td>';
	} else {
		code = code + '<td>其它主机</td>';
	}
	code = code + '<td>默认规则</td>';
	ssmode = E("ss_basic_mode").value;
	if (n == 0) {
		if (ssmode == 0) {
			code = code + '<td>SS关闭</td>';
		} else if (ssmode == 1) {
			code = code + '<td>gfwlist模式</td>';
		} else if (ssmode == 2) {
			code = code + '<td>大陆白名单模式</td>';
		} else if (ssmode == 3) {
			code = code + '<td>游戏模式</td>';
		} else if (ssmode == 5) {
			code = code + '<td>全局模式</td>';
		} else if (ssmode == 6) {
			code = code + '<td>回国模式</td>';
		}
	} else {
		code = code + '<td>';
		code = code + '<select id="ss_acl_default_mode" name="ss_acl_default_mode" style="width:160px;margin:0px 0px 0px 2px;" class="input_option_2" onchange="set_default_port();">';
		if (ssmode == 0) {
			code = code + '<td>SS关闭</td>';
		} else if (ssmode == 1) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="1" selected>gfwlist模式</option>';
		} else if (ssmode == 2) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="2" selected>大陆白名单模式</option>';
		} else if (ssmode == 3) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="3" selected>游戏模式</option>';
		} else if (ssmode == 5) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="5" selected>全局代理模式</option>';
		} else if (ssmode == 6) {
			code = code + '<option value="0">不通过ss</option>';
			code = code + '<option value="5" selected>回国模式</option>';
		}
		code = code + '</select>';
		code = code + '</td>';
	}
	code = code + '<td>';
	code = code + '<input type="text" id="ss_acl_default_port" name="ss_acl_default_port" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
	code = code + '</td>';
	code = code + '<td>';
	code = code + '</td>';
	code = code + '</tr>';
	return code;

}

function setClientIP(ip, name, mac) {
	E("ss_acl_ip").value = ip;
	E("ss_acl_name").value = name;
	hideClients_Block();
}

function pullLANIPList(obj) {
	var element = E('ClientList_Block');
	var isMenuopen = element.offsetWidth > 0 || element.offsetHeight > 0;
	if (isMenuopen == 0) {
		obj.src = "/images/arrow-top.gif"
		element.style.display = 'block';
	} else{
		hideClients_Block();
	}
}

function hideClients_Block() {
	E("pull_arrow").src = "/images/arrow-down.gif";
	E('ClientList_Block').style.display = 'none';
	validator.validIPForm(document.form.ss_acl_ip, 0);
}

function get_proc_status() {
	noChange3 = 0;
	now_get_status();
	setTimeout("write_proc_status();", 500);
	$("#detail_status").fadeIn(200);
}

function close_proc_status() {
	$("#detail_status").fadeOut(200);
}


function now_get_status() {
	$.ajax({
		url: 'apply.cgi?current_page=Main_Ss_Content.asp.asp&next_page=Main_Ss_Content.asp.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=ss_proc_status.sh&firmver=3.0.0.4',
		dataType: 'html',
		error: function(xhr) {
			console.log("start failed" + response);
		},
		success: function(response) {
			console.log("start ok" + response);
		}
	});
}

var noChange3 = 0;
function write_proc_status() {
		E("proc_status").value = ""
		$.ajax({
			url: '/res/ss_proc_status.htm',
			dataType: 'html',
			error: function(xhr) {
				setTimeout("write_proc_status();", 1400);
			},
			success: function(response) {
				var retArea = E("proc_status");
				if (response.search("XU6J03M6") != -1) {
					retArea.value = response.replace("XU6J03M6", " ");
					//retArea.scrollTop = retArea.scrollHeight;
					return true;
				} else {}
				if (_responseLen == response.length) {
					noChange3++;
				} else {
					noChange3 = 0;
				}
				if (noChange3 > 100) {
					return false;
				} else {
					setTimeout("write_proc_status();", 500);
				}
				retArea.value = response.replace("XU6J03M6", " ");
				//retArea.scrollTop = retArea.scrollHeight;
				_responseLen = response.length;
			}
		});
	}

function get_online_nodes(action) {
	if (action == 0 || action == 1) {
		require(['/res/layer/layer.js'], function(layer) {
			layer.confirm('你确定要删除吗？', {
				shade: 0.8,
			}, function(index) {
				layer.close(index);
				save_online_nodes(action);
			}, function(index) {
				layer.close(index);
				return false;
			});
		});
	} else {
		save_online_nodes(action);
	}
}

function save_online_nodes(action) {
	db_ss["ss_basic_action"] = "13";
	var dbus = {};
	dbus["SystemCmd"] = "ss_online_update.sh";
	dbus["action_mode"] = " Refresh ";
	dbus["current_page"] = "Main_Ss_Content.asp";
	dbus["ss_online_action"] = action;
	dbus["ss_online_links"] = Base64.encode(E("ss_online_links").value);
	dbus["ssr_subscribe_mode"] = E("ssr_subscribe_mode").value;
	dbus["ssr_subscribe_obfspara"] = E("ssr_subscribe_obfspara").value;
	dbus["ss_basic_online_links_goss"] = E("ss_basic_online_links_goss").value;
	dbus["ss_basic_node_update"] = E("ss_basic_node_update").value;
	dbus["ss_basic_node_update_day"] = E("ss_basic_node_update_day").value;
	dbus["ss_basic_node_update_hr"] = E("ss_basic_node_update_hr").value;
	dbus["ss_basic_node_update"] = E("ss_basic_node_update").value;
	push_data(dbus);
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="LoadingBar" class="popup_bar_bg">
<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock"  align="center">
	<tr>
		<td height="100">
		<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
		<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
		<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
			<textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:#000;color:#FFFFFF;"></textarea>
		</div>
		<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
			<input id="ok_button1" class="button_gen" type="button" onclick="hideSSLoadingBar()" value="确定">
		</div>
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
<input type="hidden" id="vpnc_type" name="vpnc_type" value="">
<input type="hidden" id="ss_online_action" name="ss_online_action" value="" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" value=""/>
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
										<div class="formfonttitle">梅林固件 - 科学上网插件</div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote"  id="head_illustrate">本插件是支持SS、SSR、koolgame三种客户端的科学上网、游戏加速工具。</div>
										<div style="margin-top: 0px;text-align: center;font-size: 18px;margin-bottom: 0px;" class="formfontdesc" id="cmdDesc"></div>
										<!-- this is the popup area for status -->
										<div id="detail_status"  class="content_status" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;display: none;">
											<div class="user_title">shadowsocks状态检测</div>
											<div style="margin-left:15px"><i>&nbsp;&nbsp;目前本功能支持ss相关进程状态和iptables表状态检测。</i></div>
											<div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
												<textarea cols="63" rows="36" wrap="off" id="proc_status" style="width:97%;padding-left:10px;padding-right:10px;border:0px solid #222;font-family:'Lucida Console'; font-size:11px;background: transparent;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" type="button" onclick="close_proc_status();" value="返回主界面">	
											</div>	
										</div>
										<!-- end of the popouparea -->
										<div id="ss_switch_show">
											<table style="margin:0px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ss_switch_table">
												<thead>
												<tr>
													<td colspan="2">开关</td>
												</tr>
												</thead>
												<tr>
												<th id="ss_switch"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">科学上网开关</a></th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="ss_basic_enable">
																<input id="ss_basic_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div id="update_button" style="display:table-cell;float: left;position: absolute;margin-left:70px;padding: 5.5px 0px;">
															<a id="updateBtn" type="button" class="ss_btn" style="cursor:pointer" onclick="update_ss(3)">检查并更新</a>
														</div>
														<div id="ss_version_show" style="display:table-cell;float: left;position: absolute;margin-left:170px;padding: 5.5px 0px;">
															<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">
																<i>当前版本：<% dbus_get_def("ss_basic_version_local", "未知"); %></i>
															</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;position: absolute;padding: 5.5px 0px;">
															<!--<a type="button" class="kp_btn" target="_blank" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/shadowsocks/Changelog.txt">更新日志</a>-->
															<a type="button" class="kp_btn" target="_blank" href="javascript:void(0);" onclick="pop_changelog()">更新日志</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:350px;position: absolute;padding: 5.5px 0px;">
															<!--<a type="button" class="kp_btn" target="_blank" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/shadowsocks/Changelog.txt">更新日志</a>-->
															<a type="button" class="kp_btn" target="_blank" href="javascript:void(0);" onclick="pop_help()">插件帮助</a>
														</div>
													</td>
												</tr>
                                    		</table>
                                    	</div>
                                    	<div id="ss_status1">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_state">
												<th id="mode_state" width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">SS运行状态</a></th>
													<td>
														<div style="display:table-cell;float: left;margin-left:0px;">
															<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">
																<span style="display: none" id="ss_state1">尚未启用! </span>
																<span id="ss_state2">国外连接 - Waiting...</span>
																<br/>
																<span id="ss_state3">国内连接 - Waiting...</span>
															</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;position: absolute;padding: 10.5px 0px;">
															<a type="button" class="ss_btn" style="cursor:pointer" onclick="pop_111(3)" href="javascript:void(0);">分流检测</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:350px;position: absolute;padding: 10.5px 0px;">
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_proc_status(3)" href="javascript:void(0);">详细状态</a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablets">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr width="235px">
													<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="账号设置" />
														<input id="show_btn1_1" class="show-btn1_1" style="cursor:pointer" type="button" value="节点管理" />
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="DNS设定" />
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="黑白名单" />
														<input id="show_btn3_1" class="show-btn3_1" style="cursor:pointer" type="button" value="KCP加速" />
														<!--<input id="show_btn3_2" class="show-btn3_2" style="cursor:pointer" type="button" value="UDP加速"/>-->
														<input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="更新管理" />
														<input id="show_btn5" class="show-btn5" style="cursor:pointer" type="button" value="访问控制" />
														<input id="show_btn6" class="show-btn6" style="cursor:pointer" type="button" value="附加功能" />
														<input id="show_btn7" class="show-btn7" style="cursor:pointer" type="button" value="查看日志" />
													</td>
												</tr>
											</table>
										</div>
										<div id="vpnc_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 50px;">
											<table class="QISform_wireless" border=0 align="center" cellpadding="5" cellspacing="0">
												<tr style="height:32px;">
													<td>		
														<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0" class="vpnClientTitle">
															<tr>
													  		<td width="33%" align="center" id="ssTitle" onclick="tabclickhandler(0);">添加SS账号</td>
													  		<td width="33%" align="center" id="ssrTitle" onclick="tabclickhandler(1);">添加SSR账号</td>
													  		<td width="33%" align="center" id="gamev2Title" onclick="tabclickhandler(2);">添加koolgame账号</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td>
														<!-- vpnc_pptp/l2tp start  -->
														<div>
														<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
															<tr  id="ss_node_table_mode_tr">
																<th>使用模式</th>
																<td>
																	<select id="ss_node_table_mode" name="ss_node_table_mode" class="input_option" style="width:350px;margin:0px 0px 0px 2px;" onchange="update_visibility_main();">
																		<option value="1">【1】 gfwlist模式</option>
																		<option value="2">【2】 大陆白名单模式</option>
																		<option value="3">【3】 游戏模式</option>
																		<option value="5">【4】 全局代理模式</option>
																		<option value="6">【5】 回国模式</option>
																	</select>
																</td>
															</tr>
															<tr>
																<th>节点别名</th>
																<td>
																  	<input type="text" maxlength="64" id="ss_node_table_name" name="ss_node_table_name" value="" class="input_ss_table" style="width:342px;float:left;" autocorrect="off" autocapitalize="off"/>
																</td>
															</tr>
															<tr>
																<th>服务器地址</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_server" name="ss_node_table_server" value="" class="input_ss_table" style="width:342px;float:left;" autocorrect="off" autocapitalize="off"/>
																</td>
															</tr>
										
															<tr>
																<th>服务器端口</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_port" name="ss_node_table_port" value="" class="input_ss_table" style="width:342px;float:left;" autocomplete="off" autocorrect="off" autocapitalize="off"/>
																</td>
															</tr>
										
															<tr>
																<th>密码</th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_password" name="ss_node_table_password" value="" class="input_ss_table" style="width:342px;float:left;" autocomplete="off" autocorrect="off" autocapitalize="off"/>
																</td>
															</tr>
															<tr>
																<th>加密方式</th>
																<td>
																	<select id="ss_node_table_method" name="ss_node_table_method" class="input_option" style="width:350px;margin:0px 0px 0px 2px;">
																		<option value="none">none</option>
																		<option value="rc4">rc4</option>
																		<option value="rc4-md5">rc4-md5</option>
																		<option value="rc4-md5-6">rc4-md5-6</option>
																		<option value="aes-128-gcm">AEAD_AES_128_GCM</option>
																		<option value="aes-192-gcm">AEAD_AES_192_GCM</option>
																		<option value="aes-256-gcm">AEAD_AES_256_GCM</option>
																		<option value="aes-128-cfb">aes-128-cfb</option>
																		<option value="aes-192-cfb">aes-192-cfb</option>
																		<option value="aes-256-cfb" selected>aes-256-cfb</option>
																		<option value="aes-128-ctr">aes-128-ctr</option>
																		<option value="aes-192-ctr">aes-192-ctr</option>
																		<option value="aes-256-ctr">aes-256-ctr</option>
																		<option value="camellia-128-cfb">camellia-128-cfb</option>
																		<option value="camellia-192-cfb">camellia-192-cfb</option>
																		<option value="camellia-256-cfb">camellia-256-cfb</option>
																		<option value="bf-cfb">bf-cfb</option>
																		<option value="cast5-cfb">cast5-cfb</option>
																		<option value="idea-cfb">idea-cfb</option>
																		<option value="rc2-cfb">rc2-cfb</option>
																		<option value="seed-cfb">seed-cfb</option>
																		<option value="salsa20">salsa20</option>
																		<option value="chacha20">chacha20</option>
																		<option value="chacha20-ietf">chacha20-ietf</option>
																		<option value="chacha20-ietf-poly1305">chacha20-ietf-poly1305</option>
																		<option value="xchacha20-ietf-poly1305">xchacha20-ietf-poly1305</option>
																	</select>
																</td>	
															</tr>
															<tr id="ss_obfs_support">
																<th>混淆 (obfs)</th>
																<td>
																	<select name="ss_node_table_ss_obfs" id="ss_node_table_ss_obfs" class="input_option" style="width:350px;margin:0px 0px 0px 2px;" onchange="update_visibility_main();">
																		<option value="0" selected>否</option>
																		<option value="http">http</option>
																		<option value="tls">tls</option>
																	</select>
																</td>
															</tr>
															<tr id="ss_obfs_host_support">
																<th>混淆主机名 (obfs-host)</th>
																<td>
																	<input type="text" name="ss_node_table_ss_obfs_host" id="ss_node_table_ss_obfs_host" placeholder="bing.com"  class="input_ss_table" style="width:342px;" maxlength="100" value=""/>
																</td>
															</tr>
															<tr id="ssr_protocol_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>协议 (protocol)</u></a></th>
																<td>
																	<select id="ss_node_table_rss_protocol" name="ss_node_table_rss_protocol" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
																		<option value="origin" selected>origin</option>
																		<option value="verify_simple">verify_simple</option>
																		<option value="verify_sha1">verify_sha1</option>
																		<option value="auth_sha1">auth_sha1</option>
																		<option value="auth_sha1_v2">auth_sha1_v2</option>
																		<option value="auth_sha1_v4">auth_sha1_v4</option>
																		<option value="auth_aes128_md5">auth_aes128_md5</option>
																		<option value="auth_aes128_sha1">auth_aes128_sha1</option>
																		<option value="auth_chain_a">auth_chain_a</option>
																		<option value="auth_chain_b">auth_chain_b</option>
																		<option value="auth_chain_c">auth_chain_c</option>
																		<option value="auth_chain_d">auth_chain_d</option>
																		<option value="auth_chain_e">auth_chain_e</option>
																		<option value="auth_chain_f">auth_chain_f</option>
																	</select>
																</td>
															</tr>
															<tr id="ssr_protocol_param_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>协议参数 (protocol_param)</u></a></th>
																<td>
																	<input type="text" maxlength="64" id="ss_node_table_rss_protocol_param" name="ss_node_table_rss_protocol_param" value="" class="input_ss_table" style="width:342px;float:left;" autocomplete="off" autocorrect="off" autocapitalize="off"/>
																</td>
															</tr>
															
															<tr id="ssr_obfs_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>混淆 (obfs)</u></a></th>
																<td>
																	<select id="ss_node_table_rss_obfs" name="ss_node_table_rss_obfs" style="width:350px;margin:0px 0px 0px 2px;" class="input_option">
																		<option value="plain">plain</option>
																		<option value="http_simple">http_simple</option>
																		<option value="http_post">http_post</option>
																		<option value="tls1.2_ticket_auth">tls1.2_ticket_auth</option>
																	</select>
																</td>
															</tr>
															<tr id="ssr_obfs_param_tr">
																<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/blob/master/ssr.md" target="_blank"><u>混淆参数 (obfs_param)</u></a></th>
																<td>
																	<input type="text" name="ss_node_table_rss_obfs_param" id="ss_node_table_rss_obfs_param" placeholder="cloudflare.com"  class="input_ss_table" style="width:342px;" maxlength="300" value=""/>
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
												 		<!-- vpnc_pptp/l2tp end  -->		 			 	
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
										<div id="tablet_1">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="node_select">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">节点选择</a>

													</th>
													<td>
														<select id="ssconf_basic_node" name="ssconf_basic_node" style="width:auto;min-width:164px;max-width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="ss_node_sel();" ></select>
													</td>
												</tr>
												<tr id="mode_select">
													<th width="35%">
														<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">模式</a>
														</th>
													<td>
														<select id="ss_basic_mode" name="ss_basic_mode" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility_main();" >
															<option value="1">【1】 gfwlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="3">【3】 游戏模式</option>
															<option value="5">【4】 全局代理模式</option>
															<option value="6">【5】 回国模式</option>
														</select>
													</td>
												</tr>
												<tr id="server_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">服务器</a></th>
													<td>
														<input type="text" class="input_ss_table" id="ss_basic_server" name="ss_basic_server" maxlength="100" value=""/>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">服务器端口</a></th>
													<td>
														<input type="text" class="input_ss_table" id="ss_basic_port" name="ss_basic_port" maxlength="100" value="" />
													</td>
												</tr>
												<tr id="pass_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">密码</a></th>
													<td>
														<input type="password" name="ss_basic_password" id="ss_basic_password" class="input_ss_table" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" value="" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
													</td>
												</tr>												
												<tr id="method_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">加密方式</a></th>
													<td>
														<select id="ss_basic_method" name="ss_basic_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_visibility_main();">
															<option value="none">none</option>
															<option value="rc4">rc4</option>
															<option value="rc4-md5">rc4-md5</option>
															<option value="rc4-md5-6">rc4-md5-6</option>
															<option value="aes-128-gcm">AEAD_AES_128_GCM</option>
															<option value="aes-192-gcm">AEAD_AES_192_GCM</option>
															<option value="aes-256-gcm">AEAD_AES_256_GCM</option>
															<option value="aes-128-cfb">aes-128-cfb</option>
															<option value="aes-192-cfb">aes-192-cfb</option>
															<option value="aes-256-cfb" selected>aes-256-cfb</option>
															<option value="aes-128-ctr">aes-128-ctr</option>
															<option value="aes-192-ctr">aes-192-ctr</option>
															<option value="aes-256-ctr">aes-256-ctr</option>
															<option value="camellia-128-cfb">camellia-128-cfb</option>
															<option value="camellia-192-cfb">camellia-192-cfb</option>
															<option value="camellia-256-cfb">camellia-256-cfb</option>
															<option value="bf-cfb">bf-cfb</option>
															<option value="cast5-cfb">cast5-cfb</option>
															<option value="idea-cfb">idea-cfb</option>
															<option value="rc2-cfb">rc2-cfb</option>
															<option value="seed-cfb">seed-cfb</option>
															<option value="salsa20">salsa20</option>
															<option value="chacha20">chacha20</option>
															<option value="chacha20-ietf">chacha20-ietf</option>
															<option value="chacha20-ietf-poly1305">chacha20-ietf-poly1305</option>
															<option value="xchacha20-ietf-poly1305">xchacha20-ietf-poly1305</option>
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
												<tr id="ss_obfs">
													<th width="35%">混淆 (obfs)</th>
													<td>
														<select id="ss_basic_ss_obfs" name="ss_basic_ss_obfs" style="width:164px;margin:0px 0px 0px 2px;" class="input_option"  onchange="update_visibility_main();" >
															<option class="content_input_fd" value="0">关闭</option>
															<option class="content_input_fd" value="tls">tls</option>
															<option class="content_input_fd" value="http">http</option>
														</select>
													</td>
												</tr>
												<tr id="ss_obfs_host">
													<th width="35%">混淆主机名 (obfs_host)</th>
													<td>
														<input type="text" name="ss_basic_ss_obfs_host" id="ss_basic_ss_obfs_host" placeholder="bing.com"  class="input_ss_table" maxlength="100" value=""/>
													</td>
												</tr>
												
												<tr id="ss_basic_rss_protocol_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">协议 (protocol)</a></th>
													<td>
														<select id="ss_basic_rss_protocol" name="ss_basic_rss_protocol" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_visibility_main();" >
															<option class="content_input_fd" value="origin">origin</option>
															<option class="content_input_fd" value="verify_simple">verify_simple</option>
															<option class="content_input_fd" value="verify_sha1">verify_sha1</option>
															<option class="content_input_fd" value="auth_sha1">auth_sha1</option>
															<option class="content_input_fd" value="auth_sha1_v2">auth_sha1_v2</option>
															<option class="content_input_fd" value="auth_sha1_v4">auth_sha1_v4</option>
															<option value="auth_aes128_md5">auth_aes128_md5</option>
															<option value="auth_aes128_sha1">auth_aes128_sha1</option>
															<option value="auth_chain_a">auth_chain_a</option>
															<option value="auth_chain_b">auth_chain_b</option>
															<option value="auth_chain_c">auth_chain_c</option>
															<option value="auth_chain_d">auth_chain_d</option>
															<option value="auth_chain_e">auth_chain_e</option>
															<option value="auth_chain_f">auth_chain_f</option>
														</select>
														<span id="ss_basic_rss_protocol_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_rss_protocol_param_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(54)">协议参数 (protocol_param)</a></th>
													<td>
														<input type="password" name="ss_basic_rss_protocol_param" id="ss_basic_rss_protocol_param" placeholder="id:password"  class="input_ss_table" maxlength="100" value="" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
													</td>
												</tr>
												<tr id="ss_basic_rss_obfs_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">混淆 (obfs)</a></th>
													<td>
														<select id="ss_basic_rss_obfs" name="ss_basic_rss_obfs" style="width:164px;margin:0px 0px 0px 2px;" class="input_option"  onchange="update_visibility_main();" >
															<option class="content_input_fd" value="plain">plain</option>
															<option class="content_input_fd" value="http_simple">http_simple</option>
															<option class="content_input_fd" value="http_post">http_post</option>
															<option class="content_input_fd" value="tls1.2_ticket_auth">tls1.2_ticket_auth</option>
														</select>
														<span id="ss_basic_rss_obfs_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_ticket_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">混淆参数 (obfs_param)</a></th>
													<td>
														<input type="text" name="ss_basic_rss_obfs_param" id="ss_basic_rss_obfs_param" placeholder="cloudflare.com"  class="input_ss_table" maxlength="300" value=""/>
													</td>
												</tr>
											</table>
										</div>
										<!-- 节点面板 -->
										<div id="ss_node_list_table_th" style="display: none; height:40px; position: absolute; top: 242px; width: 98.8%;">
											<table style="margin:0px 0px 0px 0px;table-layout:fixed;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable1">
												<tr height="40px">
													<th style="width:40px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">模式</a></th>
													<th style="width:90px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">节点名称</a></th>
													<th style="width:90px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">服务器地址</a></th>
													<th style="width:37px;">端口</th>
													<th style="width:90px;">加密方式</th>
													<th style="width:78px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">ping/丢包</a></th>
													<th style="width:36px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">延迟</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">编辑</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">删除</a></th>
													<th style="width:65px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">使用</a></th>
												</tr>
											</table>
										</div>
										<div id="ss_node_list_table_td"  style="display: none; position: static; top: 282px; bottom: 190px; width: 98.8%; overflow: visible";>
											<table id="ss_node_list_table_main" style="margin:0px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable1">
												<tr id="hide_when_folw" height="40px" style="display: none;">
													<th style="width:40px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">模式</a></th>
													<th style="width:90px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">节点名称</a></th>
													<th style="width:90px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">服务器地址</a></th>
													<th style="width:37px;">端口</th>
													<th style="width:90px;">加密方式</th>
													<th style="width:78px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">ping/丢包</a></th>
													<th style="width:36px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">延迟</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">编辑</a></th>
													<th style="width:33px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">删除</a></th>
													<th style="width:65px;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">使用</a></th>
												</tr>
											</table>
										</div>
										<div id="ss_node_list_table_btn" style="display: none;position: static;width: 747px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th style="width:20%;">ping测试</th>
													<td>
														<input class="ss_btn" style="cursor:pointer;" onClick="ping_test()" type="button" value="ping测试"/>
														<select id="ssconf_basic_ping_node" name="ssconf_basic_ping_node" style="width:124px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_ping_method();"></select>
														<select id="ssconf_basic_ping_method" name="ssconf_basic_ping_method" style="width:160px;margin:0px 0px 0px 2px;" class="input_option"></select>
														<input class="ss_btn" style="cursor:pointer;" onClick="remove_ping()" type="button" value="清空结果"/>
													</td>
												</tr>
												<tr>
													<th style="width:20%;">web测试</th>
													<td>
														<input class="ss_btn" style="cursor:pointer;" onClick="web_test()" type="button" value="web测试"/>
															<select id="ssconf_basic_test_node" name="ssconf_basic_test_node" style="width:124px;margin:0px 0px 0px 2px;" class="input_option">
															</select>
														<select id="ssconf_basic_test_domain" name="ssconf_basic_test_domain" style="width:160px;margin:0px 0px 0px 2px;" class="input_option">
															<option class="content_input_fd" value="https://www.google.com.hk/">google.com</option>
															<option class="content_input_fd" value="https://www.twitter.com/">twitter.com</option>
															<option class="content_input_fd" value="https://www.facebook.com/">facebook.com</option>
															<option class="content_input_fd" value="https://www.youtube.com/">youtube.com</option>
														</select>
														<input class="ss_btn" style="cursor:pointer;" onClick="remove_test()" type="button" value="清空结果"/>
													</td>
												</tr>
											</table>
											<table>
												<tr>
													<td>
														<div id="node_return_button" class="apply_gen" style="margin-left: 188px;;float: left;">
															<input class="button_gen" id="returnBtn" onClick="hide_text()" type="button" value="黑科技按钮"/>
															<input id="add_ss_node" class="button_gen" onClick="Add_profile()" type="button" value="添加节点"/>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<!--=====tablet_2=====-->
										<div id="tablet_2" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(53)">选择DNS解析偏好</a></th>
													<td>
														<select id="ss_dns_plan" name="ss_dns_plan" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1" selected="">国内优先</option>
															<option value="2">国外优先</option>
														</select>
														<span id="ss_dns_plan_note"></span> <br/>
													</td>
												</tr>
												<tr id="dns_plan_china">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(25)">选择国内DNS</a></th>
													<td id="dns_plan_china_td">
														<select id="ss_dns_china" name="ss_dns_china" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1" selected>运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS1【114.114.114.114】</option>
															<option value="5">114DNS1【114.114.115.115】</option>
															<option value="6">cnnic DNS【1.2.4.8】</option>
															<option value="7">cnnic DNS【210.2.4.8】</option>
															<option value="8">oneDNS1【112.124.47.27】</option>
															<option value="9">oneDNS2【114.215.126.16】</option>
															<option value="10">百度DNS【180.76.76.76】</option>
															<option value="11">DNSpod DNS【119.29.29.29】</option>
															<option value="12">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_dns_china_user" name="ss_dns_china_user" maxlength="100" value="">
														<span id="show_isp_dns"></span> <br/>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">选择国外DNS</a></th>
													<td>
														<select id="ss_dns_foreign" name="ss_dns_foreign" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1" selected="">dns2socks</option>
															<option value="2">ss-tunnel</option>
															<option value="3">dnscrypt-proxy</option>
															<option value="4">pdnsd</option>
															<option value="5">ChinaDNS</option>
															<option value="6">Pcap_DNSProxy</option>
														</select>
														<select id="ss_opendns" name="ss_opendns" class="input_option" style="width:320px"></select>
														<input type="text" class="input_ss_table" id="ss_dns2socks_user" name="ss_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_sstunnel" name="ss_sstunnel" class="input_option" style="width:200px" onclick="update_visibility_tab2();" >
															<option value="2" selected>google dns[8.8.8.8]</option>
															<option value="3">google dns[8.8.4.4]</option>
															<option value="1">OpenDNS[208.67.220.220]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_sstunnel_user" name="ss_sstunnel_user" style="width:150px" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													</td>
												</tr>
												<tr id="dns_plan_foreign_game2" style="display: none;">
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(47)">选择国外DNS</a></th>
													<td>
														<select id="ss_game2_dns_foreign" name="ss_game2_dns_foreign" class="input_option" onclick="update_visibility_tab2();" disabled="disabled" >
															<option value="1" selected>koolgame内置</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_game2_dns2ss_user" name="ss_game2_dns2ss_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<br/>
															<span id="dns_plan_foreign0">默认使用koolgame内置的DNS2SS域名解析</span>
													</td>
												</tr>
												<tr id="chinadns_china">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(27)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font></a></th>
													<td>
														<select id="ss_chinadns_china" name="ss_chinadns_china" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS1【114.114.114.114】</option>
															<option value="4">114DNS1【114.114.115.115】</option>
															<option value="5">cnnic DNS【1.2.4.8】</option>
															<option value="6">cnnic DNS【210.2.4.8】</option>
															<option value="7">oneDNS1【112.124.47.27】</option>
															<option value="8">oneDNS2【114.215.126.16】</option>
															<option value="9">百度DNS【180.76.76.76】</option>
															<option value="10">DNSpod DNS【119.29.29.29】</option>
															<option value="11">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_chinadns_china_user" name="ss_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="chinadns_foreign">
													<th width="20%">
														<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(28)">
															<font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS</font>
														</a>
													</th>
													<td>
														<select id="ss_chinadns_foreign_method" name="ss_chinadns_foreign_method" class="input_option" style="width:100px" onclick="update_visibility_tab2();" >
															<option value="1" selected>DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_chinadns_foreign_method_user" name="ss_chinadns_foreign_method_user" style="width:150px" maxlength="100" value="">
														<span id="ss_chinadns_foreign_method_user_txt">自定义直连的chinaDNS国外dns。</span>
														<select id="ss_chinadns_foreign_dns2socks" name="ss_chinadns_foreign_dns2socks" class="input_option" style="width:200px" onclick="update_visibility_tab2();" >
															<option value="2" selected>Google dns [8.8.8.8]</option>
															<option value="3">Google dns [8.8.4.4]</option>
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_chinadns_foreign_dns2socks_user" name="ss_chinadns_foreign_dns2socks_user" style="width:150px" maxlength="100" value="">

														<select id="ss_chinadns_foreign_dnscrypt" name="ss_chinadns_foreign_dnscrypt" class="input_option" style="width:320px"></select>

														
														<select id="ss_chinadns_foreign_sstunnel" name="ss_chinadns_foreign_sstunnel" class="input_option" style="width:200px" onclick="update_visibility_tab2();" >
															<option value="2" selected>Google dns [8.8.8.8]</option>
															<option value="3">Google dns [8.8.4.4]</option>
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_chinadns_foreign_sstunnel_user" name="ss_chinadns_foreign_sstunnel_user" style="width:150px" maxlength="100" value="">
													</td>
												</tr>
												<tr id="pdnsd_method">
													<th width="20%" >
														<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(29)">
															<font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font>
														</a>
													</th>
													<td>
														<select id="ss_pdnsd_method" name="ss_pdnsd_method" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_tcp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(30)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></a></th>
													<td>
														<input type="text" class="input_ss_table" id="ss_pdnsd_server_ip" name="ss_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="input_ss_table" id="ss_pdnsd_server_port" name="ss_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="pdnsd_up_stream_udp">
													<th width="20%" ><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(31)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></a></th>
													<td>
														<select id="ss_pdnsd_udp_server" name="ss_pdnsd_udp_server" class="input_option" onclick="update_visibility_tab2();" >
															<option value="1" selected>DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_pdnsd_udp_server_dns2socks" name="ss_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_pdnsd_udp_server_dnscrypt" name="ss_pdnsd_udp_server_dnscrypt" class="input_option" style="width:320px"></select>
														<select id="ss_pdnsd_udp_server_ss_tunnel" name="ss_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility_tab2();" >
															<option value="2" selected>google DNS1 [8.8.8.8]</option>
															<option value="3">google DNS2 [8.8.4.4]</option>
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_pdnsd_udp_server_ss_tunnel_user" name="ss_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="pdnsd_cache">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(32)"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></a></th>
													<td>
														<input type="text" class="input_ss_table" id="ss_pdnsd_server_cache_min" name="ss_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="input_ss_table" id="ss_pdnsd_server_cache_max" name="ss_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="pdnsd1">填写最小TTL时间与最长TTL时间</span>
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
												<tr id="ss_basic_dnslookup_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(51)">SS服务器地址解析</a></th>
													<td>
														<select id="ss_basic_dnslookup" name="ss_basic_dnslookup" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">resolveip方式</option>
															<option value="1" selected>nslookup方式</option>
														</select>
														<input type="text" class="input_ss_table" id="ss_basic_dnslookup_server" name="ss_basic_dnslookup_server" style="width:128px;"  value="114.114.114.114">
														<span id="SS_IP" style="margin-left:auto;margin-top:-23px;margin-bottom:0px;display: none;">
														</span>
													</td>
												</tr>
												<tr id="user_cdn_tr">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(33)">自定义需要CDN加速名单</a></th>
													<td>
														<textarea placeholder="# 填入需要强制用国内DNS解析的域名，一行一个，格式如下：
koolshare.cn
baidu.com
默认除了gfwlist名单外的域名都由国内DNS解析
# 注意：不支持通配符！" cols="50" rows="7" id="ss_isp_website_web" name="ss_isp_website_web" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
														<span id="user_cdn_span"></span>
													</td>
												</tr>
												<tr>
												<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(34)">自定义dnsmasq</a></th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows="12" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="ss_dnsmasq" name="ss_dnsmasq" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" title=""></textarea>
													</td>
												</tr>
											</table>
										<lable id="dns_note" style="display: none;">回国模式用户建议使用dnscrypt-proxy和ChinaDNS(国外自定义例如8.8.8.8直连)两种方案。</lable>
										</div>
										<!--=====tablet_3=====-->
										<div id="tablet_3" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="ss_wan_white_ip_tr">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(38)">IP/CIDR白名单</a><br>
														<br>
														<font color="#ffcc00">添加不需要走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的外网ip地址，一行一个，格式（IP/CIDR）如下
2.2.2.2
3.3.3.3
4.4.4.4/24" cols="50" rows="7" id="ss_wan_white_ip" name="ss_wan_white_ip" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
												<tr id="ss_wan_white_domain_tr">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(39)">域名白名单</a><br>
														<br>
														<font color="#ffcc00">添加不需要走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的域名，一行一个，格式如下：
google.com
facebook.com
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_wan_white_domain" name="ss_wan_white_domain" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
												<tr id="ss_wan_black_ip_tr">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(40)">IP/CIDR黑名单</a><br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的外网ip地址，一行一个，格式（IP/CIDR）如下：
5.5.5.5
6.6.6.6
7.7.7.7/8" cols="50" rows="7" id="ss_wan_black_ip" name="ss_wan_black_ip" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
												<tr id="ss_wan_black_domain_tr">
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(41)">域名黑名单</a><br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的域名，一行一个，格式如下：
baidu.com
taobao.com
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_wan_black_domain" name="ss_wan_black_domain" style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
											</table>
										</div>
										<!--=====tablet_3_1=====-->
										<div id="tablet_3_1" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="35%">
														KCP加速开关
													</th>
													<td>
														<input type="checkbox" id="ss_basic_use_kcp" onclick="update_visibility_main();" />
													</td>
												</tr>
												<tr id="ss_basic_kcp_port_tr">
													<th width="35%">KCP端口</th>
													<td>
														<input type="text" name="ss_basic_kcp_port" id="ss_basic_kcp_port"  class="input_ss_table" maxlength="200" value=""/>
													</td>
												</tr>
												<tr id="ss_basic_kcp_parameter_tr">
													<th width="35%">KCP参数</th>
													<td>
														<textarea style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#576D73;color:#FFFFFF;border:1px solid gray;" id="ss_basic_kcp_parameter" name="ss_basic_kcp_parameter" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>
										<!--=====tablet_3_2=====-->
										<div id="tablet_3_2" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="35%">
														UDP加速软件选择
													</th>
													<td>
														todo: udpraw和udpspeeder支持，然而这个人很懒，此功能还没写!
													</td>
												</tr>
											</table>
										</div>	
										<div id="tablet_4" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr  id="gfw_number">
													<th id="gfw_nu1" width="35%">gfwlist域名数量</th>
													<td id="gfw_nu2">
															<% nvram_get("ipset_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf" target="_blank">
																<i><% nvram_get("update_ipset"); %></i>
														</a>
													</td>
												</tr>
												<tr  id="chn_number">
													<th id="chn_nu1" width="35%">大陆白名单IP段数量</th>
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
													<th id="cdn_nu1" width="35%">国内域名数量（cdn名单）</th>		
													<td id="cdn_nu2">		
														<p>		
														<% nvram_get("cdn_numbers"); %>&nbsp;条，最后更新版本：		
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt" target="_blank">		
																<i><% nvram_get("update_cdn"); %></i>		
															</a>		
														</p>		
													</td>		
												</tr>
												<tr  id="Routing_number">		
													<th width="35%">Routing.txt（Pcap规则）</th>		
													<td>		
														<p>		
														<% nvram_get("Routing_numbers"); %> &nbsp;条，最后更新版本：		
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/Routing.txt" target="_blank">		
																<i><% nvram_get("update_Routing"); %></i>		
															</a>		
														</p>		
													</td>		
												</tr>
												<tr  id="WhiteList_number">		
													<th width="35%">WhiteList.txt（Pcap规则）</th>		
													<td>		
														<p>		
														<% nvram_get("WhiteList_numbers"); %>&nbsp;条，最后更新版本：		
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/WhiteList.txt" target="_blank">		
																<i><% nvram_get("update_WhiteList"); %></i>		
															</a>		
														</p>		
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
																<input type="checkbox" id="ss_basic_gfwlist_update" title="选择此项应用gfwlist自动更新">gfwlist
																<input type="checkbox" id="ss_basic_chnroute_update">chnroute
																<input type="checkbox" id="ss_basic_cdn_update">CDN
																<input type="checkbox" id="ss_basic_pcap_update">Pcap_list
															</a>
                                    	                	<a type="button" class="ss_btn" style="cursor:pointer" onclick="updatelist()">立即更新</a>
													</td>
												</tr>										
											</table>
											<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
											<table id="conf_table1" style="margin:8px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="3">SSR订阅设置</td>
												</tr>
												</thead>
												<tr>
													<th width="35%">订阅地址管理</th>
													<td>
														<textarea placeholder="填入需要订阅的地址，多个地址分行填写" rows=3 style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_online_links" name="ss_online_links" title="" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
												<tr>
													<th width="35%">订阅节点模式设定</th>
													<td>
														<select id="ssr_subscribe_mode" name="ssr_subscribe_mode" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="1">【1】 gfwlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="3">【3】 游戏模式</option>
															<option value="5">【4】 全局代理模式</option>
															<option value="6">【5】 回国模式</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="35%">订阅节点混淆参数设定</th>
													<td>
														<select id="ssr_subscribe_obfspara" name="ssr_subscribe_obfspara" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">留空</option>
															<option value="1" selected="">使用订阅设定</option>
															<option value="2">自定义</option>
														</select>
														<input type="text" id="ssr_subscribe_obfspara_val" name="ssr_subscribe_obfspara_val" class="input_ss_table" maxlength="50" style="width:140px;" placeholder="" value="www.baidu.com" />
													</td>
												</tr>
												<tr>
													<th width="35%">下载订阅时走SS网络</th>
													<td>
														<select id="ss_basic_online_links_goss" name="ss_basic_online_links_goss" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">不走SS</option>
															<option value="1" selected="">走SS</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="35%">订阅计划任务</th>
													<td>
														<select id="ss_basic_node_update" name="ss_basic_node_update" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">禁用</option>
															<option value="1" selected="">开启</option>
														</select>
														<select id="ss_basic_node_update_day" name="ss_basic_node_update_day" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="7" selected="">每天</option>
															<option value="1">周一</option>
															<option value="2">周二</option>
															<option value="3">周三</option>
															<option value="4">周四</option>
															<option value="5">周五</option>
															<option value="6">周六</option>
															<option value="0">周日</option>
														</select>
														<select id="ss_basic_node_update_hr" name="ss_basic_node_update_hr" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0">0点</option><option value="1">1点</option><option value="2">2点</option><option value="3" selected="">3点</option><option value="4">4点</option><option value="5">5点</option><option value="6">6点</option><option value="7">7点</option><option value="8">8点</option><option value="9">9点</option><option value="10">10点</option><option value="11">11点</option><option value="12">12点</option><option value="13">13点</option><option value="14">14点</option><option value="15">15点</option><option value="16">16点</option><option value="17">17点</option><option value="18">18点</option><option value="19">19点</option><option value="20">20点</option><option value="21">21点</option><option value="22">22点</option><option value="23">23点</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="35%">删除节点</th>
													<td>
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(0)">删除全部节点</a>
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(1)">删除全部订阅节点</a>
													</td>
												</tr>
												<tr>
													<th width="35%">订阅操作</th>
													<td>
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(2)">仅保存设置</a>
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(3)">保存并订阅</a>
													</td>
												</tr>
											</table>
											<table style="margin:8px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="3">通过SS/SSR链接添加服务器</td>
												</tr>
												</thead>
												<tr>
													<th width="35%">SS/SSR链接</th>
													<td>
														<textarea placeholder="填入需要解析的以ss://或者ssr://开头的链接，多个分行填写" rows=9 style="width:99%; font-family:'Lucida Console'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_base64_links" name="ss_base64_links" title="" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
													</td>
												</tr>
												<tr>
													<th width="35%">操作</th>
													<td>
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(4)">解析并保存为节点</a>
													</td>
												</tr>
											</table>
										</div>
										<!--====LAN ACL=====-->
										<div id="tablet_5" style="display: none;">
											<table id="ACL_table" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
													<tr>
														<th style="width:180px;">主机IP地址</th>
														<th style="width:160px;">主机别名</th>
														<th style="width:160px;">访问控制</th>
														<th style="width:160px;">目标端口</th>
														<th style="width:60px;">添加/删除</th>
													</tr>
													<tr>
														<td>
															<input type="text" maxlength="15" class="input_15_table" id="ss_acl_ip" name="ss_acl_ip" align="left" onkeypress="return validator.isIPAddr(this, event)" style="float:left;" autocomplete="off" onClick="hideClients_Block();" autocorrect="off" autocapitalize="off">
															<img id="pull_arrow" height="14px;" src="images/arrow-down.gif" align="right" onclick="pullLANIPList(this);" title="<#select_IP#>">
															<div id="ClientList_Block" class="clientlist_dropdown" style="margin-left:2px;margin-top:25px;"></div>
														</td>
														<td>
															<input type="text" id="ss_acl_name" name="ss_acl_name" class="input_ss_table" maxlength="50" style="width:140px;" placeholder="" />
														</td>
														<td>
															<select id="ss_acl_mode" name="ss_acl_mode" style="width:160px;margin:0px 0px 0px 2px;" class="input_option" onchange="set_mode_1(this);">
																<option value="0">不通过ss</option>
																<option value="1">gfwlist模式</option>
																<option value="2">大陆白名单模式</option>
																<option value="3">游戏模式</option>
																<option value="5">全局代理模式</option>
																<option value="6">回国模式</option>
															</select>
														</td>
														<td>
															<select id="ss_acl_port" name="ss_acl_port" style="width:100px;margin:0px 0px 0px 2px;" class="input_option">
																<option value="80,443">80,443</option>
																<option value="22,80,443">22,80,443</option>
																<option value="all">all</option>
															</select>
														</td>
														<td style="width:66px">
															<input style="margin-left: 6px;margin: -3px 0px -5px 6px;" type="button" class="add_btn" onclick="addTr()" value="" />
														</td>
													</tr>
											</table>
											<div id="ACL_note">
											<div><i>1&nbsp;&nbsp;默认状态下，所有局域网的主机都会走当前节点的模式（主模式），相当于即不启用局域网访问控制。</i></div>
											<div><i>2&nbsp;&nbsp;当你添加了主机，并设置默认规则为不通过SS，则只有添加的主机才会走相应的模式。</i></div>
											<div><i>3&nbsp;&nbsp;当你添加了主机，并设置默认规则为当前节点的模式，除了添加的主机才会走相应的模式，未添加的主机会走默认规则的模式。</i></div>
											<div><i>4&nbsp;&nbsp;如果使用了KCP协议，或者负载均衡，因为它们不支持udp，所以不能控制单个主机走游戏模式。</i></div>
											</div>
										</div>
										<!--===== addon =====-->
										<div id="tablet_6" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
													<th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(42)">状态更新间隔</a></th>
													<td>
														<select id="ss_basic_refreshrate" name="ss_basic_refreshrate" class="input_option">
															<option value="0">不更新</option>
															<option value="5" selected>5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
												<tr id="ss_sleep_tr">
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(46)">开机启动延时</a></th>
													<td>
														<select id="ss_basic_sleep" name="ss_basic_sleep" class="ssconfig input_option" onchange="update_visibility_tab4();" >
															<option value="0" selected>0s</option>
															<option value="5">5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
														<span>设置开机延迟会导致软件中心插件启动滞后。</span>
													</td>
												</tr>
												<tr>
													<th style="width:20%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">导出SS配置</a></th>
													<td>
														<input type="button" class="ss_btn" style="cursor:pointer;" onclick="download_SS_node();" value="导出配置">
														<input type="button" class="ss_btn" style="cursor:pointer;" onclick="remove_SS_node();" value="清空配置">
													</td>
												</tr>
												<tr>
													<th style="width:20%;"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">恢复SS配置（支持ss/ssr的json节点）</a></th>
													<td>
														<input style="color:#FFCC00;*color:#000;width: 200px;" id="ss_file" type="file" name="file"/>
														<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif"/>
														<span id="ss_file_info" style="display:none;">完成</span>
														<input type="button" class="ss_btn" style="cursor:pointer;" onclick="upload_ss_backup();" value="恢复配置"/>
													</td>
												</tr>
											</table>
										</div>

										<!--log_content-->
										<div id="tablet_7" style="display: none;">
												<div id="log_content" style="margin-top:-1px;display:none">
													<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" style="width:97%; padding-left:10px; padding-right:10px; border:1px solid #222; font-family:'Lucida Console'; font-size:11px; background:#475A5F; color:#FFFFFF; outline:none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
												</div>
										</div>		

										<div class="apply_gen" id="loading_icon">
											<img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif">
										</div>
										<div id="apply_button" class="apply_gen">
											<input id="cmdBtn" class="button_gen" type="button" onclick="save()" value="提交">
										</div>
										<div id="warn" style="display: none;font-size: 20px;position: static;" class="formfontdesc" id="cmdDesc"><i>你开启了kcptun,请先关闭后才能开启shadowsocks</i></div>
										<div id="warn1" style="display: none;font-size: 20px;position: static;" class="formfontdesc" id="cmdDesc"><i>你开启了kcptun,请先关闭后才能开启shadowsocks</i></div>
										<div id="line_image1" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
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
</html>
