# Langsung install Sayangku tanpa perlu daftar IP VPS

# Pesan dariku (WAJIB BACA) terlebih dahulu sebelum memakai

</p> 
<h2 align="center"> Supported Linux Distribution</h2>
<p align="center"><img src="https://d33wubrfki0l68.cloudfront.net/5911c43be3b1da526ed609e9c55783d9d0f6b066/9858b/assets/img/debian-ubuntu-hover.png"></p> 
<p align="center"><img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%209&message=Stretch&color=purple"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2010&message=Buster&color=purple">  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2018&message=Lts&color=red"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2020&message=Lts&color=red">
</p>

<p align="center"><img src="https://img.shields.io/badge/Service-SSH_Over_Websocket-success.svg"> <img src="https://img.shields.io/badge/Service-SSH_UDP_Custom-success.svg"> <img src="https://img.shields.io/badge/Service-SSH_Dropbear-success.svg">  <img src="https://img.shields.io/badge/Service-Stunnel4-success.svg">  <img src="https://img.shields.io/badge/Service-Fail2Ban-brightgreen">  
<p align="center"><img src="https://img.shields.io/badge/Service-XRAY_VLESS-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_VMESS-success.svg">  <img src="https://img.shields.io/badge/Service-XRAY_TROJAN-success.svg"> <img src= "https://img.shields.io/badge/Service-Websocket-success.svg"> <img src= "https://img.shields.io/badge/Service-GRPC-success.svg"> <img src= "https://img.shields.io/badge/Service-Shadowsocks-success.svg">  
<p <p align="center"><img src="https://img.shields.io/badge/Service-Webmin-success.svg"> <img src="https://img.shields.io/badge/Service-Helium-success.svg">
<p <p align="center"><img src="https://wangchujiang.com/sb/status/stable.svg">
  
# Diperlukan
# VPS masih fresh (WAJIB) / belum pernah install apapun
<br>
- DOMAIN (WAJIB) / RANDOM dari Script<br>
- NOTE domain dari script hanya dilakukan 1x saat proses install untuk mengurangi spam DOMAIN yang sering bergonta-ganti<br>
- Untuk mengubah Domain di menu setelah install menggunakan domain sendiri bukan dari script lagi OK<br>
- DEBIAN 9/10<br>
- Ubuntu 18/20 LTS<br>
- CPU MIN 1 CORE<br>
- RAM 1GB<br>
- Rekomendasi Ubuntu 18 / 20 LTS
<br>

# Setting Cloudflare bagi yang punya Domain sendiri, kamu bisa cek di folder [image](https://github.com/givpn/AutoScriptXray/tree/master/image) untuk tampilan setting lainnya
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
  
## Fitur
- Speedtest VPS by [Ookla](https://speedtest.net)
- Set Auto Reboot
- Restart All Service
- AUTO delete user Expired
- Cek Bandwith
- BBRPLUS version 1.4.0 by [Chikage0o0](https://github.com/Chikage0o0)
- DNS CHANGER
- Optional [install UDP-Custom](https://github.com/givpn/AutoScriptXray/tree/master/udp-custom) by [Exe302](https://gitlab.com/Exe302)
- Optional [install Panel Webmin + ADS Block](https://github.com/givpn/AutoScriptXray/tree/master/helium) Helium version 3.0 by [Abi Darwish](https://github.com/abidarwish)
- DLL
- auto backup tidak ada ? ya... dihilangkan permanent
- Terima saja fitur yang ada / kamu bisa tambahkan sendiri secara manual [CARANYA](https://github.com/givpn/AutoScriptXray/tree/master/cara)
  
# Menu
![Service Status](https://raw.githubusercontent.com/givpn/AutoScriptXray/master/image/menu.png)

# Service Status
![Service Status](https://raw.githubusercontent.com/givpn/AutoScriptXray/master/image/service.png)

# Installasi
- Step 1
```
apt update && apt upgrade -y && reboot
```
- Step 2
```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/givpn/AutoScriptXray/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```

# Telegram
[![Telegram-chat](https://img.shields.io/badge/Chat-Telegram-blue)](https://t.me/givpn/)
[![Telegram-grup](https://img.shields.io/badge/Grup-Telegram-blue)](https://t.me/givpn_grup)

# Belikan saya kopi, tanpa kopi tak begadang lebih baik TIDUR / NGOROK you know NGOROK Search now [NGOROK](https://www.google.com/search?q=NGOROK)
[![Saweria donate button](https://img.shields.io/badge/Donate-Saweria-red)](https://saweria.co/givpn11)
[![PayPal donate button](https://img.shields.io/badge/Donate-PayPal-blue)](https://paypal.me/givpn11)
<a href="https://www.digitalocean.com/?refcode=8a474003bf18&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a>

# Human error no comment , i go to sleep
# PERHATIAN (WAJIB) BACA SECARA SEKSAMA
- DILARANG DIPERJUAL BELIKAN KARENA SAYA MENDAPATKAN SECARA GRATIS DARI INTERNET
- KEAMANAN DATA / RIWAYAT PENGGUNAAN KAMU DI INTERNET BUKAN TANGGUNG JAWAB SAYA SEBAGAI PENYEDIA SCRIPT
- SEMUA DATA / RIWAYAT PENGGUNAAN KAMU DI INTERNET HANYA PENYEDIA JARINGAN VPS YANG MENGELOLANYA DAN (FBI) mungkin
- GUNAKAN SECARA BIJAK MAKA KAMU AKAN TERHINDAR DARI MASALAH
- NONTON UNYIL DOSA TANGGUNG SENDIRI

# PESAN AKHIR
- TERIMAKASIH SUDAH MELUANGKAN WAKTU UNTUK MEMBACA DAN MAAF BILA ADA KATA-KATA YANG TIDAK SEMPURNA
- KARENA SAYA JUGA MANUSIA YANG TIDAK LUPUT DARI KESALAHAN

<p align="center">
<a href="https://opensource.org/licenses/MIT"> <img src="https://img.shields.io/badge/License-MIT-blue.svg" style="max-width:200%;">
<p align="center">
  <a><img src="https://img.shields.io/badge/givpn-AutoScriptXray%202023-blue" style="max-width:200%;">
  
