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
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css"/>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/ss_conf?v=<% uptime(); %>"></script>
<script type="text/javascript" src="/dbconf?p=ssconf_basic&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/ss-menu.js"></script>
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
var $G = function(id) {
    return document.getElementById(id);
};
function key_event(evt) {
    if (evt.keyCode != 27 || isMenuopen == 0) return false;
    pullLANIPList(document.getElementById("pull_arrow"));
}
function onSubmitCtrl(o, s) {
    if (validForm()) {
        if (0 == node_global_max) {
            var obj = ssform2obj();
            ss_node_object("1", obj, true,
            function(a) {
		setTimeout("checkSSStatus();", 30000); //make sure ss_status do not update during reloading
	if (ssmode == "2" || ssmode == "3"){
		showSSLoadingBar(25);
	} else if (ssmode == "1"){
		showSSLoadingBar(10);
	} else if (ssmode == "0"){
		showSSLoadingBar(8);
	} else if (ssmode == "4"){
		showSSLoadingBar(8);
	}
                document.form.action_mode.value = s;
                updateOptions();
            });
        } else {
            var node_sel = $j('#ssconf_basic_node').val();
            var obj = ssform2obj();
            ss_node_object(node_sel, obj, true,
            function(a) {
	setTimeout("checkSSStatus();", 30000);
	if (ssmode == "2" || ssmode == "3"){
		showSSLoadingBar(25);
	} else if (ssmode == "1"){
		showSSLoadingBar(10);
	} else if (ssmode == "0"){
		showSSLoadingBar(8);
	} else if (ssmode == "4"){
		showSSLoadingBar(8);
	}
                document.form.action_mode.value = s;
                updateOptions();
            });
        }
    }
}

