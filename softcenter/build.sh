VERSION=1.0.3

cat version
rm -f softcenter.tar.gz
mkdir -p ./softcenter/res

python ./gen_install.py
#TODO for kuainiao
#cp ../kuainiao/webs/* ./softcenter/webs/
#cp ../kuainiao/scripts/* ./softcenter/scripts/
#cp ../kuainiao/res/* ./softcenter/res/

chmod 755 ./softcenter/scripts/*.sh

tar -zcvf softcenter.tar.gz softcenter
md5value=`md5sum softcenter.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

cat > ./config.json.js <<EOF
{
"version':"$VERSION",
"md5":"$md5value"
}
EOF

cat to_remove.txt|xargs rm -f
rm to_remove.txt
