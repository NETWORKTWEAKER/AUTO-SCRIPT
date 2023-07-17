#!/bin/bash
# Script UdpCustom 2023
# Script By MARDHEX
# https://t.me/mdxdev
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition 1.0
# Auther  : givpn
# Kuota Habisss
# (C) Copyright 2023
# =========================================
# pewarna hidup
BGreen='\e[1;32m'
NC='\e[0m'
cd
rm -rf slowdns.sh
rm -rf udp.sh
rm -rf vpn.sh
rm -rf openvpn.sh
rm -rf log-install.txt
rm -rf /usr/bin/usernew
rm -rf /usr/bin/trial
rm -rf /root/domain
echo "\e[1;32m Update Menu.. \e[0m"
sleep 1
wget -q -O /usr/bin/usernew https://raw.githubusercontent.com/givpn/AutoScriptXray/master/udp-custom/ssh/usernew.sh
wget -q -O /usr/bin/trial https://raw.githubusercontent.com/givpn/AutoScriptXray/master/udp-custom/ssh/trial.sh
echo "\e[1;32m Proses Download Script Slowdns.. \e[0m"
wget https://raw.githubusercontent.com/givpn/AutoScriptXray/master/udp-custom/slowdns/slowdns.sh && chmod +x slowdns.sh && ./slowdns.sh
sleep 1
echo "\e[1;32m Proses Download Script OpenVPN.. \e[0m"
wget https://raw.githubusercontent.com/givpn/AutoScriptXray/master/udp-custom/openvpn/openvpn.sh && chmod +x openvpn.sh && ./openvpn.sh
sleep 1
chmod +x /usr/bin/usernew
chmod +x /usr/bin/trial
rm -rf /root/udp
mkdir -p /root/udp
# install udp-custom
echo ""
sleep 1
echo "\e[1;32m Proses Download Script UdpCustom.. \e[0m"
sleep 1
clear
echo "\e[1;32m Cecking Tool UdpCustom By Mardhex.. \e[0m"
sleep 1
clear
echo "\e[1;32m Succes Cecking Tool.. \e[0m"
sleep 1
clear
echo "\e[1;32m Please Waiting Proses Downloading Toll UdpCustom.. \e[0m"
sleep 1
clear
wget -q --show-progress --load-cookies /tmp/cookies.txt "https://github.com/givpn/AutoScriptXray/raw/master/udp-custom/udp-custom-linux-amd64" -O /root/udp/udp-custom && rm -rf /tmp/cookies.txt
chmod +x /root/udp/udp-custom
clear
# install Config Default Udp
echo ""
sleep 1
echo "\e[1;32m Proses Download Script Config Default.. \e[0m"
sleep 1
clear
echo "\e[1;32m Cecking Config Default By Mardhex.. \e[0m"
sleep 1
clear
echo "\e[1;32m Succes Cecking Config Default Tool.. \e[0m"
sleep 1
clear
echo "\e[1;32m Please Waiting Proses Downloading Default Config UdpCustom.. \e[0m"
sleep 1
clear
wget -q --show-progress --load-cookies /tmp/cookies.txt "https://github.com/givpn/AutoScriptXray/raw/master/udp-custom/config.json" -O /root/udp/config.json && rm -rf /tmp/cookies.txt
chmod 644 /root/udp/config.json

if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by MARDHEX

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by MARDHEX

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi

echo start service udp-custom
systemctl start udp-custom &>/dev/null

echo enable service udp-custom
systemctl enable udp-custom &>/dev/null

echo ""
sleep 0,5
clear
cd
rm -rf udp.sh
rm -rf slowdns.sh
echo -e "\e[1;32m auto reboot in 5s \e[0m"
sleep 5
reboot

