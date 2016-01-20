<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Shadowsocks - 账号信息配置</title>
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
#Ss_node_list_Block_PC {
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
#Ss_node_list_Block_PC div {
	background-color: #576D73;
	height: auto;
	*height:20px;
	line-height: 20px;
	text-decoration: none;
	font-family: Lucida Console;
	padding-left: 2px;
}
#Ss_node_list_Block_PC a {
	background-color: #EFEFEF;
	color: #FFF;
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	text-decoration: none;
}
#Ss_node_list_Block_PC div:hover, #Ss_node_list_Block a:hover {
	background-color: #3366FF;
	color: #FFFFFF;
	cursor: default;
}
#ss_node_edit{
	background: url(/images/New_ui/ss_list.png);
	background-position: 0px 0px;
	width: 30px;
	height: 35px;
}
</style>
<script>
var socks5 = 0
var $j = jQuery.noConflict();
var _responseLen;
var noChange = 0;
var over_var = 0;
var isMenuopen = 0;
var $G = function(id) {
    return document.getElementById(id);
};

var refreshRate = 5;
function init() {
    show_menu(menu_hook);
    version_show();
    show_hide_table();
    buildswitch();
    refreshRate = getRefresh();
    for (var field in db_ss) {
		$j('#'+field).val(db_ss[field]);
	}
    if (typeof db_ss != "undefined") {
        update_ss_ui(db_ss);
        loadAllConfigs();
    } else {
        document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
    }
    setTimeout("checkSSStatus();", 1000);
    setTimeout("write_ss_install_status()", 1000);
}
function onSubmitCtrl() {
	ssmode = document.getElementById("ss_basic_mode").value;
	global_status_enable=false;
	checkSSStatus();
    if (validForm()) {
        if (0 == node_global_max) {
            var obj = ssform2obj();
            ss_node_object("1", obj, true,
            function(a) {
			setTimeout("checkSSStatus();", 50000); //make sure ss_status do not update during reloading
			if (ssmode == "2" || ssmode == "3"){
				showSSLoadingBar(25);
			} else if (ssmode == "1"){
				showSSLoadingBar(12);
			} else if (ssmode == "0"){
				showSSLoadingBar(8);
			} else if (ssmode == "4"){
				showSSLoadingBar(8);
			}
        	document.form.action_mode.value = ' Refresh ';
        	updateOptions();
            });
        } else {
            var node_sel = $j('#ssconf_basic_node').val();
            var obj = ssform2obj();
            ss_node_object(node_sel, obj, true,
            function(a) {
			setTimeout("checkSSStatus();", 50000);
			if (ssmode == "2" || ssmode == "3"){
				showSSLoadingBar(25);
			} else if (ssmode == "1"){
				showSSLoadingBar(12);
			} else if (ssmode == "0"){
				showSSLoadingBar(8);
			} else if (ssmode == "4"){
				showSSLoadingBar(8);
			}
    		document.form.action_mode.value = ' Refresh ';
    		updateOptions();
            });
        }
    }
}

function done_validating(action) {
	return true;
}

function save_ss_method(m) {
    var o = document.getElementById("ss_basic_method");
    for (var c = 0; c < o.length; c++) {
        if (o.options[c].value == m) {
            o.options[c].selected = true;
            break;
        }
    }
}

function update_ss_ui(obj) {
	for (var field in obj) {
		var el = document.getElementById(field);
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
			if (obj[field] != "origin" && obj[field] != "verify_simple" && obj[field] != "verify_deflate" &&  obj[field] != "auth_simple" && obj[field] != "auth_sha1"&& obj[field] != "verify_sha1" ) {
				$j("#ss_basic_rss_protocol").val("origin");
			} else {
				$j("#ss_basic_rss_protocol").val(obj.ss_basic_rss_protocol);
			}
			continue;
		} else if (field == "ss_basic_rss_obfs") {
			if (obj[field] != "plain" && obj[field] != "http_simple" && obj[field] != "tls_simple" &&  obj[field] != "random_head" &&  obj[field] != "tls1.0_session_auth" ) {
				$j("#ss_basic_rss_obfs").val("plain");
			} else {
				$j("#ss_basic_rss_obfs").val(obj.ss_basic_rss_obfs);
			}
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
		if (el != null) {
			el.value = obj[field];
		}
	}
	$j("#ss_basic_method").val(obj.ss_basic_method);
}

function updateOptions() {
	document.form.action = "/applydb.cgi?p=ss";
	document.form.SystemCmd.value = "ssconfig basic";
	document.form.submit();
}

function validForm() {
	var is_ok = true;
	return is_ok;
}

