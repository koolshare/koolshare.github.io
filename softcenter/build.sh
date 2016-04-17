VERSION=1.0.5

cat version
rm -f softcenter.tar.gz
mkdir -p ./softcenter/res

python ./gen_install_stage1.py

chmod 755 ./softcenter/scripts/app_install.sh

tar -zcvf softcenter.tar.gz softcenter
md5value=`md5sum softcenter.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value"
}
EOF

python ./gen_install_stage2.py

cat to_remove.txt|xargs rm -f
rm to_remove.txt
