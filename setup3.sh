#!/bin/bash

# Define colors for output
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
NC='\e[0m'

# Define functions for colored output
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

# Check if the script is run as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    sleep 5
    exit 1
fi

# Check for OpenVZ virtualization
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    clear
    echo "For VPS with KVM and VMWare virtualization ONLY"
    sleep 5
    exit 1
fi

# Set up directories and files
mkdir -p /etc/xray /etc/v2ray
touch /etc/xray/domain /etc/v2ray/domain /etc/xray/scdomain /etc/v2ray/scdomain

# Check and install necessary headers
totet=$(uname -r)
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
    echo -e "[ ${BRed}WARNING${NC} ] Installing $REQUIRED_PKG..."
    apt-get --yes install $REQUIRED_PKG
    echo -e "[ ${BBlue}NOTES${NC} ] If there is an error, run 'apt update && apt upgrade -y && reboot' and then rerun this script."
    exit 1
else
    echo -e "[ ${BGreen}INFO${NC} ] $REQUIRED_PKG is installed."
fi

# Set timezone and disable IPv6
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

# Prepare for installation
echo -e "[ ${BGreen}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
echo -e "[ ${BGreen}INFO${NC} ] Installation file is ready"

# Create necessary directories and files
mkdir -p /var/lib/
echo "IP=" > /var/lib/ipvps.conf

# Clear the screen and show the domain setup menu
clear
echo -e "$BBlue                     SETUP DOMAIN VPS     $NC"
echo -e "$BYellow----------------------------------------------------------$NC"
echo -e "$BGreen 1. Use Domain Random / Gunakan Domain Random $NC"
echo -e "$BGreen 2. Choose Your Own Domain / Gunakan Domain Sendiri $NC"
echo -e "$BYellow----------------------------------------------------------$NC"

# Read user choice
read -rp " input 1 or 2 / pilih 1 atau 2 : " dns
if [ "$dns" -eq 1 ]; then
    # Use random domain
    wget https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/ssh/cf -O cf
    dos2unix cf
    bash cf
    dom=$(cat /root/scdomain)
elif [ "$dns" -eq 2 ]; then
    # Use user-provided domain
    read -rp "Enter Your Domain: " dom
    echo "$dom" > /var/lib/ipvps.conf
    echo "$dom" > /root/scdomain
    echo "$dom" > /etc/xray/scdomain
    echo "$dom" > /etc/xray/domain
    echo "$dom" > /etc/v2ray/domain
else
    echo "Invalid option"
    exit 1
fi

# Record the domain
echo "IP=$dom" > /var/lib/ipvps.conf
echo "$dom" > /root/scdomain
echo "$dom" > /etc/xray/scdomain
echo "$dom" > /etc/xray/domain
echo "$dom" > /etc/v2ray/domain

# Continue with installation
echo -e "${BGreen}Done!${NC}"
sleep 2
clear

# Install SSH and other components
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen      Install NT SSH Websocket           $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh

echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen          Install NT XRAY              $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
wget https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear

# Setup profile
cat > /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile

# Clean up
if [ -f "/root/log-install.txt" ]; then
    rm /root/log-install.txt >/dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
    rm /etc/afak.conf >/dev/null 2>&1
fi
if [ ! -f "/etc/log-create-ssh.log" ]; then
    echo "Log SSH Account " > /etc/log-create-ssh.log
fi
if [ ! -f "/etc/log-create-vmess.log" ]; then
    echo "Log Vmess Account " > /etc/log-create-vmess.log
fi
if [ ! -f "/etc/log-create-vless.log" ]; then
    echo "Log Vless Account " > /etc/log-create-vless.log
fi
if [ ! -f "/etc/log-create-trojan.log" ]; then
    echo "Log Trojan Account " > /etc/log-create-trojan.log
fi
if [ ! -f "/etc/log-create-shadowsocks.log" ]; then
    echo "Log Shadowsocks Account " > /etc/log-create-shadowsocks.log
fi

history -c
serverV=$(curl -sS https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/menu/versi)
echo $serverV > /opt/.ver

curl -sS ipv4.icanhazip.com > /etc/myipvps

echo ""
echo "=================================================================="  | tee -a log-install.txt
echo "      ___                                    ___         ___      "  | tee -a log-install.txt
echo "     /  /\        ___           ___         /  /\       /__/\     "  | tee -a log-install.txt
echo "    /  /:/_      /  /\         /__/\       /  /::\      \  \:\    "  | tee -a log-install.txt
echo "   /  /:/ /\    /  /:/         \  \:\     /  /:/\:\      \  \:\   "  | tee -a log-install.txt
echo "  /  /:/_/::\  /__/::\          \  \:\   /  /:/~/:/  _____\__\:\  "  | tee -a log-install.txt
echo " /__/:/__\/\:\ \__\/\:\__   ___  \__\:\ /__/:/ /:/  /__/::::::::\ "  | tee -a log-install.txt
echo " \  \:\ /~~/:/    \  \:\/\ /__/\ |  |:| \  \:\/:/   \  \:\~~\~~\/ "  | tee -a log-install.txt
echo "  \  \:\  /:/      \__\::/ \  \:\|  |:|  \  \::/     \  \:\  ~~~  "  | tee -a log-install.txt
echo "   \  \:\/:/       /__/:/   \  \:\__|:|   \  \:\      \  \:\      "  | tee -a log-install.txt
echo "    \  \::/        \__\/     \__\::::/     \  \:\      \  \:\     "  | tee -a log-install.txt
echo "     \__\/                       ~~~~       \__\/       \__\/ 1.0 "  | tee -a log-install.txt
echo "=================================================================="  | tee -a log-install.txt
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                  : 22"  | tee -a log-install.txt
echo "   - SSH Websocket            : 80" | tee -a log-install.txt
echo "   - SSH SSL Websocket        : 443" | tee -a log-install.txt
echo "   - Stunnel4                 : 222, 777" | tee -a log-install.txt
echo "   - Dropbear                 : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                   : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                    : 81" | tee -a log-install.txt
echo "   - Vmess WS TLS             : 443" | tee -a log-install.txt
echo "   - Vless WS TLS             : 443" | tee -a log-install.txt
echo "   - Trojan WS TLS            : 443" | tee -a log-install.txt
echo "   - Shadowsocks WS TLS       : 443" | tee -a log-install.txt
echo "   - Vmess WS none TLS        : 80" | tee -a log-install.txt
echo "   - Vless WS none TLS        : 80" | tee -a log-install.txt
echo "   - Trojan WS none TLS       : 80" | tee -a log-install.txt
echo "   - Shadowsocks WS none TLS  : 80" | tee -a log-install.txt
echo "   - Vmess gRPC               : 443" | tee -a log-install.txt
echo "   - Vless gRPC               : 443" | tee -a log-install.txt
echo "   - Trojan gRPC              : 443" | tee -a log-install.txt
echo "   - Shadowsocks gRPC         : 443" | tee -a log-install.txt
echo ""
echo "=============================Contact==============================" | tee -a log-install.txt
echo "---------------------------t.me/networktweakerop-----------------------------" | tee -a log-install.txt
echo "==================================================================" | tee -a log-install.txt
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
echo " Auto reboot in 10 Seconds "
sleep 10
rm -rf setup.sh
reboot
