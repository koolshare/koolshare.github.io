#!/bin/sh

eval `dbus export aliddns_`

if [ "$aliddns_enable" != "1" ]; then
	nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
    echo "not enable"
    exit
fi

now=`date`

die () {
    echo $1
    dbus ram aliddns_last_act="$now: failed($1)"
}

[ "$aliddns_curl" = "" ] && aliddns_curl="curl -s --interface ppp0 whatismyip.akamai.com"
[ "$aliddns_dns" = "" ] && aliddns_dns="223.5.5.5"
[ "$aliddns_ttl" = "" ] && aliddns_ttl="600"

ip=`$aliddns_curl 2>&1` || die "$ip"

#support @ record nslookup
if [ "$aliddns_name" = "@" ]
then
  current_ip=`nslookup $aliddns_domain $aliddns_dns 2>&1`
else
  current_ip=`nslookup $aliddns_name.$aliddns_domain $aliddns_dns 2>&1`
fi

if [ "$?" -eq "0" ]
then
    current_ip=`echo "$current_ip" | grep 'Address 1' | tail -n1 | awk '{print $NF}'`

    if [ "$ip" = "$current_ip" ]
    then
        echo "skipping"
        dbus set aliddns_last_act="$now: skipped($ip)"
	nvram set ddns_enable_x=1
#web ui show without @.
        if [ "$aliddns_name" = "@" ] ;then
          nvram set ddns_hostname_x="$aliddns_domain"
        else
          nvram set ddns_hostname_x="$aliddns_name"."$aliddns_domain"
	  ddns_custom_updated 1
          exit 0
	fi
    fi 
# fix when A record removed by manual dns is always update error
else
    unset aliddns_record_id
fi


timestamp=`date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ"`

urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c
    do
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
    done
    echo -n $out
}

enc() {
    echo -n "$1" | urlencode
}

send_request() {
    local args="AccessKeyId=$aliddns_ak&Action=$1&Format=json&$2&Version=2015-01-09"
    local hash=$(echo -n "GET&%2F&$(enc "$args")" | openssl dgst -sha1 -hmac "$aliddns_sk&" -binary | openssl base64)
    curl -s "http://alidns.aliyuncs.com/?$args&Signature=$(enc "$hash")"
}

get_recordid() {
    grep -Eo '"RecordId":"[0-9]+"' | cut -d':' -f2 | tr -d '"'
}

query_recordid() {
    send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$aliddns_name1.$aliddns_domain&Timestamp=$timestamp"
}

update_record() {
    send_request "UpdateDomainRecord" "RR=$aliddns_name1&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$aliddns_ttl&Timestamp=$timestamp&Type=A&Value=$ip"
}

add_record() {
    send_request "AddDomainRecord&DomainName=$aliddns_domain" "RR=$aliddns_name1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&TTL=$aliddns_ttl&Timestamp=$timestamp&Type=A&Value=$ip"
}

#add support */%2A and @/%40 record
case  $aliddns_name  in
      \*)
        aliddns_name1=%2A
        ;;
      \@)
        aliddns_name1=%40
        ;;
      *)
        aliddns_name1=$aliddns_name
        ;;
esac

if [ "$aliddns_record_id" = "" ]
then
    aliddns_record_id=`query_recordid | get_recordid`
fi
if [ "$aliddns_record_id" = "" ]
then
    aliddns_record_id=`add_record | get_recordid`
    echo "added record $aliddns_record_id"
else
    update_record $aliddns_record_id
    echo "updated record $aliddns_record_id"
fi

# save to file
if [ "$aliddns_record_id" = "" ]; then
    # failed
    dbus ram aliddns_last_act="$now: failed"
    nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
else
    dbus ram aliddns_record_id=$aliddns_record_id
    dbus ram aliddns_last_act="$now: success($ip)"
    nvram set ddns_enable_x=1
#web ui show without @.
    if [ "$aliddns_name" = "@" ] ;then
        nvram set ddns_hostname_x="$aliddns_domain"
        ddns_custom_updated 1
    else
        nvram set ddns_hostname_x="$aliddns_name"."$aliddns_domain"
        ddns_custom_updated 1
    fi
fi
