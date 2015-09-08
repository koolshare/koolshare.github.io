#!/bin/sh

HOME_URL=https://koolshare.github.io
mkdir -p ./ngrok
cd ./ngrok

if [ ! -f n.tar.gz ]; then
    echo "geting install script"
    wget --no-check-certificate  $HOME_URL/ngrokd/n.tar.gz
    tar -zxvf ./n.tar.gz
fi

if [ ! -f config.sh ]; then
echo "Please enter your dns: "
read dns
cat << 'EOF' > ./config.sh
#!/bin/sh
dns=$dns
EOF
chmod 755 ./config.sh
fi

http_port=80
https_port=443
remote_port=4443

echo "you can change config.sh for port settings"
. ./config.sh

if [ ! -f device.csr ]; then
    echo "generate tls"
    openssl genrsa -out rootCA.key 2048 
    openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$dns" -days 5000 -out rootCA.pem 
    openssl genrsa -out device.key 2048 
    openssl req -new -key device.key -subj "/CN=$dns" -out device.csr 
    openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000 
fi

echo "TODO check for port 80 443 4443 for available"
#sudo lsof -i -n -P 

ROOT_UID="0"
if [ "$UID" -ne "$ROOT_UID" ] ; then

if [ -f /etc/redhat-release ]; then
    sudo setenforce 0
    sudo service iptables stop
fi

if [ -f /etc/lsb-release ]; then
    sudo ufw disable
fi

else

if [ -f /etc/redhat-release ]; then
    setenforce 0
    service iptables stop
fi

if [ -f /etc/lsb-release ]; then
    ufw disable
fi

fi

nohup ./bin/ngrokd -domain="$dns" -httpAddr=":$http_port" -httpsAddr=":$https_port" -tlsCrt=device.crt -tlsKey=device.key -tunnelAddr=":$remote_port" > z.log 2>&1 &
sleep 2
echo "read z.log for log"
cat z.log
