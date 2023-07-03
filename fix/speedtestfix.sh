#!/bin/bash
# pewarna hidup
BGreen='\e[1;32m'
NC='\e[0m'
clear
rm -rf /usr/bin/speedtest
echo -e "\e[1;32m Start download speedtest.. \e[0m"
wget -q -O /usr/bin/speedtest https://raw.githubusercontent.com/givpn/AutoScriptXray/master/fix/speedtest.sh
chmod +x /usr/bin/speedtest
clear
echo -e "\e[1;32m Setup done Please wait.. \e[0m"
sleep 2
rm -rf speedtestfix.sh
clear
echo -e "\e[1;32m auto reboot in 5s \e[0m"
sleep 5
reboot

