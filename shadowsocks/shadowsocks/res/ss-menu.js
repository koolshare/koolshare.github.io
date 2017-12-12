function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
var retArea = E('log_content1');
var autoTextarea = function(elem, extra, maxHeight) {
	extra = extra || 0;
	var isFirefox = !!document.getBoxObjectFor || 'mozInnerScreenX' in window,
		isOpera = !!window.opera && !!window.opera.toString().indexOf('Opera'),
		addEvent = function(type, callback) {
			elem.addEventListener ?
				elem.addEventListener(type, callback, false) :
				elem.attachEvent('on' + type, callback);
		},
		getStyle = elem.currentStyle ? function(name) {
			var val = elem.currentStyle[name];

			if (name === 'height' && val.search(/px/i) !== 1) {
				var rect = elem.getBoundingClientRect();
				return rect.bottom - rect.top -
					parseFloat(getStyle('paddingTop')) -
					parseFloat(getStyle('paddingBottom')) + 'px';
			};

			return val;
		} : function(name) {
			return getComputedStyle(elem, null)[name];
		},
		minHeight = parseFloat(getStyle('height'));

	elem.style.resize = 'none';

	var change = function() {
		var scrollTop, height,
			padding = 0,
			style = elem.style;

		if (elem._length === elem.value.length) return;
		elem._length = elem.value.length;

		if (!isFirefox && !isOpera) {
			padding = parseInt(getStyle('paddingTop')) + parseInt(getStyle('paddingBottom'));
		};
		scrollTop = document.body.scrollTop || document.documentElement.scrollTop;

		elem.style.height = minHeight + 'px';
		if (elem.scrollHeight > minHeight) {
			if (maxHeight && elem.scrollHeight > maxHeight) {
				height = maxHeight - padding;
				style.overflowY = 'auto';
			} else {
				height = elem.scrollHeight - padding;
				style.overflowY = 'hidden';
			};
			style.height = height + extra + 'px';
			scrollTop += parseInt(style.height) - elem.currHeight;
			document.body.scrollTop = scrollTop;
			document.documentElement.scrollTop = scrollTop;
			elem.currHeight = parseInt(style.height);
		};
	};
	addEvent('propertychange', change);
	addEvent('input', change);
	addEvent('focus', change);
	change();
};

function browser_compatibility1(){
	//fw versiom
	var _fw = "<% nvram_get("extendno"); %>";
	fw_version=parseFloat(_fw.split("X")[1]);
	// chrome
	var isChrome = navigator.userAgent.search("Chrome") > -1;
	if(isChrome){
		var major = navigator.userAgent.match("Chrome\/([0-9]*)\.");    //check for major version
		var isChrome56 = (parseInt(major[1], 10) >= 56);
	} else {
		var isChrome56 = false;
	}
	if((isChrome56) && document.getElementById("FormTitle") && fw_version < 7.5){
		document.getElementById("FormTitle").className = "FormTitle_chrome56";
	}else if((isChrome56) && document.getElementById("FormTitle") && fw_version >= 7.5){
		document.getElementById("FormTitle").className = "FormTitle";
	}
	//firefox
	var isFirefox = navigator.userAgent.search("Firefox") > -1;
	if((isFirefox) && document.getElementById("FormTitle") && fw_version < 7.5){
		document.getElementById("FormTitle").className = "FormTitle_firefox";
		if(current_url.indexOf("Main_Ss") == 0){
			document.getElementById("FormTitle").style.marginTop = "-100px"
		}

	}else if((isFirefox) && document.getElementById("FormTitle") && fw_version >= 7.5){
		document.getElementById("FormTitle").className = "FormTitle_firefox";
		if(current_url.indexOf("Main_Ss") == 0){
			document.getElementById("FormTitle").style.marginTop = "0px"	
			E("FormTitle").style.height = "975px";
		}
	}
}

function menu_hook() {
	browser_compatibility1();
	tabtitle[tabtitle.length - 1] = new Array("", "shadowsocks设置", "负载均衡设置", "Socks5设置");
	tablink[tablink.length - 1] = new Array("", "Main_Ss_Content.asp", "Main_Ss_LoadBlance.asp", "Main_SsLocal_Content.asp");
}

function done_validating(action) {
	return true;
}

var Base64;
if (typeof btoa == "Function") {
	Base64 = {
		encode: function(e) {
			return btoa(e);
		},
		decode: function(e) {
			return atob(e);
		}
	};
} else {
	Base64 = {
		_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
		encode: function(e) {
			var t = "";
			var n, r, i, s, o, u, a;
			var f = 0;
			e = Base64._utf8_encode(e);
			while (f < e.length) {
				n = e.charCodeAt(f++);
				r = e.charCodeAt(f++);
				i = e.charCodeAt(f++);
				s = n >> 2;
				o = (n & 3) << 4 | r >> 4;
				u = (r & 15) << 2 | i >> 6;
				a = i & 63;
				if (isNaN(r)) {
					u = a = 64
				} else if (isNaN(i)) {
					a = 64
				}
				t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
			}
			return t
		},
		decode: function(e) {
			var t = "";
			var n, r, i;
			var s, o, u, a;
			var f = 0;
			e = e.replace(/[^A-Za-z0-9\+\/\=]/g, "");
			while (f < e.length) {
				s = this._keyStr.indexOf(e.charAt(f++));
				o = this._keyStr.indexOf(e.charAt(f++));
				u = this._keyStr.indexOf(e.charAt(f++));
				a = this._keyStr.indexOf(e.charAt(f++));
				n = s << 2 | o >> 4;
				r = (o & 15) << 4 | u >> 2;
				i = (u & 3) << 6 | a;
				t = t + String.fromCharCode(n);
				if (u != 64) {
					t = t + String.fromCharCode(r)
				}
				if (a != 64) {
					t = t + String.fromCharCode(i)
				}
			}
			t = Base64._utf8_decode(t);
			return t
		},
		_utf8_encode: function(e) {
			e = e.replace(/\r\n/g, "\n");
			var t = "";
			for (var n = 0; n < e.length; n++) {
				var r = e.charCodeAt(n);
				if (r < 128) {
					t += String.fromCharCode(r)
				} else if (r > 127 && r < 2048) {
					t += String.fromCharCode(r >> 6 | 192);
					t += String.fromCharCode(r & 63 | 128)
				} else {
					t += String.fromCharCode(r >> 12 | 224);
					t += String.fromCharCode(r >> 6 & 63 | 128);
					t += String.fromCharCode(r & 63 | 128)
				}
			}
			return t
		},
		_utf8_decode: function(e) {
			var t = "";
			var n = 0;
			var r = c1 = c2 = 0;
			while (n < e.length) {
				r = e.charCodeAt(n);
				if (r < 128) {
					t += String.fromCharCode(r);
					n++
				} else if (r > 191 && r < 224) {
					c2 = e.charCodeAt(n + 1);
					t += String.fromCharCode((r & 31) << 6 | c2 & 63);
					n += 2
				} else {
					c2 = e.charCodeAt(n + 1);
					c3 = e.charCodeAt(n + 2);
					t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
					n += 3
				}
			}
			return t
		}
	}
}

