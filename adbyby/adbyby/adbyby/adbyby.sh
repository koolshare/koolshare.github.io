#! /bin/sh
# ====================================变量定义====================================
# 版本号定义
version="1.0"
dbus set adbyby_version="$version"
# 导入skipd数据
eval `dbus export adbyby`

# 引用环境变量等
source /koolshare/scripts/base.sh



start_adbyby(){
	/koolshare/adbyby/adbyby >/dev/null 2>&1 &
}

stop_adbyby(){
	killall adbyby
}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "Could not load nat rules!"
	        sh /koolshare/ss/stop.sh
	        exit
	    fi
	    sleep 1
	done
	echo $(date): "Apply nat rules!"

	iptables -t nat -N adbyby
	iptables -t nat -A PREROUTING -p tcp -j adbyby
	iptables -t nat -A adbyby -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 10.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 127.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 169.254.0.0/16 -j RETURN
	iptables -t nat -A adbyby -d 172.16.0.0/12 -j RETURN
	iptables -t nat -A adbyby -d 192.168.0.0/16 -j RETURN
	iptables -t nat -A adbyby -d 224.0.0.0/4 -j RETURN
	iptables -t nat -A adbyby -d 240.0.0.0/4 -j RETURN
	iptables -t nat -A adbyby -p tcp --dport 80 -j REDIRECT --to-ports 8118
}

flush_nat(){
	iptables -t nat -D PREROUTING -p tcp -j adbyby
	iptables -t nat -F adbyby
	iptables -t nat -X adbyby
}

creat_start_up(){
	rm -rf /koolshare/init.d/S93Adbyby.sh
	ln -sf /koolshare/adbyby/adbyby.sh /koolshare/init.d/S93Adbyby.sh
}


case $ACTION in
start)
	start_adbyby
	load_nat
	creat_start_up
	;;
restart)
	stop_adbyby
	flush_nat
	sleep 2
	start_adbyby
	load_nat
	creat_start_up
	;;
stop)
	stop_adbyby
	flush_nat
	rm -rf /koolshare/init.d/S93Adbyby.sh
	;;
esac