function done_validating(action) {
	if (ssmode == "2" || ssmode == "3"){
		refreshpage(25);
	} else if (ssmode == "1"){
		refreshpage(10);
	} else if (ssmode == "0"){
		refreshpage(8);
	} else if (ssmode == "4"){
		refreshpage(8);
	}
}
function save_ss_method(m) {
    var o = document.getElementById("ss_method");
    for (var c = 0; c < o.length; c++) {
        if (o.options[c].value == m) {
            o.options[c].selected = true;
            break;
        }
    }
}
function update_ss_ui(obj) {
    for (var field in obj) {
        var el = document.getElementById("ss_" + field);
        if (field == "method") {
            continue;
        } else if (el != null && el.getAttribute("type") == "checkbox") {
            if (obj[field] != "0") {
                el.checked = true;
                document.getElementById("hd_ss_" + field).value = "1";
            } else {
                el.checked = false;
                document.getElementById("hd_ss_" + field).value = "0";
            }
            continue;
        }
        if (el != null) {
            el.value = obj[field];
        }
    }
    $j("#ss_method").val(obj.method);
}
var refreshRate = 5;
function init() {
    show_menu(menu_hook);
    refreshRate = getRefresh();
    for(var field in db_ssconf_basic) {
		$j('#'+field).val(db_ssconf_basic[field]);
	}
    if (typeof ss != "undefined") {
        update_ss_ui(ss);
        loadAllConfigs();
    } else {
        document.getElementById("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
    }
    checkIP();
    update_visibility();
    init_detail();
    setTimeout("checkSSStatus();", 1000);
}
function updateOptions() {
    document.form.action = "/applyss.cgi";
    document.form.SystemCmd.value = "ssconfig basic";
    document.form.submit();
}
var $j = jQuery.noConflict();
var _responseLen;
var noChange = 0;
var over_var = 0;
var isMenuopen = 0;
function hideS_Block(evt) {
    if (typeof(evt) != "undefined") {
        if (!evt.srcElement) evt.srcElement = evt.target; // for Firefox
        if (evt.srcElement.id == "pull_arrow" || evt.srcElement.id == "Ss_node_list_Block") {
            return;
        }
    }
    $G("pull_arrow").src = "/images/arrow-down.gif";
    $G('Ss_node_list_Block_PC').style.display = 'none';
    isMenuopen = 0;
}
function pullLANIPList(obj) {
    if (isMenuopen == 0) {
        obj.src = "/images/arrow-top.gif"
		$G("Ss_node_list_Block_PC").style.display = 'block';
        isMenuopen = 1;
    } else hideSS_Block();
}
function validForm() {
    var is_ok = true;
    return is_ok;
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
function update_visibility() {
    ssmode = document.form.ss_mode.value;
    crst = document.form.ss_chromecast.value;
    cadb = document.form.ss_adblock.value;
    sru = document.form.ss_rule_update.value;
    slc = document.form.ss_lan_control.value;
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
    showhide("gfw_nu1", (ssmode == "1"));
    showhide("gfw_nu2", (ssmode == "1"));
    showhide("chn_nu1", (ssmode == "2" || ssmode == "3"));
    showhide("chn_nu2", (ssmode == "2" || ssmode == "3"));
    showhide("number2", (ssmode == "2" || ssmode == "3"));
    showhide("adblock_nu", (cadb == "1"));
    showhide("adblock_nu1", (cadb == "1"));
    showhide("ss_rule_update_time", (sru == "1"));
    showhide("update_choose", (sru == "1"));
    showhide("help_mode", (ssmode !== "0"));
    showhide("help_mode1", (ssmode == "1"));
    showhide("help_mode2", (ssmode == "2"));
    showhide("help_mode3", (ssmode == "3"));
    showhide("help_mode4", (ssmode == "4"));
    showhide("ss_black_lan", (slc == "1"));
    showhide("ss_white_lan", (slc == "2"));
    init_detail();
}
function update_visibility2() {
    showhide("checkip");
}
function oncheckclick(obj) {
    if (obj.checked) {
        document.getElementById("hd_" + obj.id).value = "1";
    } else {
        document.getElementById("hd_" + obj.id).value = "0";
    }
}
function checkSSStatus() {
    if (document.form.ss_mode.value !== "0") {
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
    }
}
function checkIP() {
    str = document.getElementById("ss_server").value
    str = str.match(/(\d+)\.(\d+)\.(\d+)\.(\d+)/g);
    if (RegExp.$1 > 255 || RegExp.$2 > 255 || RegExp.$3 > 255 || RegExp.$4 > 255) {
        showhide("checkip1");
        return false;
    } else {
        showhide("checkip1");
        showhide("checkip2");
        return true;
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
function pass_checked(obj) {
    switchType(obj, document.form.show_pass.checked, true);
}
function ssconf_node2obj(node_sel) {
    var p = "ssconf_basic";
    if (typeof db_ssconf_basic[p + "_server_" + node_sel] == "undefined") {
        var obj = {
            "server": "",
            "port": "",
            "password": "",
            "method": "table"
        };
        return obj;
    } else {
        var obj = {};
        var params = ["server", "port", "password", "method"];
        for (var i = 0; i < params.length; i++) {
            obj[params[i]] = db_ssconf_basic[p + "_" + params[i] + "_" + node_sel];
        }
        return obj;
    }
}
function ss_node_sel() {
    var node_sel = $G("ssconf_basic_node").value;
    var obj = ssconf_node2obj(node_sel);
    update_ss_ui(obj);
}
function ss_node_object(node_sel, obj, isSubmit, end) {
    var ns = {};
    var p = "ssconf_basic";
    var params = ["server", "port", "password", "method"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
        db_ssconf_basic[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
    }
    if (isSubmit) {
        ns[p + "_node"] = node_sel;
        db_ssconf_basic[p + "_node"] = node_sel;
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
    obj["mode"] = $G("ss_mode").value;
    obj["server"] = $G("ss_server").value;
    obj["port"] = $G("ss_port").value;
    obj["password"] = $G("ss_password").value;
    obj["method"] = $G("ss_method").value;
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
    for (var field in db_ssconf_basic) {
        names = field.split("_");
        dic[names[names.length - 1]] = 'ok';
    }
    confs = {};
    var p = "ssconf_basic";
    var params = ["name", "server", "port", "password", "method"];
    for (var field in dic) {
        var obj = {};
        if (typeof db_ssconf_basic[p + "_name_" + field] == "undefined") {
            obj["name"] = '节点' + field;
        } else {
            obj["name"] = db_ssconf_basic[p + "_name_" + field];
        }
        for (var i = 1; i < params.length; i++) {
            var ofield = p + "_" + params[i] + "_" + field;
            if (typeof db_ssconf_basic[ofield] == "undefined") {
                obj = null;
                break;
            }
            obj[params[i]] = db_ssconf_basic[ofield];
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
        if (typeof db_ssconf_basic.ssconf_basic_node != "undefined") {
            node_sel = db_ssconf_basic.ssconf_basic_node;
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
    var params = ["name", "server", "port", "password", "method"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_global_max] = $j('#ssconf_table_' + params[i]).val();
    }
    $j.ajax({
        url: '/applydb.cgi?p=' + p,
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
    var params = ["name", "mode", "server", "port", "password", "method"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + id] = "";
    }
    $j.ajax({
        url: '/applydb.cgi?use_rm=1&p=' + p,
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
    code += "<div style='text-align:right;width:30px;position:relative;margin-top:0px;margin-left:96%;'><img src='/images/button-close.gif' style='width:30px;cursor:pointer' onclick='closeSs_node_listView();'></div>";
    code += "<table width='100%' border='1' align='center' cellpadding='0' cellspacing='0' class='FormTable_table' style='margin-top:10px;'>"
    code += "<thead>"
    code += "<tr height='28px'>"
    code += "<td id='td_all_list_title' colspan='" + wl_colspan + "'>Shadowsocks节点配置</td>"
    code += "</tr>"
    code += "</thead>"
    code += "<tr id='tr_all_title' height='40px'>"
    code += "<th width=" + obj_width[0] + ">节点名称</th>";
    code += "<th width=" + obj_width[1] + ">服务器地址</th>";
    code += "<th width=" + obj_width[2] + ">端口</th>";
    code += "<th width=" + obj_width[3] + ">密码</th>";
    code += "<th width=" + obj_width[4] + ">加密方式</th>";
    code += "<th width=" + obj_width[5] + ">添加<br>删除</th>";
    code += "</tr>"
    code += "<tr height='40px'>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_name' name='ssconf_table_name' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_server' name='ssconf_table_server' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_port' name='ssconf_table_port' value='' /></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_password' name='ssconf_table_password' value='' /></td>";
    code += "<td><select id='ssconf_table_method' name='ssconf_table_method' style='width:164px;margin:0px 0px 0px 2px;' class='input_option' />"
    code += "<option class='content_input_fd' value='table'>table</option>"
    code += "<option class='content_input_fd' value='rc4'>rc4</option>"
    code += "<option class='content_input_fd' value='rc4-md5'>rc4-md5</option>"
    code += "<option class='content_input_fd' value='aes-128-cfb'>aes-128-cfb</option>"
    code += "<option class='content_input_fd' value='aes-192-cfb'>aes-192-cfb</option>"
    code += "<option class='content_input_fd' value='aes-256-cfb' selected=''>aes-256-cfb</option>"
    code += "<option class='content_input_fd' value='bf-cfb'>bf-cfb</option>"
    code += "<option class='content_input_fd' value='camellia-128-cfb'>camellia-128-cfb</option>"
    code += "<option class='content_input_fd' value='camellia-192-cfb'>camellia-192-cfb</option>"
    code += "<option class='content_input_fd' value='camellia-256-cfb'>camellia-256-cfb</option>"
    code += "<option class='content_input_fd' value='cast5-cfb'>cast5-cfb</option>"
    code += "<option class='content_input_fd' value='des-cfb'>des-cfb</option>"
    code += "<option class='content_input_fd' value='idea-cfb'>idea-cfb</option>"
    code += "<option class='content_input_fd' value='rc2-cfb'>rc2-cfb</option>"
    code += "<option class='content_input_fd' value='seed-cfb'>seed-cfb</option>"
    code += "<option class='content_input_fd' value='salsa20'>salsa20</option>"
    code += "<option class='content_input_fd' value='chacha20'>chacha20</option>"
    code += "</select>"
    code += "<td><input class='add_btn' onclick='add_conf_in_table(this);' type='button' value=''></td>";
    code += "</tr>";
    code += field_code;
    code += "<tr>"
    code += "</tr>"
    code += "</table>"
    code += "<div style='text-align:center;margin-top:15px;'><input type='button' class='button_gen' onclick='closeSs_node_listView();' value='返回'></div>";
    code += "<div id='clientlist_all_list_Block'></div>";
    divObj.innerHTML = code;
    document.getElementById("ss_node_list_viewlist_content").appendChild(divObj);
}
function updateSs_node_listView() {
    $j.ajax({
        url: '/dbconf?p=ssconf_basic',
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
        slideDown("detail_show", 200);
        slideDown("add_fun", 200);
        slideDown("help_mode", 200);
        slideDown("status_update", 200);
        thisObj.innerHTML = "<em>[ 简洁 ]</em>";
        createCookie("ss_table_detail", 0, 365);
    } else {
        slideUp("detail_show", 200);
        slideUp("add_fun", 200);
        slideUp("help_mode", 200);
        slideUp("status_update", 200);
        thisObj.innerHTML = "<em>[ 详细 ]</em>";
        createCookie("ss_table_detail", 1, 365);
    }
}
function init_detail() {
    var state1 = readCookie("ss_table_detail")
    if (state1 == "1") {
        document.getElementById("detail_show").style.display = "none";
        document.getElementById("add_fun").style.display = "none";
        document.getElementById("help_mode").style.display = "none";
        document.getElementById("status_update").style.display = "none";
        $j("#detail_show_hide").html("<em>[ 详细 ]</em>");
    } else {
        document.getElementById("detail_show").style.display = "";
        document.getElementById("add_fun").style.display = "";
        document.getElementById("help_mode").style.display = "";
        document.getElementById("status_update").style.display = "";
        $j("#detail_show_hide").html("<em>[ 简洁 ]</em>");
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

</script>
</head>
<body onkeydown="key_event(event);" onclick="if(isMenuopen){hideClients_Block(event)}" onload="init();">
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
<!--[if lte IE 6.5]><iframe class="hackiframe"></iframe><![endif]-->
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applyss.cgi" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="next_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="25"/>
<input type="hidden" name="first_time" value=""/>
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
										<div>
											<table style="margin:0px 0px 0px 0px;" width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<thead>
												<tr>
													<td colspan="2">Shadowsocks信息
														<a id="detail_show_hide" name="detail_show_hide" value="" class="clientlist_expander" onclick="show_detail(this);"><em>[ 简洁 ]</em></a>
													</td>
												</tr>
												</thead>
												<tr>
													<th width="20%">节点选择</th>
													<td>
														<div style="float:left; width:165px; height:25px"><select id="ssconf_basic_node" name="ssconf_basic_node" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" onchange="ss_node_sel();" onclick="update_visibility();" >
														</select></div>
														<div id="ss_node_edit" style="float:left; width:35px; height:35px;margin:-3px 0px -5px 2px;cursor:pointer" onclick="pop_ss_node_list_listview(true);"></div>
													</td>
												</tr>
												<tr>
													<th width="20%">模式</th>
													<td>
														<select id="ss_mode" name="ss_mode" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onclick="update_visibility();" >
															<option value="0">【0】 禁用</option>
															<option value="1">【1】 GFWlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="">【3】 游戏模式(尚未开放)</option>
															<option value="4">【4】 全局代理模式</option>
														</select>
														<span id="game_alert">
															<a href="http://koolshare.cn/thread-4519-1-1.html" target="_blank"><i>&nbsp 账号需支持UDP转发&nbsp &nbsp<u>FAQ</u></i></a>
														</span>
													</td>
												</tr>
											</table>
										</div>
										<div id="detail_show">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="server_tr">
													<th width="20%">服务器</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_server" name="ss_server" maxlength="100" onKeyPress="checkIP();" placeholder="建议填ip,域名可能导致错误" value=""/>
														<span id="checkip1" onclick="style.display='block'"> 输入域名可能导致无法启动ss </span>
														<span id="checkip2"> 你输入的IP地址有误！ </span>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="20%">服务器端口</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_port" name="ss_port" maxlength="100" value="" />
														<!--<input readonly style="background:transparent;" name="ssconf_basic_time" id="ssconf_basic_time" class="input_ss_table" maxlength="100" value=""/>-->

													</td>
												</tr>
												<tr id="pass_tr">
													<th width="20%">密码</th>
													<td>
														<input type="password" name="ss_password" id="ss_password" class="ssconfig input_ss_table" maxlength="100" value=""/>
														<div style="margin:-20px 0px 5px 170px;"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ss_password);">
															显示密码
														</div>
													</td>
												</tr>
												<tr id="method_tr">
													<th width="20%">加密方式</th>
													<td>
														<select id="ss_method" name="ss_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
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
											</table>
										</div>
										<div>
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<thead id="add_fun">
												<tr>
													<td colspan="2">附加功能</td>
												</tr>
												</thead>
												<tr id="ss_state">
												<th id="mode_state" width="20%">SS运行状态</th>
													<td>
														<a title="该运行状态5秒自动更新一次">
															<span id="ss_state1">尚未启用! </span>
															<span id="ss_state2">国外连接 - <% nvram_get("ss_foreign_state"); %></span>
															<br/>
															<span id="ss_state3">国内连接 - <% nvram_get("ss_china_state"); %></span>
														</a>
													</td>
												</tr>
												<tr id="status_update">
												<th>状态更新间隔</th>
													<td>
														<select title="立即生效，无须提交" name="refreshrate" id="refreshrate" class="input_option" onchange="setRefresh(this);">
															<option value="0">不更新</option>
															<option value="5">5秒</option>
															<option value="10" selected>10秒</option>
															<option value="15">15秒</option>
															<option value="30">30秒</option>
															<option value="60">60秒</option>
														</select>
													</td>
												</tr>												
												<tr id="number">
													<th id="gfw_nu1" width="20%">当前gfwlist域名数量</th>
													<th id="chn_nu1" width="20%">当前大陆白名单IP段数量</th>
													<td id="gfw_nu2">
														<a>
															<% nvram_get("ipset_numbers"); %>条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/gfwlist.conf" target="_blank">
																<i><% nvram_get("update_ipset"); %></i>
															</a>
														</a>
													</td>
												<td id="chn_nu2">
													<p>
														<% nvram_get("chnroute_numbers"); %>行，最后更新版本：
														<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/chnroute.txt" target="_blank">
															<i><% nvram_get("update_chnroute"); %></i>
														</a>
													</p>
												</td>
												</tr>
												<tr id="number2">
													<th id="cdn_nu1" width="20%">当前国内域名数量</th>
													<td id="cdn_nu2">
														<p>
														<% nvram_get("cdn_numbers"); %>条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/cdn.txt" target="_blank">
																<i><% nvram_get("update_cdn"); %></i>
															</a>
														</p>
													</td>
												</tr>
												<tr id="chromecast">
													<th width="20%">Chromecast支持</th>
													<td>
														<select id="ss_chromecast" name="ss_chromecast" class="ssconfig input_option" onclick="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="chromecast1"> 建议开启chromecast支持 </span>
													</td>
												</tr>
												<tr id="123">
													<th width="20%">广告过滤</th>
													<td>
														<select id="ss_adblock" name="ss_adblock" class="ssconfig input_option" onclick="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<a id="adblock_nu">当前规则条数 ：<% nvram_get("adblock_numbers"); %>，最后更新版本：
																		<a id="adblock_nu1" href="https://github.com/koolshare/koolshare.github.io/blob/master/maintain_files/adblock.conf" target="_blank">
																			<i><% nvram_get("update_adblock"); %></i>
																		</a>
															</a>
													</td>
												</tr>
												<tr id="update_rules">
													<th width="20%">Shadowsocks规则自动更新</th>
													<td>
														<select id="ss_rule_update" name="ss_rule_update" class="ssconfig input_option" onclick="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
														<select id="ss_rule_update_time" name="ss_rule_update_time" class="ssconfig input_option" title="选择规则列表自动更新时间，更新后将自动重启SS" onclick="update_visibility();" >
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
																<input type="checkbox" id="ss_gfwlist_update" name="a" title="选择此项应用gfwlist自动更新" onclick="oncheckclick(this);">gfwlist</input>
																<input type="checkbox" id="ss_chnroute_update" name="a2" onclick="oncheckclick(this);">chnroute</input>
																<input type="checkbox" id="ss_cdn_update" name="a3" onclick="oncheckclick(this);">CDN</input>
																<input type="checkbox" id="ss_adblock_update" name="a4" onclick="oncheckclick(this);">adblock</input>
																<input type="hidden" id="hd_ss_gfwlist_update" name="ss_gfwlist_update" value=""/>
																<input type="hidden" id="hd_ss_chnroute_update" name="ss_chnroute_update" value=""/>
																<input type="hidden" id="hd_ss_cdn_update" name="ss_cdn_update" value=""/>
																<input type="hidden" id="hd_ss_adblock_update" name="ss_adblock_update" value=""/>
															</a>
																<input id="update_now" onclick="updatelist()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="立即更新" />
															<a href="http://192.168.1.1/Main_SsLog_Content.asp" target="_blank"></a>
													</td>
												</tr>
												<tr id="ss_lan_controls">
													<th width="20%">局域网客户端控制</th>
													<td>
														<select id="ss_lan_control" name="ss_lan_control" class="ssconfig input_option" onclick="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">黑名单模式</option>
															<option value="2">白名单模式</option>
														</select>
															<input type="text" class="ssconfig input_32_table" id="ss_black_lan" name="ss_black_lan" maxlength="100" placeholder="填入需要限制的局域网客户端IP:192.168.1.2,192.168.1.3" value="" />
															<input type="text" class="ssconfig input_32_table" id="ss_white_lan" name="ss_white_lan" maxlength="100" placeholder="填入仅允许的局域网客户端IP:192.168.1.2,192.168.1.3" value="" />
													</td>
												</tr>

											</table>
										</div>
										<div id="help_mode" >
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
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
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交"/>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div class="SimpleNote">
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
												<p> 开启此功能并选择你需要自动更新的文件，这些文件我们放在 &nbsp<a href="https://github.com/koolshare/koolshare.github.io" target="_blank"><i><u>https://github.com/koolshare/koolshare.github.io</u></i></a></p>
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
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
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

