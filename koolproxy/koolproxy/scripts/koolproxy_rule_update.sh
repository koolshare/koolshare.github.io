#! /bin/sh
# 导入skipd数据
eval `dbus export koolproxy`
# 引用环境变量等
source /koolshare/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
reboot=0

update_kp_rules(){
	mkdir -p /tmp/kpd
	rm -rf rm -rf /tmp/kpd/*
	rule_nu=`dbus list koolproxy_rule_address_|sort -n -t "=" -k 2|cut -d "=" -f 1 | cut -d "_" -f 4`
	echo_date ================== 规则更新 =================
	echo_date 
	if [ -n "$rule_nu" ]; then
		for rule in $rule_nu
		do
			rule_name=`dbus get koolproxy_rule_name_$rule`
			rule_addr=`dbus get koolproxy_rule_address_$rule`
			rule_load=`dbus get koolproxy_rule_load_$rule`
			file_name=`dbus get koolproxy_rule_address_$rule|grep -Eo "\w+.dat|\w+.txt"`
			echo_date ① 检测【$rule_name】$file_name 是否有更新...
			wget -q --timeout=3 --tries=2 $rule_addr -O /tmp/kpd/$rule"_"$file_name
			if [ "$?" == "0" ]; then
				MD5_TMP=`md5sum /tmp/kpd/$rule"_"$file_name| awk '{print $1}'`
				MD5_ORI=`md5sum /koolshare/koolproxy/rule_store/$rule"_"$file_name| awk '{print $1}'`
				dbus set koolproxy_rule_date_$rule=`ls -l /koolshare/koolproxy/rule_store/$rule"_"$file_name | awk '{print $6,$7,$8}'`
				if [ ! -f /koolshare/koolproxy/rule_store/$rule"_"$file_name ] || [ "$MD5_TMP"x != "$MD5_ORI"x ];then
					echo_date ② 更新【$rule_name】，$rule_addr
					mv -f /tmp/kpd/$rule"_"$file_name /koolshare/koolproxy/rule_store/
					reboot=$(($reboot+1))
				else
					echo_date ② 本地【$rule_name】$file_name 已经是最新！
				fi
			else
				rm -rf rm -rf /tmp/kpd/*
				echo_date ① 检测规则错误！请检查你的网络到 $rule_addr 的连通性！
			fi
			[ "$rule_load" == "1" ] && \
			echo_date ③ 应用规则文件：【$rule_name】$file_name && \
			ln -sf /koolshare/koolproxy/rule_store/$rule"_"$file_name /koolshare/koolproxy/data/$rule"_"$file_name
			echo_date 
		done
	else
		echo_date ！！！没有加载任何规则！退出！！！
		no_rule_load=1
	fi
	
	# 应用更新
	if [ "$reboot" != "0" ] && [ "$koolproxy_enable" == "1" ];then
		echo_date ================== koolproxy重启 =================
		echo_date 自动重启koolproxy插件，以应用新的规则文件！请稍后！
		sh /koolshare/koolproxy/kp_config.sh restart
	fi
}

update_kp_rules > /tmp/koolproxy_run.log
echo_date ================================================= >> /tmp/koolproxy_run.log
echo XU6J03M6 >> /tmp/koolproxy_run.log
sleep 1
rm -rf /tmp/koolproxy_run.log