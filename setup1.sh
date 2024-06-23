#!/bin/bash

# Ensure the script is run as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    sleep 5
    exit 1
fi

# Check virtualization
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    sleep 5
    exit 1
fi

# Create necessary directories and files
mkdir -p /etc/xray /etc/v2ray
touch /etc/xray/domain /etc/v2ray/domain /etc/xray/scdomain /etc/v2ray/scdomain

# Update and install required packages
apt-get update
apt-get install -y software-properties-common build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git dos2unix

# Download and install Python 2.7 from source
cd /usr/src
wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
tar xzf Python-2.7.18.tgz
cd Python-2.7.18
./configure --enable-optimizations
make altinstall

# Ensure python2.7 is the command for Python 2.7
update-alternatives --install /usr/bin/python python /usr/local/bin/python2.7 1
update-alternatives --set python /usr/local/bin/python2.7

# Check that 'python' command works and points to Python 2.7
if ! python --version 2>&1 | grep -q "Python 2.7"; then
    echo "Failed to set python to Python 2.7"
    exit 1
fi

# Domain configuration
echo "1. Use Our NT Domain Random"
echo "2. Choose Your Own Domain"
read -rp "Input 1 or 2: " dns
if [ "$dns" -eq 1 ]; then
    # Download cf script and convert line endings
    wget https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/ssh/cf
    dos2unix cf
    bash cf
elif [ "$dns" -eq 2 ]; then
    read -rp "Enter Your Domain: " dom
    echo "$dom" > /var/lib/ipvps.conf
    echo "$dom" > /root/scdomain
    echo "$dom" > /etc/xray/scdomain
    echo "$dom" > /etc/xray/domain
    echo "$dom" > /etc/v2ray/domain
    echo "$dom" > /root/domain
else
    echo "Not Found Argument"
    exit 1
fi

# Install services
wget -q https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/ssh/ssh-vpn.sh
dos2unix ssh-vpn.sh
bash ssh-vpn.sh

wget -q https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/xray/ins-xray.sh
dos2unix ins-xray.sh
bash ins-xray.sh

wget -q https://raw.githubusercontent.com/NETWORKTWEAKER/AUTO-SCRIPT/master/sshws/insshws.sh
dos2unix insshws.sh
bash insshws.sh

# Setup environment for auto-reboot
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# Log setup
mkdir -p /var/lib/
echo "IP=" >> /var/lib/ipvps.conf

# Installation summary
echo "===================================="
echo " _   _ _______     ______  _   _ "
echo "| \ | |_   _\ \   / /  _ \| \ | |"
echo "|  \| | | |  \ \ / /| |_) |  \| |"
echo "| |\  | | |   \ V / |  __/| |\  |"
echo "|_| \_| |_|    \_/  |_|   |_| \_|"
echo "===================================="        
echo "Services and Ports:"
echo " - OpenSSH: 22"
echo " - SSH Websocket: 80"
echo " - SSH SSL Websocket: 443"
echo " - Stunnel4: 222, 777"
echo " - Dropbear: 109, 143"
echo " - Badvpn: 7100-7900"
echo " - Nginx: 81"
echo " - Vmess WS TLS: 443"
echo " - Vless WS TLS: 443"
echo " - Trojan WS TLS: 443"
echo " - Shadowsocks WS TLS: 443"
echo " - Vmess WS none TLS: 80"
echo " - Vless WS none TLS: 80"
echo " - Trojan WS none TLS: 80"
echo " - Shadowsocks WS none TLS: 80"
echo " - Vmess gRPC: 443"
echo " - Vless gRPC: 443"
echo " - Trojan gRPC: 443"
echo " - Shadowsocks gRPC: 443"
echo "=================================================================="
echo "Contact: t.me/networktweakerop"
echo "=================================================================="

# Additional commands
bash <(curl -Ls https://raw.githubusercontent.com/lalfulsk/Auto/main/dnsdisable.sh)
wget -O /root/log-install.txt https://github.com/NETWORKTWEAKER/SCRIPTS/raw/main/log-install.txt
bash <(curl -Ls https://raw.githubusercontent.com/lalfulsk/NT-A.I.O/main/dropbearconfig.sh)
bash <(curl -Ls https://github.com/lalfulsk/NT-A.I.O/raw/main/dropbear.sh)
bash <(curl -Ls https://github.com/NETWORKTWEAKER/SCRIPTS/raw/main/swap.sh)
sudo systemctl start dropbear
sudo systemctl enable dropbear
# Cleanup and reboot
rm -f /root/setup.sh /root/ins-xray.sh /root/insshws.sh cf ssh-vpn.sh ins-xray.sh insshws.sh
echo "Auto reboot in 40 seconds..."
sleep 40

# Reboot
reboot
