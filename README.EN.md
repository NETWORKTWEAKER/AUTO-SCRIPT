# Directly install My darling without the need to register a VPS IP

# Order from me (MUST READ) before using

</p> 
<h2 align="center"> Supported Linux Distribution</h2>
<p align="center"><img src="https://d33wubrfki0l68.cloudfront.net/5911c43be3b1da526ed609e9c55783d9d0f6b066/9858b/assets/img/debian-ubuntu-hover.png"></p> 
<p align="center"><img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%209&message=Stretch&color=purple"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2010&message=Buster&color=purple">  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2018&message=Lts&color=red"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2020&message=Lts&color=red">
</p>

<p align="center"><img src="https://img.shields.io/badge/Service-SSH_Over_Websocket-success.svg">  <img src="https://img.shields.io/badge/Service-SSH_Dropbear-success.svg">  <img src="https://img.shields.io/badge/Service-Stunnel4-success.svg">  <img src="https://img.shields.io/badge/Service-Fail2Ban-brightgreen">  <p align="center"><img src="https://img.shields.io/badge/Service-XRAY-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_Websocket_TLS-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_VLESS_VMESS-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_gRPC_VLESS_VMESS-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_TROJAN-success.svg">  <img src= "https://img.shields.io/badge/Service-Shadowsocks-success.svg">  <img src="https://wangchujiang.com/sb/status/stable.svg">
  
# Required
- VPS is still fresh (MUST) / have never installed anything
<br>
- DOMAIN (MUST) / RANDOM from Script<br>
- NOTE the domain from the script is only done once during the install process to reduce DOMAIN spam which often changes<br>
- To change the Domain in the menu after install use your own domain instead of the script again OK<br>
- DEBIAN 9/10<br>
- Ubuntu 18/20 LTS<br>
- CPU MIN 1 CORE<br>
- 1GB RAM<br>
- Ubuntu 18 recommendation
<br>

# Cloudflare settings for those who have their own Domain, you can check in the folder [image](https://github.com/givpn/AutoScriptXray/tree/master/image) to display other settings
<br>
- SSL/TLS : FULL<br>
- SSL/TLS Recommender : OFF<br>
- GRPC : ON<br>
- WEBSOCKET : ON<br>
- Always Use HTTPS : OFF<br>
- UNDER ATTACK MODE : OFF<br>
<br>

# Pointing
![Pointing](https://raw.githubusercontent.com/givpn/AutoScriptXray/master/image/pointing.png)

## Service & Port:
<br>
- OpenSSH                  : 22<br>
- SSH Websocket            : 80<br>
- SSH SSL Websocket        : 443<br>
- Stunnel4                 : 222, 777<br>
- Dropbear                 : 109, 143<br>
- Badvpn                   : 7100-7900<br>
- Nginx                    : 81<br>
- Vmess WS TLS             : 443<br>
- Vless WS TLS             : 443<br>
- Trojan WS TLS            : 443<br>
- Shadowsocks WS TLS       : 443<br>
- Vmess WS none TLS        : 80<br>
- Vless WS none TLS        : 80<br>
- Trojan WS none TLS       : 80<br>
- Shadowsocks WS none TLS  : 80<br>
- Vmess gRPC               : 443<br>
- Vless gRPC               : 443<br>
- Trojan gRPC              : 443<br>
- Shadowsocks gRPC         : 443<br>
<br>
  
# Feature
- Speedtest VPS by [Ookla](https://speedtest.net)
- Set Auto Reboot
- Restart All Services
- AUTO delete expired users
- Bandwidth Check
- BBRPLUS version 1.4.0 by [Chikage0o0](https://github.com/Chikage0o0/Linux-NetSpeed)
- DNS CHANGER
- Optional [install Panel ADS Block](https://github.com/givpn/AutoScriptXray/tree/master/helium) Helium version 3.0 by [Abi Darwish](https://github.com/abidarwish/helium)
- ETC
- no auto backup? yes... removed permanently
- Just accept the existing features / you can add them yourself manually [HOW](https://github.com/givpn/AutoScriptXray/tree/master/cara)
  
# Menu
![Service Status](https://raw.githubusercontent.com/givpn/AutoScriptXray/master/image/menu.png)

# Service Status
![Service Status](https://raw.githubusercontent.com/givpn/AutoScriptXray/master/image/service.png)

# Create root on the VPS for those of you who log into the server still using a username that isn't root
- Step 1
```
sudo su
```
- Step 2
```
cd
```
- Step 3
```
apt update && apt install wget -y && apt upgrade -y && apt dist-upgrade -y && wget -qO- -O rootvps.sh https://raw.githubusercontent.com/givpn/AutoScriptXray/master/rootvps.sh && bash rootvps.sh
```
- Step 4 INSTALL, NOTE If you have root, just copy and paste the link below
```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/givpn/AutoScriptXray/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```

# Telegram
[![Telegram-chat](https://img.shields.io/badge/Chat-Telegram-blue)](https://t.me/givpn/)
[![Telegram-grup](https://img.shields.io/badge/Grup-Telegram-blue)](https://t.me/givpn_grup)

# Buy me coffee, without coffee it's better to SLEEP / NGOROK you know NGOROK Search now [NGOROK](https://www.google.com/search?q=NGOROK)
[![Saweria donate button](https://img.shields.io/badge/Donate-Saweria-red)](https://saweria.co/givpn11)
[![PayPal donate button](https://img.shields.io/badge/Donate-PayPal-blue)](https://paypal.me/givpn11)
<a href="https://www.digitalocean.com/?refcode=8a474003bf18&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a>

# Human error no comment , i go to sleep
# ATTENTION (MUST) READ CAREFULLY
- NOT FOR SALE BECAUSE I GET IT FREE FROM THE INTERNET
- DATA SECURITY / YOUR USE HISTORY ON THE INTERNET IS NOT MY RESPONSIBILITY AS A SCRIPT PROVIDER
- ALL YOUR DATA / USAGE HISTORY ON THE INTERNET ONLY VPS NETWORK PROVIDERS MANAGE IT AND (FBI) maybe
- USE IT WISELY THEN YOU WILL AVOID PROBLEMS
- WATCH SIN UNYIL AT YOUR OWN RESPONSIBILITY

# END MESSAGE
- THANK YOU FOR TAKING THE TIME TO READ AND SORRY IF THERE ARE IMPERFECT WORDS
- BECAUSE I AM ALSO A HUMAN WHO DOESN'T ESCAPE MISTAKES


<p align="center">
<a href="https://opensource.org/licenses/MIT"> <img src="https://img.shields.io/badge/License-MIT-blue.svg" style="max-width:200%;">
<p align="center">
  <a><img src="https://img.shields.io/badge/givpn-AutoScriptXray%202023-blue" style="max-width:200%;">
  