String.prototype.replaceAll = function(s1, s2) {　　
	return this.replace(new RegExp(s1, "gm"), s2);
}

function showSSLoadingBar(seconds) {
	if (window.scrollTo)
		window.scrollTo(0, 0);

	disableCheckChangedStatus();

	htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

	winW_H();

	var blockmarginTop;
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;

	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;

	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if (winWidth > 1050) {

		winPadding = (winWidth - 1050) / 2;
		winWidth = 1105;
		blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
	} else if (winWidth <= 1050) {
		blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;

	}

	if (winHeight > 660)
		winHeight = 660;

	blockmarginTop = winHeight * 0.3 - 140

	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop + "px";
	document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
	document.getElementById("loadingBarBlock").style.width = 770 + "px";
	document.getElementById("LoadingBar").style.width = winW + "px";
	document.getElementById("LoadingBar").style.height = winH + "px";

	loadingSeconds = seconds;
	progress = 100 / loadingSeconds;
	y = 0;
	LoadingSSProgress(seconds);
}

function LoadingSSProgress(seconds) {
	action = db_ss["ss_basic_action"];
	document.getElementById("LoadingBar").style.visibility = "visible";
	if (action == 0) {
		document.getElementById("loading_block3").innerHTML = "科学上网功能关闭中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'><a href='https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui/shadowsocks' target='_blank'></font>SS工作有问题？请到github提交issue...</font></li>");
	} else if (action == 1) {
		document.getElementById("loading_block3").innerHTML = "gfwlist模式启用中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>尝试不同的DNS解析方案，可以达到最佳的效果哦...</font></li><li><font color='#ffcc00'>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>");
	} else if (action == 2) {
		document.getElementById("loading_block3").innerHTML = "大陆白名单模式启用中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>");
	} else if (action == 3) {
		document.getElementById("loading_block3").innerHTML = "游戏模式启用中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>为确保游戏工作，请确保你的SS账号支持UDP转发...</font></li><font color='#ffcc00'><li>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>");
	} else if (action == 5) {
		document.getElementById("loading_block3").innerHTML = "全局模式启用中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>此模式非科学上网方式，会影响国内网页速度...</font></li><li><font color='#ffcc00'>注意：全局模式并非VPN，只支持TCP流量转发...</font></li><li><font color='#ffcc00'>请等待日志显示完毕，并出现自动关闭按钮！</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>");
	} else if (action == 6) {
		document.getElementById("loading_block3").innerHTML = "回国启用中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>在此期间请不要刷新本页面，不然可能导致问题！</font></li>");
	} else if (action == 7) {
		document.getElementById("loading_block3").innerHTML = "科学上网插件升级 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，等待脚本运行完毕后再刷新！</font></li><li><font color='#ffcc00'>升级服务会自动检测最新版本并下载升级...</font></li>");
	} else if (action == 8) {
		document.getElementById("loading_block3").innerHTML = "科学上网规则更新 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，等待脚本运行完毕后再刷新！</font></li><li><font color='#ffcc00'>正在自动检测github上的更新...</font></li>");
	} else if (action == 9) {
		document.getElementById("loading_block3").innerHTML = "恢复科学上网配置 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，配置恢复后需要重新提交！</font></li><li><font color='#ffcc00'>恢复配置中...</font></li>");
	} else if (action == 10) {
		document.getElementById("loading_block3").innerHTML = "清空科学上网配置 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，正在清空科学上网配置...</font></li>");
	} else if (action == 11) {
		document.getElementById("loading_block3").innerHTML = "插件打包中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>打包时间较长，请稍等...</font></li><li><font color='#ffcc00'>打包的插件可以用于离线安装...</font></li>");
	} else if (action == 12) {
		document.getElementById("loading_block3").innerHTML = "应用负载均衡设置 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，应用负载均衡设置 ...</font></li>");
	} else if (action == 13) {
		document.getElementById("loading_block3").innerHTML = "SSR节点订阅 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，正在订阅中 ...</font></li>");
	} else if (action == 14) {
		document.getElementById("loading_block3").innerHTML = "socks5代理设置 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'>请勿刷新本页面，应用中 ...</font></li>");
	}
}

function hideSSLoadingBar() {
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	checkss = 0;
	refreshpage();
}

