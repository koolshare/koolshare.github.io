<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 离线安装</title>
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
function init(menu_hook) {
	show_menu();
}

function onSubmitCtrl(o, s) {
	document.form.action_mode.value = s;
	showLoading(7);
	document.form.submit();
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装");
	tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp");
}
function upload_software() {
	var fullPath = document.getElementById('ss_file').value;
	if(!fullPath) {
		return;
	}
	document.getElementById('file_info').style.display = "none";
	document.getElementById('loadingicon').style.display = "block";
	var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
	var filename = fullPath.substring(startIndex);
	if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
		filename = filename.substring(1);
	}
	document.form.soft_name.value = filename;
	document.form.enctype = "multipart/form-data";
	document.form.encoding = "multipart/form-data";
	document.form.action="ssupload.cgi?a=/tmp/"+filename;
	document.form.submit();
}

function upload_ok(isok) {
	var info = $G('file_info');
	if(isok==1){
		info.innerHTML="上传完成";
		checkCmdRet();
		setTimeout("start_install();", 100);
		setTimeout("checkCmdRet();", 600);
	} else {
		info.innerHTML="上传失败";
	}
	info.style.display = "block";
	$G('loadingicon').style.display = "none";
}

function start_install() {
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=soft";
    document.form.SystemCmd.value = "ks_tar_intall.sh";
	document.form.enctype = "";
	document.form.encoding = "";
	document.form.submit();
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
				retArea.value = response.replace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				return false;
			}
			
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}

			if(noChange > 50){
				return false;
			}else{
				setTimeout("checkCmdRet();", 200);
			}
			
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="" target="hidden_frame">
	<input type="hidden" name="current_page" value="Main_Soft_setting.asp"/>
	<input type="hidden" name="next_page" value="Main_Soft_setting.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="adm_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="soft_name" name="soft_name" value=""/>
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
										<div style="float:left;" class="formfonttitle">软件中心，离线安装页面</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc"></div>
										<div style="padding-top:5px;margin-top:0px;float: left;" id="NoteBox" >
											<li>通过本页面，你可以上传插件的离线安装包来安装插件,此功能需要在7.0及以上的固件才能使用; </li>
											<li>离线安装会自动解压tar.gz后缀的压缩包，识别压缩包一级目录下的install.sh文件并执行； </li>
										</div>
										<div class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">软件中心 - 高级设置</td>
											</tr>
											</thead>
											<tr>
												<th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(24)">离线安装插件</a></th>
												<td>
													<input type="button" id="upload_btn" class="button_gen" onclick="upload_software();" value="上传并安装"/>
													<input style="color:#FFCC00;*color:#000;width: 200px;" id="ss_file" type="file" name="file"/>
													<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
													<span id="file_info" style="display:none;">完成</span>
												</td>
											</tr>
                                    	</table>
                                    	<div id="log_content" style="margin-top:10px;display: block;">
											<textarea cols="63" rows="15" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;"></textarea>
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



