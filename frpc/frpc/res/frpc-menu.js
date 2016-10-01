function openssHint(itemNum){
	statusmenu = "";	
	width="350px";

	if(itemNum == 0){
		statusmenu ="如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
		_caption = "服务器说明";
	}
	else if(itemNum == 1){
		statusmenu ="此处填入你的frp服务器的地址。</br>建议优先填入<font color='#F46'>IP地址</font>。填入域名，特别是一些服务商给的复杂域名，有时遇到无法解析会导致无法连接!";
		_caption = "服务器";
	}
	else if(itemNum == 2){
		statusmenu ="此处填入你的frp服务器的端口，对应服务器配置文件中的节[common]下的bind_port字段";
		_caption = "服务器端口";
	}
	else if(itemNum == 3){
		statusmenu ="此处填入你的frp服务器的特权授权码。对应服务器配置文件中的节[common]下的privilege_token字段。</br><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致frpc链接不上服务器。";
		_caption = "Privilege Token";
	}
	else if(itemNum == 4){
		statusmenu ="此处填入你的frp服务器HTTP穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_http_port字段";
		_caption = "HTTP穿透服务端口";
	}
	else if(itemNum == 5){
		statusmenu ="此处填入你的frp服务器HTTPS穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_https_port字段";
		_caption = "HTTPS穿透服务端口";
	}
	else if(itemNum == 6){
		statusmenu ="此处是否开启frpc客户端日志。</br><font color='#F46'>注意：</font>默认不开启，开启后日志路径为/tmp/frpc.log";
		_caption = "日志记录";
	}
	else if(itemNum == 7){
		statusmenu ="此处选择日志记录等级。</br>可选内容：info、warn、error、debug。";
		_caption = "日志等级";
	}
	else if(itemNum == 8){
		statusmenu ="此处选择要保留的日志天数。";
		_caption = "日志记录天数";
	}
	else if(itemNum == 9){
		statusmenu ="要穿透的协议类型，目前有http和tcp两种方式。";
		_caption = "协议类型";
	}
	else if(itemNum == 10){
		statusmenu ="此处输入穿透内容的命名（描述），如：ac68u-web或ac68u-webshell，对应客户端配置文件中的节名称。</br><font color='#F46'>注意：</font>frp服务器上的所有命名不能重复！";
		_caption = "服务名称";
	}
	else if(itemNum == 11){
		statusmenu ="此处输入穿透内容的域名，如：ac68u.frp.com，对应客户端配置文件中节下的custom_domains字段。</br><font color='#F46'>注意：</font>frp上运行的域名不能重复！";
        _caption = "域名配置";
		
	}
	else if(itemNum == 12){
		statusmenu ="此处输入要穿透的内部主机IP地址，如：192.168.1.1";
        _caption = "内网主机地址";
		
	}
	else if(itemNum == 13){
		statusmenu ="此处输入要穿透的内部主机的端口，如：80或22";
        _caption = "内网主机端口";
		
	}
	else if(itemNum == 14){
		statusmenu ="此处输入服务器端端口用来映射内部主机端口，如：80或8080</br><font color='#F46'>注意：</font>";
        statusmenu +="</br><b><font color='#669900'>http协议：</font></b>选择http协议时，远程主机端口对应服务器配置文件中的节[common]下的vhost_http_port字段值。";
        statusmenu +="</br><b><font color='#669900'>https协议：</font></b>选择https协议时，远程主机端口对应服务器配置文件中的节[common]下的vhost_https_port字段值。https协议只能对应穿透内网https协议。";
        statusmenu +="</br><b><font color='#669900'>tcp协议：</font></b>选择tcp协议时，远程主机端口应在服务器配置文件中的节[common]下的privilege_allow_ports字段值范围内。";
        _caption = "远程主机端口";
		
	}
	else if(itemNum == 15){
		statusmenu ="如果公司内网防火墙对外网访问进行了流量识别与屏蔽，例如禁止了 ssh 协议等，通过设置加密，将 frpc 与 frps 之间的通信内容加密传输，将会有效防止流量被拦截。";
        _caption = "加密";
		
	}
	else if(itemNum == 16){
		statusmenu ="如果传输的报文长度较长，通过设置对传输内容进行压缩，可以有效减小 frpc 与 frps 之间的网络流量，加快流量转发速度，但是会额外消耗一些 cpu 资源。";
		_caption = "压缩";
	}
		//return overlib(statusmenu, OFFSETX, -160, LEFT, DELAY, 200);
		//return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, " ", FGCOLOR, "#4D595D", CAPCOLOR, "#000000", CLOSECOLOR, "#000000", MOUSEOFF, "1",TEXTCOLOR, "#FFF", CLOSETITLE, '');
		return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

	var tag_name= document.getElementsByTagName('a');	
	for (var i=0;i<tag_name.length;i++)
		tag_name[i].onmouseout=nd;
		
	if(helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if(hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else{
		if(hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}
