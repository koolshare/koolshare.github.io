function menu_hook(title, tab) {
	var ss_mode = '<% nvram_get("ss_mode"); %>';
	tabtitle[16] = new Array("", "shadowsocks设置", "Socks5设置");
	tablink[16] = new Array("", "Main_Ss_Content.asp", "Main_SsLocal_Content.asp");
}

function showSSLoadingBar(seconds){
	if(window.scrollTo)
		window.scrollTo(0,0);

	disableCheckChangedStatus();
	
	htmlbodyforIE = document.getElementsByTagName("html");  //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden";	  //hidden the Y-scrollbar for preventing from user scroll it.
	
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

	if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if(winWidth >1050){
	
		winPadding = (winWidth-1050)/2;	
		winWidth = 1105;
		blockmarginLeft= (winWidth*0.3)+winPadding;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.3+document.body.scrollLeft;	

	}
	
	if(winHeight >660)
		winHeight = 660;
	
	blockmarginTop= winHeight*0.3			
	
	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop+"px";
	// marked by Jerry 2012.11.14 using CSS to decide the margin
	document.getElementById("loadingBarBlock").style.marginLeft = blockmarginLeft+"px";

	
	/*blockmarginTop = document.documentElement.scrollTop + 200;
	document.getElementById("loadingBarBlock").style.marginTop = blockmarginTop+"px";*/

	document.getElementById("LoadingBar").style.width = winW+"px";
	document.getElementById("LoadingBar").style.height = winH+"px";
	
	loadingSeconds = seconds;
	progress = 100/loadingSeconds;
	y = 0;
	if (socks5 == "1"){
		LoadingLocalProgress(seconds);
	} else {
		LoadingSSProgress(seconds);
	}
	
}


function LoadingSSProgress(seconds){
	document.getElementById("LoadingBar").style.visibility = "visible";

	if (document.form.ss_basic_enable.value == 0){
		document.getElementById("loading_block3").innerHTML = "SS服务关闭中 ..."
		$j("#loading_block2").html("<li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>SS工作有问题？请来我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>反应问题...</font></li>");
	} else {
		if (document.form.ss_basic_action.value == 1){
			if (document.form.ss_basic_mode.value == 5){
				document.getElementById("loading_block3").innerHTML = "全局模式启用中 ..."
				$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>此模式非科学上网方式，会影响国内网页速度...</font></li><li><font color='#ffcc00'>注意：全局模式并非VPN，只支持TCP流量转发...</font></li>");
			} else if (document.form.ss_basic_mode.value == 2){
				document.getElementById("loading_block3").innerHTML = "大陆白名单模式启用中 ..."
				$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>模式加载时间较长，请耐心等待进度条...</font></li>");
			} else if (document.form.ss_basic_mode.value == 1){
				document.getElementById("loading_block3").innerHTML = "gfwlist模式启用中 ..."
				$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>尝试不同的DNS解析方案，可以达到最佳的效果哦...</font></li>");
			}
		}else if (document.form.ss_basic_action.value == 2){
			document.getElementById("loading_block3").innerHTML = "快速重启DNS服务 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，DNS即可生效~</font></li>");
		} else if (document.form.ss_basic_action.value == 3){
			document.getElementById("loading_block3").innerHTML = "快速应用黑白名单 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，黑白名单即可生效~</font></li>");
		} else if (document.form.ss_basic_action.value == 4){
			document.getElementById("loading_block3").innerHTML = "快速应用附加功能 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>无需重启全部服务，附加功能即可生效~</font></li>");
		}
	}
	y = y + progress;
	if(typeof(seconds) == "number" && seconds >= 0){
		if(seconds != 0){
			document.getElementById("proceeding_img").style.width = Math.round(y) + "%";
			document.getElementById("proceeding_img_text").innerHTML = Math.round(y) + "%";
	
			if(document.getElementById("loading_block1")){
				document.getElementById("proceeding_img_text").style.width = document.getElementById("loading_block1").clientWidth;
				document.getElementById("proceeding_img_text").style.marginLeft = "175px";
			}
			--seconds;
			setTimeout("LoadingSSProgress("+seconds+");", 1000);
		}
		else{
			document.getElementById("proceeding_img_text").innerHTML = "完成";
			y = 0;
				setTimeout("hideSSLoadingBar();",1000);
				refreshpage()
		}
	}
}

function LoadingLocalProgress(seconds){
	document.getElementById("LoadingBar").style.visibility = "visible";
	document.getElementById("loading_block3").innerHTML = "socks5启用中 ..."
	$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>此模式非科学上网方式，会影响国内网页速度...</font></li><li><font color='#ffcc00'>注意：全局模式并非VPN，只支持TCP流量转发...</font></li>");
	y = y + progress;
	if(typeof(seconds) == "number" && seconds >= 0){
		if(seconds != 0){
			document.getElementById("proceeding_img").style.width = Math.round(y) + "%";
			document.getElementById("proceeding_img_text").innerHTML = Math.round(y) + "%";
	
			if(document.getElementById("loading_block1")){
				document.getElementById("proceeding_img_text").style.width = document.getElementById("loading_block1").clientWidth;
				document.getElementById("proceeding_img_text").style.marginLeft = "175px";
			}
			--seconds;
			setTimeout("LoadingLocalProgress("+seconds+");", 1000);
		}
		else{
			document.getElementById("proceeding_img_text").innerHTML = "完成";
			y = 0;
				setTimeout("hideSSLoadingBar();",1000);
				refreshpage()
		}
	}
}

function hideSSLoadingBar(){
	document.getElementById("LoadingBar").style.visibility = "hidden";
}

function pass_checked(obj){
	switchType(obj, document.form.show_pass.checked, true);
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
		if(isFirefox=navigator.userAgent.indexOf("Firefox")>0){
			$G(oTargetObj).style.margin = "0px 0px 0px 15px";
		}
			targetObj.style.display = "block";
		if (openTip && shutTip) {
		    sourceObj.innerHTML = openTip;
		}
	}
}

