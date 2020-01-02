#!/bin/sh

#################################################
# 由AnripDdns修改而来，原版信息如下：
#################################################
# AnripDdns v5.08
# 基于DNSPod用户API实现的动态域名客户端
# 作者: 若海[mail@anrip.com]
# 介绍: http://www.anrip.com/ddnspod
# 时间: 2016-02-24 16:25:00
# Mod: 荒野无灯 http://ihacklog.com  2016-03-16
#################################################

# ====================================变量定义====================================
# 版本号定义
version="0.1.6"

# 导入skipd数据
eval `dbus export ddnspod`

# 引用环境变量等
source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp


# 使用Token认证(推荐) 请去 https://www.dnspod.cn/console/user/security 获取
arToken=$ddnspod_config_token
# 使用邮箱和密码认证
arMail=$ddnspod_config_uname
arPass=$ddnspod_config_pwd
# 域名
mainDomain=""
subDomain=""

# ====================================函数定义====================================
# 获得外网地址
arIpAdress() {
    #双WAN判断
    local wans_mode=$(nvram get wans_mode)
    local inter
    if [ "$ddnspod_config_wan" == "1" ] && [ "$wans_mode" == "lb" ]; then
        inter=$(nvram get wan0_ipaddr)
    elif [ "$ddnspod_config_wan" == "2" ] && [ "$wans_mode" == "lb" ]; then
        inter=$(nvram get wan1_ipaddr)
    else
        inter=$(nvram get wan0_ipaddr)
    fi
    echo $inter
}

# 查询域名地址
# 参数: 待查询域名
arNslookup() {
    local inter="http://119.29.29.29/d?dn="
    curl --silent $inter$1
}

# 读取接口数据
# 参数: 接口类型 待提交数据
arApiPost() {
    local agent="AnripDdns/5.07(mail@anrip.com)"
    local inter="https://dnsapi.cn/${1:?'Info.Version'}"
    if [ "x${arToken}" = "x" ]; then # undefine token
        local param="login_email=${arMail}&login_password=${arPass}&format=json&${2}"
    else
        local param="login_token=${arToken}&format=json&${2}"
    fi
    curl -X POST --silent --insecure --user-agent $agent --data $param $inter
}

# 更新记录信息
# 参数: 主域名 子域名
arDdnsUpdate() {
    local domainID recordID recordRS recordCD myIP errMsg
    # 获得域名ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
    domainID=$(echo $domainID | sed 's/.*"id":"\([0-9]*\)".*/\1/')
    # 获得记录ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&sub_domain=${2}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    # 更新记录IP
    myIP=$($inter)
    recordRS=$(arApiPost "Record.Ddns" "domain_id=${domainID}&record_id=${recordID}&sub_domain=${2}&value=${myIP}&record_line=默认")
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    # 输出记录IP
    if [ "$recordCD" == "1" ]; then
        echo $recordRS | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/'
        dbus set ddnspod_run_status="更新成功"
        return 1
    fi
    # 输出错误信息
    errMsg=$(echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/')
    dbus set ddnspod_run_status="$errMsg"
    echo $errMsg
}

# 动态检查更新
# 参数: 主域名 子域名
arDdnsCheck() {
    local postRS
    local hostIP=$(arIpAdress)
    local lastIP=$(arNslookup "${2}.${1}")
    echo "hostIP: ${hostIP}"
    echo "lastIP: ${lastIP}"
    if [ "$lastIP" != "$hostIP" ]; then
        dbus set ddnspod_run_status="更新中。。。"
        postRS=$(arDdnsUpdate $1 $2)
        echo "postRS: ${postRS}"
        if [ $? -ne 1 ]; then
            return 1
        fi
    else
        dbus set ddnspod_run_status="wan ip未改变，无需更新"
    fi
    return 0
}

parseDomain() {
    mainDomain=${ddnspod_config_domain#*.}
    local tmp=${ddnspod_config_domain%$mainDomain}
    subDomain=${tmp%.}
}

#将执行脚本写入crontab定时运行
add_ddnspod_cru(){
	if [ -f /koolshare/ddnspod/ddnspod.sh ]; then
		#确保有执行权限
		chmod +x /koolshare/ddnspod/ddnspod.sh
		cru a ddnspod "0 */$ddnspod_refresh_time * * * /koolshare/ddnspod/ddnspod.sh restart"
	fi
}

#停止服务
stop_ddnspod(){
	#停掉cru里的任务
    local ddnspodcru=$(cru l | grep "ddnspod")
	if [ ! -z "$ddnspodcru" ]; then
		cru d ddnspod
	fi
}

# 写入版本号
write_ddnspod_version(){
	dbus set ddnspod_version="$version"
}

# ====================================主逻辑====================================

case $ACTION in
start)
	#此处为开机自启动设计
	if [ "$ddnspod_enable" == "1" ] && [ "$ddnspod_auto_start" == "1" ];then
    parseDomain
    add_ddnspod_cru
    sleep $ddnspod_delay_time
    arDdnsCheck $mainDomain $subDomain
	fi
	;;
stop | kill )
    stop_ddnspod
	;;
restart)
    stop_ddnspod
    parseDomain
    add_ddnspod_cru
    sleep $ddnspod_delay_time
    arDdnsCheck $mainDomain $subDomain
	write_ddnspod_version
	;;
*)
	echo "Usage: $0 (start|stop|restart|kill)"
	exit 1
	;;
esac