function update_visibility() {
	ssmode = document.form.ss_basic_mode.value;
	crst = document.form.ss_basic_chromecast.value;
	cadb = document.form.ss_basic_adblock.value;
	sru = document.form.ss_basic_rule_update.value;
	slc = document.form.ss_basic_lan_control.value;
	std = readCookie("ss_table_detail");
	srp = document.form.ss_basic_rss_protocol.value;
	sro = document.form.ss_basic_rss_obfs.value;
	sur = document.form.hd_ss_basic_use_rss.value
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
		$j("#ss_basic_rss_protocol_alert").html("抗重放攻击和抗CCA攻击");
	}

	if (sro == "plain"){
		$j("#ss_basic_rss_obfs_alert").html("不混淆");
	} else if (sro == "http_simple"){
		$j("#ss_basic_rss_obfs_alert").html("伪装为http协议");
	} else if (sro == "tls_simple"){
		$j("#ss_basic_rss_obfs_alert").html("伪装为tls协议");
	} else if (sro == "random_head"){
		$j("#ss_basic_rss_obfs_alert").html("发送一个随机包再通讯的协议");
	} else if (sro == "tls1.0_session_auth"){
		$j("#ss_basic_rss_obfs_alert").html("伪装为tls session握手协议同时能抗重放攻击");
	}
	
	if (ssmode == "0"){
		$j("#mode_state").html("SS运行状态");
	} else if (ssmode == "1"){
		$j("#mode_state").html("SS运行状态【gfwlist模式】");
	} else if (ssmode == "2"){
		$j("#mode_state").html("SS运行状态【大陆白名单模式】");
	} else if (ssmode == "3"){
		$j("#mode_state").html("SS运行状态【游戏模式】");
	} else if (ssmode == "4"){
		$j("#mode_state").html("SS运行状态【全局模式】");
	}
	showhide("123", (ssmode !== "4"));
	showhide("ss_state1", (ssmode == "0"));
	showhide("ss_state2", (ssmode !== "0"));
	showhide("ss_state3", (ssmode !== "0"));
	showhide("update_rules", (ssmode !== "0"));
	showhide("game_alert", (ssmode == "3"));
	showhide("chromecast1", (crst == "0"));
	showhide("gfw_number", (ssmode == "1"));
	showhide("chn_number", (ssmode == "2" || ssmode == "3"));
	showhide("cdn_number", (ssmode == "2" || ssmode == "3"));
	showhide("adblock_nu", (cadb == "1" && ssmode !== "0"));
	showhide("adblock_nu1", (cadb == "1"));
	showhide("ss_basic_rule_update_time", (sru == "1"));
	showhide("update_choose", (sru == "1"));
	showhide("help", (ssmode !== "0"));
	showhide("help_mode1", (ssmode == "1"));
	showhide("help_mode2", (ssmode == "2"));
	showhide("help_mode3", (ssmode == "3"));
	showhide("help_mode4", (ssmode == "4"));
	showhide("ss_basic_black_lan", (slc == "1"));
	showhide("ss_basic_white_lan", (slc == "2"));
	showhide("onetime_auth", (sur !== "1"));
	showhide("ss_basic_rss_protocol_tr", (sur == "1"));
	showhide("ss_basic_rss_obfs_tr", (sur == "1"));
}

function oncheckclick(obj) {
	if (obj.checked) {
		document.getElementById("hd_" + obj.id).value = "1";
	} else {
		document.getElementById("hd_" + obj.id).value = "0";
	}
}

var global_status_enable = true;
/*
function checkSSStatus() {
    if (db_ss['ss_basic_enable'] !== "0") {
	    if(!global_status_enable) {//not enabled
		    if(refreshRate > 0) {
			    setTimeout("checkSSStatus();", refreshRate * 10000);
		    }
		    return;
	    }
        $j.ajax({
            url: '/ss_status',
            dataType: 'html',
            error: function(xhr) {
	            if (refreshRate > 0)
                setTimeout("checkSSStatus();", refreshRate * 1000);
            },
            success: function(response) {
                var arr = JSON.parse(response);
                document.getElementById("ss_state2").innerHTML = "国外连接 - " + arr[0];
                document.getElementById("ss_state3").innerHTML = "国内连接 - " + arr[1];
                if (refreshRate > 0)
                setTimeout("checkSSStatus();", refreshRate * 1000);
            }
        });
    } else {
        document.getElementById("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
        document.getElementById("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
        //setTimeout("checkSSStatus();", refreshRate * 1000);
    }
}
*/
function checkSSStatus() {
	if (db_ss['ss_basic_enable'] !== "0") {
	    if(!global_status_enable) {//not enabled
		    if(refreshRate > 0) {
			    setTimeout("checkSSStatus();", refreshRate * 100000);
		    }
		    return;
	    }
		$j.ajax({
		url: '/ss_status',
		dataType: "html",
        error: function(xhr) {
	        refreshRate = getRefresh();
	        if (refreshRate > 0)
            setTimeout("checkSSStatus();", refreshRate * 1000);
        },
		success: function() {
			$j("#ss_state2").html("国外连接 - " + db_ss['ss_basic_state_foreign']);
			$j("#ss_state3").html("国内连接 - " + db_ss['ss_basic_state_china']);
			refreshRate = getRefresh();
			if (refreshRate > 0)
        	setTimeout("checkSSStatus();", refreshRate * 1000);
		}
		});
	} else {
		document.getElementById("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
        document.getElementById("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
	}
}


function updatelist() {
    $j.ajax({
        url: 'apply.cgi?current_page=Main_Ss_Update.asp&next_page=Main_Ss_Content.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=update.sh&firmver=3.0.0.4',
        dataType: 'html',
        error: function(xhr) {},
        success: function(response) {
            if (response == "ok") {
                alert("将跳转到SS日志，查看更新情况");
                window.location.href = "Main_SsLog_Content.asp"
            }
        }
    });
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
            "ss_basic_onetime_auth": ""
        };
        return obj;
    } else {
        var obj = {};
        var params = ["server", "port", "password", "method", "rss_protocol", "rss_obfs", "use_rss", "onetime_auth"];
        for (var i = 0; i < params.length; i++) {
            obj["ss_basic_" + params[i]] = db_ss[p + "_" + params[i] + "_" + node_sel];
        }
        return obj;
    }
}

function ss_node_sel() {
    var node_sel = $G("ssconf_basic_node").value;
    var obj = ssconf_node2obj(node_sel);
    update_ss_ui(obj);
    update_visibility();
}

function ss_node_object(node_sel, obj, isSubmit, end) {
    var ns = {};
    var p = "ssconf_basic";
    var params = ["server", "port", "password", "method", "rss_protocol", "rss_obfs", "use_rss", "onetime_auth"];
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
    obj["use_rss"] = $G("hd_ss_basic_use_rss").value;
    obj["onetime_auth"] = $G("ss_basic_onetime_auth").value;
    return obj;
}

var ss_node_list_view_hide_flag = false;
function hide_ss_node_list_view_block() {
    if (ss_node_list_view_hide_flag) {
        fadeOut(document.getElementById("ss_node_list_viewlist_content"), 10, 0);
        document.body.onclick = null;
        document.body.onresize = null;
        clientListViewMacUploadIcon = [];
        removeIframeClick("statusframe", hide_ss_node_list_view_block);
    }
    ss_node_list_view_hide_flag = true;
}

