<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
		<meta HTTP-EQUIV="Expires" CONTENT="-1" />
		<link rel="shortcut icon" href="images/favicon.png" />
		<link rel="icon" href="images/favicon.png" />
		<title>软件中心-Aria2</title>
		<link rel="stylesheet" type="text/css" href="index_style.css" />
		<link rel="stylesheet" type="text/css" href="form_style.css" />
		<link rel="stylesheet" type="text/css" href="usp_style.css" />
		<link rel="stylesheet" type="text/css" href="ParentalControl.css">
		<link rel="stylesheet" type="text/css" href="css/icon.css">
		<link rel="stylesheet" type="text/css" href="css/element.css">
		<script type="text/javascript" src="/state.js"></script>
		<script type="text/javascript" src="/popup.js"></script>
		<script type="text/javascript" src="/help.js"></script>
		<script type="text/javascript" src="/validator.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/general.js"></script>
		<script type="text/javascript" src="/disk_functions.js"></script>
		<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
		<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
		<script type="text/javascript" src="/dbconf?p=aria2_&v=<% uptime(); %>"></script>
		<style type="text/css">
			/* folder tree */
			.mask_bg{
				position:absolute;
				margin:auto;
				top:0;
				left:0;
				width:100%;
				height:100%;
				z-index:100;
				/*background-color: #FFF;*/
				background:url(images/popup_bg2.gif);
				background-repeat: repeat;
				filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
				-moz-opacity: 0.6;
				display:none;
				/*visibility:hidden;*/
				overflow:hidden;
			}
			.mask_floder_bg{
				position:absolute;
				margin:auto;
				top:0;
				left:0;
				width:100%;
				height:100%;
				z-index:300;
				/*background-color: #FFF;*/
				background:url(images/popup_bg2.gif);
				background-repeat: repeat;
				filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
				-moz-opacity: 0.6;
				display:none;
				/*visibility:hidden;*/
				overflow:hidden;
			}
			.folderClicked{
				color:#569AC7;
				font-size:14px;
				cursor:text;
			}
			.lastfolderClicked{
				color:#FFFFFF;
				cursor:pointer;
			}
		</style>
		<script>

    jQuery.ajax = (function(_ajax){
    
    var protocol = location.protocol,
        hostname = location.hostname,
        exRegex = RegExp(protocol + '//' + hostname),
        YQL = 'http' + (/^https/.test(protocol)?'s':'') + '://query.yahooapis.com/v1/public/yql?callback=?',
        query = 'select * from html where url="{URL}" and xpath="*"';
    
    function isExternal(url) {
        return !exRegex.test(url) && /:\/\//.test(url);
    }
    
    return function(o) {
        
        var url = o.url;
        
        if ( /get/i.test(o.type) && !/json/i.test(o.dataType) && isExternal(url) ) {
            
            // Manipulate options so that JSONP-x request is made to YQL
            
            o.url = YQL;
            o.dataType = 'json';
            
            o.data = {
                q: query.replace(
                    '{URL}',
                    url + (o.data ?
                        (/\?/.test(url) ? '&' : '?') + jQuery.param(o.data)
                    : '')
                ),
                format: 'xml'
            };
            
            // Since it's a JSONP request
            // complete === success
            if (!o.success && o.complete) {
                o.success = o.complete;
                delete o.complete;
            }
            
            o.success = (function(_success){
                return function(data) {
                    
                    if (_success) {
                        // Fake XHR callback.
                        _success.call(this, {
                            responseText: (data.results[0] || '')
                                // YQL screws with <script>s
                                // Get rid of them
                                .replace(/<script[^>]+?\/>|<script(.|\s)*?\/script>/gi, '')
                        }, 'success');
                    }
                    
                };
            })(o.success);
            
        }
        
        return _ajax.apply(this, arguments);
        
    };
    
})(jQuery.ajax);

			<% get_AiDisk_status(); %>
			<% disk_pool_mapping_info(); %>
			var PROTOCOL = "cifs";
			var _layer_order = "";
			var FromObject = "0";
			var lastClickedObj = 0;
			var disk_flag=0;
			window.onresize = cal_panel_block;
			var nfsd_enable = '<% nvram_get("nfsd_enable"); %>';
			var nfsd_exportlist_array = '<% nvram_get("nfsd_exportlist"); %>';
			window.onresize = cal_panel_block;
			String.prototype.replaceAll = function(s1,s2){
　　			return this.replace(new RegExp(s1,"gm"),s2);
			}
			function init() {
				show_menu();
				buildswitch();
			    conf2obj();
			    line_show();
				update_visibility();
				write_aria2_install_status();
				version_check();
			   	initial_dir();
				check_dir_path();
			}
			function done_validating() {
				return true;
			//refreshpage();
			}
			function buildswitch(){
				$("#switch").click(
				function(){
					if(document.getElementById('switch').checked){
					document.aria2_form.aria2_enable.value = 1;
			        document.getElementById('h5ai').style.display = "";
			        document.getElementById('aria2-webui').style.display = "";
			        document.getElementById('yaaw').style.display = "";
			        document.getElementById('aria2_base_table').style.display = "";
			        document.getElementById('aria2_rpc_table').style.display = "";
			        document.getElementById('aria2_limit_table').style.display = "";
			        document.getElementById('aria2_bt_table').style.display = "";
					document.getElementById('cmdBtn1').style.display = "";
			    } else {
				    document.aria2_form.aria2_enable.value = 0;
			        document.getElementById('h5ai').style.display = "none";
			        document.getElementById('aria2-webui').style.display = "none";
			        document.getElementById('yaaw').style.display = "none";
			        document.getElementById('aria2_base_table').style.display = "none";
			        document.getElementById('aria2_rpc_table').style.display = "none";
			        document.getElementById('aria2_limit_table').style.display = "none";
			        document.getElementById('aria2_bt_table').style.display = "none";
			        document.getElementById('cmdBtn1').style.display = "none";
					}
				});
			}
			function update_visibility(){
				var rrt = document.getElementById("switch");
			    if (document.aria2_form.aria2_enable.value !== "1") {
			        rrt.checked = false;
			        document.getElementById('h5ai').style.display = "none";
			        document.getElementById('aria2-webui').style.display = "none";
			        document.getElementById('yaaw').style.display = "none";
			        document.getElementById('aria2_base_table').style.display = "none";
			        document.getElementById('aria2_rpc_table').style.display = "none";
			        document.getElementById('aria2_limit_table').style.display = "none";
			        document.getElementById('aria2_bt_table').style.display = "none";
			        document.getElementById('cmdBtn1').style.display = "none";
			    } else {
			        rrt.checked = true;
			        document.getElementById('h5ai').style.display = "";
			        document.getElementById('aria2-webui').style.display = "";
			        document.getElementById('yaaw').style.display = "";
			        document.getElementById('aria2_base_table').style.display = "";
			        document.getElementById('aria2_rpc_table').style.display = "";
			        document.getElementById('aria2_limit_table').style.display = "";
			        document.getElementById('aria2_bt_table').style.display = "";
			        document.getElementById('cmdBtn1').style.display = "";
			    }
			    var lan_ipaddr = '<% nvram_get("lan_ipaddr"); %>';
			    document.getElementById("link1.1").innerHTML = "<i><u>http://"+lan_ipaddr+":8088</u></i>";
			   	document.getElementById("link1.1").href = "http://"+lan_ipaddr+":8088";
			    document.getElementById("link2.1").innerHTML = "<i><u>http://"+lan_ipaddr+":8088/aria2</u></i>";
			   	document.getElementById("link2.1").href = "http://"+lan_ipaddr+":8088/aria2";
			    document.getElementById("link3.1").innerHTML = "<i><u>http://"+lan_ipaddr+":8088/yaaw</u></i>";
			   	document.getElementById("link3.1").href = "http://"+lan_ipaddr+":8088/yaaw";
			   	showhide("aria2_binary_custom", (document.aria2_form.aria2_binary.value == "custom"));
			   	showhide("aria2_check_time_tr", (document.aria2_form.f_aria2_check.value !== "false"));
			   	showhide("aria2_rpc_listen_port_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_rpc_allow_origin_all_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_rpc_listen_all_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_disable_ipv6_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_event_poll_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_rpc_secret_tr", (document.aria2_form.f_aria2_enable_rpc.value !== "false"));
			   	showhide("aria2_save_session_tr", (document.aria2_form.f_aria2_force_save.value !== "false"));
			   	showhide("aria2_save_session_interval_tr", (document.aria2_form.f_aria2_force_save.value !== "false"));
			   	showhide("aria2_dht_listen_port_tr", (document.aria2_form.f_aria2_enable_dht.value !== "false"));
			   	showhide("aria2_cpulimit_value", (document.aria2_form.f_aria2_cpulimit_enable.value !== "false"));
			}
			function onSubmitCtrl(o, s) {
				alert_custom();
				if(validForm()){
					document.aria2_form.action_mode.value = s;
					showLoading(5);
					document.aria2_form.submit();
				}
			}
			function conf2obj(){
			        var params1 = ["aria2_cpulimit_value", "aria2_binary", "aria2_binary_custom", "aria2_bt_max_peers", "aria2_check_time", "aria2_custom", "aria2_dht_listen_port", "aria2_dir", "aria2_disk_cache", "aria2_enable", "aria2_event_poll", "aria2_file_allocation", "aria2_force_save", "aria2_install_status", "aria2_listen_port", "aria2_lowest_speed_limit", "aria2_max_concurrent_downloads", "aria2_max_connection_per_server", "aria2_max_download_limit", "aria2_max_overall_download_limit", "aria2_max_overall_upload_limit", "aria2_max_tries", "aria2_max_upload_limit", "aria2_min_split_size", "aria2_peer_id_prefix", "aria2_referer", "aria2_retry_wait", "aria2_rpc_listen_port", "aria2_rpc_secret", "aria2_save_session_interval", "aria2_seed_ratio", "aria2_sleep", "aria2_split", "aria2_update_enable", "aria2_update_sel", "aria2_user_agent"];
			        for (var i = 0; i < params1.length; i++) {
				        if (typeof db_aria2_[params1[i]] !== "undefined") {
					        $("#"+params1[i]).val(db_aria2_[params1[i]]);
				        }
		       		}
			        var params2 = ["aria2_cpulimit_enable", "aria2_disable_ipv6", "aria2_check", "aria2_continue", "aria2_enable_mmap", "aria2_enable_rpc", "aria2_rpc_allow_origin_all", "aria2_rpc_listen_all", "aria2_bt_enable_lpd", "aria2_enable_dht", "aria2_bt_require_crypto", "aria2_follow_torrent", "aria2_enable_peer_exchange", "aria2_force_save", "aria2_bt_hash_check_seed", "aria2_bt_seed_unverified", "aria2_bt_save_metadata"];
					for (var i = 0; i < params2.length; i++) {
						if (typeof db_aria2_[params2[i]] !== "undefined") {
							$("#f_"+params2[i]).val(db_aria2_[params2[i]]);
							if (db_aria2_[params2[i]] != "true"){
								document.getElementById(params2[i]).checked = false;
								document.getElementById("f_" + params2[i]).value = "false";
							} else {
								document.getElementById(params2[i]).checked = true;
								document.getElementById("f_" + params2[i]).value = "true";
							}
						} else {
							if (document.getElementById(params2[i]).checked){
								document.getElementById("f_" + params2[i]).value = "true"
							} else {
								document.getElementById("f_" + params2[i]).value = "false"
							}
						}
					}
			}
			function write_aria2_install_status(){
				$.ajax({
					type: "get",
					url: "dbconf?p=aria2_",
					dataType: "script",
					success: function() {
					if (db_aria2_['aria2_install_status'] == "0"){
						$("#aria2_install_status").html("<i>Aria2尚未安装</i>");
						//document.aria2_form.aria2_enable.value = 0;
						document.getElementById('aria2_switch').style.display = "none";
						document.getElementById('cmdBtn').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('install_button').style.display = "";
						document.getElementById('aria2_version_status').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "1"){
						//document.aria2_form.aria2_enable.value = 0;
						$("#aria2_install_status").html("<i>Aria2已安装</i>");
						document.getElementById('aria2_switch').style.display = "";
						document.getElementById('cmdBtn').style.display = "";
						document.getElementById('uninstall_button').style.display = "";
						document.getElementById('install_button').style.display = "none";
						document.getElementById('aria2_version_status').style.display = "";
					} else if (db_aria2_['aria2_install_status'] == "2"){
						$("#aria2_install_status").html("<i>Aria2将被安装到jffs分区</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "3"){
						$("#aria2_install_status").html("<i>正在下载Aria2中...请耐心等待...</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "4"){
						$("#aria2_install_status").html("<i>正在安装Aria2中...</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "5"){
						$("#aria2_install_status").html("<i>Aria2安装成功！请等待页面刷新！</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
						version_check();
					} else if (db_aria2_['aria2_install_status'] == "6"){
						$("#aria2_install_status").html("<i>Aria2卸载中...</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "7"){
						$("#aria2_install_status").html("<i>Aria2卸载成功！</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else if (db_aria2_['aria2_install_status'] == "8"){
						$("#aria2_install_status").html("<i>Aria2下载文件校验不一致！</i>");
						document.getElementById('install_button').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('update_button').style.display = "none";
					} else {
						$("#aria2_install_status").html("<i>Aria2尚未安装</i>");
						//document.aria2_form.aria2_enable.value = 0;
						document.getElementById('aria2_switch').style.display = "none";
						document.getElementById('cmdBtn').style.display = "none";
						document.getElementById('uninstall_button').style.display = "none";
						document.getElementById('install_button').style.display = "";
						document.getElementById('aria2_version_status').style.display = "none";
					}
					setTimeout("write_aria2_install_status()", 1000);
					}
					});
				}
			function aria2_install(o, s){
				//document.getElementById('SystemCmd').value = "aria2_install.sh";
				document.aria2_form.aria2_enable.value = 2;
				if(validForm()){
					document.aria2_form.action_mode.value = s;
					//showLoading(5);
					document.aria2_form.submit();
					
					update_visibility();
				}
			}
			function aria2_uninstall(o, s){
				document.aria2_form.aria2_enable.value = 3;
				if(validForm()){
					document.aria2_form.action_mode.value = s;
					document.aria2_form.submit();
					update_visibility();
				}
			}
			function update_aria2(o, s){
				document.aria2_form.aria2_enable.value = 4;
				if(validForm()){
					document.aria2_form.action_mode.value = s;
					document.aria2_form.submit();
					update_visibility();
				}
			}
			function load_default_value(o, s){
				document.aria2_form.aria2_enable.value = 5;
				if(validForm()){
					document.aria2_form.action_mode.value = s;
					showLoading(5);
					document.aria2_form.submit();
					update_visibility();
				}
			}
			function version_check(){
				/* if (db_aria2_['aria2_version'] != db_aria2_['aria2_version_web'] && db_aria2_['aria2_version_web'] !== "undefined"){
					$("#aria2_version_status").html("<i>有新版本：" + db_aria2_['aria2_version_web']);
					document.getElementById('update_button').style.display = "";
				} else {
					$("#aria2_version_status").html("<i>当前版本：" + db_aria2_['aria2_version']);
					document.getElementById('update_button').style.display = "none";
				} */
				
    $.ajax({
        url: 'https://raw.githubusercontent.com/koolshare/koolshare.github.io/master/aria2/config.json.js',
        type: 'GET',
        success: function(res) {
            var txt = jQuery(res.responseText).text();
            if(typeof(txt) != "undefined" && txt.length > 0) {
                var obj = jQuery.parseJSON(txt.replace("'", "\""));

		if(obj.version != db_aria2_['aria2_version']) {
			$("#aria2_version_status").html("<i>有新版本：" + db_aria2_['aria2_version_web']);
			$("#update_button").show();
		} else {
			$("#aria2_version_status").html("<i>当前版本：" + db_aria2_['aria2_version']);
			$("#update_button").hide();
		}
            }
        }
    });

			}
			function valid_custom(){
				var s = document.getElementById('aria2_custom').value;
				var ins = ["/enable-rpc=/", "/rpc-allow-origin-all=/", "/rpc-listen-all=/"];
				for (var i = 0; i < ins.length; i++) {
					if (s.search(ins[i]) != -1){
					alert("不能在此设置选项! 请在图形界面设置");
					}
				}
			}
			function alert_custom(){
			var s = document.getElementById('aria2_custom').value;
				if (s.search(/enable-rpc=/) != -1) {
					alert("不能在此设置 enable-rpc 选项! 请在图形界面设置");
				} 
				if (s.search(/rpc-allow-origin-all=/) != -1) {
					alert("不能在此设置 enable-rpc 选项! 请在图形界面设置");
				}
				if (s.search(/rpc-listen-all=/) != -1) {
					alert("不能在此设置 rpc-listen-all 选项! 请在图形界面设置");
				}
				if (s.search(/rpc-listen-port=/) != -1) {
					alert("不能在此设置 rpc-listen-port 选项! 请在图形界面设置");
				}
				if (s.search(/event-poll=/) != -1) {
					alert("不能在此设置 event-poll 选项! 请在图形界面设置");
				}
				if (s.search(/rpc-user=/) != -1) {
					alert("不能在此设置 rpc-user 选项! 请在图形界面设置");
				}
				if (s.search(/rpc-passwd=/) != -1) {
					alert("不能在此设置 rpc-passwd 选项! 请在图形界面设置");
				}
				if (s.search(/max-concurrent-downloads=/) != -1) {
					alert("不能在此设置 max-concurrent-downloads 选项! 请在图形界面设置");
				}
				if (s.search(/continue=/) != -1) {
					alert("不能在此设置 continue 选项! 请在图形界面设置");
				}
				if (s.search(/max-connection-per-server=/) != -1) {
					alert("不能在此设置 max-connection-per-server 选项! 请在图形界面设置");
				}
				if (s.search(/min-split-size=/) != -1) {
					alert("不能在此设置 min-split-size 选项! 请在图形界面设置");
				}
				if (s.search(/split=/) != -1) {
					alert("不能在此设置 split 选项! 请在图形界面设置");
				}
				if (s.search(/max-overall-download-limit=/) != -1) {
					alert("不能在此设置 max-overall-download-limit 选项! 请在图形界面设置");
				}
				if (s.search(/max-download-limit=/) != -1) {
					alert("不能在此设置 max-download-limit 选项! 请在图形界面设置");
				}
				if (s.search(/max-overall-upload-limit=/) != -1) {
					alert("不能在此设置 max-overall-upload-limit 选项! 请在图形界面设置");
				}
				if (s.search(/max-upload-limit=/) != -1) {
					alert("不能在此设置 max-upload-limit 选项! 请在图形界面设置");
				}
				if (s.search(/lowest-speed-limit=/) != -1) {
					alert("不能在此设置 lowest-speed-limit 选项! 请在图形界面设置");
				}
				if (s.search(/lowest-speed-limit=/) != -1) {
					alert("不能在此设置 referer 选项! 请在图形界面设置");
				}
				if (s.search(/input-file=/) != -1) {
					alert("不能在此设置 input-file 选项! 请在图形界面设置");
				}
				if (s.search(/save-session=/) != -1) {
					alert("不能在此设置 save-session 选项! 请在图形界面设置");
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
				}
				if (s.search(/disk-cache=/) != -1) {
					alert("不能在此设置 disk-cache 选项! 请在图形界面设置");
				}
				if (s.search(/enable-mmap=/) != -1) {
					alert("不能在此设置 enable-mmap 选项! 请在图形界面设置");
				}
				if (s.search(/file-allocation=/) != -1) {
					alert("不能在此设置 file-allocation 选项! 请在图形界面设置");
				}
				if (s.search(/bt-enable-lpd=/) != -1) {
					alert("不能在此设置 bt-enable-lpd 选项! 请在图形界面设置");
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
				}
				if (s.search(/bt-tracker=/) != -1) {
					alert("不能在此设置 bt-tracker 选项! 请在图形界面设置");
				}
				if (s.search(/bt-max-peers=/) != -1) {
					alert("不能在此设置 bt-max-peers 选项! 请在图形界面设置");
				}
				if (s.search(/bt-require-crypto=/) != -1) {
					alert("不能在此设置 bt-require-crypto 选项! 请在图形界面设置");
				}
				if (s.search(/follow-torrent=/) != -1) {
					alert("不能在此设置 follow-torrent 选项! 请在图形界面设置");
				}
				if (s.search(/listen-port=/) != -1) {
					alert("不能在此设置 listen-port 选项! 请在图形界面设置");
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
				}
				if (s.search(/enable-dht=/) != -1) {
					alert("不能在此设置 enable-dht 选项! 请在图形界面设置");
				}
				if (s.search(/enable-peer-exchange=/) != -1) {
					alert("不能在此设置 enable-peer-exchange 选项! 请在图形界面设置");
				}
				if (s.search(/user-agent=/) != -1) {
					alert("不能在此设置 user-agent 选项! 请在图形界面设置");
				}
				if (s.search(/peer-id-prefix=/) != -1) {
					alert("不能在此设置 peer-id-prefix 选项! 请在图形界面设置");
				}
				if (s.search(/seed-ratio=/) != -1) {
					alert("不能在此设置 seed-ratio 选项! 请在图形界面设置");
				}
				if (s.search(/force-save=/) != -1) {
					alert("不能在此设置 force-save 选项! 请在图形界面设置");
				}
				if (s.search(/bt-hash-check-seed=/) != -1) {
					alert("不能在此设置 bt-hash-check-seed 选项! 请在图形界面设置");
				}
				if (s.search(/bt-seed-unverified=/) != -1) {
					alert("不能在此设置 bt-seed-unverified 选项! 请在图形界面设置");
				}
				if (s.search(/bt-save-metadata=/) != -1) {
					alert("不能在此设置 bt-save-metadata 选项! 请在图形界面设置");
				}
				if (s.search(/save-session-interval=/) != -1) {
					alert("不能在此设置 save-session-interval 选项! 请在图形界面设置");
				}
				if (s.search(/disable-ipv6=/) != -1) {
					alert("不能在此设置 save-session-interval 选项! 请在图形界面设置");
				}
			}
			function oncheckclick(obj) {
			    if (obj.checked) {
			        document.getElementById("f_" + obj.id).value = "true";
			    } else {
			        document.getElementById("f_" + obj.id).value = "false";
			    }
			}
			function line_show(){
				var temp_aria2 = ["aria2_custom"];
					for (var i = 0; i < temp_aria2.length; i++) {
					temp_str = document.getElementById(temp_aria2[i]).value;
					document.getElementById(temp_aria2[i]).value = temp_str.replaceAll(",","\n");
					}
			}
			function validForm(){
				var temp_aria2 = ["aria2_custom"];
				for(var i = 0; i < temp_aria2.length; i++) {
					var temp_str = document.getElementById(temp_aria2[i]).value;
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
					alert(temp_aria2[i] + " 不能超过10000个字符");
					return false;
				}
					document.getElementById(temp_aria2[i]).value = rlt;
					return true;
				}

			}
			function pass_checked(obj){
				switchType(obj, document.form.show_pass.checked, true);
			}
			function reload_Soft_Center(){
				location.href = "/Main_Soft_center.asp";
			}
			
			function openWeb(){
				window.open("http://yuancheng.xunlei.com/")
			}
			function initial_dir(){
				var __layer_order = "0_0";
				var url = "/getfoldertree.asp";
				var type = "General";
			
				url += "?motion=gettree&layer_order=" + __layer_order + "&t=" + Math.random();
				$.get(url,function(data){initial_dir_status(data);});
			}
			
			function initial_dir_status(data){
				if(data != "" && data.length != 2){
					get_layer_items("0");
					eval("var default_dir=" + data);
				}
				else {
					//document.getElementById("EditExports").style.display = "none";
					document.getElementById("NoUSB").style.display = "";
					disk_flag=1;
				}
			}
			function submit_server(x){
				var server_type = eval('document.serverForm.nfsd_enable ');
			
				showLoading();
				if(x == 1)
					server_type.value = 0;
				else
					server_type.value = 1;
			
				document.serverForm.flag.value = "nodetect";
				document.serverForm.submit();
			}
			// get folder
			var dm_dir = new Array();
			var WH_INT=0,Floder_WH_INT=0,General_WH_INT=0;
			var folderlist = new Array();
			function apply(){
				var rule_num = document.getElementById('nfsd_exportlist_table').rows.length;
				var item_num = document.getElementById('nfsd_exportlist_table').rows[0].cells.length;
				var tmp_value = "";
			
				for(i=0; i<rule_num; i++){
					tmp_value += "<"
					for(j=0; j<item_num-1; j++){
						tmp_value += document.getElementById('nfsd_exportlist_table').rows[i].cells[j].innerHTML;
						if(j != item_num-2)
							tmp_value += ">";
					}
				}
				if(tmp_value == "<"+"<#IPConnection_VSList_Norule#>" || tmp_value == "<")
					tmp_value = "";
			
				document.form.nfsd_exportlist.value = tmp_value;
			
				showLoading();
				FormActions("start_apply.htm", "apply", "restart_nasapps", "5");
				document.form.submit();
			}
			function get_disk_tree(){
				if(disk_flag == 1){
					alert('<#no_usb_found#>');
					return false;
				}
				cal_panel_block();
				$("#folderTree_panel").fadeIn(300);
				get_layer_items("0");
			}
			function get_layer_items(layer_order){
				$.ajax({
			    		url: '/gettree.asp?layer_order='+layer_order,
			    		dataType: 'script',
			    		error: function(xhr){
			    			;
			    		},
			    		success: function(){
							get_tree_items(treeitems);
			  			}
					});
			}
			function get_tree_items(treeitems){
				document.aidiskForm.test_flag.value = 0;
				this.isLoading = 1;
				var array_temp = new Array();
				var array_temp_split = new Array();
				for(var j=0;j<treeitems.length;j++){ // To hide folder 'Download2'
					array_temp_split[j] = treeitems[j].split("#");
					if( array_temp_split[j][0].match(/^asusware$/)	){
						continue;
					}
			
					array_temp.push(treeitems[j]);
				}
				this.Items = array_temp;
				if(this.Items && this.Items.length >= 0){
					BuildTree();
				}
			}
			function BuildTree(){
				var ItemText, ItemSub, ItemIcon;
				var vertline, isSubTree;
				var layer;
				var short_ItemText = "";
				var shown_ItemText = "";
				var ItemBarCode ="";
				var TempObject = "";
				for(var i = 0; i < this.Items.length; ++i){
					this.Items[i] = this.Items[i].split("#");
					var Item_size = 0;
					Item_size = this.Items[i].length;
					if(Item_size > 3){
						var temp_array = new Array(3);
						temp_array[2] = this.Items[i][Item_size-1];
						temp_array[1] = this.Items[i][Item_size-2];
						temp_array[0] = "";
						for(var j = 0; j < Item_size-2; ++j){
							if(j != 0)
								temp_array[0] += "#";
							temp_array[0] += this.Items[i][j];
						}
						this.Items[i] = temp_array;
					}
					ItemText = (this.Items[i][0]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,"");
					ItemBarCode = this.FromObject+"_"+(this.Items[i][1]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,"");
					ItemSub = parseInt((this.Items[i][2]).replace(/^[\s]+/gi,"").replace(/[\s]+$/gi,""));
					layer = get_layer(ItemBarCode.substring(1));
					if(layer == 3){
						if(ItemText.length > 21)
					 		short_ItemText = ItemText.substring(0,30)+"...";
					 	else
					 		short_ItemText = ItemText;
					}
					else
						short_ItemText = ItemText;
			
					shown_ItemText = showhtmlspace(short_ItemText);
			
					if(layer == 1)
						ItemIcon = 'disk';
					else if(layer == 2)
						ItemIcon = 'part';
					else
						ItemIcon = 'folders';
			
					SubClick = ' onclick="GetFolderItem(this, ';
					if(ItemSub <= 0){
						SubClick += '0);"';
						isSubTree = 'n';
					}
					else{
						SubClick += '1);"';
						isSubTree = 's';
					}
			
					if(i == this.Items.length-1){
						vertline = '';
						isSubTree += '1';
					}
					else{
						vertline = ' background="/images/Tree/vert_line.gif"';
						isSubTree += '0';
					}
			
					if(layer == 2 && isSubTree == 'n1'){	// Uee to rebuild folder tree if disk without folder, Jieming add at 2012/08/29
						document.aidiskForm.test_flag.value = 1;
					}
					TempObject +='<table class="tree_table" id="bug_test">';
					TempObject +='<tr>';
					// the line in the front.
					TempObject +='<td class="vert_line">';
					TempObject +='<img id="a'+ItemBarCode+'" onclick=\'document.getElementById("d'+ItemBarCode+'").onclick();\' class="FdRead" src="/images/Tree/vert_line_'+isSubTree+'0.gif">';
					TempObject +='</td>';
			
					if(layer == 3){
					/*a: connect_line b: harddisc+name  c:harddisc  d:name e: next layer forder*/
						TempObject +='<td>';
						TempObject +='<img id="c'+ItemBarCode+'" onclick=\'document.getElementById("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
						TempObject +='</td>';
						TempObject +='<td>';
						TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>\n';
						TempObject +='</td>';
					}
					else if(layer == 2){
						TempObject +='<td>';
						TempObject +='<table class="tree_table">';
						TempObject +='<tr>';
						TempObject +='<td class="vert_line">';
						TempObject +='<img id="c'+ItemBarCode+'" onclick=\'document.getElementById("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
						TempObject +='</td>';
						TempObject +='<td class="FdText">';
						TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>';
						TempObject +='</td>';
						TempObject +='<td></td>';
						TempObject +='</tr>';
						TempObject +='</table>';
						TempObject +='</td>';
						TempObject +='</tr>';
						TempObject +='<tr><td></td>';
						TempObject +='<td colspan=2><div id="e'+ItemBarCode+'" ></div></td>';
					}
					else{
					/*a: connect_line b: harddisc+name  c:harddisc  d:name e: next layer forder*/
						TempObject +='<td>';
						TempObject +='<table><tr><td>';
						TempObject +='<img id="c'+ItemBarCode+'" onclick=\'document.getElementById("d'+ItemBarCode+'").onclick();\' src="/images/New_ui/advancesetting/'+ItemIcon+'.png">';
						TempObject +='</td><td>';
						TempObject +='<span id="d'+ItemBarCode+'"'+SubClick+' title="'+ItemText+'">'+shown_ItemText+'</span>';
						TempObject +='</td></tr></table>';
						TempObject +='</td>';
						TempObject +='</tr>';
						TempObject +='<tr><td></td>';
						TempObject +='<td><div id="e'+ItemBarCode+'" ></div></td>';
					}
			
					TempObject +='</tr>';
				}
				TempObject +='</table>';
				document.getElementById("e"+this.FromObject).innerHTML = TempObject;
			}
			function get_layer(barcode){
				var tmp, layer;
				layer = 0;
				while(barcode.indexOf('_') != -1){
					barcode = barcode.substring(barcode.indexOf('_'), barcode.length);
					++layer;
					barcode = barcode.substring(1);
				}
				return layer;
			}
			function build_array(obj,layer){
				var path_temp ="/mnt";
				var layer2_path ="";
				var layer3_path ="";
				if(obj.id.length>6){
					if(layer ==3){
			 			layer3_path = "/" + obj.title;
						while(layer3_path.indexOf("&nbsp;") != -1)
							layer3_path = layer3_path.replace("&nbsp;"," ");
			
						if(obj.id.length >8)
							layer2_path = "/" + document.getElementById(obj.id.substring(0,obj.id.length-3)).innerHTML;
						else
							layer2_path = "/" + document.getElementById(obj.id.substring(0,obj.id.length-2)).innerHTML;
			
						while(layer2_path.indexOf("&nbsp;") != -1)
							layer2_path = layer2_path.replace("&nbsp;"," ");
					}
				}
				if(obj.id.length>4 && obj.id.length<=6){
					if(layer ==2){
						layer2_path = "/" + obj.title;
						while(layer2_path.indexOf("&nbsp;") != -1)
							layer2_path = layer2_path.replace("&nbsp;"," ");
					}
				}
				path_temp = path_temp + layer2_path +layer3_path;
				return path_temp;
			}
			function GetFolderItem(selectedObj, haveSubTree){
				var barcode, layer = 0;
				showClickedObj(selectedObj);
				barcode = selectedObj.id.substring(1);
				layer = get_layer(barcode);
			
				if(layer == 0)
					alert("Machine: Wrong");
				else if(layer == 1){
					// chose Disk
					setSelectedDiskOrder(selectedObj.id);
					path_directory = build_array(selectedObj,layer);
					document.getElementById('createFolderBtn').className = "createFolderBtn";
					document.getElementById('deleteFolderBtn').className = "deleteFolderBtn";
					document.getElementById('modifyFolderBtn').className = "modifyFolderBtn";
			
					document.getElementById('createFolderBtn').onclick = function(){};
					document.getElementById('deleteFolderBtn').onclick = function(){};
					document.getElementById('modifyFolderBtn').onclick = function(){};
				}
				else if(layer == 2){
					// chose Partition
					setSelectedPoolOrder(selectedObj.id);
					path_directory = build_array(selectedObj,layer);
					document.getElementById('createFolderBtn').className = "createFolderBtn_add";
					document.getElementById('deleteFolderBtn').className = "deleteFolderBtn";
					document.getElementById('modifyFolderBtn').className = "modifyFolderBtn";
			
					document.getElementById('createFolderBtn').onclick = function(){popupWindow('OverlayMask','/aidisk/popCreateFolder.asp');};
					document.getElementById('deleteFolderBtn').onclick = function(){};
					document.getElementById('modifyFolderBtn').onclick = function(){};
					document.aidiskForm.layer_order.disabled = "disabled";
					document.aidiskForm.layer_order.value = barcode;
				}
				else if(layer == 3){
					// chose Shared-Folder
					setSelectedFolderOrder(selectedObj.id);
					path_directory = build_array(selectedObj,layer);
					document.getElementById('createFolderBtn').className = "createFolderBtn";
					document.getElementById('deleteFolderBtn').className = "deleteFolderBtn_add";
					document.getElementById('modifyFolderBtn').className = "modifyFolderBtn_add";
			
					document.getElementById('createFolderBtn').onclick = function(){};
					document.getElementById('deleteFolderBtn').onclick = function(){popupWindow('OverlayMask','/aidisk/popDeleteFolder.asp');};
					document.getElementById('modifyFolderBtn').onclick = function(){popupWindow('OverlayMask','/aidisk/popModifyFolder.asp');};
					document.aidiskForm.layer_order.disabled = "disabled";
					document.aidiskForm.layer_order.value = barcode;
				}
			
				if(haveSubTree)
					GetTree(barcode, 1);
			}
			function showClickedObj(clickedObj){
				if(this.lastClickedObj != 0)
					this.lastClickedObj.className = "lastfolderClicked";  //this className set in AiDisk_style.css
			
				clickedObj.className = "folderClicked";
				this.lastClickedObj = clickedObj;
			}
			function GetTree(layer_order, v){
				if(layer_order == "0"){
					this.FromObject = layer_order;
					document.getElementById('d'+layer_order).innerHTML = '<span class="FdWait">. . . . . . . . . .</span>';
					setTimeout('get_layer_items("'+layer_order+'", "gettree")', 1);
					return;
				}
			
				if(document.getElementById('a'+layer_order).className == "FdRead"){
					document.getElementById('a'+layer_order).className = "FdOpen";
					document.getElementById('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"1.gif";
					this.FromObject = layer_order;
					document.getElementById('e'+layer_order).innerHTML = '<img src="/images/Tree/folder_wait.gif">';
					setTimeout('get_layer_items("'+layer_order+'", "gettree")', 1);
				}
				else if(document.getElementById('a'+layer_order).className == "FdOpen"){
					document.getElementById('a'+layer_order).className = "FdClose";
					document.getElementById('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"0.gif";
					document.getElementById('e'+layer_order).style.position = "absolute";
					document.getElementById('e'+layer_order).style.visibility = "hidden";
				}
				else if(document.getElementById('a'+layer_order).className == "FdClose"){
					document.getElementById('a'+layer_order).className = "FdOpen";
					document.getElementById('a'+layer_order).src = "/images/Tree/vert_line_s"+v+"1.gif";
					document.getElementById('e'+layer_order).style.position = "";
					document.getElementById('e'+layer_order).style.visibility = "";
				}
				else
					alert("Error when show the folder-tree!");
			}
			function cancel_folderTree(){
				this.FromObject ="0";
				$("#folderTree_panel").fadeOut(300);
			}
			function confirm_folderTree(){
				document.getElementById('aria2_dir').value = path_directory ;
				this.FromObject ="0";
				$("#folderTree_panel").fadeOut(300);
			}
			
			function cal_panel_block(){
				var blockmarginLeft;
				if (window.innerWidth)
					winWidth = window.innerWidth;
				else if ((document.body) && (document.body.clientWidth))
					winWidth = document.body.clientWidth;
			
				if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
					winWidth = document.documentElement.clientWidth;
				}
			
				if(winWidth >1050){
					winPadding = (winWidth-1050)/2;
					winWidth = 1105;
					blockmarginLeft= (winWidth*0.25)+winPadding;
				}
				else if(winWidth <=1050){
					blockmarginLeft= (winWidth)*0.25+document.body.scrollLeft;
				}
			
				document.getElementById("folderTree_panel").style.marginLeft = blockmarginLeft+"px";
			}
			
			function addRow(obj, head){
				if(head == 1)
					nfsd_exportlist_array += "&#60"
				else
					nfsd_exportlist_array += "&#62"
			
				nfsd_exportlist_array += obj.value;
			
				obj.value = "";
			}
			
			function check_dir_path(){
				var dir_array = document.getElementById('aria2_dir').value.split("/");
				if(dir_array[dir_array.length - 1].length > 21)
				document.getElementById('aria2_dir').value = "/" + dir_array[1] + "/" + dir_array[2] + "/" + dir_array[dir_array.length - 1].substring(0,18) + "...";
			}
		</script>
	</head>
	<body onload="init();">
		<div id="TopBanner"></div>
		<!-- floder tree-->
		<div id="DM_mask" class="mask_bg"></div>
		<div id="folderTree_panel" class="panel_folder">
			<table>
				<tr>
					<td>
						<div class="machineName" style="width:200px;font-family:Microsoft JhengHei;font-size:12pt;font-weight:bolder; margin-top:15px;margin-left:30px;">选择下载目录</div>
					</td>
					<td>
						<div style="width:240px;margin-top:17px;margin-left:125px;">
							<table>
								<tr>
									<td>
										<div id="createFolderBtn" class="createFolderBtn" title="<#AddFolderTitle#>"></div>
									</td>
									<td>
										<div id="deleteFolderBtn" class="deleteFolderBtn" title="<#DelFolderTitle#>"></div>
									</td>
									<td>
										<div id="modifyFolderBtn" class="modifyFolderBtn" title="<#ModFolderTitle#>"></div>
									</td>
									<tr>
							</table>
						</div>
					</td>
					</tr>
			</table>
			<div id="e0" class="folder_tree"></div>
			<div style="background-image:url(images/Tree/bg_02.png);background-repeat:no-repeat;height:90px;">
				<input class="button_gen" type="button" style="margin-left:27%;margin-top:18px;" onclick="cancel_folderTree();" value="取消">
				<input class="button_gen" type="button" onclick="confirm_folderTree();" value="确认">
			</div>
		</div>
		<div id="DM_mask_floder" class="mask_floder_bg"></div>
		<!-- floder tree-->
		<div id="Loading" class="popup_bg"></div>
		<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<form method="post" name="serverForm" action="/start_apply.htm" target="hidden_frame">
			<input type="hidden" name="action_mode" value="apply">
			<input type="hidden" name="action_script" value="restart_nasapps">
			<input type="hidden" name="action_wait" value="5">
			<input type="hidden" name="current_page" value="/Advanced_AiDisk_NFS.asp">
			<input type="hidden" name="flag" value="">
			<input type="hidden" name="nfsd_enable" value="<% nvram_get(" nfsd_enable "); %>">
		</form>
		<form method="post" name="aidiskForm" action="" target="hidden_frame">
			<input type="hidden" name="motion" id="motion" value="">
			<input type="hidden" name="layer_order" id="layer_order" value="">
			<input type="hidden" name="test_flag" value="" disabled="disabled">
			<input type="hidden" name="protocol" id="protocol" value="">
		</form>
		<form method="POST" name="aria2_form" action="/applydb.cgi?p=aria2_" target="hidden_frame">
			<input type="hidden" name="current_page" value="Module_aria2.asp" />
			<input type="hidden" name="next_page" value="Module_aria2.asp" />
			<input type="hidden" name="group_id" value="" />
			<input type="hidden" name="modified" value="0" />
			<input type="hidden" name="action_mode" value="" />
			<input type="hidden" name="action_script" value="" />
			<input type="hidden" name="action_wait" value="5" />
			<input type="hidden" name="first_time" value="" />
			<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
			<input type="hidden" name="SystemCmd" id="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="aria2_run.sh" />
			<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
			<input type="hidden" id="aria2_enable" name="aria2_enable" value='<% dbus_get_def("aria2_enable", "0"); %>' />
			<input type="hidden" id="aria2_restart" name="aria2_restart" value="1" />
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
												<div style="float:left;" class="formfonttitle">Aria2</div>
												<div style="float:right; width:15px; height:25px;margin-top:10px">
													<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
													<img src="/images/New_ui/export/line_export.png">
												</div>
												<div class="formfontdesc" id="cmdDesc">在此页面，你能进行Aria2的安装和卸载，以及其他一些简单的设置</div>
												<div class="formfontdesc" id="cmdDesc"></div>
												<table id="aria2_switch" style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<tr>
														<th style="width:25%;">开启Aria2</th>
														<td colspan="2">
															<div class="switch_field" style="display:table-cell">
																<label for="switch">
																	<input id="switch" class="switch" type="checkbox" style="display: none;">
																	<div class="switch_container">
																		<div class="switch_bar"></div>
																		<div class="switch_circle transition_style">
																			<div></div>
																		</div>
																	</div>
																</label>
															</div>
														</td>
													</tr>
												</table>
												<!--beginning of aria2 install table-->
												<table id="aria2_install_table" style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">Aria2相关信息</td>
														</tr>
													</thead>
													<tr>
														<th style="width:25%;">Aria2安装</th>
														<td>
															
															<div id="aria2_install_status" style="padding-top:5px;float: left;"></div>
															<div id="aria2_version_status" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"><i>当前版本：<% dbus_get_def("aria2_version", "0"); %></i></div>
															<div style="padding-top:0px;margin-left:30px;margin-top:0px;float: left;">
																<button id="install_button" class="button_gen" onclick="aria2_install(this, ' Refresh ');">安装</button>
																<button id="uninstall_button" class="button_gen" onclick="aria2_uninstall(this, ' Refresh ');">卸载</button>
																<button id="update_button" class="button_gen" onclick="update_aria2(this, ' Refresh ');">更新</button>
															</div>
														</td>
													</tr>
													<tr id="h5ai">
														<th style="width:25%;">h5ai文件服务器</th>
														<td>
															<div id="link1" style="padding-top:5px;">
																<a id="link1.1" href="http://192.168.100.1:808" target="_blank"><i><u>http://192.168.100.1:808</u></i></a>
															</div>
														</td>
													</tr>
													<tr id="aria2-webui">
														<th style="width:25%;">aria2-webui控制台</th>
														<td>
															<div id="link2" style="padding-top:5px;">
																<a id="link2.1" href="http://192.168.100.1:808/aria2" target="_blank"><i><u>http://192.168.100.1:808/aria2</u></i></a>
															</div>
														</td>
													</tr>
													<tr id="yaaw">
														<th style="width:25%;">Yaaw控制台</th>
														<td>
															<div id="link3" style="padding-top:5px;">
																<a id="link3.1" href="http://192.168.100.1:808/yaaw" target="_blank"><i><u>http://192.168.100.1:808/yaaw</u></i></a>
															</div>
														</td>
													</tr>
												</table>
												<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;" class="formfontdesc" id="cmdDesc">
													<i><% dbus_get_def("tunnel_config_enable", "0"); %></i>
												</div>
												
												<table id="aria2_base_table" style="margin:10px 0px 0px 0px;display: none;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">Aria2基本设置</td>
														</tr>
													</thead>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>aria2c 程序所在目录</label>
														</td>
														<td>
															<select class="input_ss_table" style="width:auto;height:25px;" name="aria2_binary" id="aria2_binary" onchange="update_visibility();">
																<option value="internal" selected="">内置 (/koolshare/aria2)</option>
																<option value="entware">外置 (/opt/bin)</option>
																<option value="custom">自定义</option>
															</select>
															<small>*</small>
															<input style="display: none;" type="text" class="input_ss_table" style="width:auto;" name="aria2_binary_custom" value="/mnt/opt/bin" maxlength="40" size="40" id="aria2_binary_custom">
															<small>不包含程序名称"/aria2c"</small>

														</td>
													</tr>


													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用CPU占用限制</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_cpulimit_enable" checked="" onclick="oncheckclick(this)" onchange="update_visibility();">
															<input type="hidden" id="f_aria2_cpulimit_enable" name="aria2_cpulimit_enable" value="" />
															<input style="display: none;" type="text" class="input_ss_table" style="width:auto;" name="aria2_cpulimit_value" value="30" maxlength="40" size="40" id="aria2_cpulimit_value">
															<small>(范围: 1 - 100; 默认: 30)</small>
														</td>
													</tr>	

													
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用守护进程</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_check" checked="" onclick="oncheckclick(this)" onchange="update_visibility();">
															<input type="hidden" id="f_aria2_check" name="aria2_check" value="" />
															<small>*</small>

														</td>
													</tr>
													<tr id="aria2_check_time_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>检测时间间隔</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_check_time" value="15" maxlength="5" size="7" id="aria2_check_time">
															<small>分钟 (范围: 1 - 55; 默认: 15)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启动延迟</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_sleep" value="10" maxlength="5" size="7" id="aria2_sleep">
															<small>秒 (范围: 1 - 60; 默认: 10)</small>

														</td>
													</tr>
													<tr id="update_rules">
														<td  style="background-color: #2F3A3E;width:25%;">Aria2更新检测</td>
														<td>
															<select id="aria2_update_enable" name="aria2_update_enable" class="input_ss_table" style="width:86px;height:25px;" onchange="update_visibility();" >
																<option value="0">禁用</option>
																<option value="1">开启</option>
															</select>
															<select id="aria2_update_sel" name="aria2_update_sel" class="input_ss_table" style="width:86px;height:25px;" title="选择规则列表自动更新时间，更新后将自动重启SS" onchange="update_visibility();" >
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
															<small>开启时检测aria2有无更新，并在右上版本号处提示</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>下载存储目录</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_dir" value="downloads" maxlength="50" size="40" readonly="readonly" onclick="get_disk_tree();" id="aria2_dir">
															<small>如果没有自定义，将使用第一个USB的根目录.</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用续传</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_continue" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_continue" name="aria2_continue" value="" />
															<small>*</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>最大重试次数</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_tries" value="0" maxlength="16" size="7" id="aria2_max_tries">
															<small>(范围: 0 - 9999; 默认: 0 - 无限制)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>重试间隔时间</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_retry_wait" value="10" maxlength="16" size="7" id="aria2_retry_wait">
															<small>秒 (范围: 0 - 3600; 默认: 10)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>Referer (适用于v1.16+)</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_referer" value="*" maxlength="1024" size="15" id="aria2_referer">
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>磁盘缓存大小 (适用于v1.16+)</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_disk_cache" value="0" maxlength="16" size="7" id="aria2_disk_cache">
															<small>( 以K或M结尾，例如，10K, 5M, 1024K 等等; 缺省: 0 - 无磁盘缓存)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用 MMAP</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_enable_mmap" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_enable_mmap" name="aria2_enable_mmap" value="" />
															<small>*</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>文件分配方式</label>
														</td>
														<td>
															<select class="input_ss_table" style="width:86px;height:25px;" name="aria2_file_allocation" id="aria2_file_allocation">
																<option value="prealloc">Prealloc</option>
																<option value="trunc">Trunc</option>
																<option value="falloc">Falloc</option>
																<option value="none" selected="">None*</option>
															</select>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>Aria2 配置自定义</label>
														</td>
														<td>
															<textarea rows=6 style="width:99%; font-size:11px;background:#475A5F;color:#FFFFFF;border:1px solid gray;height:auto;" name="aria2_custom" id="aria2_custom" title="">ca-certificate=false,check-certificate=false</textarea>
														</td>
													</tr>
												</table>
												<table id="aria2_rpc_table" style="margin:10px 0px 0px 0px;display: none;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">RPC远程访问设置</td>
														</tr>
													</thead>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用 RPC</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_enable_rpc" checked="" onclick="oncheckclick(this)" onchange="update_visibility();">
															<input type="hidden" id="f_aria2_enable_rpc" name="aria2_enable_rpc" value="" />															
															<small>*</small>
														</td>
													</tr>
													<tr id="aria2_rpc_listen_port_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>RPC 监听端口</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_rpc_listen_port" value="6800" maxlength="5" size="7" id="aria2_rpc_listen_port" title="">	<small>*</small>

														</td>
													</tr>
													<tr id="aria2_rpc_allow_origin_all_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>RPC 允许所有来源</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_rpc_allow_origin_all" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_rpc_allow_origin_all" name="aria2_rpc_allow_origin_all" value="" />		
															<small>*</small>
														</td>
													</tr>

													<tr id="aria2_disable_ipv6_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>RPC 不监听IPV6</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_disable_ipv6" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_disable_ipv6" name="aria2_disable_ipv6" value="" />	
															<small>*</small>
														</td>
													</tr>
													
													<tr id="aria2_rpc_listen_all_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>RPC 监听所有网络接口</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_rpc_listen_all" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_rpc_listen_all" name="aria2_rpc_listen_all" value="" />	
															<small>*</small>
														</td>
													</tr>
													<tr id="aria2_event_poll_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>轮询方式</label>
														</td>
														<td>
															<select class="input_ss_table" style="width:86px;height:25px;" name="aria2_event_poll" id="aria2_event_poll">
																<option value="select" selected="">Select</option>
																<option value="poll">Poll</option>
																<option value="port">Port</option>
																<option value="kqueue">KQueue</option>
																<option value="epoll">EPoll</option>
															</select>
														</td>
													</tr>
													<tr id="aria2_rpc_secret_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>RPC密码 / token</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_rpc_secret" value="" maxlength="32" size="32" id="aria2_rpc_secret">
															<small><i>(如果不填，此处将会自动生成随机密码)</i></small>
														</td>
													</tr>
												</table>
												<table id="aria2_limit_table" style="margin:10px 0px 0px 0px;display: none;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">下载限制设置</td>
														</tr>
													</thead>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>最大同时下载任务数</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_concurrent_downloads" value="3" maxlength="10" size="7" id="aria2_max_concurrent_downloads">
															<small>(范围: 1 - 100; 缺省: 5)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>同服务器最大连接数</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_connection_per_server" value="3" maxlength="10" size="7" id="aria2_max_connection_per_server">	<small>(范围: 1 - 16; 缺省: 5)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;" style="background-color: #2F3A3E;width:25%;">
															<label>最小文件分片大小</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_min_split_size" value="10M" maxlength="20" size="10" id="aria2_min_split_size">	<small>(范围: 1M - 1024M; 缺省: 10M)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>单文件最大线程数</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_split" value="5" maxlength="10" size="10" id="aria2_split">	<small>(范围: 1 - 100; 缺省: 5)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>下载总速度限制</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_overall_download_limit" value="0" maxlength="16" size="10" id="aria2_max_overall_download_limit">	<small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>单文件下载速度限制</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_download_limit" value="0" maxlength="16" size="10" id="aria2_max_download_limit">	<small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>上传总速度限制</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_overall_upload_limit" value="0" maxlength="16" size="10" id="aria2_max_overall_upload_limit">	<small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>单文件上传速度限制</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_upload_limit" value="0" maxlength="16" size="10" id="aria2_max_upload_limit">	<small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>断开此速度以下的连接</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:80px;" name="aria2_lowest_speed_limit" value="0" maxlength="16" size="10" id="aria2_lowest_speed_limit">	<small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>

														</td>
													</tr>
												</table>
												<table id="aria2_bt_table" style="margin:10px 0px 0px 0px;display: none;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">BT 相关设置</td>
														</tr>
													</thead>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用本地节点查找(LPD)</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_bt_enable_lpd" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_bt_enable_lpd" name="aria2_bt_enable_lpd" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用 DHT</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_enable_dht" checked="" onclick="oncheckclick(this)"  onchange="update_visibility();">
															<input type="hidden" id="f_aria2_enable_dht" name="aria2_enable_dht" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr id="aria2_dht_listen_port_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>DHT 监听端口</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_dht_listen_port" value="6881-6999" maxlength="50" size="50" id="aria2_dht_listen_port">
															<small>默认: 6881-6999</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>添加额外的Tracker</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_bt_tracker" value="" maxlength="256" size="64" id="aria2_bt_tracker">
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>单种子最大连接数</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_bt_max_peers" value="55" maxlength="10" size="7" id="aria2_bt_max_peers">
															<small>(范围: 1 - 9999; 缺省: 55)</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>强制加密</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_bt_require_crypto" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_bt_require_crypto" name="aria2_bt_require_crypto" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>自动下载.torrent种子</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_follow_torrent" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_follow_torrent" name="aria2_follow_torrent" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>BT 监听端口</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_listen_port" value="6881-6889,51413" maxlength="50" size="50" id="aria2_listen_port">
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用节点信息交换</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_enable_peer_exchange" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_enable_peer_exchange" name="aria2_enable_peer_exchange" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>用户代理</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_user_agent" value="uTorrent/2210(25130)" maxlength="64" size="50" id="aria2_user_agent">
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>节点ID前缀</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_peer_id_prefix" value="-UT2210-" maxlength="64" size="15" id="aria2_peer_id_prefix">
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>分享比例</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_seed_ratio" value="1.0" maxlength="64" size="15" id="aria2_seed_ratio">	<small>(范围: 0.0 - 9999; 缺省: 1.0)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用会话session强制保存</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_force_save" checked="" onclick="oncheckclick(this)"  onchange="update_visibility();">
															<input type="hidden" id="f_aria2_force_save" name="aria2_force_save" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr id="aria2_save_session_interval_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>&nbsp;&nbsp;&nbsp;&nbsp;会话session保存间隔</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_save_session_interval" value="60" maxlength="20" size="7" id="aria2_save_session_interval">	<small>秒 (范围: 0 - 3600; 缺省: 60)</small>

														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>&nbsp;&nbsp;&nbsp;&nbsp;下载的URIs 文件</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_input_file" value="/koolshare/aria2/aria2.session" maxlength="50" size="50" id="aria2_input_file">
														</td>
													</tr>
													<tr id="aria2_save_session_tr">
														<td style="background-color: #2F3A3E;width:25%;">
															<label>&nbsp;&nbsp;&nbsp;&nbsp;会话session保存文件</label>
														</td>
														<td>
															<input type="text" class="input_ss_table" style="width:auto;" name="aria2_save_session" value="/koolshare/aria2/aria2.session" maxlength="50" size="50" id="aria2_save_session">
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用哈希检查做种</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_bt_hash_check_seed" checked="" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_bt_hash_check_seed" name="aria2_bt_hash_check_seed" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用无校验做种</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_bt_seed_unverified" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_bt_seed_unverified" name="aria2_bt_seed_unverified" value="" />
															<small>*</small>
														</td>
													</tr>
													<tr>
														<td style="background-color: #2F3A3E;width:25%;">
															<label>启用元数据保存</label>
														</td>
														<td>
															<input type="checkbox" id="aria2_bt_save_metadata" onclick="oncheckclick(this)">
															<input type="hidden" id="f_aria2_bt_save_metadata" name="aria2_bt_save_metadata" value="" />
															<small>*</small>
														</td>
													</tr>
												</table>
												<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;" class="formfontdesc" id="cmdDesc">
													<i>开启双线路负载均衡模式才能进行本页面设置，建议负载均衡设置比例1：1</i>
												</div>
												<div class="apply_gen">
													<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
													<button id="cmdBtn1" class="button_gen" onclick="load_default_value(this, ' Refresh ')">恢复默认参数</button>
												</div>
												<div style="margin-left:5px;margin-top:10px;margin-bottom:10px">
													<img src="/images/New_ui/export/line_export.png">
												</div>
												<div class="KoolshareBottom">
													<br/>论坛技术支持：
													<a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> 
													</a>
													<br/>后台技术支持： <i>Xiaobao</i> 
													<br/>Shell, Web by： <i>fw867</i>
													<br/>
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
			<div id="footer"></div>
			<!-- mask for disabling AiDisk -->
			<div id="OverlayMask" class="popup_bg">
				<div align="center">
					<iframe src="" frameborder="0" scrolling="no" id="popupframe" width="400" height="400" allowtransparency="true" style="margin-top:150px;"></iframe>
				</div>
				<!--[if lte IE 6.5]>
					<iframe class="hackiframe"></iframe>
				<![endif]-->
			</div>
		</form>
	</body>

</html>
