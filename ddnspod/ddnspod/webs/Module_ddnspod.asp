<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
		<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
		<link rel="shortcut icon" href="images/favicon.png"/>
		<link rel="icon" href="images/favicon.png"/>
		<title>软件中心 - DDnspod设置</title>
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
		<script type="text/javascript" src="/dbconf?p=ddnspod_&v=<% uptime(); %>"></script>
        <script type="text/javascript" src="/res/rsa.js"></script>
        <script type="text/javascript" src="/res/md5.js"></script>
		<script type="text/javascript" src="/res/sha1.js"></script>
        <script type="text/javascript">
		function init() {
			show_menu();
			buildswitch();
			var rrt = document.getElementById("switch");
		    if (document.form.ddnspod_enable.value != "1") {
		        rrt.checked = false;
		        document.getElementById('ddnspod_detail_table').style.display = "none";
		    } else {
		        rrt.checked = true;
		        document.getElementById('ddnspod_detail_table').style.display = "";
		    }
			//双wan开始判断
			var lb_mode = '<% nvram_get("wans_mode"); %>';
			if(lb_mode !== "lb"){
				document.getElementById('double_wan_set').style.display = "none";
				document.getElementById('select_wan').style.display = "none";
				document.form.ddnspod_config_wan.value = 0;
			} else {
				check_selected("ddnspod_config_wan", db_ddnspod_.ddnspod_config_wan);
			}
			version_show();
			write_ddnspod_run_status();
			check_selected("ddnspod_auto_start", db_ddnspod_.ddnspod_auto_start);
			check_selected("ddnspod_delay_time", db_ddnspod_.ddnspod_delay_time);
			check_selected("ddnspod_refresh_time", db_ddnspod_.ddnspod_refresh_time);
		}

        var kn = '00AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD';
        var ke = '010001';

        var rsa = new RSAKey();

        rsa.setPublic(kn, ke);

		function onSubmitCtrl(o, s) {
			document.form.action_mode.value = s;
			//开始赋值
			var pwd = $("#ddnspod_config_old_pwd").val();
			var encrypted_pwd = rsa.encrypt(md5(pwd));
			$("#ddnspod_config_pwd").val(encrypted_pwd.toUpperCase());
			showLoading(9);
			document.form.submit();
			setTimeout("conf2obj()", 8000);
		}

		function pass_checked(obj){
			switchType(obj, document.form.show_pass.checked, true);
		}

		function conf2obj() {
			$.ajax({
				type: "get",
				url: "dbconf?p=ddnspod_",
				dataType: "script",
				success: function(xhr) {
			    	var p = "ddnspod_";
			        var params = ["run_status"];
			        for (var i = 0; i < params.length; i++) {
						if (typeof db_ddnspod_[p + params[i]] !== "undefined") {
							$("#ddnspod_"+params[i]).val(db_ddnspod_[p + params[i]]);
						}
			        }
                    $("#ddnspod_run_state").html(db_ddnspod_['ddnspod_run_status']);
					check_selected("ddnspod_auto_start", db_ddnspod_.ddnspod_auto_start);
					check_selected("ddnspod_delay_time", db_ddnspod_.ddnspod_delay_time);
					check_selected("ddnspod_refresh_time", db_ddnspod_.ddnspod_refresh_time);
				}
			});
		}

		function buildswitch(){
			$("#switch").click(
			function(){
				if(document.getElementById('switch').checked){
					document.form.ddnspod_enable.value = 1;
					document.getElementById('ddnspod_detail_table').style.display = "";
				}else{
					document.form.ddnspod_enable.value = 0;
					document.getElementById('ddnspod_detail_table').style.display = "none";
				}
			});
		}

		function check_selected(obj, m) {
		    var o = document.getElementById(obj);
		    for (var c = 0; c < o.length; c++) {
		        if (o.options[c].value == m) {
		            o.options[c].selected = true;
		            break;
		        }
		    }
		}

		function write_ddnspod_run_status(){
			$.ajax({
				type: "get",
				url: "dbconf?p=ddnspod_",
				dataType: "script",
				success: function() {
					var p = "ddnspod_";
					var params = ["run_status"];
					for (var i = 0; i < params.length; i++) {
						if (typeof db_ddnspod_[p + params[i]] !== "undefined") {
							$("#ddnspod_"+params[i]).val(db_ddnspod_[p + params[i]]);
						}
					}
                    $("#ddnspod_run_state").html(db_ddnspod_['ddnspod_run_status']);

					setTimeout("write_ddnspod_run_status()", 10000);
				}
			});
		}

		function version_show(){
			$("#ddnspod_version_status").html("<i>当前版本：" + db_ddnspod_['ddnspod_version']);
		    $.ajax({
		        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/ddnspod/config.json.js',
		        type: 'GET',
		        success: function(res) {
		            var txt = $(res.responseText).text();
		            if(typeof(txt) != "undefined" && txt.length > 0) {
		                //console.log(txt);
		                var obj = $.parseJSON(txt.replace("'", "\""));
				        $("#ddnspod_version_status").html("<i>当前版本：" + obj.version);
				        if(obj.version != db_ddnspod_["ddnspod_version"]) {
					        $("#ddnspod_version_status").html("<i>有新版本：" + obj.version);
				        }
		            }
		        }
		    });
		}

		function done_validating(action) {
			return true;
		}

		function reload_Soft_Center() {
			location.href = "/Main_Soft_center.asp";
		}
        </script>
    </head>
    <body onload="init();">
		<div id="TopBanner"></div>
		<div id="Loading" class="popup_bg"></div>
		<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<form method="post" name="form" action="/applydb.cgi?p=ddnspod_" target="hidden_frame">
			<input type="hidden" name="current_page" value="Module_ddnspod.asp"/>
			<input type="hidden" name="next_page" value="Module_ddnspod.asp"/>
			<input type="hidden" name="group_id" value=""/>
			<input type="hidden" name="modified" value="0"/>
			<input type="hidden" name="action_mode" value=""/>
			<input type="hidden" name="action_script" value=""/>
			<input type="hidden" name="action_wait" value="5"/>
			<input type="hidden" name="first_time" value=""/>
			<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
			<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ddnspod_config.sh"/>
			<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
			<input type="hidden" id="ddnspod_config_pwd" name="ddnspod_config_pwd" value='<% dbus_get_def("ddnspod_config_pwd", ""); %>'/>
			<input type="hidden" id="ddnspod_enable" name="ddnspod_enable" value='<% dbus_get_def("ddnspod_enable", "0"); %>'/>
			<input type="hidden" id="ddnspod_run_status" name="ddnspod_run_status" value='<% dbus_get_def("ddnspod_run_status", "0"); %>'/>

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
												<div style="float:left;" class="formfonttitle">DDnspod</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                                <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
                                                <div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">
                                                <div>使用dnspod实现的ddns服务</div>
                                                <ul style="padding-top:5px;margin-top:10px;float: left;">
                                                <li>使用前需要将域名添加到dnspod中，并添加一条A记录，使用之后将自动更新ip</li>
                                                <li>dnspod账户·密码 和 dnspod Token 选填一组，推荐使用dnspod Token，可以保护账户安全</li>
                                                <li>点 <a href="https://support.dnspod.cn/Kb/showarticle/tsid/227"><i><u>这里</u></i></a> 查看官方说明以及如何获取dnspod Token</li>
                                                </ul>
                                                </div>
                                                <!--<div class="formfontdesc" id="cmdDesc"></div>-->
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
													<thead>
													<tr>
														<td colspan="2">开关设置</td>
													</tr>
													</thead>
													<tr>
													<th>开启DDnspod</th>
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
                                                            <div id="ddnspod_version_status" style="padding-top:5px;margin-left:230px;margin-top:0px;float:left;">
                                                                <i>当前版本：<% dbus_get_def("ddnspod_version", "未知"); %></i>
                                                            </div>
													</td>
													</tr>
		                                    	</table>
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ddnspod_detail_table">
													<thead>
													<tr>
														<td colspan="2">基本设置</td>
													</tr>
													</thead>
													<tr>
														<th width="35%">dnspod账户</th>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" size="30" id="ddnspod_config_uname" name="ddnspod_config_uname" maxlength="20" placeholder="dnspod账户" value='<% dbus_get_def("ddnspod_config_uname", ""); %>' >
														</td>
													</tr>
													<tr>
														<th width="35%">dnspod密码</th>
														<td>
															<input  type="password" class="input_ss_table" style="width:auto;" size="20"  id="ddnspod_config_old_pwd" name="ddnspod_config_old_pwd" maxlength="30" placeholder="dnspod密码" value='<% dbus_get_def("ddnspod_config_old_pwd", ""); %>' />
															<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ddnspod_config_old_pwd);">显示密码</div>
														</td>
													</tr>
													<tr>
														<th width="35%">dnspod Token</th>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" size="30" id="ddnspod_config_token" name="ddnspod_config_token" maxlength="50" placeholder="ID,Token" value='<% dbus_get_def("ddnspod_config_token", ""); %>' >
															<div class="formfontdesc" style="margin-left:270px;margin-top:-20px;margin-bottom:0px;color:rgb(255,204,0);">推荐使用</div>
														</td>
													</tr>
													<tr>
														<th width="35%">域名</th>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" size="30" id="ddnspod_config_domain" name="ddnspod_config_domain" maxlength="40" placeholder="填写完整域名" value='<% dbus_get_def("ddnspod_config_domain", ""); %>' >
														</td>
													</tr>

													<thead>
													<tr>
														<td colspan="3">运行状态</td>
													</tr>
													</thead>
													<tr>
													    <th width="35%">状态</th>
														<td>
															<a>
																<span id="ddnspod_run_state"></span>
															</a>
														</td>
													</tr>

													<thead>
													<tr>
														<td colspan="4">启动设置</td>
													</tr>
													</thead>
													<tr>
													    <th width="35%">开机自启</th>
														<td>
															<select id="ddnspod_auto_start" name="ddnspod_auto_start" class="input_option"  >
																<option value="1">是</option>
																<option value="0">否</option>
															</select>
														</td>
													</tr>

		                                    	    <tr>
													    <th width="35%">启动延时</th>
														<td>
															<select id="ddnspod_delay_time" name="ddnspod_delay_time" class="input_option"  >
																<option value="1">1S</option>
																<option value="5">5S</option>
																<option value="10">10S</option>
															</select>
														</td>
													</tr>

													<thead>
													<tr>
														<td colspan="4">刷新设置</td>
													</tr>
													</thead>
		                                    	    <tr>
													    <th width="35%">刷新时间</th>
														<td>
															<select id="ddnspod_refresh_time" name="ddnspod_refresh_time" class="input_option"  >
																<option value="1">1H</option>
																<option value="5">5H</option>
																<option value="10">10H</option>
															</select>
														</td>
													</tr>

													<thead id="double_wan_set">
													<tr>
														<td colspan="4">双WAN设置</td>
													</tr>
													</thead>
													<tr id="select_wan">
													    <th width="35%">加速WAN口</th>
														<td>
															<select id="ddnspod_config_wan" name="ddnspod_config_wan" class="input_option"  >
																<option value="1">WAN1</option>
																<option value="2">WAN2</option>
															</select>
														</td>
													</tr>

		 										</table>
		 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" ></div>
												<div class="apply_gen">
													<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
												<div class="KoolshareBottom">
													<br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
													后台技术支持： <i>Xiaobao</i> <br/>
													Shell, Web by： <i>freexiaoyao</i><br/>
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
		<div id="footer"></div>
    </body>
</html>
