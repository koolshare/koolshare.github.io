<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
		<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
		<link rel="shortcut icon" href="images/favicon.png"/>
		<link rel="icon" href="images/favicon.png"/>
		<title>软件中心 - 迅雷快鸟设置</title>
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
		<script type="text/javascript" src="/dbconf?p=kuainiao_&v=<% uptime(); %>"></script>
        <script type="text/javascript" src="/res/rsa.js"></script>
        <script type="text/javascript" src="/res/md5.js"></script>
        <script type="text/javascript">
		function init() {
			show_menu();
			buildswitch();
			var rrt = document.getElementById("switch");
		    if (document.form.kuainiao_enable.value != "1") {
		        rrt.checked = false;
		        document.getElementById('Kuainiao_detail_table').style.display = "none";
		    } else {
		        rrt.checked = true;
		        document.getElementById('Kuainiao_detail_table').style.display = "";
		    }
			//双wan开始判断
			var lb_mode = '<% nvram_get("wans_mode"); %>';
			if(lb_mode !== "lb"){
				document.getElementById('double_wan_set').style.display = "none";
				document.getElementById('select_wan').style.display = "none";
				document.form.kuainiao_config_wan.value = 0;
			} else {
				check_selected("kuainiao_config_wan", db_kuainiao_.kuainiao_config_wan);
			}
			//conf2obj();
			//var conf_ajax = setInterval("conf2obj();", 60000);
			version_show();
			check_selected("kuainiao_start", db_kuainiao_.kuainiao_start);
			check_selected("kuainiao_time", db_kuainiao_.kuainiao_time);
		}
        var kn = '00D6F1CFBF4D9F70710527E1B1911635460B1FF9AB7C202294D04A6F135A906E90E2398123C234340A3CEA0E5EFDCB4BCF7C613A5A52B96F59871D8AB9D240ABD4481CCFD758EC3F2FDD54A1D4D56BFFD5C4A95810A8CA25E87FDC752EFA047DF4710C7D67CA025A2DC3EA59B09A9F2E3A41D4A7EFBB31C738B35FFAAA5C6F4E6F';
        var ke = '010001';

        var rsa = new RSAKey();

        rsa.setPublic(kn, ke);

		function onSubmitCtrl(o, s) {
			document.form.action_mode.value = s;
			//开始赋值
			var pwd = $("#kuainiao_config_old_pwd").val();
			var encrypted_pwd = rsa.encrypt(md5(pwd));
			$("#kuainiao_config_pwd").val(encrypted_pwd.toUpperCase());
			//防止变为更新操作
			$("#kuainiao_update_check").val(0);
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
				url: "dbconf?p=kuainiao_",
				dataType: "script",
				success: function(xhr) {
			    	var p = "kuainiao_";
			        var params = ["warning","can_upgrade", "run_status", "run_warnning"];
			        for (var i = 0; i < params.length; i++) {
						if (typeof db_kuainiao_[p + params[i]] !== "undefined") {
							$("#kuainiao_"+params[i]).val(db_kuainiao_[p + params[i]]);
						}
			        }
					update_visibility();
					check_selected("kuainiao_start", db_kuainiao_.kuainiao_start);
					check_selected("kuainiao_time", db_kuainiao_.kuainiao_time);
					check_downstream(parseInt(db_kuainiao_.kuainiao_config_downstream), parseInt(db_kuainiao_.kuainiao_config_max_downstream), db_kuainiao_.kuainiao_run_status);
				}
			});
		}

		function buildswitch(){
			$("#switch").click(
			function(){
				if(document.getElementById('switch').checked){
					document.form.kuainiao_enable.value = 1;
					document.getElementById('Kuainiao_detail_table').style.display = "";
				}else{
					document.form.kuainiao_enable.value = 0;
					document.getElementById('Kuainiao_detail_table').style.display = "none";
				}
			});
		}

		function update_visibility() {
			//不满足快鸟条件的显示异常信息
			if ($("#kuainiao_can_upgrade").val() == "0") {
				$("#warn").html($("#kuainiao_warning").val());
				showhide("warn", ($("#kuainiao_can_upgrade").val() == "0"));
			}
			$("#warn").html($("#kuainiao_warning").val());
			showhide("warn", ($("#kuainiao_can_upgrade").val() == "0"));
			//给出快鸟运行状态
			$("#kn_state2").html($("#kuainiao_run_warnning").val());
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

		function check_downstream(old, max, state) {
			if (max > 0 && max > old && state == "1") {
				$("#kn_upgreade_state").html("宽带已从"+old+"M提速到"+max+"M");
			} else {
				if (+old) {
					$("#kn_upgreade_state").html("当前默认宽带为:"+old+"M,快鸟可以提速到:"+max+"M");
				} else {
					$("#kn_upgreade_state").html("");
				}
			}
		}
		
		function version_show(){
			$j("#kuainiao_version_status").html("<i>当前版本：" + db_adm_['adm_version']);
		    $j.ajax({
		        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/kuainiao/config.json.js',
		        type: 'GET',
		        success: function(res) {
		            var txt = $j(res.responseText).text();
		            if(typeof(txt) != "undefined" && txt.length > 0) {
		                //console.log(txt);
		                var obj = $j.parseJSON(txt.replace("'", "\""));
				$j("#kuainiao_version_status").html("<i>当前版本：" + obj.version);
				if(obj.version != db_adm_["adm_version"]) {
					$j("#kuainiao_version_status").html("<i>有新版本：" + obj.version);
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
		<form method="post" name="form" action="/applydb.cgi?p=kuainiao_" target="hidden_frame">
			<input type="hidden" name="current_page" value="Module_kuainiao.asp"/>
			<input type="hidden" name="next_page" value="Module_kuainiao.asp"/>
			<input type="hidden" name="group_id" value=""/>
			<input type="hidden" name="modified" value="0"/>
			<input type="hidden" name="action_mode" value=""/>
			<input type="hidden" name="action_script" value=""/>
			<input type="hidden" name="action_wait" value="5"/>
			<input type="hidden" name="first_time" value=""/>
			<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
			<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="kuainiao_config.sh"/>
			<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
			<input type="hidden" id="kuainiao_config_pwd" name="kuainiao_config_pwd" value='<% dbus_get_def("kuainiao_config_pwd", ""); %>'/>
			<input type="hidden" id="kuainiao_warning" name="kuainiao_warning" value='<% dbus_get_def("kuainiao_warning", ""); %>'/>
			<input type="hidden" id="kuainiao_enable" name="kuainiao_enable" value='<% dbus_get_def("kuainiao_enable", "0"); %>'/>
			<input type="hidden" id="kuainiao_can_upgrade" name="kuainiao_can_upgrade" value='<% dbus_get_def("kuainiao_can_upgrade", "0"); %>'/>
			<input type="hidden" id="kuainiao_run_status" name="kuainiao_run_status" value='<% dbus_get_def("kuainiao_run_status", "0"); %>'/>
			<input type="hidden" id="kuainiao_run_warnning" name="kuainiao_run_warnning" value='<% dbus_get_def("kuainiao_run_warnning", ""); %>'/>

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
												<div style="float:left;" class="formfonttitle">迅雷快鸟</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
												<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">迅雷快鸟加速服务，带宽平均提升5倍，最高可达100M</div>
												<div class="formfontdesc" id="cmdDesc"></div>
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
													<thead>
													<tr>
														<td colspan="2">开关设置</td>
													</tr>
													</thead>
													<tr>
													<th>开启快鸟加速</th>
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
															<div id="kuainiao_version_status" style="padding-top:5px;margin-left:230px;margin-top:0px;">
																<i>当前版本：<% dbus_get_def("kuainiao_version", "未知"); %></i>
															</div>
													</td>
													</tr>
		                                    	</table>
												<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="Kuainiao_detail_table">
													<thead>
													<tr>
														<td colspan="2">基本设置</td>
													</tr>
													</thead>
													<tr>
														<th width="35%">迅雷用户名</th>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" size="30" id="kuainiao_config_uname" name="kuainiao_config_uname" maxlength="20" placeholder="迅雷用户名" value='<% dbus_get_def("kuainiao_config_uname", ""); %>' >
														</td>
													</tr>
													<tr>
														<th width="35%">密码</th>
														<td>
															<input  type="password" class="input_ss_table" style="width:auto;" size="20"  id="kuainiao_config_old_pwd" name="kuainiao_config_old_pwd" maxlength="30" placeholder="迅雷密码" value='<% dbus_get_def("kuainiao_config_old_pwd", ""); %>' />
															<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.kuainiao_config_old_pwd);">显示密码</div>
														</td>
													</tr>

													<thead>
													<tr>
														<td colspan="3">运行状态</td>
													</tr>
													</thead>
													<tr>
													    <th width="35%">快鸟状态</th>
														<td>
															<a>
																<span style="display: none" id="kn_state1">尚未启用! </span>
																<span id="kn_state2"></span>
															</a>
														</td>
													</tr>

													<tr>
													    <th width="35%">提速状态</th>
														<td>
															<a>
																<span id="kn_upgreade_state"></span>
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
															<select id="kuainiao_start" name="kuainiao_start" class="input_option"  >
																<option value="1">是</option>
																<option value="0">否</option>
															</select>
														</td>
													</tr>

		                                    	    <tr>
													    <th width="35%">启动延时</th>
														<td>
															<select id="kuainiao_time" name="kuainiao_time" class="input_option"  >
																<option value="1">1S</option>
																<option value="5">5S</option>
																<option value="10">10S</option>
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
															<select id="kuainiao_config_wan" name="kuainiao_config_wan" class="input_option"  >
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
													Shell, Web by： <i>wangchll</i><br/>
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
