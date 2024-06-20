#!/bin/bash
# NETWORK TWEAKER 
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
NC='\e[0m'
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m                NT BANDWIDTH MONITOR                 \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "" 
echo -e "\e[1;35m 1 \e[0m View Total Remaining Bandwidth"
echo -e "\e[1;35m 2 \e[0m Table of Usage Every 5 Minutes"
echo -e "\e[1;35m 3 \e[0m Table of Usage Every Hour"
echo -e "\e[1;35m 4 \e[0m Table of Usage Every Day"
echo -e "\e[1;35m 5 \e[0m Table of Usage Every Month"
echo -e "\e[1;35m 6 \e[0m Table of Usage Every Year"
echo -e "\e[1;35m 7 \e[0m Highest Usage Table"
echo -e "\e[1;35m 8 \e[0m Hourly Usage Statistics"
echo -e "\e[1;35m 9 \e[0m View Current Active Usage"
echo -e "\e[1;35m 10 \e[0m View Active Traffic Usage [5s]"
echo -e "" 
echo -e "\e[1;34m 0 BACK TO MENU \e[0m"
echo -e "\e[1;34m x Exit \e[0m"
echo -e "" 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -p " Select menu: " opt
echo -e ""
case $opt in
1)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m          NT TOTAL REMAINING SERVER BANDWIDTH         \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

2)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m           NT TOTAL BANDWIDTH USAGE EVERY 5 MINUTES         \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -5

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

3)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m             NT TOTAL BANDWIDTH USAGE EVERY HOUR         \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -h

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

4)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m           NT TOTAL BANDWIDTH USAGE EVERY DAY            \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -d

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

5)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m           NT TOTAL BANDWIDTH USAGE EVERY MONTH •         \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -m

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

6)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m           NT TOTAL BANDWIDTH USAGE EVERY YEAR           \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -y

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

7)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m            NT HIGHEST TOTAL BANDWIDTH USAGE            \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -t

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

8)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m          NT HOURLY USAGE STATISTICS          \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -hg

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

9)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m              NT LIVE BANDWIDTH USAGE             \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m Press [ Ctrl+C ] To-Exit \e[0m"
echo -e ""

vnstat -l

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

10)
clear 
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e "\e[1;34m          NT LIVE TRAFFIC BANDWIDTH USAGE        \e[0m"
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""

vnstat -tr

echo -e ""
echo -e "\e[1;33m -------------------------------------------------\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to go back to menu"
bw
;;

0)
sleep 1
m-system
;;
x)
exit
;;
*)
echo -e ""
echo -e "EREN YEAGER"
sleep 1
bw
;;
esac