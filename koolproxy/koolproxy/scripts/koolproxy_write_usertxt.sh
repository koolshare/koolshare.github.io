#! /bin/sh
eval `dbus export koolproxy_user_rule`
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'


write_user_txt(){
	if [ -n "$koolproxy_user_rule" ];then
		user_nu=`echo $koolproxy_user_rule | base64_decode |grep -cv "!"`
		echo $koolproxy_user_rule | base64_decode > /koolshare/koolproxy/data/rules/user.txt
		echo_date 成功添加了"$user_nu"条自定义规则！ >> /tmp/koolproxy_run.log
		echo_date 自动为你重启koolproxy插件！ >> /tmp/koolproxy_run.log
		dbus remove koolproxy_user_rule
		echo_date ============================================ >> /tmp/koolproxy_run.log
		sh /koolshare/koolproxy/kp_config.sh restart  >> /tmp/koolproxy_run.log
		
		echo XU6J03M6 >> /tmp/koolproxy_run.log
		sleep 1
		rm -rf /tmp/koolproxy_run.log
	fi
}

write_user_txt