function show_ss_node_list_view_block() {
    ss_node_list_view_hide_flag = false;
}

function closeSs_node_listView() {
    fadeOut(document.getElementById("ss_node_list_viewlist_content"), 10, 0);
}

function refresh_popup_listview(confs) {
    $j("#ss_node_list_viewlist_content").remove();
    $j("<div class='ss_node_list_viewlist' id='ss_node_list_viewlist_content' style='display:none'>").appendTo(document.body);
    create_ss_node_list_listview(confs);
    registerIframeClick("statusframe", hide_ss_node_list_view_block);
}

function pop_ss_node_list_listview() {
    confs = getAllConfigs();
    refresh_popup_listview(confs);
    fadeIn(document.getElementById("ss_node_list_viewlist_content"));
    cal_panel_block_clientList("ss_node_list_viewlist_content", 0.045);
    ss_node_list_view_hide_flag = false;
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
    refresh_popup_listview(confs);
}

function add_conf_in_table(o) {
    var ns = {};
    var p = "ssconf_basic";
    node_global_max += 1;
    var params = ["name", "server", "port", "password", "method", "rss_protocol", "rss_obfs", "use_rss", "onetime_auth"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_global_max] = $j('#ssconf_table_' + params[i]).val();
    }
    $j.ajax({
        url: '/applydb.cgi?p=ss',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            updateSs_node_listView();
        }
    });
}

function remove_conf_table(o) {
    var id = $j(o).attr("id");
    var ids = id.split("_");
    var p = "ssconf_basic";
    id = ids[ids.length - 1];
    var ns = {};
    var params = ["name", "mode", "server", "port", "password", "method", "rss_protocol", "rss_obfs", "onetime_auth"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + id] = "";
    }
    $j.ajax({
        url: '/applydb.cgi?use_rm=1&p=ss',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            updateSs_node_listView();
        }
    });
}

function create_ss_node_list_listview(confs) {
    field_code = "";
    for (var field in confs) {
        var c = confs[field];
        field_code += "<tr height='40px'>";
        field_code += "<td>" + c["name"] + "</td>";
        field_code += "<td>" + c["server"] + "</td>";
        field_code += "<td>" + c["port"] + "</td>";
        field_code += "<td>" + c["password"] + "</td>";
        field_code += "<td>" + c["method"] + "</td>";
        field_code += "<td><input id='td_node_" + c["node"] + "' class='remove_btn' type='button' onclick='return remove_conf_table(this);' value=''></td>";
        field_code += "</tr>";
    }
    if (document.getElementById("ss_node_list_viewlist_block") != null) {
        removeElement(document.getElementById("ss_node_list_viewlist_block"));
    }
    var divObj = document.createElement("div");
    divObj.setAttribute("id", "ss_node_list_viewlist_block");
    var obj_width_map = [["15%", "45%", "20%", "20%"], ["10%", "45%", "19%", "19%", "7%"], ["20%", "20%", "20%", "20%", "20%", "12%"]];
    var obj_width = stainfo_support ? obj_width_map[2] : obj_width_map[1];
    var wl_colspan = stainfo_support ? 8 : 5;
    var code = "";
    code += "<form method='POST' name='file_form' action='/ssupload.cgi?a=/tmp/ss_conf_backup.txt' target='hidden_frame'>";
    code += "<div style='text-align:right;width:30px;position:relative;margin-top:0px;margin-left:96%;'><img src='/images/button-close.gif' style='width:30px;cursor:pointer' onclick='closeSs_node_listView();'></div>";
    code += "<table width='100%' border='1' align='center' cellpadding='0' cellspacing='0' class='FormTable_table' style='margin-top:10px;'>";
    code += "<thead>";
    code += "<tr height='28px'>";
    code += "<td id='td_all_list_title' colspan='" + wl_colspan + "'>Shadowsocks节点配置</td>";
    code += "</tr>";
    code += "</thead>";
    code += "<tr id='tr_all_title' height='40px'>";
    code += "<th width=" + obj_width[0] + ">节点名称</th>";
    code += "<th width=" + obj_width[1] + ">服务器地址</th>";
    code += "<th width=" + obj_width[2] + ">端口</th>";
    code += "<th width=" + obj_width[3] + ">密码</th>";
    code += "<th width=" + obj_width[4] + ">加密方式</th>";
    code += "<th width=" + obj_width[5] + ">添加<br>删除</th>";
    code += "</tr>";
    code += "<tr height='40px'>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_name' name='ssconf_table_name' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_server' name='ssconf_table_server' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_port' name='ssconf_table_port' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_password' name='ssconf_table_password' value='' /></td>";
    code += "<td><select id='ssconf_table_method' name='ssconf_table_method' style='width:164px;margin:0px 0px 0px 2px;' class='input_option' />"
    code += "<option class='content_input_fd' value='table'>table</option>";
    code += "<option class='content_input_fd' value='rc4'>rc4</option>";
    code += "<option class='content_input_fd' value='rc4-md5'>rc4-md5</option>";
    code += "<option class='content_input_fd' value='aes-128-cfb'>aes-128-cfb</option>";
    code += "<option class='content_input_fd' value='aes-192-cfb'>aes-192-cfb</option>";
    code += "<option class='content_input_fd' value='aes-256-cfb' selected=''>aes-256-cfb</option>";
    code += "<option class='content_input_fd' value='bf-cfb'>bf-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-128-cfb'>camellia-128-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-192-cfb'>camellia-192-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-256-cfb'>camellia-256-cfb</option>";
    code += "<option class='content_input_fd' value='cast5-cfb'>cast5-cfb</option>";
    code += "<option class='content_input_fd' value='des-cfb'>des-cfb</option>";
    code += "<option class='content_input_fd' value='idea-cfb'>idea-cfb</option>";
    code += "<option class='content_input_fd' value='rc2-cfb'>rc2-cfb</option>";
    code += "<option class='content_input_fd' value='seed-cfb'>seed-cfb</option>";
    code += "<option class='content_input_fd' value='salsa20'>salsa20</option>";
    code += "<option class='content_input_fd' value='chacha20'>chacha20</option>";
    code += "</select>";
    code += "<td><input class='add_btn' onclick='add_conf_in_table(this);' type='button' value=''></td>";
    code += "</tr>";
    code += field_code;
    code += "<tr>";
    code += "</tr>";
    code += "</table>";
    code += "<div style='align:center;margin-left:220px;margin-top:15px'>";
    code += "<table>";
    code += "<tr>";
    code += "<td style='border:1px'>";
    code += "<input type='button' class='button_gen' onclick='remove_SS_node();' value='清空配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='margin-left:50px;' type='button' class='button_gen' onclick='download_SS_node();' value='导出配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='margin-left:50px;' type='button' id='upload_btn' class='button_gen' onclick='upload_SS_node();' value='恢复配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='color:#FFCC00;*color:#000;width: 200px;'id='ss_file' type='file' name='file'/>";
    code += "<img id='loadingicon' style='margin-left:5px;margin-right:5px;display:none;' src='/images/InternetScan.gif'/>";
    code += "<span id='ss_file_info' style='display:none;'>完成</span>";
    code += "</td>";

    //code += "<td style='border:1px'>";
    
    //code += "</td>";
    code += "</tr>";
    code += "</table>";
    code += "<div style='align:center;margin-left:180px;margin-top:20px;margin-bottom:20px;'><input type='button' class='button_gen' onclick='closeSs_node_listView();' value='返回'></div>";
    code += "</div>";
    code += "<div id='clientlist_all_list_Block'></div>";
    code += "</form>";
    divObj.innerHTML = code;
    document.getElementById("ss_node_list_viewlist_content").appendChild(divObj);
}

