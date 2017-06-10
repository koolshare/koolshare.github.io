<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Aliddns</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="/state.js"></script>
<script src="/help.js"></script>
</head>
<body>
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
			<!--=====Beginning of Main Content=====-->
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Aliddns - 设置</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>Aliddns</em>是一款基于阿里云解析的私人ddns解决方案。<a href='http://koolshare.cn/thread-64703-1-1.html' target='_blank'><i>&nbsp;&nbsp;<u>点击查看插件详情</u></i></a></div>
                						<table style="margin:20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">Aliddns - 设置面板</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启Aliddns</label>
												</th>
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
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
                						    <tr id="last_act_tr">
                						        <th>上次运行</th>
                						        <td>
                						            <% dbus_get_def("aliddns_last_act", "--"); %>
                						        </td>
                						    </tr>
                						    <tr id="ak_tr">
                						        <th>app key</th>
                						        <td>
                						            <input type="text" id="aliddns_ak" value="<% dbus_get_def("aliddns_ak", ""); %>" class="input_ss_table">
                						        </td>
                						    </tr>
                						    <tr id="sk_tr">
                						        <th>app secret</th>
                						        <td><input type="password" id="aliddns_sk" value="<% dbus_get_def("aliddns_sk", ""); %>" class="input_ss_table"></td>
                						    </tr>
                						    <tr id="interval_tr">
                						        <th>检查周期</th>
                						        <td><input type="text" style="width: 2.5em" id="aliddns_interval" value="<% dbus_get_def("aliddns_interval", "120"); %>" class="input_ss_table">s</td>
                						    </tr>
                						    <tr id="name_tr">
                						        <th>域名</th>
                						        <td>
                						            <input type="text" style="width: 4em" id="aliddns_name" placeholder="子域名" value="<% dbus_get_def("aliddns_name", "home"); %>" class="input_ss_table"
                						            >.<input type="text"  id="aliddns_domain" placeholder="主域名" value="<% dbus_get_def("aliddns_domain", "example.com"); %>" class="input_ss_table">
                						        </td>
                						    </tr>
                						    <tr id="dns_tr">
                						        <th title="查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS">DNS服务器(?)</th>
                						        <td><input id="aliddns_dns" class="input_ss_table" value="<% dbus_get_def("aliddns_dns", "223.5.5.5"); %>"></td>
                						    </tr>
                						    <tr id="curl_tr">
                						        <th title="可自行修改命令行，以获得正确的公网IP。如添加 '--interface vlan2' 以指定多播情况下的端口支持">获得IP命令(?)</th>
                						        <td><textarea id="aliddns_curl" class="input_ss_table" style="width: 94%; height: 2.4em"><% dbus_get_def("aliddns_curl", "curl -s --interface ppp0 whatismyip.akamai.com"); %></textarea></td>
                						    </tr>
                						    <tr id="ttl_tr">
                						        <th title="设置解析TTL，默认10分钟，免费版的范围是600-86400">TTL(?)</th>
                						        <td><input id="aliddns_ttl" style="width: 4.5em" class="input_ss_table" value="<% dbus_get_def("aliddns_ttl", "600"); %>">s (1~86400)</td>
                						    </tr>
                						</table>
                						<div class="apply_gen">
                						    <input class="button_gen" type="button" value="提交">
                						</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div class="KoolshareBottom" style="margin-top:540px;">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
											Shell by： <i>kyrios</i> , Web by： <i>kyrios</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<!--=====end of Main Content=====-->
        </td>
    </tr>
</table>
<div id="footer"></div>
<script>
$(function () {
    show_menu(menu_hook);
    var enable = "<% dbus_get_def("aliddns_enable", "0"); %>";
    $('#switch').prop('checked', enable === "1");
    buildswitch();
    update_visibility();
    var posting = false;
	var inputs = ['ak', 'sk', 'name', 'domain', 'interval', 'dns', 'curl', 'ttl'];
    $('.button_gen').click(function () {
        if(posting) return;
        posting = true; // save
		var data = {
			aliddns_enable: $('#switch').prop('checked') | 0,
			action_mode: ' Refresh ',
			current_page: 'Module_aliddns.asp',
			next_page: 'Module_aliddns.asp',
			SystemCmd: 'aliddns_config.sh'
		};
		for(var i = 0; i< inputs.length; i++) {
			var key = 'aliddns_' + inputs[i];
			data['aliddns_' + inputs[i]] = $('#aliddns_' + inputs[i]).val()
		}
        $.ajax({
            type: 'POST',
            url: 'applydb.cgi?p=aliddns_',
            data: $.param(data)
        }).then(function () {
            posting = false;
            alert('saved');
        }, function () {
            posting = false;
           alert('failed'); 
        })
    })
})

var enable_ss = "<% nvram_get("enable_ss"); %>";
var enable_soft = "<% nvram_get("enable_soft"); %>";
function menu_hook(title, tab) {
	if(enable_ss == "1" && enable_soft == "1"){
		tabtitle[17] = new Array("", "Aliddns");
		tablink[17] = new Array("", "Module_aliddns.asp");
	}else{
		tabtitle[16] = new Array("", "Aliddns");
		tablink[16] = new Array("", "Module_aliddns.asp");
	}
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function buildswitch(){
	$("#switch").click(
	function(){
		update_visibility();
	});
}

function update_visibility(){
	if(document.getElementById('switch').checked){
		document.getElementById("last_act_tr").style.display = "";
		document.getElementById("ak_tr").style.display = "";
		document.getElementById("sk_tr").style.display = "";
		document.getElementById("interval_tr").style.display = "";
		document.getElementById("name_tr").style.display = "";
		document.getElementById("dns_tr").style.display = "";
		document.getElementById("curl_tr").style.display = "";
		document.getElementById("ttl_tr").style.display = "";
		
	}else{
		document.getElementById("last_act_tr").style.display = "none";
		document.getElementById("ak_tr").style.display = "none";
		document.getElementById("sk_tr").style.display = "none";
		document.getElementById("interval_tr").style.display = "none";
		document.getElementById("name_tr").style.display = "none";
		document.getElementById("dns_tr").style.display = "none";
		document.getElementById("curl_tr").style.display = "none";
		document.getElementById("ttl_tr").style.display = "none";
	}
}

</script>
</body>
</html>

