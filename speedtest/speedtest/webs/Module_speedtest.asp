<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="-1"/>
        <link rel="shortcut icon" href="images/favicon.png"/>
        <link rel="icon" href="images/favicon.png"/>
        <title>软件中心 - Speedtest网络测速</title>
        <link rel="stylesheet" type="text/css" href="index_style.css">
        <link rel="stylesheet" type="text/css" href="form_style.css">
        <link rel="stylesheet" type="text/css" href="usp_style.css">
        <link rel="stylesheet" type="text/css" href="/device-map/device-map.css" />
        <script type="text/javascript" src="/state.js"></script>
        <script type="text/javascript" src="/popup.js"></script>
        <script type="text/javascript" src="/help.js"></script>
        <script type="text/javascript" src="/general.js"></script>
        <script type="text/javascript" src="/js/jquery.js"></script>
        <script type="text/javascript" src="/client_function.js"></script>
        <script type="text/javascript" src="/calendar/jquery-ui.js"></script>
        <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
        <script type="text/javascript" src="/form.js"></script>
        <style type="text/css">
        .splitLine{
            background-image: url('/images/New_ui/export/line_export.png');
            background-repeat: no-repeat;
            height: 3px;
            width: 100%;
            margin-bottom: 7px;
        }
        #sortable div table tr:hover{
            cursor: pointer;
            color: #000;
            background-color: #66777D;
            font-weight: bolder;
        }
        #sortable div table{
            font-family:Verdana;
            width: 100%;
            border-spacing: 0px;
        }
        .trafficIcons{
            width:56px;
            height:56px;
            background-image:url('/images/New_ui/networkmap/client-list.png');
            background-repeat:no-repeat;
            border-radius:10px;
            margin-left:10px;
            background-position:50% 61.10%;
        }
        .trafficIcons:hover{
            background-image:url('/images/New_ui/networkmap/client-listover.png');
        }
        .trafficIcons_clicked{
            width:56px;
            height:56px;
            background-image:url('/images/New_ui/networkmap/client-listover.png');
            background-repeat:no-repeat;
            border-radius:10px;
            margin-left:10px;
            background-position:50% 64.40%;
        }
        .trafficVenderIcons{
            width:56px;
            height:56px;
            background-image:url('/images/New_ui/networkmap/vender-list.png');
            background-repeat:no-repeat;
            border-radius:10px;
            margin-left:10px;
        }
        .trafficVenderIcons:hover{
            background-image:url('/images/New_ui/networkmap/vender-listover.png');
        }
        .trafficVenderIcons_clicked{
            width:56px;
            height:56px;
            background-image:url('/images/New_ui/networkmap/vender-listover.png');
            background-repeat:no-repeat;
            border-radius:10px;
            margin-left:10px;
        }

        .qosLevel, .qosLevel3{
            background-color: #7A797A;
        }
        .qosLevel0{
            background-color: #F01F09;
        }
        .qosLevel1{
            background-color: #F08C09;
        }
        .qosLevel2{
            background-color: #F3DD09;
        }
        .qosLevel4{
            background-color: #58CCED;
        }
        .imgUserIcon{
            margin-left: 2px;
            margin-top: 2px;
            width: 51px;
            height: 52px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 10px;
        }
        .divUserIcon{
            cursor: pointer;
            margin-left:10px;
            width:56px;
            height:56px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 10px;
            border-radius:10px;
        }
        .traffic_bar{
            width: 0%;
            background-color: #93E7FF;
            height: 8px;
            border-radius:5px;
        }
        .traffic_bar_boost{
            background-color: #B71010;
        }
        .boost_tag_BM {
            font-weight: normal;
            text-align: center;
            width: 55px;
            height: 25px;
            line-height: 25px;
            border-radius: 15%;
            margin-top: -21px;
            margin-left: 25px;
            color: #FFFFFF;
            font-size: 9px;
            -webkit-transform: scale(0.75);
            background: #FF4848; /* Old browsers */
            background: -moz-linear-gradient(top, #A21717 0%, #B71010 50%, #FF4848 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#A21717), color-stop(50%,#B71010), color-stop(100%,#FF4848)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #A21717 0%,#B71010 50%,#FF4848 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #A21717 0%,#B71010 50%,#FF4848 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #A21717 0%,#B71010 50%,#FF4848 100%); /* IE10+ */
            background: linear-gradient(to bottom, #A21717 0%,#B71010 70%,#FF4848 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#A21717', endColorstr='#FF4848',GradientType=0 ); /* IE6-9 */
        }
        </style>
        <style>
            .plugin-header{
                overflow: hidden;
                padding:0px 20px;
            }
            .plugin-header .text{
                float: left;
                line-height:35px;
                color:#fff;
                font-size: 26px;
            }
            .plugin-header .return-button{
                float:right;
                display:block;
                background: url(/images/backprev.png) no-repeat center center;
                width: 40px;
                height: 40px;
                text-indent: -9999px;
                overflow:hidden;
            }
            .version-info{
                color:red;
                font-size: 14px;
                font-weight:normal;
            }

            /* 测速表样式 */
            .dashboard-content{
                width: 504px;
                margin:0px auto;
            }
            .graph{
                display:inline-block;
                margin-right: 40px;
                position: relative;
            }
            .graph:last-child{
                margin-right: 0;
            }
            .graph .desc{
                color: #fff;
                line-height: 24px;
                font-size: 14px;
                text-align: center;
                font-weight: normal;
            }
            .graph .background{
                background:url(/images/New_ui/speedmeter.png) no-repeat center -13px;
                width:230px;
                height:175px;
            }
            .graph .speed{
                text-align:center;
                color:#fff;
                font-weight:bold;
                font-size: 18px;
                line-height:24px;
                position:absolute;
                width:100%;
                bottom:10px;
            }
            .graph .indicator{
                position:absolute;
                background:url('images/New_ui/indicator.png') no-repeat -16px center;
                height:64px;
                width: 17px;
                left: 104px;
                bottom: 62px;
                -webkit-transform:rotate(-123deg);
                -moz-transform:rotate(-123deg);
                -o-transform:rotate(-123deg);
                msTransform:rotate(-123deg);
                transform-origin: center bottom;
                transform:rotate(-123deg);
                -webkit-transition: all 2s ease-in-out;
                -moz-transition: all 2s ease-in-out;
                -o-transition: all 2s ease-in-out;
                transition: all 2s ease-in-out;
            }
            .opt-bar{
                padding: 10px;
                background-color:#4D595D;
                margin-top: 20px;
            }
        </style>
    </head>
    <body onload="init();">
        <div id="TopBanner"></div>
        <div id="Loading" class="popup_bg"></div>
        <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
        <form method="post" name="form" action="/applydb.cgi?p=speedtest_" target="hidden_frame">
            <input type="hidden" name="current_page" value="Module_speedtest.asp"/>
            <input type="hidden" name="next_page" value="Module_speedtest.asp"/>
            <input type="hidden" name="group_id" value=""/>
            <input type="hidden" name="modified" value="0"/>
            <input type="hidden" name="action_mode" value=""/>
            <input type="hidden" name="action_script" value=""/>
            <input type="hidden" name="action_wait" value="5"/>
            <input type="hidden" name="first_time" value=""/>
            <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
            <input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="speedtest_config.sh"/>
            <input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>

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
					                            <h2 class="plugin-header">
					                                <span class="text">Speedtest网络测速
					                                    <span class="version-info">(V<% dbus_get_def("speedtest_version", "0"); %>)</span>
					                                </span>
					                                <a class="return-button" href="/Main_Soft_center.asp">返回软件中心</a>
					                            </h2>
					                            <div class="speedtest-dashboard">
					                                <div class="dashboard-content">
					                                    <div class="graph">
					                                        <h4 class="desc">下载速度</h4>
					                                        <div class="background">
					                                            <div id="download_speed" class="speed">0.00</div>
					                                        </div>
					                                        <div id="indicator_download" class="indicator"></div>
					                                    </div>
					                                    <div class="graph">
					                                        <h4 class="desc">上传速度</h4>
					                                        <div class="background">
					                                            <div id="upload_speed" class="speed">0.00</div>
					                                        </div>
					                                        <div id="indicator_upload" class="indicator"></div>
					                                    </div>
					                                </div>
					                            </div>
					                            <div class="opt-bar">
					                                <center>
					                                    <button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">开始测速</button>
					                                </center>
					                            </div>
					                            <div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" ><i></i></div>
					                            <div class="KoolshareBottom">
					                                <br/>论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
					                                后台技术支持： <i>Xiaobao</i> <br/>
					                                Shell, Web by： <i>wangchll</i>, <i>acelan</i><br/>
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
        <script type="text/javascript">
            function init() {
                show_menu();
                var testStatus = <% dbus_get_def("speedtest_status", "0"); %>;
                if (+testStatus === 1) {
                    $("#cmdBtn").attr("disabled", true);
                    $("#cmdBtn").html("测速中...");
                    TestModule.polling(function () {
                        $("#cmdBtn").attr("disabled", false);
                        $("#cmdBtn").html("开始测速");
                    });
                } else {
                    TestModule.updateView('upload', <% dbus_get_def("speedtest_upload", "0"); %>);
                    TestModule.updateView('download', <% dbus_get_def("speedtest_download", "0"); %>);
                }
            }
            function update_visibility() {
                //不满足快鸟条件的显示异常信息
                if ($("#speedtest_can_upgrade").val() == "0") {
                    $("#warn").html($("#speedtest_warning").val());
                    showhide("warn", ($("#speedtest_can_upgrade").val() == "0"));
                }
                $("#warn").html($("#speedtest_warning").val());
                showhide("warn", ($("#speedtest_can_upgrade").val() == "0"));
                //给出快鸟运行状态
                $("#kn_state2").html($("#speedtest_run_warnning").val());
            }


            function version_show(){
                if (db_speedtest_['speedtest_version'] != db_speedtest_['speedtest_version_web'] && db_speedtest_['speedtest_version_web'] !== undefined){
                    $("#speedtest_version_status").html("<i>有新版本：" + db_speedtest_['speedtest_version_web']);
                } else {
                    if (db_speedtest_['speedtest_version'] == undefined) {
                        $("#speedtest_version_status").html("<i>当前版本：");
                    } else {
                        $("#speedtest_version_status").html("<i>当前版本：" + db_speedtest_['speedtest_version']);
                    }
                }
            }


            function reload_Soft_Center() {
                location.href = "/Main_Soft_center.asp";
            }

            /* 测速模块 */
            var TestModule = (function () {
                var timer;
                var freq = 2 * 1000;

                var STATUS = {
                    DONE: 0,
                    DOING: 1
                };

                /* 速度转换成弧度 */
                function speed2deg(speed) {
                    var deg = -123;
                    //表盘分区值，最后一个作为哨兵，防止超出最大表盘
                    var area = [1, 5, 10, 20, 30, 50, 75, 100, 999999];
                    if (speed) {
                        for (var i = 0, last, len = area.length; i < len; i++) {
                            if (speed < area[i]) {
                                last = area[i - 1] || 0;
                                deg = (speed - last) * 30 / (area[i] - last) - 120 + 30 * i;
                                break;
                            }
                        }
                    }
                    return Math.floor(deg > 123 ? 123 : deg);
                }
                /* 更新表盘 */
                function update(type, speed) {
                    speed = parseFloat(speed).toFixed(2);
                    var deg = speed2deg(+speed);
                    $('#indicator_' + type).css({
                        transform: 'rotate(' + deg + 'deg)'
                    });
                    $('#' + type + '_speed').html(speed);
                }

                /* 轮询返回的速度的方法 */
                function loopFn(oncomplete) {
                    $.ajax({
                        type: "get",
                        url: "dbconf",
                        data: {
                            p:"speedtest_"
                        },
                        dataType: "script"
                        })
                        .done(function () {
                            var speed = window.db_speedtest_;
                            if (speed) {
                                switch (+speed['speedtest_status']) {
                                    case STATUS.DONE:
                                        oncomplete();
                                        clearInterval(timer);
                                        timer = null;
                                    case STATUS.DOING:
                                        hideLoading();
                                        update('upload', speed['speedtest_upload']);
                                        update('download', speed['speedtest_download']);
                                        break;
                                    default:
                                        showLoading();
                                        break;
                                }
                            }
                        });
                }

                return {
                    polling: function (oncomplete) {
                        if (!timer) {
                            //一般第一次不可能就结束了，所以这里偷懒了，没有判断第一次是否成功才去做下面的操作
                            setTimeout(function () {
                                loopFn(oncomplete);
                            }, 1000);
                            timer = setInterval(function () {
                                loopFn(oncomplete);
                            }, freq);
                        }
                    },
                    updateView: update,
                    reset: function (download, upload) {
                        update('upload', upload || 0);
                        update('download', download || 0);
                    }
                };
            })();

            //开始测速
            function onSubmitCtrl(o, s) {
                document.form.action_mode.value = s;
                $("#updateBtn").attr("disabled", true);
                $("#updateBtn").hide();
                $("#cmdBtn").attr("disabled", true);
                $("#cmdBtn").html("测速中...");
                document.form.submit();
                TestModule.reset();
                TestModule.polling(function () {
                    $("#cmdBtn").attr("disabled", false);
                    $("#updateBtn").attr("disabled", false);
                    $("#updateBtn").show();
                    $("#cmdBtn").html("开始测速");
                });
            }


			function done_validating(action) {
				return true;
			}
        </script>
    </body>
</html>