function download_SS_node() {
	location.href='ss_conf_backup.txt';
}

function upload_SS_node() {
	if (document.getElementById('ss_file').value == "") return false;
	document.getElementById('ss_file_info').style.display = "none";
	document.getElementById('loadingicon').style.display = "block";
	//document.form.action = "ssupload.cgi?a=/tmp/ss_conf_backup.txt";
	document.file_form.enctype = "multipart/form-data";
	document.file_form.encoding = "multipart/form-data";
	//console.log(document.file_form);
	//console.log(document.file_form[0]);
	document.file_form.submit();
	
	}

function upload_ok(isok) {
	var info = document.getElementById('ss_file_info');
	if(isok==1){
		info.innerHTML="上传完成";
		restore_ss_conf();
	} else {
		info.innerHTML="上传失败";
	}
	info.style.display = "block";
	document.getElementById('loadingicon').style.display = "none";
}

function restore_ss_conf() {
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_conf_restore.sh";
    document.form.submit();
    //setTimeout("onSubmitCtrl();", 2000);
    refreshpage(2);
}

function remove_SS_node() {
	global_status_enable=false;
	checkSSStatus();
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_conf_remove.sh";
    document.form.submit();
    refreshpage(2);
}

function updateSs_node_listView() {
    $j.ajax({
        url: '/dbconf?p=ss',
        dataType: 'html',
        error: function(xhr) {            
	        },
        success: function(response) {
            $j.globalEval(response);
            loadAllConfigs();
            cal_panel_block_clientList("ss_node_list_viewlist_content", 0.045);
            $j("#ss_node_list_viewlist_content").show();
        }
    });
}

function show_detail(thisObj) {
    var state1 = readCookie("ss_table_detail")
    if (state1 == "1") {
        slideDown("detail_show", 350);
        slideDown("add_fun", 350);
        slideDown("help_mode", 350);
        slideDown("status_update_interval", 350);
        slideDown("boot_delay", 350);
        thisObj.innerHTML = "[ 简洁 ]";
        createCookie("ss_table_detail", 0, 365);
    } else {
        slideUp("detail_show", 350);
        slideUp("add_fun", 350);
        slideUp("help_mode", 350);
        slideUp("status_update_interval", 350);
        slideUp("boot_delay", 350);
        thisObj.innerHTML = "[ 详细 ]";
        createCookie("ss_table_detail", 1, 365);
    }
}

function init_detail() {
    var std = readCookie("ss_table_detail")
    if (std == "1") {
        document.getElementById("detail_show").style.display = "none";
        document.getElementById("add_fun").style.display = "none";
        document.getElementById("help_mode").style.display = "none";
        document.getElementById("status_update_interval").style.display = "none";
        document.getElementById("boot_delay").style.display = "none";
        $j("#detail_show_hide").html("[ 详细 ]");
    } else {
        document.getElementById("detail_show").style.display = "";
        document.getElementById("add_fun").style.display = "";
        document.getElementById("help_mode").style.display = "";
        document.getElementById("status_update_interval").style.display = "";
        document.getElementById("boot_delay").style.display = "";
        $j("#detail_show_hide").html("[ 简洁 ]");
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
	checkSSStatus();
}
function getRefresh() {
	val = parseInt(cookie.get('status_restart'));
	if ((val != 0) && (val != 5) && (val != 10) && (val != 15) && (val != 30) && (val != 60))
	val = 10;
	document.getElementById('refreshrate').value = val;
	return val;
}


function buildswitch(){
	$j("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.action_mode.value = ' Refresh ';
			document.getElementById('ss_basic_enable').value = 1;
			update_visibility();
			document.getElementById('basic_show').style.display = "";
			document.getElementById('detail_show').style.display = "";	
			document.getElementById('add_fun').style.display = "";	
			document.getElementById('ss_status1').style.display = "";	
			document.getElementById('status_update_interval').style.display = "";	
			document.getElementById('ss_rule_number').style.display = "";	
			document.getElementById('boot_delay').style.display = "";	
			document.getElementById('help_mode').style.display = "";	
			document.getElementById('apply_button').style.display = "";	
			document.getElementById('line_image1').style.display = "";	
			document.getElementById('help_note').style.display = "";	
		}else{
			document.form.ss_basic_enable.value = 0;
			showSSLoadingBar(8);
			document.form.action_mode.value = ' Refresh ';
			document.form.action = "/applydb.cgi?p=ss";
			document.form.SystemCmd.value = "ssconfig basic";
			document.form.submit();
			document.getElementById('basic_show').style.display = "none";
			document.getElementById('detail_show').style.display = "none";	
			document.getElementById('add_fun').style.display = "none";	
			document.getElementById('ss_status1').style.display = "none";	
			document.getElementById('status_update_interval').style.display = "none";	
			document.getElementById('ss_rule_number').style.display = "none";	
			document.getElementById('boot_delay').style.display = "none";	
			document.getElementById('help_mode').style.display = "none";	
			document.getElementById('apply_button').style.display = "none";	
			document.getElementById('line_image1').style.display = "none";	
			document.getElementById('help_note').style.display = "none";	
		}
	});
}

