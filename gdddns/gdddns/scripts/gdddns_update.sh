#!/bin/sh

eval `dbus export gdddns_`

if [ "$gdddns_enable" != "1" ]; then
    echo "not enable"
    exit
fi

now=`date`
ip=`$gdddns_curl 2>&1` || die "$ip"
current_ip=`nslookup $gdddns_name.$gdddns_domain $gdddns_dns 2>&1`

[ "$gdddns_curl" = "" ] && gdddns_curl="curl -s whatismyip.akamai.com"
[ "$gdddns_dns" = "" ] && gdddns_dns="114.114.114.114"
[ "$gdddns_ttl" = "" ] && gdddns_ttl="600"

die () {
    echo $1
    dbus ram gdddns_last_act="$now: failed($1)"
}

urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c; do
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

update_record() {
    curl -kLsX PUT -H "Authorization: sso-key $gdddns_key:$gdddns_secret" \
        -H "Content-type: application/json" "https://api.godaddy.com/v1/domains/$gdddns_domain/records/A/$(enc "$gdddns_name")" \
        -d "{\"data\":\"$ip\",\"ttl\":$gdddns_ttl}"
}


if [ "$?" -eq "0" ]; then
    current_ip=`echo "$current_ip" | grep 'Address 1' | tail -n1 | awk '{print $NF}'`

    if [ "$ip" = "$current_ip" ]; then
        echo "skipping"
        dbus set gdddns_last_act="$now: skipped($ip)"
        exit 0
    else
        echo "changing"
        update_record
        dbus set gdddns_last_act="$now: changed($ip)"
    fi 
fi

