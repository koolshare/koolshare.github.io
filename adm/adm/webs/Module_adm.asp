<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 阿呆喵</title>
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
<script type="text/javascript" src="/dbconf?p=adm_&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>


<script>
function init() {
	show_menu();
	//line_show();
	buildswitch();
    version_show();
    setTimeout("version_show()", 3000);
    /*
    var ss_mode = '<% nvram_get("ss_mode"); %>';
	if(ss_mode != "0" && ss_mode != 'undefined'){
		$j("#warn").html("<i>你开启了shadowsocks, 阿呆喵将只过滤国内广告</i>");
	}else{
		$j("#warn").html("<i>阿呆喵将过滤全部广告</i>");
	}
    */
    var rrt = document.getElementById("switch");
    if (document.form.adm_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}
/*
function line_show() {
	if(typeof db_adm_ != "undefined") {
		for(var field in db_adm_) {
			var el = document.getElementById(field);
				if(el != null) {
				el.value = db_adm_[field];
			}
			var temp_ss = ["adm_user_txt"];
			for (var i = 0; i < temp_ss.length; i++) {
				temp_str = $G(temp_ss[i]).value;
				$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
			}
		}
	}
}

function validForm(){
	var temp_ss = ["adm_user_txt"];
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
*/

function buildswitch(){
	$j("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.adm_enable.value = 1;
			//document.getElementById('adm_enable').value = 1;
			
		}else{
			document.form.adm_enable.value = 0;
			//document.getElementById('adm_enable').value = 0;
		}
	});
}

function onSubmitCtrl(o, s) {
	//if(validForm()){
		document.form.action_mode.value = s;
		showLoading(7);
		document.form.submit();
	//}
}

function conf2obj(){
	$j.ajax({
	type: "get",
	url: "dbconf?p=adm_",
	dataType: "script",
	success: function(xhr) {
    var p = "adm_";
        var params = ["user_txt"];
        for (var i = 0; i < params.length; i++) {
			if (typeof db_adm_[p + params[i]] !== "undefined") {
				$j("#adm_"+params[i]).val(db_adm_[p + params[i]]);
			}
        }
	}
	});
}



function version_show(){
	$j("#adm_version_status").html("<i>当前版本：" + db_adm_['adm_version']);

    $j.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/adm/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = $j(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                //console.log(txt);
                var obj = $j.parseJSON(txt.replace("'", "\""));
		$j("#adm_version_status").html("<i>当前版本：" + obj.version);
		if(obj.version != db_adm_["adm_version"]) {
			$j("#adm_version_status").html("<i>有新版本：" + obj.version);
		}
            }
        }
    });
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=adm_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_adm_.asp"/>
	<input type="hidden" name="next_page" value="Module_adm_.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="adm_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="adm_enable" name="adm_enable" value='<% dbus_get_def("adm_enable", "0"); %>'/>
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
										<div style="float:left;" class="formfonttitle">ADM 喵~</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">使用ADM，你就知道，去广告，原来是如此简单</div>
										<div id="adm_version_status" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"><i>当前版本：<% dbus_get_def("adm_version", "0"); %></i></div>
										<div style="padding-top:5px;margin-top:0px;float: left;" id="NoteBox" >
											<li>由于adm(阿呆猫)路由器版本性能问题，导致可能会出现卡网，因此我们对广告过滤做了限制：<i>adm将专注过滤视频广告;</i> </li>
											<li>注意：即使专注过滤视频广告，如果你的client过多，ADM也可能出现卡网，这是ADM本身的一些问题，目前我们尚不能解决; </li>
											<li>如果你需要过滤更多广告，可以编辑<i>/koolshare/adm/adblock.conf</i>添加你要过滤的网站; </li>
											<li>如果突然发现视频广告不能过滤了，不要惊慌，手动重启下吧！ </li>
										</div>
																	
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">开关设置</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启ADM</label>
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
													<div id="adm_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<!--
											<tr id="adm_status">
												<th>
													<label>ADM状态</label>
												</th>
												<td>
 													<div id="warn" style="margin-top: 20px;text-align: center;font-size: 18px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"></div>
												</td>										
											</tr>
											<tr id="adm_user">
												<td style="background-color: #2F3A3E;width:15%;">
													<label>自定义过滤规则</label>
												</td>
												</th>
												<td>
													<textarea placeholder='[ADM]
!  ------------------------------ 阿呆喵[ADM] 自定义过滤语法简表---------------------------------
!  --------------  规则基于ABP规则，并进行了字符替换部分的扩展-----------------------------
!  ABP规则请参考https://adblockplus.org/zh_CN/filters，下面为大致摘要
!  "!" 为行注释符，注释行以该符号起始作为一行注释语义，用于规则描述
!  "*" 为字符通配符，能够匹配0长度或任意长度的字符串，该通配符不能与正则语法混用。
!  "^" 为分隔符，可以匹配除了字母、数字或者 _ - . % 之外的任何字符。
!  "|" 为管线符号，来表示地址的最前端或最末端  比如 "|http://"  或  |http://www.abc.com/a.js|  
!  "||" 为子域通配符，方便匹配主域名下的所有子域。比如 "||www.baidu.com"  就可以不要前面的 "http://"
!  "~" 为排除标识符，通配符能过滤大多数广告，但同时存在误杀, 可以通过排除标识符修正误杀链接。

! ## #@# ##&  这3种为元素插入语法 (在语句末尾加 $B , 可以选择插入css语句在</body>前, 默认为</head>)
!  "##" 为元素选择器标识符，后面跟需要隐藏元素的CSS样式例如 #ad_id  .ad_class
! "#@#" 元素选择器白名单 
! "##&" 为JQuery选择器标识符，后面跟需要隐藏元素的JQuery筛选语法
!  元素隐藏支持全局规则   ##.ad_text  不需要前面配置域名,对所有页面有效. 误杀会比较多, 慎用.

!  文本替换选择器标识符, 支持通配符*和？，格式："页面C$s@内容A@内容B@"   意思为 <在使用"某正则模式" 在 "页面C"上用"内容A"替换"内容B" >  ; 
! 文本替换方式1:  S@   使用正则匹配替换
! 文本替换方式2:  s@   使用通配符 ?  *  匹配替换
!  -------------------------------------------------------------------------------------------

!新增规则语法测试样例

!样例1 使用正则删除某地方(替换 "<p...</p>" 字符串为 "http://www.admflt.com")
!<p id="lg"><img src="http://www.baidu.com/img/bdlogo.gif" width="270" height="129"></p>
!||www.baidu.com$S@<p.*<\/p>@http://www.admflt.com@
!||kafan.cn$s@<div id="hd">@<div id="hd" style="display:none!important">@' cols="50" rows="20" id="adm_user_txt" name="adm_user_txt" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
												</td>
											</tr>
											-->
                                    	</table>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
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