function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";

	if (itemNum == 10) {
		statusmenu = "如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
		_caption = "服务器说明";
	}
	if (itemNum == 0) {
		width = "750px";
		bgcolor = "#CC0066",
			statusmenu = "<li>通过对路由器内ss访问(<a href='https://www.google.com.tw/' target='_blank'><u><font color='#00F'>https://www.google.com.tw/</font></u></a>)状态的检测，返回状态信息。状态检测默认每10秒进行一次，可以通过附加设置中的选项，更改检测时间间隔，每次检测都会请求<a href='https://www.google.com.tw/' target='_blank'><u><font color='#00F'>https://www.google.com.tw/</font></u></a>，该请求不会进行下载，仅仅请求HTTP头部，请求成功后，会返回working信息，请求失败，会返回Problem detected!</li>"
		statusmenu += "</br><li>状态检测只在SS主界面打开时进行，网页关闭后，后台是不会进行检测的，每次进入页面，或者切换模式，重新提交等操作，状态检测会在此后5秒后进行，在这之前，状态会显示为watting... 如果显示Waiting for first refresh...则表示正在等待首次状态检测的结果。</li>"
		statusmenu += "</br><li>状态检测反应的是路由器本身访问https://www.google.com.tw/的结果，并不代表电脑或路由器下其它终端的访问结果，透过状态检测，可以为使用SS代理中遇到的一些问题进行排查,一下列举一些常见的情况：</li>"
		statusmenu += "</br><b><font color='#CC0066'>1：双working，不能访问被墙网站：</font></b>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>1.1：DNS缓存：</font>可能你在未开启ss的时候访问过被墙域名，DNS缓存受到了污染，只需要简单的刷新下缓存，window电脑通过在CMD中运行命令：<font color='#669900'>ipconfig /flushdns</font>刷新电脑DNS缓存，手机端可以通过尝试开启飞行模式后关闭飞行模式刷新DNS缓存。"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>1.2：自定义DNS：</font>很多用户喜欢自己在电脑上定义DNS来使用，这样访问google等被墙网站，解析出来的域名基本都是污染的，因此建议将DNS解析改为自动获取。如果你的路由器很多人使用，你不能阻止别人自定义DNS，那么建议开启chromecast功能，路由器会将所有自定义的DNS劫持到自己的DNS服务器上，避免DNS污染。"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>1.3：host：</font>电脑端以前设置过host翻墙，host翻墙失效快，DNS解析将通过host完成，不过路由器，如果host失效，使用chnroute翻墙的模式将无法使用；即使未失效，在gfwlist模式下，域名解析通过电脑host完成，而无法进入ipset，同样使得翻墙无法使用，因此强烈建议清除相关host！"
		statusmenu += "</br><b><font color='#CC0066'>2：国内working，国外Problem detected!：</font></b>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.1：检查你的SS账号：</font>在电脑端用SS客户端检查是否正常；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.2：是否使用了域名：</font>一些SS服务商提供的域名，特别是较为复杂的域名，可能有解析不了的问题，可尝试更换为IP地址；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.3：是否使用了含有特殊字符的密码：</font>极少数情况下，电脑端账号使用正常，路由端却Problem detected!是因为使用了包含特殊字符的密码；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.4：尝试更换国外dns：</font>此部分详细解析，请看DNS部分帮助文档；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.5：更换shadowsocks主程序：</font>meirlin ss一直使用最新的shadowsocks-libev和shadowsocksR-libev代码编译主程序，如果某次更新后出现这种情况，在检查了以上均无问题后，可能出现的问题就是路由器内的ss主程序和服务器端的不匹配，此时你可以通过下载历史安装包，将旧的主程序替换掉新的，主程序位于路由器下的/koolshare/bin目录，shadowsocks-libev：ss-redir,ss-local,ss-tunnel；shadowsocksR-libev：rss-redir,rss-local,rss-tunnel；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.6：更新服务器端：</font>如果你不希望更换路由器端主程序，可以更新最新服务器端来尝试解决问题，另外建议使用原版SS的朋友,在服务器端部署和路由器端相同版本的shadowsocks-libev；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>2.7：ntp时间问题：</font>如果你使用SSR，一些混淆协议是需要验证ss服务器和路由器的时间的，如果时间相差太多，那么就会出现Problem detected! 。"
		statusmenu += "</br><b><font color='#CC0066'>3：双Problem detected!：</font></b>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>3.1：更换国内DNS：</font>在电脑端用SS客户端检查是否正常；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>3.2：逐项检查第2点中每个项目。</font>"
		statusmenu += "</br><b><font color='#CC0066'>4：国内Problem detected!，国外working：</font></b>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>4.1：尝试更换国内DNS。</font>"
		statusmenu += "</br><b><font color='#CC0066'>5：国外间歇性Problem detected!：</font></b>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>5.1：检查你的SS服务器ping和丢包：</font>一些线路可能在高峰期或者线路调整期，导致丢包过多，获取状态失败；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<font color='#00F'>5.2：升级新版本后出现这种情况：</font>merlin ss插件从2015年6月，其核心部分就基本无改动，升级新版本出现这种情况，最大可能的原因，新版本升级了最新的ss或者ssr的主程序，解决方法可以通过回滚路由器内程序，也可以升级你的服务器端到最新，如果你是自己搭建的用户,建议最新原版shadowsocks-libev程序。"
		statusmenu += "</br><b><font color='#CC0066'>6：你遇到了非常少见的情况：</font></b>来这里反馈吧：<a href='https://telegram.me/joinchat/DCq55kC7pgWKX9J4cJ4dJw' target='_blank'><u><font color='#00F'>telegram</font></u></a>。"
		_caption = "状态检测";
		return overlib(statusmenu, OFFSETX, -460, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	}
	if (itemNum == 1) {
		width = "700px";
		bgcolor = "#CC0066",
		//gfwlist
		statusmenu = "<span><b><font color='#CC0066'>【1】gfwlist模式:</font></b></br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;该模式使用gfwlist区分流量，Shadowsocks会将所有访问gfwlist内域名的TCP链接转发到Shadowsocks服务器，实现透明代理；</br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;和真正的gfwlist模式相比较，路由器内的gfwlist模式还是有一定缺点，因为它没法做到像gfwlist PAC文件一样，对某些域名的二级域名有例外规则。</br>"
		statusmenu += "<b><font color='#669900'>优点：</font></b>节省SS流量，可防止迅雷和PT流量。</br>"
		statusmenu += "<b><font color='#669900'>缺点：</font></b>代理受限于名单内的4000多个被墙网站，需要维护黑名单。一些不走域名解析的应用，比如telegram，需要单独添加IP/CIDR黑名单。</span></br></br>"
		//redchn
		statusmenu += "<span><b><font color='#CC0066'>【2】大陆白名单模式:</font></b></br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;该模式使用chnroute IP网段区分国内外流量，ss-redir将流量转发到Shadowsocks服务器，实现透明代理；</br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;由于采用了预先定义的ip地址块(chnroute)，所以DNS解析就非常重要，如果一个国内有的网站被解析到了国外地址，那么这个国内网站是会走ss的；</br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;因为使用了大量的cdn名单，能够保证常用的国内网站都获得国内的解析结果，但是即使如此还是不能完全保证国内的一些网站解析到国内地址，这个时候就推荐使用具备cdn解析能力的cdns或者chinadns2。</br>"
		statusmenu += "<b><font color='#669900'>优点：</font></b>所有被墙国外网站均能通过代理访问，无需维护域名黑名单；主机玩家用此模式可以实现TCP代理UDP国内直连。</br>"
		statusmenu += "<b><font color='#669900'>缺点：</font></b>消耗更多的Shadowsocks流量，迅雷下载和BT可能消耗SS流量。</span></br></br>"
		//game
		statusmenu += "<span><b><font color='#CC0066'>【3】游戏模式:</font></b></br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;游戏模式较于其它模式最大的特点就是支持UDP代理，能让游戏的UDP链接走SS，主机玩家用此模式可以实现TCP+UDP走SS代理；</br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;由于采用了预先定义的ip地址块(chnroute)，所以DNS解析就非常重要，如果一个国内有的网站被解析到了国外地址，那么这个国内网站是会走ss的。</br>"
		statusmenu += "<b><font color='#669900'>优点：</font></b>除了具有大陆白名单模式的优点外，还能代理UDP链接，并且实现主机游戏<b> NAT2!</b></br>"
		statusmenu += "<b><font color='#669900'>缺点：</font></b>由于UDP链接也走SS，而迅雷等BT下载多为UDP链接，如果下载资源的P2P链接中有国外链接，这部分流量就会走SS！</span></br></br>"
		//overall
		statusmenu += "<span><b><font color='#CC0066'>【4】全局模式:</font></b></br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;除局域网和ss服务器等流量不走代理，其它都走代理(udp不走)，高级设置中提供了对代理协议的选择。</br>"
		statusmenu += "<b><font color='#669900'>优点：</font></b>简单暴力，全部出国；可选仅web浏览走ss，还是全部tcp代理走ss，因为不需要区分国内外流量，因此性能最好。</br>"
		statusmenu += "<b><font color='#669900'>缺点：</font></b>国内网站全部走ss，迅雷下载和BT全部走SS流量。</span></br></br>"
		//overall
		statusmenu += "<span><b><font color='#CC0066'>【5】回国模式:</font></b></br>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;提供给国外的朋友，通过在中间服务器翻回来，以享受一些视频、音乐等网络服务。</br>"
		statusmenu += "<b><font color='#669900'>优点：</font></b>建议设置cdns或者chinadns2作为dns解析方案~</br>"
		_caption = "模式说明";
		return overlib(statusmenu, OFFSETX, -860, OFFSETY, -290, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	} else if (itemNum == 2) {
		statusmenu = "此处填入你的SS服务器的地址。</br>建议优先填入<font color='#F46'>IP地址</font>。填入域名，特别是一些服务商给的复杂域名，有时遇到无法解析会导致Problem detected!";
		_caption = "服务器";
	} else if (itemNum == 3) {
		statusmenu = "此处填入你的SS服务器的端口";
		_caption = "服务器端口";
	} else if (itemNum == 4) {
		statusmenu = "此处填入你的SS服务器的密码。</br><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致SS链接不上服务器。";
		_caption = "服务器密码";
	} else if (itemNum == 5) {
		statusmenu = "此处填入你的SS服务器的加密方式。</br><font color='#F46'>建议</font>如果是自己搭建服务器，建议使用对路由器负担比较小的加密方式，例如chacha20,chacha20-ietf等。";
		_caption = "服务器加密方式";
	} else if (itemNum == 6) {
		statusmenu = "此处选择你希望UDP的通道。</br>很多游戏都走udp的初衷就是加速udp连接。</br>如果你到vps的udp链接较快，可以选择udp in udp，如果你的运营商封锁了udp，可以选择udp in tcp。";
		_caption = "游戏模式V2 UDP通道";
	} else if (itemNum == 8) {
		statusmenu = "更多信息，请参考<a href='https://github.com/koolshare/shadowsocks-rss/blob/master/ssr.md' target='_blank'><u><font color='#00F'>ShadowsocksR 协议插件文档</font></u></a>"
		_caption = "协议插件（protocol）";
	} else if (itemNum == 9) {
		statusmenu = "更多信息，请参考<a href='https://github.com/koolshare/shadowsocks-rss/blob/master/ssr.md' target='_blank'><u><font color='#00F'>ShadowsocksR 协议插件文档</font></u></a>"
		_caption = "混淆插件 (obfs)";

	} else if (itemNum == 11) {
		statusmenu = "如果不知道如何填写，请一定留空，不然可能带来副作用！"
		statusmenu += "</br></br>请参考<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(8)'><font color='#00F'>协议插件（protocol）</font></a>和<a class='hintstyle' href='javascript:void(0);' onclick='openssHint(9)'><font color='#00F'>混淆插件 (obfs)</font></a>内说明。"
		statusmenu += "</br></br>更多信息，请参考<a href='https://github.com/koolshare/shadowsocks-rss/blob/master/ssr.md' target='_blank'><u><font color='#00F'>ShadowsocksR 协议插件文档</font></u></a>"
		_caption = "自定义参数 (obfs_param)";
		//return overlib(statusmenu, OFFSETX, -860, OFFSETY, -290, LEFT, STICKY, WIDTH, 'width', CAPTION, " ", CLOSETITLE, '');
	} else if (itemNum == 12) {
		width = "500px";
		statusmenu = "此处显示你的SS插件当前的版本号，当前版本：<% dbus_get_def("
		ss_basic_version_local ", "
		未知 "); %>,如果需要回滚SS版本，请参考以下操作步骤：";
		statusmenu += "</br></br><font color='#CC0066'>1&nbsp;&nbsp;</font>进入<a href='Tools_Shell.asp' target='_blank'><u><font color='#00F'>webshell</font></u></a>或者其他telnet,ssh等能输入命令的工具";
		statusmenu += "</br><font color='#CC0066'>2&nbsp;&nbsp;</font>请依次输入以下命令，等待上一条命令执行完后再运行下一条(这里以回滚3.6.4为例)：";
		statusmenu += "</br></br>&nbsp;&nbsp;&nbsp;&nbsp;cd /tmp";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;wget --no-check-certificate https://raw.githubusercontent.com/koolshare/koolshare.github.io/acelan_softcenter_ui/shadowsocks/history/shadowsocks_3.6.4.tar.gz";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;tar -zxvf /tmp/shadowsocks.tar.gz";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;chmod +x /tmp/shadowsocks/install.sh";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;sh /tmp/shadowsocks/install.sh";
		statusmenu += "</br></br>最后一条命令输入完后不会有任何打印信息。";
		statusmenu += "</br>回滚其它版本号，请参考<a href='https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui/shadowsocks/history' target='_blank'><u><font color='#00F'>版本历史列表</font></u></a>";
		_caption = "shadowsocks for merlin 版本";
	} else if (itemNum == 13) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;SSR表示shadowwocksR-libev，相比较原版shadowwocksR-libev，其提供了强大的协议混淆插件，让你避开gfw的侦测。"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;虽然你在节点编辑界面能够指定使用SS的类型，不过这里还是提供了勾选使用SSR的选项，是为了方便一些服务器端是兼容原版协议的用户，快速切换SS账号类型而设定。";
		_caption = "使用SSR";
	} else if (itemNum == 15) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;点击右侧的铅笔图标，进入节点界面，在节点界面，你可以进行节点的添加，修改，删除，应用，检查节点ping，和web访问性等操作。"
		_caption = "选择节点";
	} else if (itemNum == 16) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;此处不同模式会显示不同的图标，如果你是从2.0以前的老版本升级过来的，可能有些节点不会显示图标，只需要编辑一下节点，选择好模式，然后保存即可显示。"
		_caption = "模式";
	} else if (itemNum == 17) {
		statusmenu = "节点名称支持中文，支持空格。"
		_caption = "节点名称";
	} else if (itemNum == 18) {
		statusmenu = "优先建议使用ip地址"
		_caption = "服务器地址";
	} else if (itemNum == 19) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;ping/丢包功能用于检测你的路由器到ss服务器的ping值和丢包；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;比如一些游戏线路对ping值和丢包有要求，可以选择ping值较低，丢包较少的节点；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;一些奇葩的运营商可能会禁ping，一些SS服务器也会禁止ping，此处检测就会failed，所以遇到这种情况不必惊恐。"
		_caption = "ping/丢包";
	} else if (itemNum == 20) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;延迟是你访问所测试网站，请求完整个网站所花的时间，间接的反应了你的ss的速度；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;目前游戏模式V2节点暂时不支持延迟测试。"
		_caption = "延迟";
	} else if (itemNum == 21) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;编辑节点功能能帮助你快速的更改ss某个节点的设置，比如服务商更换IP地址之后，可以快速更改；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;编辑节点目前只支持相同类型节点的编辑，比如不能将ss节点编辑为ssr节点，如果你的ssr节点是兼容原版协议的，建议你在主面板用使用ssr勾选框来进行更改。"
		_caption = "编辑节点";
	} else if (itemNum == 22) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;删除节点功能能快速的删除某个特定的节点，为了方便快速删除，删除节点点击后生效，不会有是否确认弹出。"
		_caption = "编辑节点";
	} else if (itemNum == 23) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;点击使用节点能快速的将该节点填入主面板，但是你需要在主面板点击提交，才能使用该节点。</br>不同的颜色代表了不同的节点类型，SS：蓝色；SSR；粉色，V2：绿色"
		_caption = "使用节点";
	} else if (itemNum == 24) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;导出功能可以将ss所有的设置全部导出，包括节点信息，dns设定，黑白名单设定等；"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;恢复配置功能可以使用之前导出的文件，也可以使用标准的json格式节点文件。"
		_caption = "导出恢复";
	} else if (itemNum == 25) {
		statusmenu = "<font color='#CC0066'>1&nbsp;&nbsp;在gfwlist模式下：</font>";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;此处定义的国内DNS仅在dns2socks和ss-tunnel下有效，chinadns1和chinadns2因为自带了国内外cdn，所以不需要。"
		_caption = "国内DNS";
	} else if (itemNum == 26) {
		width = "750px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;国外DNS为大家提供了丰富的选择，其目的有二，一是为了保证大家有能用的国外DNS服务；二是在有能用的基础上，能够选择多种DNS解析方案，达到最佳的解析效果；所以如果你切换某个DNS程序，导致国外连接Problem detected! 那么更换能用的就好，不用纠结某个解析方案不能用。"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;</br></br>各DNS方案做简单介绍："
		//dns2socks
		statusmenu += "</br><font color='#CC0066'><b>1:dns2socks(推荐等级 ★★★☆☆)：</b></font>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;万金油方案，DNS请求通过一个socks5隧道转发到DNS服务器，和下文中ss-tunnel类似，不过dns2socks是利用了SOCK5隧道代理，ss-tunnel是利用了加密UDP；该DNS方案不受到ss服务是否支持udp限制，只要能建立socoks5链接，就能使用；";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<b>国外解析通过SS服务器转发，国内cdn由cdn.txt提供，对cpu负担较大，国外cdn很好。</b>";
		//ss-tunnel
		statusmenu += "</br><font color='#CC0066'><b>2:ss-tunnel(推荐等级 ★★★☆☆)：</b></font>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;原理是将DNS请求，通过ss-tunnel利用UDP发送到ss服务器上，由ss服务器向你定义的DNS服务器发送解析请求，解析出到正确的IP地址，的解析效果和dns2socks应该是一模一样的。"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<b>国外解析通过SS服务器转发，国内cdn由cdn.txt提供，对cpu负担较大，国外cdn很好。</b>";
		_caption = "国外DNS";
		//cdns
		statusmenu += "</br><font color='#CC0066'><b>3:cdns(推荐等级 ★★☆☆☆)：</b></font>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;和chinadns2一样，支持ednsDNS请求时将携带一个EDNS标签，解析成功后返回带该标签的解析结果，gfw投毒的解析结果则不会带该标签，以达到防dns污染的目的！";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<b>国外解析本地直链国外DNS服务器，国内cdn由cdn.txt提供，对cpu负担较大，国外cdn较弱。</b>";
		//chinadns1
		statusmenu += "</br><font color='#CC0066'><b>4:chinadns1(推荐等级 ★★★★★)：</b></font>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;使用dns2socks作为chinadns上游dns解析工具获取无污染dns，通过chinadns的国内dns请求国内dns获取国内解析结果";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<b>国外解析通过SS服务器转发，具有很好的国内cdn，和很好的国外cdn，不需要cdn.txt作为国内加速，对cpu负担小。</b>";
		//chinadns2
		statusmenu += "</br><font color='#CC0066'><b>5:chinadns2(推荐等级 ★★★★☆)：</b></font>"
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;和cdns一样，支持EDNS，并且chinadns2根据本地公网ip和ss服务器ip，同时发送两个带edns标签的请求，dns服务器会根据此信息选择离你最近的解析结果返回给你，因此具有非常好的cdn效果！";
		statusmenu += "</br>&nbsp;&nbsp;&nbsp;&nbsp;<b>国外解析本地直链国外DNS服务器，具有较好的国内cdn，和很好的国外cdn，不需要cdn.txt作为国内加速，对cpu负担小。</b>";

		return overlib(statusmenu, OFFSETX, -860, OFFSETY, -290, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	} else if (itemNum == 33) {
		statusmenu = "填入需要强制用国内DNS解析的域名，一行一个，格式如下：。"
		statusmenu += "</br>注意：不支持通配符！"
		statusmenu += "</br></br>koolshare.cn"
		statusmenu += "</br>baidu.com"
		statusmenu += "</br></br>需要注意的是，这里要填写的一定是网站的一级域名，比如taobao.com才是正确的，www.taobao.com，http://www.taobao.com/这些格式都是错误的！"
		_caption = "自定义需要CDN加速网站";
	} else if (itemNum == 34) {
		statusmenu = "填入自定义的dnsmasq设置，一行一个，格式如下：。"
		statusmenu += "</br></br>#例如hosts设置："
		statusmenu += "</br>address=/koolshare.cn/2.2.2.2"
		statusmenu += "</br></br>#防DNS劫持设置"
		statusmenu += "</br>bogus-nxdomain=220.250.64.18"
		statusmenu += "</br></br>#指定config设置"
		statusmenu += "</br>conf-file=/jffs/mydnsmasq.conf"
		statusmenu += "</br></br>如果填入了错误的格式，可能导致dnsmasq启动失败！"
		statusmenu += "</br></br>如果填入的信息里带有英文逗号的，也会导致dnsmasq启动失败！"
		_caption = "自定义dnsamsq";
	} else if (itemNum == 38) {
		statusmenu = "填入不需要走代理的外网ip/cidr地址，一行一个，格式如下：。"
		statusmenu += "</br></br>2.2.2.2"
		statusmenu += "</br>3.3.3.3"
		statusmenu += "</br>4.4.4.4/24"
		_caption = "IP/CIDR白名单";
	} else if (itemNum == 39) {
		statusmenu = "填入不需要走代理的域名，一行一个，格式如下：。"
		statusmenu += "</br></br>google.com"
		statusmenu += "</br>facebook.com"
		statusmenu += "</br></br>需要注意的是，这里要填写的一定是网站的一级域名，比如google.com才是正确的，www.google.com，https://www.google.com/这些格式都是错误的！"
		statusmenu += "</br></br>需要清空电脑DNS缓存，才能立即看到效果"
		_caption = "域名白名单";
	} else if (itemNum == 40) {
		statusmenu = "填入需要强制走代理的外网ip/cidr地址，，一行一个，格式如下：。"
		statusmenu += "</br></br>5.5.5.5"
		statusmenu += "</br>6.6.6.6"
		statusmenu += "</br>7.7.7.7/8"
		_caption = "IP/CIDR黑名单";
	} else if (itemNum == 41) {
		statusmenu = "填入需要强制走代理的域名，，一行一个，格式如下：。"
		statusmenu += "</br></br>baidu.com"
		statusmenu += "</br>taobao.com"
		statusmenu += "</br></br>需要注意的是，这里要填写的一定是网站的一级域名，比如google.com才是正确的，www.baidu.com，http://www.baidu.com/这些格式都是错误的！"
		statusmenu += "</br></br>需要清空电脑DNS缓存，才能立即看到效果。"
		_caption = "IP/CIDR黑名单";
	} else if (itemNum == 42) {
		statusmenu = "此处定义ss状态检测更新时间间隔，默认5秒。"
		_caption = "状态更新间隔";
	} else if (itemNum == 44) {
		statusmenu = "shadowsocks规则更新包括了gfwlist模式中用到的<a href='https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf' target='_blank'><font color='#00F'><u>gfwlist</u></font></a>，在大陆白名单模式和游戏模式中用到的<a href='https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/chnroute.txt' target='_blank'><u><font color='#00F'>chnroute</font></u></a>和<a href='https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt' target='_blank'><u><font color='#00F'>国内cdn名单</font></u></a>"
		statusmenu += "</br>建议更新时间在凌晨闲时进行，以避免更新时重启ss服务器造成网络访问问题。"
		_caption = "shadowsocks规则自动更新";
	} else if (itemNum == 45) {
		statusmenu = "通过局域网客户端控制功能，你能定义在当前模式下某个局域网地址是否走SS。"
		_caption = "局域网客户端控制";
	} else if (itemNum == 46) {
		statusmenu = "一些用户的网络拨号可能比较滞后，为了保证SS在路由器开机后能正常启动，可以通过此功能，为ss的启动增加开机延迟。"
		_caption = "开机启动延迟";
	} else if (itemNum == 50) {
		statusmenu = "通过此开关，你可以开启或者关闭侧边栏面板上的shadowsocks入口;"
		statusmenu += "</br>该开关在固件版本6.6.1（不包括6.6.1）以上起作用。"
		_caption = "侧边栏开关";
	} else if (itemNum == 52) {
		statusmenu = "KCP协议，ss-libev混淆，负载均衡下均不支持UDP！"
		statusmenu += "</br>请检查你是否启用了其中之一。"
		_caption = "侧边栏开关";
	} else if (itemNum == 54) {
		statusmenu = "更多信息，请参考<a href='https://breakwa11.blogspot.jp/2017/01/shadowsocksr-mu.html' target='_blank'><u><font color='#00F'>ShadowsocksR 协议参数文档</font></u></a>"
		_caption = "协议参数（protocol）";
	} else if (itemNum == 90) {
		statusmenu = "此处设定为预设不可更改。<br />&nbsp;&nbsp;&nbsp;&nbsp;1. 单开KCPTUN的情况下，ss-redir的TCP流量都会转发到此；<br />&nbsp;&nbsp;&nbsp;&nbsp;2. KCPTUN和UDP2raw串联的模式下，ss-redir的TCP流量才会转发到UDP2raw；"
		_caption = "说明：";
	} else if (itemNum == 91) {
		width = "600px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1. <b>单独加速：</b>此处配置为服务器ip+服务器端口(或者留空+服务器端口)，KCPTUN的UDP流量会转发给服务器；<br />&nbsp;&nbsp;&nbsp;&nbsp;2.  <b>串联1：</b>此处配置为127.0.0.1:1092（即UDPspeeder监听端口）时，可配置kcptun和UDPspeeder串联，KCPTUN的UDP流量会转发给UDPspeeder，然后转为tcp，并转发给服务器的UDP2raw。同时你需要在服务器端配置KCPTUN和UDP2raw的串联。<br />&nbsp;&nbsp;&nbsp;&nbsp;2.  <b>串联3：</b>此处配置为127.0.0.1:1093（即UDP2raw监听端口）时，可配置kcptun和udp2raw串联，KCPTUN的UDP流量会转发给UDP2raw，然后转为tcp，并转发给服务器的UDP2raw。同时你需要在服务器端配置KCPTUN和UDP2raw的串联。"
		_caption = "说明：";
	} else if (itemNum == 97) {
		width = "600px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;UDPspeeder(V1/V2)针对udp传输进行优化，能加速udp，降低udp的丢包，特别适合游戏。<br />&nbsp;&nbsp;&nbsp;&nbsp;UDP2raw可以将udp协议转为tcp，这对一些对udp有限制或者qos的情况特别好用，UDP2raw不是一个udp加速工具，如果需要udp加速，还需要配合UDPspeeder(V1/V2)串联使用。<br />&nbsp;&nbsp;&nbsp;&nbsp;正确开启的姿势是需要在服务器端配置UDPspeeder(V1/V2)/UDP2raw的服务器端程序，然后在路由器下，需要以下条件才能正常开启：<b><br />1. 当前正在使用游戏模式或者访问控制主机中有游戏模式主机；<br />2. 此处加速的节点和正在使用的节点一致；<br />3. 正确配置并开启UDPspeeder(V1/V2)或UDP2raw，或者两者都开启（串联模式）。</b>	 "
		_caption = "说明：";
	} else if (itemNum == 98) {
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;此处设定的MTU值将用于ss-redir/ssr-redir。<br />&nbsp;&nbsp;&nbsp;&nbsp;因为UDPspeeder(V1/V2)和UDP2raw对上游软件的MTU有要求，此处方便高级用户对其进行设定，以达到更好的UDP加速效果。不知道如何设定的请选择不设定，以免造成不必要的问题<br />&nbsp;&nbsp;&nbsp;&nbsp;此处的设定只有在UDPspeeder(V1/V2)/UDP2raw开启或者两者都开启的情况下才会生效。"
		_caption = "说明：";
	} else if (itemNum == 99) {
		statusmenu = "此处设定为预设不可更改。<br />&nbsp;&nbsp;&nbsp;&nbsp;1. 单开UDPspeeder(V1/V2)模式或者UDPspeeder(V1/V2)和UDP2raw双开（串联模式下），ss-redir的UDP流量都会转发到此；<br />&nbsp;&nbsp;&nbsp;&nbsp;2. 只有UDPepeeder未开启且UDP2raw开启的情况下，ss-redir的UDP流量才会转发到UDP2raw；"
		_caption = "说明：";
	} else if (itemNum == 100) {
		width = "600px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1.单开UDPspeeder(V1/V2)模式下，ss-redir的udp流量经过UDPspeeder(V1/V2)加速后的UDP流量会转发到服务器，此处应按填写服务器的ip和服务器端UDPspeeder(V1/V2)的监听端口；<br />&nbsp;&nbsp;&nbsp;&nbsp;2.UDPspeeder(V1/V2)和UDP2raw双开（串联模式下），ss-redir的udp流量经过UDPspeeder(V1/V2)加速后的UDP流量会先转发给本地的UDP2raw程序，然后由UDP2raw和服务器的UDP2raw之间利用TCP（faketcp模式）协议进行通讯，然后服务器的UDP2raw收到TCP（faketcp模式）后还原为UDPspeeder(V1/V2)加速后的流量转发给服务器的UDPspeeder(V1/V2)，然后服务器的UDPspeeder(V1/V2)将此流量继续还原为ss-redir的UDP流量，转发给服务器的ss服务器程序。 所以路由器下UDPspeeder(V1/V2)和UDP2raw的串联也需要服务器端UDPspeeder(V1/V2)和UDP2raw的串联。"
		_caption = "说明：";
	} else if (itemNum == 101) {
		width = "600px";
		statusmenu = "此处设定为预设不可更改。<br />&nbsp;&nbsp;&nbsp;&nbsp;1.单开UDP2raw模式下，ss-redir的UDP流量会转发到此；<br />&nbsp;&nbsp;&nbsp;&nbsp;2.UDPspeeder(V1/V2)和UDP2raw双开（串联模式下），ss-redir的UDP流量会转发到UDPspeeder(V1/V2)，经过UDPspeeder(V1/V2)加速后的udp流量流量会转发到此（即转发到UDP2raw），形成UDPspeeder(V1/V2)和UDP2raw的串联。"
		_caption = "说明";
	} else if (itemNum == 102) {
		width = "600px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1.单开udp2raw模式下，ss-redir的udp流量经过udp2raw转换为tcp后的流量会转发此处设置的到服务器端口，此处应按填写服务器的ip和服务器端UDPspeeder(V1/V2)的监听端口；<br />&nbsp;&nbsp;&nbsp;&nbsp;2.在UDPspeeder(V1/V2)和UDP2raw双开（串联模式下），ss-redir的udp流量经过UDPspeeder(V1/V2)加速后的UDP流量，经过udp2raw转换为tcp后的流量会转发此处设置的到服务器端口，此处应按填写服务器的ip和服务器端UDPspeeder(V1/V2)的监听端口；"
		_caption = "说明：";
	} else if (itemNum == 103) {
		width = "600px";
		statusmenu = "梅林固件推荐使用auto.<br />&nbsp;&nbsp;&nbsp;&nbsp;大部分udp2raw不能连通的情况都是设置了不兼容的iptables造成的。--lower-level选项允许绕过本地iptables。<br />&nbsp;&nbsp;&nbsp;&nbsp;虽然作者推荐merlin固件使用auto，但是merlin固件在某些拨号网络下可能无法通过--lower-level auto自动获取参数，而导致udp2raw启动失败，此时可以手动填写此处或者留空（实测留空也是可以工作的）"
		_caption = "说明：";
	} else if (itemNum == 103) {
		width = "600px";
		statusmenu = "<br />&nbsp;&nbsp;&nbsp;&nbsp;UDPspeeder有两个版本，V2是V1的升级版本，只有V2版才支持FEC；V1和V2版都支持多倍发包，V2通过配置FEC比例就能达到V1的多倍发包效果。<br />如果你只需要多倍发包，可以直接用V1版，V1版配置更简单，占用内存更小，而且经过了几个月的考验，很稳定。V2版在梅林固件下的消耗更高一些。"
		_caption = "说明：";
	}
	return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

	var tag_name = document.getElementsByTagName('a');
	for (var i = 0; i < tag_name.length; i++)
		tag_name[i].onmouseout = nd;

	if (helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if (hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else {
		if (hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}

function showDropdownClientList(_callBackFun, _callBackFunParam, _interfaceMode, _containerID, _pullArrowID, _clientState) {
	document.body.addEventListener("click", function(_evt) {
		control_dropdown_client_block(_containerID, _pullArrowID, _evt);
	})
	if (clientList.length == 0) {
		setTimeout(function() {
			genClientList();
			showDropdownClientList(_callBackFun, _callBackFunParam, _interfaceMode, _containerID, _pullArrowID);
		}, 500);
		return false;
	}

	var htmlCode = "";
	htmlCode += "<div id='" + _containerID + "_clientlist_online'></div>";
	htmlCode += "<div id='" + _containerID + "_clientlist_dropdown_expand' class='clientlist_dropdown_expand' onclick='expand_hide_Client(\"" + _containerID + "_clientlist_dropdown_expand\", \"" + _containerID + "_clientlist_offline\");' onmouseover='over_var=1;' onmouseout='over_var=0;'>Show Offline Client List</div>";
	htmlCode += "<div id='" + _containerID + "_clientlist_offline'></div>";
	document.getElementById(_containerID).innerHTML = htmlCode;

	var param = _callBackFunParam.split(">");
	var clientMAC = "";
	var clientIP = "";
	var getClientValue = function(_attribute, _clienyObj) {
		var attribute_value = "";
		switch (_attribute) {
			case "mac":
				attribute_value = _clienyObj.mac;
				break;
			case "ip":
				if (clientObj.ip != "offline") {
					attribute_value = _clienyObj.ip;
				}
				break;
			case "name":
				attribute_value = (clientObj.nickName == "") ? clientObj.name.replace(/'/g, "\\'") : clientObj.nickName.replace(/'/g, "\\'");
				break;
			default:
				attribute_value = _attribute;
				break;
		}
		return attribute_value;
	};

	var genClientItem = function(_state) {
		var code = "";
		var clientName = (clientObj.nickName == "") ? clientObj.name : clientObj.nickName;

		code += '<a id=' + clientList[i] + ' title=' + clientList[i] + '>';
		if (_state == "online")
			code += '<div onclick="' + _callBackFun + '(\'';
		else if (_state == "offline")
			code += '<div style="color:#A0A0A0" onclick="' + _callBackFun + '(\'';
		for (var j = 0; j < param.length; j += 1) {
			if (j == 0) {
				code += getClientValue(param[j], clientObj);
			} else {
				code += '\', \'';
				code += getClientValue(param[j], clientObj);
			}
		}
		code += '\''
		code += ', '
		code += '\''
		code += clientName;
		code += '\');">';
		code += '<strong>';
		if (clientName.length > 32) {
			code += clientName.substring(0, 30) + "..";
		} else {
			code += clientName;
		}
		code += '</strong>';
		if (_state == "offline")
			code += '<strong title="Remove this client" style="float:right;margin-right:5px;cursor:pointer;" onclick="removeClient(\'' + clientObj.mac + '\', \'' + _containerID + '_clientlist_dropdown_expand\', \'' + _containerID + '_clientlist_offline\')">×</strong>';
		code += '</div><!--[if lte IE 6.5]><iframe class="hackiframe2"></iframe><![endif]--></a>';
		return code;
	};

	for (var i = 0; i < clientList.length; i += 1) {
		var clientObj = clientList[clientList[i]];
		switch (_clientState) {
			case "all":
				if (_interfaceMode == "wl" && (clientList[clientList[i]].isWL == 0)) {
					continue;
				}
				if (_interfaceMode == "wired" && (clientList[clientList[i]].isWL != 0)) {
					continue;
				}
				if (clientObj.isOnline) {
					document.getElementById("" + _containerID + "_clientlist_online").innerHTML += genClientItem("online");
				} else if (clientObj.from == "nmpClient") {
					document.getElementById("" + _containerID + "_clientlist_offline").innerHTML += genClientItem("offline");
				}
				break;
			case "online":
				if (_interfaceMode == "wl" && (clientList[clientList[i]].isWL == 0)) {
					continue;
				}
				if (_interfaceMode == "wired" && (clientList[clientList[i]].isWL != 0)) {
					continue;
				}
				if (clientObj.isOnline) {
					document.getElementById("" + _containerID + "_clientlist_online").innerHTML += genClientItem("online");
				}
				break;
			case "offline":
				if (_interfaceMode == "wl" && (clientList[clientList[i]].isWL == 0)) {
					continue;
				}
				if (_interfaceMode == "wired" && (clientList[clientList[i]].isWL != 0)) {
					continue;
				}
				if (clientObj.from == "nmpClient") {
					document.getElementById("" + _containerID + "_clientlist_offline").innerHTML += genClientItem("offline");
				}
				break;
		}
	}

	if (document.getElementById("" + _containerID + "_clientlist_offline").childNodes.length == "0") {
		if (document.getElementById("" + _containerID + "_clientlist_dropdown_expand") != null) {
			removeElement(document.getElementById("" + _containerID + "_clientlist_dropdown_expand"));
		}
		if (document.getElementById("" + _containerID + "_clientlist_offline") != null) {
			removeElement(document.getElementById("" + _containerID + "_clientlist_offline"));
		}
	} else {
		if (document.getElementById("" + _containerID + "_clientlist_dropdown_expand").innerText == "Show Offline Client List") {
			document.getElementById("" + _containerID + "_clientlist_offline").style.display = "none";
		} else {
			document.getElementById("" + _containerID + "_clientlist_offline").style.display = "";
		}
	}
	if (document.getElementById("" + _containerID + "_clientlist_online").childNodes.length == "0") {
		if (document.getElementById("" + _containerID + "_clientlist_online") != null) {
			removeElement(document.getElementById("" + _containerID + "_clientlist_online"));
		}
	}
	if (document.getElementById(_containerID).childNodes.length == "0")
		document.getElementById(_pullArrowID).style.display = "none";
	else
		document.getElementById(_pullArrowID).style.display = "";
}