function show_hide_table(){
	if (db_ss['ss_basic_enable'] == "1"){
		document.getElementById("switch").checked = true;
    	update_visibility();
    	init_detail();
	} else {
		document.getElementById("switch").checked = false;
		document.getElementById('basic_show').style.display = "none";
		document.getElementById('detail_show').style.display = "none";	
		document.getElementById('add_fun').style.display = "none";	
		document.getElementById('ss_status1').style.display = "none";	
		document.getElementById('status_update_interval').style.display = "none";	
		document.getElementById('ss_rule_number').style.display = "none";	
		document.getElementById('boot_delay').style.display = "none";	
		document.getElementById('help_mode').style.display = "none";	
		document.getElementById('apply_button').style.display = "none";	
		document.getElementById('line_image1').style.display = "none";	
		document.getElementById('help_note').style.display = "none";	
	}
}

function version_show(){
	if (db_ss['ss_basic_version_local'] != db_ss['ss_basic_version_web'] && db_ss['ss_basic_version_web'] !== "undefined"){
		$j("#ss_version_show").html("<i>有新版本：" + db_ss['ss_basic_version_web']);
	} else {
		$j("#ss_version_show").html("<i>当前版本：" + db_ss['ss_basic_version_local']);
	}
}

function write_ss_install_status(){
		$j.ajax({
		type: "get",
		url: "dbconf?p=ss",
		dataType: "script",
		success: function() {
		if (db_ss['ss_basic_install_status'] == "1"){
			$j("#ss_install_show").html("<i>正在下载更新...</i>");
			document.getElementById('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "2"){
			$j("#ss_install_show").html("<i>正在安装更新...</i>");
			document.getElementById('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "3"){
			$j("#ss_install_show").html("<i>安装更新成功，5秒自动重启SS！</i>");
			document.getElementById('ss_version_show').style.display = "none";
			version_show();
			setTimeout("write_ss_install_status()", 200000);
			setTimeout("onSubmitCtrl();", 4000);
		} else if (db_ss['ss_basic_install_status'] == "4"){
			$j("#ss_install_show").html("<i>下载文件校验不一致！</i>");
			document.getElementById('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "5"){
			$j("#ss_install_show").html("<i>然而并没有更新！</i>");
			document.getElementById('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "6"){
			document.getElementById('ss_version_show').style.display = "none";
			$j("#ss_install_show").html("<i>正在检查是否有更新~</i>");
			document.getElementById('update_button').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "7"){
			$j("#ss_install_show").html("<i>检测更新错误！</i>");
		} else {
			$j("#ss_install_show").html("");
			document.getElementById('update_button').style.display = "";
			document.getElementById('ss_version_show').style.display = "";
		}
		setTimeout("write_ss_install_status()", 2000);
		}
		});
	}

function update_ss(){
	global_status_enable=false;
	checkSSStatus();
	document.form.ss_basic_update_check.value = 1;
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ssconfig basic";
    document.form.submit();
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
<input type="hidden" name="current_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="next_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="25"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="0" />
<input type="hidden" id="ss_basic_install_status" name="ss_basic_install_status" value="0" />
<input type="hidden" id="ss_basic_update_check" name="ss_basic_update_check" value="0" />
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
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">Shadowsocks - 账号信息配置</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote"><i>说明：</i>请在下面的<em>Shadowsocks信息</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。</div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ss_switch_table">
											<thead>
											<tr>
												<td colspan="2">开关</td>
											</tr>
											</thead>
											<tr>
											<th>ShadowSocks 开关</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
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
													<div id="update_button" style="padding-top:5px;margin-left:100px;margin-top:-35px;float: left;">
														<button id="updateBtn" class="button_gen" onclick="update_ss();">检查更新</button>
														<a style="margin-left: 185px;" href="https://github.com/koolshare/koolshare.github.io/blob/master/shadowsocks" target="_blank"><em>[<u>view code</u>]</em></a>
													</div>
													<div id="ss_version_show" style="padding-top:5px;margin-left:230px;margin-top:-27px;"><i>当前版本：<% dbus_get_def("ss_version_local", "未知"); %></i></div>
													<div id="ss_install_show" style="padding-top:5px;margin-left:230px;margin-top:-29px;"></div>	
												</td>
											</tr>
                                    	</table>
										<div id="basic_show">
											<table style="margin:10px 0px 0px 0px;" width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<thead>
												<tr>
													<td colspan="2">Shadowsocks信息
														<i id="detail_show_hide" name="detail_show_hide" value="" class="clientlist_expander" style="cursor:pointer;margin-left: 565px;" onclick="show_detail(this);">[ 简洁 ]</i>
													</td>
												</tr>
												</thead>
											</table>
											<table style="margin:-1px 0px 0px 0px;" width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
													<th width="35%">节点选择</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="ssconf_basic_node" name="ssconf_basic_node" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="ss_node_sel();update_visibility();" >
															</select>
														</div>
														<div id="ss_node_edit" style="float:left; width:35px; height:35px;margin:-3px 0px -5px 2px;cursor:pointer" onclick="pop_ss_node_list_listview(true);"></div>
													</td>
												</tr>
												<tr>
													<th width="35%">模式</th>
													<td>
														<select id="ss_basic_mode" name="ss_basic_mode" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility();" >
															<!--<option value="0">【0】 禁用</option>-->
															<option value="1">【1】 GFWlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="3">【3】 游戏模式</option>
															<option value="4">【4】 全局代理模式</option>
														</select>
														<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px;">
															<input type="checkbox" id="ss_basic_use_rss" onclick="oncheckclick(this);update_visibility();" />
															<input type="hidden" id="hd_ss_basic_use_rss" name="ss_basic_use_rss" value="" />
															使用SSR
														</div>
														<div id="game_alert" style="margin-left:270px;margin-top:-20px;margin-bottom:0px;">
															<a href="http://koolshare.cn/thread-4519-1-1.html" target="_blank"><i>&nbsp;账号需支持UDP转发&nbsp;&nbsp;<u>FAQ</u></i></a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="detail_show">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="server_tr">
													<th width="35%">服务器</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_server" name="ss_basic_server" maxlength="100" value=""/>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%">服务器端口</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_port" name="ss_basic_port" maxlength="100" value="" />
														<!--<input readonly style="background:transparent;" name="ssconf_basic_time" id="ssconf_basic_time" class="input_ss_table" maxlength="100" value=""/>-->

													</td>
												</tr>
												<tr id="pass_tr">
													<th width="35%">密码</th>
													<td>
														<input type="password" name="ss_basic_password" id="ss_basic_password" class="ssconfig input_ss_table" maxlength="100" value=""></input>
														<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ss_basic_password);">
															显示密码
														</div>
													</td>
												</tr>
												<tr id="method_tr">
													<th width="35%">加密方式</th>
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
														</select>
													</td>
												</tr>

												<tr id="onetime_auth">
													<th width="35%"><a href="https://shadowsocks.org/en/spec/one-time-auth.html" target="_blank"><u>onetime authentication</font></u></a></th>
													<td>
														<select id="ss_basic_onetime_auth" name="ss_basic_onetime_auth" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="1">开启</option>
															<option class="content_input_fd" value="0">关闭</option>
														</select>
														<span id="ss_basic_onetime_auth_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_rss_protocol_tr">
													<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>协议 (protocol)</u></a></th>
													<td>
														<select id="ss_basic_rss_protocol" name="ss_basic_rss_protocol" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_visibility();" >
															<option class="content_input_fd" value="origin">origin</option>
															<option class="content_input_fd" value="verify_simple">verify_simple</option>
															<option class="content_input_fd" value="verify_deflate">verify_deflate</option>
															<option class="content_input_fd" value="verify_sha1">verify_sha1</option>
															<option class="content_input_fd" value="auth_simple">auth_simple</option>
															<option class="content_input_fd" value="auth_sha1">auth_sha1</option>
														</select>
														<span id="ss_basic_rss_protocol_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px">yuanben</span>
													</td>
												</tr>
												<tr id="ss_basic_rss_obfs_tr">
													<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>混淆插件 (obfs)</u></a></th>
													<td>
														<select id="ss_basic_rss_obfs" name="ss_basic_rss_obfs" style="width:164px;margin:0px 0px 0px 2px;" class="input_option"  onchange="update_visibility();" >
															<option class="content_input_fd" value="plain">plain</option>
															<option class="content_input_fd" value="http_simple">http_simple</option>
															<option class="content_input_fd" value="tls_simple">tls_simple</option>
															<option class="content_input_fd" value="random_head">random_head</option>
															<option class="content_input_fd" value="tls1.0_session_auth">tls1.0_session_auth</option>
														</select>
														<span id="ss_basic_rss_obfs_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>


												
												
											</table>
										</div>
										<div id="add_fun">
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<thead >
												<tr>
													<td colspan="2">附加功能</td>
												</tr>
												</thead>
											</table>
										</div>
										<div id="ss_status1">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_state">
												<th id="mode_state" width="35%">SS运行状态</th>
													<td>
														<a>
															<span style="display: none" id="ss_state1">尚未启用! </span>
															<!--<span id="ss_state2">国外连接 - <% nvram_get("ss_foreign_state"); %></span>-->
															<span id="ss_state2">国外连接 - Waiting...</span>
															<br/>
															<!--<span id="ss_state3">国内连接 - <% nvram_get("ss_china_state"); %></span>-->
															<span id="ss_state3">国内连接 - Waiting...</span>
														</a>
													</td>
												</tr>
											</table>
										</div>
										<div id="status_update_interval">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
												<th>状态更新间隔</th>
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
											</table>
										</div>
										<div id="ss_rule_number">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >		
												<tr  id="gfw_number">
													<th id="gfw_nu1" width="35%">当前gfwlist域名数量</th>
													<td id="gfw_nu2">
															<% nvram_get("ipset_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank">
																<i><% nvram_get("update_ipset"); %></i>
														</a>
													</td>
												</tr>
												<tr  id="chn_number">
													<th id="chn_nu1" width="35%">当前大陆白名单IP段数量</th>
												<td id="chn_nu2">
													<p>
														<% nvram_get("chnroute_numbers"); %>&nbsp;行，最后更新版本：
														<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/chnroute.txt" target="_blank">
															<i><% nvram_get("update_chnroute"); %></i>
														</a>
													</p>
												</td>
												</tr>
												<tr  id="cdn_number">
													<th id="cdn_nu1" width="35%">当前国内域名数量</th>
													<td id="cdn_nu2">
														<p>
														<% nvram_get("cdn_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/cdn.txt" target="_blank">
																<i><% nvram_get("update_cdn"); %></i>
															</a>
														</p>
													</td>
												</tr>
												<tr id="chromecast">
													<th width="35%">Chromecast支持</th>
													<td>
														<select id="ss_basic_chromecast" name="ss_basic_chromecast" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="chromecast1"> 建议开启chromecast支持 </span>
													</td>
												</tr>
												<tr id="123">
													<th width="35%">广告过滤</th>
													<td>
														<select id="ss_basic_adblock" name="ss_basic_adblock" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="adblock_nu" >当前规则条数 ：<% nvram_get("adblock_numbers"); %>，最后更新版本：
																		<a id="adblock_nu1" href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/adblock.conf" target="_blank">
																			<i><% nvram_get("update_adblock"); %></i>
																		</a>
															</span>
													</td>
												</tr>
												<tr id="update_rules">
													<th width="35%">Shadowsocks规则自动更新</th>
													<td>
														<select id="ss_basic_rule_update" name="ss_basic_rule_update" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
														<select id="ss_basic_rule_update_time" name="ss_basic_rule_update_time" class="ssconfig input_option" title="选择规则列表自动更新时间，更新后将自动重启SS" onchange="update_visibility();" >
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
																<input type="checkbox" id="ss_basic_adblock_update" name="a4" onclick="oncheckclick(this);">adblock
																<input type="hidden" id="hd_ss_basic_gfwlist_update" name="ss_basic_gfwlist_update" value=""/>
																<input type="hidden" id="hd_ss_basic_chnroute_update" name="ss_basic_chnroute_update" value=""/>
																<input type="hidden" id="hd_ss_basic_cdn_update" name="ss_basic_cdn_update" value=""/>
																<input type="hidden" id="hd_ss_basic_adblock_update" name="ss_basic_adblock_update" value=""/>
															</a>
																<input id="update_now" onclick="updatelist()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="立即更新" />
															<a href="http://192.168.1.1/Main_SsLog_Content.asp" target="_blank"></a>
													</td>
												</tr>
												<tr id="ss_lan_controls">
													<th width="35%">局域网客户端控制</th>
													<td>
														<select id="ss_basic_lan_control" name="ss_basic_lan_control" class="input_ss_table" style="width:auto;height:25px;margin-left: 0px;" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">黑名单模式</option>
															<option value="2">白名单模式</option>
														</select>
															<input type="text" class="input_ss_table" style="width:auto;display: none;" id="ss_basic_black_lan" name="ss_basic_black_lan" maxlength="80" size="43" placeholder="需要限制客户端IP如:192.168.1.2,192.168.1.3" value="">
															<input type="text" class="input_ss_table" style="width:auto;display: none;" id="ss_basic_white_lan" name="ss_basic_white_lan" maxlength="80" size="43" placeholder="仅允许的客户端IP如:192.168.1.2,192.168.1.3" value="">
													</td>
												</tr>
											</table>
										</div>
										<div id="boot_delay">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_sleep_tr">
													<th width="35%">开机启动延时</th>
													<td>
														<select id="ss_basic_sleep" name="ss_basic_sleep" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">0s</option>
															<option value="5">5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
											</table>
										</div>
										<div id="help_mode" >
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<thead>
												<tr id="help">
													<td colspan="2">当前模式说明</td>
												</tr>
												</thead>
												<tr id="help_mode1">
													<th>
														<h3>【1】 Gfwlist模式</h3>
													</th>
													<td>
														<p> 该模式使用Gfwlist区分流量，Shadowsocks会将所有访问Gfwlist内域名的TCP链接转发到Shadowsocks服务器，实现透明代理。 </p>
														<p><b> 优点：</b>节省SS流量，可防止迅雷和PT流量。 </p>
														<p><b> 缺点：</b>代理受限于名单内的3000多个被墙网站，需要维护黑名单。</p>
													</td>
												</tr>
												<tr id="help_mode2">
													<th>
														<h3>【2】 大陆白名单模式</h3>
													</th>
													<td>
														<p> 该模式使用chnroute IP网段区分国内外流量，Redsocks2会将所有到国外的TCP链接转发到Shadowsocks服务器，实现透明代理。 </p>
														<p><b> 优点：</b>所有国外网站通过代理访问；主机玩家用此模式可以实现TCP代理UDP国内直连 </p>
														<p><b> 缺点：</b>消耗更多的Shadowsocks流量，迅雷下载和BT可能消耗SS流量。</p>
													</td>
												</tr>
												<tr id="help_mode3">
													<th>
														<h3>【3】 游戏模式（NAT2 ready）</h3>
													</th>
													<td>
														<p> 游戏模式较于其它模式最大的特点就是支持UDP代理，能让游戏的UDP链接走SS，主机玩家用此模式可以实现TCP+UDP走SS代理 。 </p>
														<p><b> 优点：</b>除了具有大陆白名单模式的优点外，还能代理UDP链接，并且实现主机游戏<b> NAT2!</b> </p>
														<p><b> 缺点：</b>迅雷等BT下载多为UDP，如P2P链接中有国外地址，这部分流量就会走SS！</p>
													</td>
												</tr>
												<tr id="help_mode4">
													<th>
														<h3>【4】 全局代理模式【Redsocks2】</h3>
													</th>
													<td>
														<p> 该除局域网和ss服务器等流量不走代理，其它都走代理，高级设置中提供了对代理协议的选择。 </p>
														<p><b> 优点：</b>简单暴力，全部出国。 </p>
														<p><b> 缺点：</b>国内网站全部走ss，迅雷下载和BT全部走SS流量。</p>
													</td>
													</tr>
											</table>									
										</div>
										<div id="apply_button"class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl()" type="button" value="提交"/>
										</div>
										<div id="line_image1" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div id="help_note" class="SimpleNote">
											<button onclick="openShutManager(this,'NoteBox',false,'点击关闭详细说明','点击查看详细说明') " class="NoteButton">点击查看详细说明</button>
										</div>
										<div id="NoteBox" style="display:none">
											<h2>特别注意事项</h2>
												<p>启用服务后建议刷新电脑后台缓存，windows下运行CMD，输入 <b>ipconfig /flushdns </b> 能更快看到代理效果。</p>
												<p>请勿在你的设备上定义第三方DNS，如果你曾经定义过翻墙host文件，也请删掉这些host 。</p>
											<h2>各模式说明</h2>
											<h3>【1】 Gfwlist模式</h3>
												<p> 该模式使用Gfwlist区分流量，Shadowsocks会将所有访问Gfwlist内域名的TCP链接转发到Shadowsocks服务器，实现透明代理。 </p>
												<p><b> 优点：</b>节省SS流量，可防止迅雷和PT流量。 </p>
												<p><b> 缺点：</b>代理受限于名单内的3000多个被墙网站，需要维护黑名单。</p>
											<h3>【2】 大陆白名单模式</h3>
												<p> 该模式使用chnroute IP网段区分国内外流量，Redsocks2会将所有到国外的TCP链接转发到Shadowsocks服务器，实现透明代理。 </p>
												<p><b> 优点：</b>所有被墙国外网站均能通过代理访问，无需维护域名黑名单；主机玩家用此模式可以实现TCP代理UDP国内直连 </p>
												<p><b> 缺点：</b>消耗更多的Shadowsocks流量，迅雷下载和BT可能消耗SS流量。</p>
											<h3>【3】 游戏模式（NAT 2 ready）</h3>
												<p> 游戏模式较于其它模式最大的特点就是支持UDP代理，能让游戏的UDP链接走SS，主机玩家用此模式可以实现TCP+UDP走SS代理 。 </p>
												<p><b> 优点：</b>除了具有大陆白名单模式的优点外，还能代理UDP链接，并且实现主机游戏<b> NAT2!</b> </p>
												<p><b> 缺点：</b>由于UDP链接也走SS，而迅雷等BT下载多为UDP链接，如果下载资源的P2P链接中有国外链接，这部分流量就会走SS！</p>
											<h3>【4】 全局代理模式【Redsocks2】</h3>
												<p> 该除局域网和ss服务器等流量不走代理，其它都走代理，高级设置中提供了对代理协议的选择。 </p>
												<p><b> 优点：</b>简单暴力，全部出国；可选仅web浏览走ss，还是全部tcp代理走ss </p>
												<p><b> 缺点：</b>国内网站全部走ss，迅雷下载和BT全部走SS流量。</p>
											<h2>功能详解</h2>
											<h4>Shadowsocks运行状态</h4>
												<p> 此处会显示Shadowsocks到国内和到国外的联通状况，如果出现问题，会显示错误； </p>
												<p> 该运行状态5秒更新一次，此状态显示可以用于故障检测 ； </p>
												<li> 如果国外是working...状态，而你电脑不能访问google，请检查你的电脑设置（DNS,HOST）； </li>
												<li> 如果国外是problem detected！状态，那么请检查国外DNS设置，SS服务器状态 ； </li>
												<li> 如果国内是problem detected！状态，那么请检查国内DNS设置，你的网络连通状态 ；</li>
													<p> </p>
											<h4>当前gfwlist域名数量</h4>
												<p> 这里显示当前gfwlist中的国外被墙域名数量，如果你开启了自动更新，那么更新版本号也会显示在这里（以日期表示）</p>
												<p> 只有你激活了gfwlist模式，才会显示该项目。</p>
											<h4>当前大陆白名单IP段数量</h4>
												<p> 这里显示当前chnroute中IP段的行数，如果你开启了自动更新，那么更新版本号也会显示在这里（以日期表示）</p>
												<p> 只有你激活了大陆白名单模式或者游戏模式，才会显示该项目。</p>
											<h4>当前国内域名数量</h4>
												<p> 这里显示当前CDN站点中的国内域名数量，如果你开启了自动更新，那么更新版本号也会显示在这里（以日期表示）</p>
												<p> 只有你激活了大陆白名单模式或者游戏模式，才会显示该项目。</p>
											<h4>chromecast支持</h4>
												<p> 启用该项可以将局域网内客户端自定义的DNS进行接管，强制转发到路由器DNS，对于chromecast这样的设备非常有用。</p>
											<h4>广告过滤</h4>
												<p> 启用该项将会使用预定义的adblock文件，使用dnsmasq的host功能对指定域名进行过滤，达到去除广告的功能。</p>
											<h4>Shadowsocks规则自动更新</h4>
												<p> 开启此功能并选择你需要自动更新的文件，这些文件我们放在 &nbsp;<a href="https://github.com/koolshare/koolshare.github.io" target="_blank"><i><u>https://github.com/koolshare/koolshare.github.io</u></i></a></p>
												<p> 项目中，欢迎大家去提交自己的list，我们会选择合并，然后你就能自动更新到你的路由器。</p>
												<p> 自动更新会首先检测服务器上的文件的版本号，如果发现不一致，则会下载相应文件，更新到路由器。 </p>
												<p> 一旦有任何文件更新到路由器，SS服务就会重启，确保更新过程中别点击任何被墙网站，避免污染DNS进入缓存！。 </p>
												<p> 点击<b>立即更新</b>后，会马上运行更新脚本，检测是否有新版本，如果有新版本，将会立即下载更新，下载完后会自动重启SS。 </p>
												<p> 建议你将自动更新，设置到网络使用闲时，因为更新过程中会重启SS，如果你在游戏中，可能会引起掉线等不必要的麻烦。 </p>
											<h4>局域网客户端控制</h4>
												<p> 如果有多个局域网ip需要设置，请用英文逗号","隔开；需要注意的是，如果设定了某个机器不走该SS模式，但是因为消除了DNS污染，一些采用DNS污染屏蔽的网站，仍然可以访问（国内直连），但是不会走ss </p>
												<li> 禁用：局域网内所有机器都将走选定的模式 </li>
												<li> 黑名单模式：设定的局域网ip地址将走国内直连，其它机器将走选定的模式 </li>
												<li> 白名单模式：设定的局域网ip地址将走选定的模式，其它机器将走国内直连 </li>
										</div>
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

