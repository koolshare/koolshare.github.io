function menu_hook(title, tab) {
var ss_mode = '<% nvram_get("ss_mode"); %>';
if(ss_mode == '0'){
	remove_menu_item("Main_SsIpset_Content.asp");
	remove_menu_item("Main_SsAuto_Content.asp");
	remove_menu_item("Main_SsGame_Content.asp");
	remove_menu_item("Main_Ss_Overall.asp");
	remove_menu_item("Main_SsLog_Content.asp");
} else if(ss_mode == '1'){
	remove_menu_item("Main_SsAuto_Content.asp");
	remove_menu_item("Main_SsGame_Content.asp");
	remove_menu_item("Main_Ss_Overall.asp");
} else if(ss_mode == '2'){
	remove_menu_item("Main_SsIpset_Content.asp");
	remove_menu_item("Main_SsGame_Content.asp");
	remove_menu_item("Main_Ss_Overall.asp");
} else if(ss_mode == '3'){
	remove_menu_item("Main_SsIpset_Content.asp");
	remove_menu_item("Main_SsAuto_Content.asp");
	remove_menu_item("Main_Ss_Overall.asp");
} else if(ss_mode == '4'){
	remove_menu_item("Main_SsIpset_Content.asp");
	remove_menu_item("Main_SsAuto_Content.asp");
	remove_menu_item("Main_SsGame_Content.asp");
} else {
	remove_menu_item("Main_SsIpset_Content.asp");
	remove_menu_item("Main_SsAuto_Content.asp");
	remove_menu_item("Main_SsGame_Content.asp");
	remove_menu_item("Main_Ss_Overall.asp");
	remove_menu_item("Main_SsLog_Content.asp");
}
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
	ssmode = document.getElementById("ss_mode").value;
	if (document.getElementById("ss_enable").value == "0"){
	//if (db_ss['ss_enable'] == "0"){
		document.getElementById("loading_block3").innerHTML = "SS服务关闭中 ..."
		$j("#loading_block2").html("<li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>SS工作有问题？请来我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>反应问题...</font></li>");
	} else {
		if (ssmode == "4"){
			document.getElementById("loading_block3").innerHTML = "全局模式启用中 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>此模式非科学上网方式，会影响国内网页速度...</font></li><li><font color='#ffcc00'>注意：全局模式并非VPN，只支持TCP流量转发...</font></li>");
		} else if (ssmode == "3"){
			document.getElementById("loading_block3").innerHTML = "游戏模式启用中 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>为确保游戏工作，请确保你的SS账号支持UDP转发...</font></li><font color='#ffcc00'><li>游戏模式加载时间较长，请等待进度条...</font></li>");
		} else if (ssmode == "2"){
			document.getElementById("loading_block3").innerHTML = "大陆白名单模式启用中 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>模式加载时间较长，请耐心等待进度条...</font></li>");
		} else if (ssmode == "1"){
			document.getElementById("loading_block3").innerHTML = "gfwlist模式启用中 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'>此期间请勿访问屏蔽网址，以免污染DNS进入缓存</font></li><li><font color='#ffcc00'>尝试不同的DNS解析方案，可以达到最佳的效果哦...</font></li>");
		} else if (ssmode == "0"){
			document.getElementById("loading_block3").innerHTML = "SS服务关闭中 ..."
			$j("#loading_block2").html("<li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>SS工作有问题？请来我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>反应问题...</font></li>");
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

