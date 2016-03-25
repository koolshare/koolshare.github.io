cat version
rm -f softcenter.tar.gz
tar -zcvf softcenter.tar.gz softcenter
md5value=`md5sum softcenter.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
1.0.2
$md5value
EOF
cat version

cat > ./config.json.js <<EOF
{
"version':"1.0.2",
"md5":"$md5value"
}
EOF
