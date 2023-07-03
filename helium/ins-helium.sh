#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V2.0
# Auther  : givpn
# (C) Copyright 2023
# =========================================
clear
if [[ -e /usr/bin/helium ]]; then
     echo ""
     echo -e "${green}Ads Block Already Install${NC}"
     echo ""
	 read -n1 -r -p "Press any key to continue..."
	 m-system
else
rm -rf /usr/bin/m-system
wget -q -O /usr/bin/m-system https://raw.githubusercontent.com/givpn/AutoScriptXray/master/helium/menu/m-system.sh
chmod +x /usr/bin/m-system
rm -rf /usr/bin/helium
wget -q -O /usr/bin/helium https://raw.githubusercontent.com/givpn/AutoScriptXray/master/helium/helium.sh
chmod +x /usr/bin/helium
rm -rf /usr/bin/ins-helium
read -n1 -r -p "Press any key to reboot..."
reboot

fi
