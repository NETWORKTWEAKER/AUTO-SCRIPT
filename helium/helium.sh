#!/bin/bash
#script by Abi Darwish
#recode sikit by givpn

VERSIONNAME="Helium v"
VERSIONNUMBER="3.0"
GREEN="\e[1;32m"
RED="\e[1;31m"
WHITE="\e[1m"
NOCOLOR="\e[0m"

providers="/etc/dnsmasq/providers.txt"
dnsmasqHostFinalList="/etc/dnsmasq/adblock.hosts"
tempHostsList="/etc/dnsmasq/list.tmp"
publicIP=$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | awk '{print $1}' | head -1)

function header() {
	echo -e $GREEN" $VERSIONNAME$VERSIONNUMBER" $NOCOLOR
	echo -e $WHITE" by Abi Darwish" $NOCOLOR
}

function isRoot() {
	if [ ${EUID} != 0 ]; then
		echo " You need to run this script as root"
		exit 1
	fi
}

function checkVirt() {
	if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo " OpenVZ is not supported"
		exit 1
	fi
	if [ "$(systemd-detect-virt)" == "lxc" ]; then
		echo " LXC is not supported (yet)"
		exit 1
	fi
}

function checkOS() {
	if [[ $(grep -w "ID" /etc/os-release | awk -F'=' '{print $2}') -ne "debian" ]] || [[ $(grep -w "ID" /etc/os-release | awk -F'=' '{print $2}') -ne "ubuntu" ]]; then
		clear
		header
		echo
		echo -e ${RED}" Your OS is not supported. Please use Debian/Ubuntu"$NOCOLOR
		echo ""
		exit 1
	fi
}

function initialCheck() {
	isRoot
	checkVirt
	checkOS
}

function install() {
	echo -e " Installing Helium..."
	[[ ! -e /etc/dnsmasq ]] && mkdir -p /etc/dnsmasq
	[[ ! -e /etc/resolv.conf.bak ]] && cp /etc/resolv.conf /etc/resolv.conf.bak
	if [[ $(lsof -i :53 | grep -w -c "systemd-r") -ge 1 ]]; then
		systemctl disable systemd-resolved
		systemctl stop systemd-resolved
		unlink /etc/resolv.conf
		echo "nameserver 1.1.1.1" >/etc/resolv.conf
	fi
	apt update && apt install -y dnsmasq dnsutils vnstat resolvconf bc
	systemctl enable dnsmasq
	mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
	rm -rf /etc/dnsmasq.conf
	wget -q -O /etc/dnsmasq.conf "https://raw.githubusercontent.com/abidarwish/helium/main/dnsmasq.conf"
	sed -i "s/YourPublicIP/${publicIP}/" /etc/dnsmasq.conf
	rm -rf ${providers}
	wget -q -O ${providers} "https://raw.githubusercontent.com/abidarwish/helium/main/providers.txt"
	rm -rf /usr/local/sbin/helium_daily
	wget -q -O /usr/local/sbin/helium_daily "https://raw.githubusercontent.com/abidarwish/helium/main/helium_daily.sh"
	chmod 755 /usr/local/sbin/helium_daily
	sed -i '/helium_daily/d' /etc/crontab
	echo -e "0 4 * * * root helium_daily # Helium by Abi Darwish" >>/etc/crontab
	updateEngine
	echo "nameserver 127.0.0.1" >/etc/resolv.conf
	>/etc/resolvconf/resolv.conf.d/head
        sleep 1
        clear
        header
        echo
	echo -e " Installation completed"
	sleep 1
	echo -e " Type \e[1;32mhelium\e[0m to start"
	echo
	exit 0
}

function start() {
	clear
	header
	echo
        heliumStatus
        echo
	if [[ $(systemctl is-active dnsmasq) == "active" ]]; then
		read -p $' Press Enter to continue...'
		mainMenu
	fi
	echo -e -n " Starting Helium..."
	systemctl enable dnsmasq >/dev/null 2>&1
	systemctl restart dnsmasq
	echo "nameserver 127.0.0.1" >/etc/resolv.conf
	sleep 2
	echo -e $GREEN"done"$NOCOLOR
	echo
	read -p $' Press Enter to continue...'
	mainMenu
}

function stop() {
	clear
	header
	echo
        heliumStatus
        echo
	if [[ $(systemctl is-active dnsmasq) == "active" ]]; then
		read -p " Do you want to stop Helium? [y/n]: " STOP
		if [[ ${STOP,,} == "y" ]]; then
			systemctl disable dnsmasq >/dev/null 2>&1
			systemctl stop dnsmasq
			echo "nameserver 1.1.1.1" >/etc/resolv.conf
			echo -e -n " Stopping Helium..."
			sleep 2
			echo -e $GREEN"done"$NOCOLOR
			echo
			read -p " Press Enter to continue..."
			mainMenu
		else
			mainMenu
		fi
	else
		read -p " Press Enter to continue..."
		mainMenu
	fi
}

function DNSOption() {
	clear
	header
	echo
        heliumStatus
        echo
	echo -e " ${WHITE}Change DNS${NOCOLOR}"
	echo -e " [1] Google
 [2] Cloudflare
 [3] Cloudflare for Families
 [4] Adguard DNS
 [5] Adguard Family
 [6] Quad9
 [7] Custom (bypass Netflix)
 [8] Main menu"
	echo
	read -p $' Enter option [1-8]: ' MENU_OPTION
	case ${MENU_OPTION} in
	1)
		googleDNS
		;;
	2)
		cloudflareDNS
		;;
	3)
		cloudflareForFamilies
		;;
	4)
		adguardDNS
		;;
	5)
		adguardFamily
		;;
	6)
		quad9
		;;
	7)
		customDNS
		;;
	8)
		mainMenu
		;;
	*)
		DNSOption
		;;
	esac
}

function changeDNS() {
	echo -e -n " Changing to ${PROVIDER} DNS..."
	OLD_DNS=$(grep -E -w "^server" /etc/dnsmasq.conf | cut -d '=' -f2)
	# [[ ${NEW_DNS,,} == "c" ]] && mainMenu
	# [[ -z ${NEW_DNS} ]] && changeDNS
	sed -i "s/server=${OLD_DNS}/server=${NEW_DNS}/" /etc/dnsmasq.conf
	systemctl restart dnsmasq
	sleep 3
	echo
	echo -e -n " DNS server has been changed to "
	echo -e -n $GREEN"${NEW_DNS}"$NOCOLOR
	sleep 1
	echo
	echo
	read -p " Press Enter to continue..."
	DNSOption
}

function googleDNS() {
	PROVIDER=Google
	NEW_DNS="8.8.8.8"
	clear
	header
	echo
	changeDNS
}

function cloudflareDNS() {
	PROVIDER=Cloudflare
	NEW_DNS="1.1.1.1"
	clear
	header
	echo
	changeDNS
}

function cloudflareForFamilies() {
	PROVIDER="Cloudflare for Families"
	NEW_DNS="1.1.1.3"
	clear
	header
	echo
	changeDNS
}

function adguardDNS() {
	PROVIDER=Adguard
	NEW_DNS="94.140.14.14"
	clear
	header
	echo
	changeDNS
}

function adguardFamily() {
	PROVIDER="Adguard Family"
	NEW_DNS="94.140.14.15"
	clear
	header
	echo
	changeDNS
}

function quad9() {
	PROVIDER="Quad 9"
	NEW_DNS="9.9.9.9"
	clear
	header
	echo
	changeDNS
}

function customDNS() {
	clear
	header
	echo
	read -p " Type DNS IP address (press c to cancel): " NEW_DNS
	[[ ${NEW_DNS,,} == "c" ]] && DNSOption
	[[ -z ${NEW_DNS} ]] && customDNS
	PROVIDER=custom
	changeDNS
}

function reinstall() {
	clear
	header
	echo
	read -p " Do you want to reinstall Helium? [y/n]: " REINSTALL
	[[ ${REINSTALL,,} != "y" ]] && mainMenu
	echo -e -n " Reinstalling Helium..."
	sleep 2
	[[ ! -e /etc/dnsmasq ]] && mkdir -p /etc/dnsmasq
	echo "nameserver 1.1.1.1" >/etc/resolv.conf
	echo
	apt update && apt install -y dnsmasq dnsutils vnstat resolvconf
	systemctl enable dnsmasq >/dev/null 2>&1
	rm -rf /etc/dnsmasq.conf
	wget -q -O /etc/dnsmasq.conf "https://raw.githubusercontent.com/abidarwish/helium/main/dnsmasq.conf"
	sed -i "s/YourPublicIP/${publicIP}/" /etc/dnsmasq.conf
	rm -rf ${providers}
	wget -q -O ${providers} "https://raw.githubusercontent.com/abidarwish/helium/main/providers.txt"
	rm -rf /usr/local/sbin/helium_daily
	wget -q -O /usr/local/sbin/helium_daily "https://raw.githubusercontent.com/abidarwish/helium/main/helium_daily.sh"
	chmod 755 /usr/local/sbin/helium_daily
	sed -i '/helium_daily/d' /etc/crontab
	echo -e "0 4 * * * root helium_daily # Helium by Abi Darwish" >>/etc/crontab
	updateEngine
	echo "nameserver 127.0.0.1" >/etc/resolv.conf
	>/etc/resolvconf/resolv.conf.d/head
	sleep 1
        clear
        header
        echo
	echo -e -n " Reinstallation completed"
	sleep 1
	echo
	echo
	echo -e " Type \e[1;32mhelium\e[0m to start"
	echo
	exit 0
}

function uninstall() {
	clear
	header
	echo
	read -p " Do you want to uninstall Helium? [y/n]: " UNINSTALL
	[[ ${UNINSTALL,,} != "y" ]] && mainMenu
	echo -e -n " Uninstalling Helium..."
	systemctl stop dnsmasq >/dev/null 2>&1
	systemctl disable dnsmasq >/dev/null 2>&1
	apt remove -y dnsmasq >/dev/null 2>&1
	rm -rf /etc/dnsmasq
	rm -rf /usr/local/sbin/helium_daily
	sed -i '/helium_daily/d' /etc/crontab
	>/etc/resolvconf/resolv.conf.d/head
	#mv /etc/resolv.conf.bak /etc/resolv.conf
        echo -e "nameserver 1.1.1.1" >/etc/resolv.conf
	sleep 2
	echo -e $GREEN"done"$NOCOLOR
	echo
	rm -rf /usr/local/sbin/helium
	exit 0
}

function updateEngine() {
	echo -e -n " Updating blocked hostnames..."
	>${tempHostsList}
	while IFS= read -r line; do
		list_url=$(echo $line | grep -E -v "^#" | cut -d '"' -f2)
		#curl "${list_url}" 2>/dev/null | sed -E '/^!/d' | sed '/#/d' | sed -E 's/^\|\|/0.0.0.0 /g' | awk -F '^' '{print $1}' | grep -E "^0.0.0.0" >>${tempHostsList}
		curl "${list_url}" 2>/dev/null | sed -E '/^!/d' | sed '/#/d' | sed -E 's/^\|\|/0.0.0.0 /g' | sed 's/^127.0.0.1 //g' | awk -F '^' '{print $1}' | sed '/^$/d' | sed 's/^0.0.0.0 //g' | sed 's/^/0.0.0.0 /g' | grep -E "^0.0.0.0" >>${tempHostsList}
	done <${providers}
	[[ ! -z $(ip a | grep -w "inet6") ]] && grep -E "^0.0.0.0" ${tempHostsList} | sed -E 's/^0.0.0.0/::1/g' >>${tempHostsList}
	cat ${tempHostsList} | sed '/^$/d' | sed -E '/^0.0.0.0 0.0.0.0|^::1 0.0.0.0/d' | sort | uniq >${dnsmasqHostFinalList}
	[[ ! -e /etc/dnsmasq/whitelist.hosts ]] && touch /etc/dnsmasq/whitelist.hosts
	DATA=$(cat /etc/dnsmasq/whitelist.hosts)
	for HOSTNAME in ${DATA}; do
		sed -E -i "/${HOSTNAME}/d" /etc/dnsmasq/adblock.hosts
	done
	systemctl restart dnsmasq
	echo -e ${GREEN}"done"${NOCOLOR}
	sleep 1
	echo -e -n $GREEN" $(cat ${dnsmasqHostFinalList} | sed '/^$/d' | wc -l) "$NOCOLOR
	echo -e "hostnames have been blocked"
}

function heliumStatus() {
	HELIUM_NAMESERVER=$(grep -E "^server" /etc/dnsmasq.conf | head -1 | awk -F= '{print $2}')
	BLOCKED_HOSTNAME=$(cat ${dnsmasqHostFinalList} | wc -l)
	NAMESERVER=$(grep -E "^nameserver" /etc/resolv.conf | head -1 | awk '{print $2}')
	ACTIVE_SINCE=$(systemctl status dnsmasq.service | sed -ne 's|^.*active (running).*; \(.*\)$|\1|p')
	echo -e " ${WHITE}System Status${NOCOLOR}"
	if [[ $(systemctl is-active dnsmasq) == active ]]; then
        	printf " %-25s %1s ${GREEN}%7s${NOCOLOR}" "DNSMasq" ":" "running"
        	printf "\n %-25s %1s ${GREEN}%7s${NOCOLOR}" "Nameserver" ":" "${HELIUM_NAMESERVER}"
        	printf "\n %-25s %1s ${GREEN}%'d${NOCOLOR}" "Blocked Hostnames" ":" "${BLOCKED_HOSTNAME}"
		printf "\n %-25s %1s ${GREEN}%-7s\n${NOCOLOR}" "Active since" ":" "${ACTIVE_SINCE}"
	else
        	printf " %-25s %1s ${RED}%7s${NOCOLOR}" "DNSMasq" ":" "stopped"
        	printf "\n %-25s %1s ${RED}%7s${NOCOLOR}" "Nameserver" ":" "${NAMESERVER}"
        	printf "\n %-25s %1s ${RED}%'d\n${NOCOLOR}" "Blocked hostnames" ":" "0"
	fi
}

function listUpdate() {
	clear
	header
	echo
        heliumStatus
        echo
	read -p " Do you want to update blocked hostnames? [y/n]: " UPDATE
	[[ ${UPDATE,,} != "y" ]] && mainMenu
	updateEngine
	echo
	read -p " Press Enter to continue..."
	mainMenu
}

function activateProvider() {
	clear
	header
	echo
	[[ ! -e /etc/dnsmasq/providers.tmp ]] && cp /etc/dnsmasq/providers.txt /etc/dnsmasq/providers.tmp
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "PROVIDERS" "STATUS"
	echo " --------------------------------------"
	while IFS= read -r line; do
		ACTIVE_PROVIDER=$(echo $line | grep -v -E "^#" | cut -d '=' -f1)
		INACTIVE_PROVIDER=$(echo $line | grep -E "^#" | cut -d '=' -f1 | sed -E 's/^#//g')
		if [[ $(echo $line | grep -v -c -E "^#") -gt 0 ]]; then
			printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_PROVIDER}" "active"
		else
			printf " %-25s \e[1;31m%12s\e[0m\n" "${INACTIVE_PROVIDER}" "inactive"
		fi
	done </etc/dnsmasq/providers.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt) ]]; then
		read -p " Select a provider to be activated
 (press s to save changes or c to cancel): " SELECT
		if [[ ${SELECT,,} == "s" ]]; then
			mv /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt
			echo " Applying changes..."
			updateEngine
			echo
			read -p " Press Enter to continue..."
			mainMenu
		fi
	else
		read -p " Select a provider to be activated
 (press c to cancel): " SELECT
	fi
	if [[ ${SELECT,,} == "c" ]]; then
		rm -rf /etc/dnsmasq/providers.tmp
		mainMenu
	fi
	[[ -z $SELECT ]] && activateProvider
	if [[ $(grep -E -c -w "^#${SELECT}" /etc/dnsmasq/providers.tmp) -ne 0 ]]; then
		sed -E -i "s/^\#${SELECT}/${SELECT}/" /etc/dnsmasq/providers.tmp
		activateProvider
	else
		if [[ $(grep -E -c -w "^${SELECT}" /etc/dnsmasq/providers.tmp) -ne 0  ]]; then
			echo -e " ${SELECT} is already active"
		else
			echo -e " ${SELECT} is not in the list"
		fi
	fi
	echo
	read -p " Press Enter to continue..."
	activateProvider
}

function deactivateProvider() {
	clear
	header
	echo
	[[ ! -e /etc/dnsmasq/providers.tmp ]] && cp /etc/dnsmasq/providers.txt /etc/dnsmasq/providers.tmp
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "PROVIDERS" "STATUS"
	echo " --------------------------------------"
	while IFS= read -r line; do
		ACTIVE_PROVIDER=$(echo $line | grep -v -E "^#" | cut -d '=' -f1)
		INACTIVE_PROVIDER=$(echo $line | grep -E "^#" | cut -d '=' -f1 | sed -E 's/^#//g')
		if [[ $(echo $line | grep -v -c -E "^#") -gt 0 ]]; then
			printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_PROVIDER}" "active"
		else
			printf " %-25s \e[1;31m%12s\e[0m\n" "${INACTIVE_PROVIDER}" "inactive"
		fi
	done </etc/dnsmasq/providers.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt) ]]; then
		read -p " Select a provider to be activated
 (press s to save changes or c to cancel): " SELECT
		if [[ ${SELECT,,} == "s" ]]; then
			mv /etc/dnsmasq/providers.tmp /etc/dnsmasq/providers.txt
			echo " Applying changes..."
			updateEngine
			echo
			read -p " Press Enter to continue..."
			mainMenu
		fi
	else
		read -p " Select a provider to be deactivated
 (press c to cancel): " SELECT
	fi
	if [[ ${SELECT,,} == "c" ]]; then
		rm -rf /etc/dnsmasq/providers.tmp
		mainMenu
	fi
	[[ -z $SELECT ]] && deactivateProvider
	if [[ $(grep -E -c -w "^${SELECT}" /etc/dnsmasq/providers.tmp) -ne 0 ]]; then
		sed -E -i "s/^${SELECT}/\#${SELECT}/" /etc/dnsmasq/providers.tmp
		deactivateProvider
	else
		if [[ $(grep -E -c -w "^#${SELECT}" /etc/dnsmasq/providers.tmp) -ne 0  ]]; then
			echo -e " ${SELECT} is already inactive"
		else
			echo -e " ${SELECT} is not in the list"
		fi
	fi
	echo
	read -p " Press Enter to continue..."
	deactivateProvider
}

function whitelistHost() {
	clear
	header
	echo
	[[ ! -e /etc/dnsmasq/whitelist.hosts ]] && touch /etc/dnsmasq/whitelist.hosts
	[[ ! -e /etc/dnsmasq/whitelist.hosts.tmp ]] && cp /etc/dnsmasq/whitelist.hosts /etc/dnsmasq/whitelist.hosts.tmp
	printf " ${WHITE}%-26s %10s${NOCOLOR}\n" "HOST" "STATUS"
	echo " --------------------------------------"
	[[ -z $(cat /etc/dnsmasq/whitelist.hosts.tmp) ]] && echo -e " List is empty"
	while IFS= read -r line; do
		ACTIVE_HOST=$(echo $line)
		printf " %-25s \e[1;32m%12s\e[0m\n" "${ACTIVE_HOST}" "whitelisted"
	done </etc/dnsmasq/whitelist.hosts.tmp
	echo
	if [[ ! -z $(diff -q /etc/dnsmasq/whitelist.hosts.tmp /etc/dnsmasq/whitelist.hosts) ]]; then
		read -p " Select a url from above to delete or type a new one to whitelist
 (press s to save changes or c to cancel): " SELECT
		if [[ ${SELECT,,} == "s" ]]; then
			mv /etc/dnsmasq/whitelist.hosts.tmp /etc/dnsmasq/whitelist.hosts
			updateEngine
			echo
			read -p " Press Enter to continue..."
			mainMenu
		fi
	else
		read -p " Select a url from above to delete or type a new one to whitelist
 (press c to cancel): " SELECT
	fi
	if [[ ${SELECT,,} == "c" ]]; then
		rm -rf /etc/dnsmasq/whitelist.hosts.tmp
		mainMenu
	fi
	if [[ ${SELECT} == "s" ]]; then
		whitelistHost
	fi
	[[ -z $SELECT ]] && whitelistHost
	if [[ $(grep -c -w "${SELECT}" /etc/dnsmasq/whitelist.hosts.tmp) == 0 ]]; then
		echo "${SELECT}" >>/etc/dnsmasq/whitelist.hosts.tmp
		sed -i '/^$/d' /etc/dnsmasq/whitelist.hosts.tmp
		whitelistHost
	else
		read -p " Do you want to delete this url? [y/n]: " DELETE
		if [[ ${DELETE,,} == "y" ]]; then
			sed -E -i "/^${SELECT}/d" /etc/dnsmasq/whitelist.hosts.tmp
			whitelistHost
		else
			whitelistHost
		fi
	fi
}

function cleaner() {
	clear
	header
	echo
        heliumStatus
        echo
	read -p " Do you want to cleanup the database? [y/n]: " CLEANUP
	[[ ${CLEANUP,,} != "y" ]] && mainMenu
	OLD_DATABASE=$(cat /etc/dnsmasq/adblock.hosts | sed '/^$/d' | wc -l)
	echo -e -n " Checking database..."
	sleep 2
	#rm -rf /etc/dnsmasq/dead.hosts
	#wget -q -O /etc/dnsmasq/dead.hosts "https://raw.githubusercontent.com/abidarwish/helium/main/dead.hosts"
	DATA=$(awk '{print $1}' /etc/dnsmasq/dead.hosts)
	for URL in ${DATA}; do
		sed -E -i "/^0.0.0.0 ${URL}$|^::1 ${URL}$/d" /etc/dnsmasq/adblock.hosts
		echo -e -n "\n ${URL}\t"
		echo -e -n ${RED}"deleted"${NOCOLOR}
	done
	NEW_DATABASE=$(cat /etc/dnsmasq/adblock.hosts | sed '/^$/d' | wc -l)
	DELETED_HOSTNAMES=$((OLD_DATABASE - NEW_DATABASE))
	printf "\n \e[1;32m%'d\e[0m %-10s\n" "${DELETED_HOSTNAMES}" "dead hostnames have been deleted from the database"
	[[ ${DELETED_HOSTNAMES} -gt 0 ]] && systemctl restart dnsmasq
	echo
	read -p " Press Enter to continue..."
	mainMenu
}

function updateHelium() {
	clear
	header
	echo
	echo -e -n " Checking for update..."
	sleep 1
	rm -rf /tmp/helium.tmp
	wget -q -O /tmp/helium.tmp "https://raw.githubusercontent.com/abidarwish/helium/main/helium.sh"
	LATEST_HELIUM=$(grep -w "VERSIONNUMBER=" /tmp/helium.tmp | awk -F'"' '{print $2}' | head -n 1)
	INSTALLED_HELIUM=$(grep -w "VERSIONNUMBER=" /usr/local/sbin/helium | awk -F'"' '{print $2}' | head -n 1)
	if [[ ${INSTALLED_HELIUM} == ${LATEST_HELIUM} ]]; then
		echo -e -n "\n Your Helium v${VERSIONNUMBER} is the latest version"
		echo -e -n "\n No need to update"
		echo
		echo
		read -p " Press Enter to continue..."
		rm -rf /tmp/helium.tmp
		mainMenu
	fi
	echo -n -e "\n New Helium v${LATEST_HELIUM} is available"
	echo
	echo
	read -p " Do you want to update? [y/n]: " UPDATE
	if [[ ${UPDATE,,} != "y" ]]; then
		rm -rf /tmp/helium.tmp
		mainMenu
	fi
	read -p " Do you want to overwrite the existing providers? [y/n]: " OVERWRITE
	echo -n -e " Updating Helium..."
	if [[ ${OVERWRITE,,} == "y" ]]; then
		rm -rf /etc/dnsmasq/providers.txt
		wget -q -O /etc/dnsmasq/providers.txt "https://raw.githubusercontent.com/abidarwish/helium/main/providers.txt"
	fi
	mv /tmp/helium.tmp /usr/local/sbin/helium
	chmod 755 /usr/local/sbin/helium
	OLD_NAMESERVER=$(grep -w "server" /etc/dnsmasq.conf | awk -F'=' '{print $2}' | head -n 1)
	rm -rf /etc/dnsmasq.conf
	wget -q -O /etc/dnsmasq.conf "https://raw.githubusercontent.com/abidarwish/helium/main/dnsmasq.conf"
	NEW_NAMESERVER=$(grep -w "server" /etc/dnsmasq.conf | awk -F'=' '{print $2}' | head -n 1)
	sed -i "s/${NEW_NAMESERVER}/${OLD_NAMESERVER}/" /etc/dnsmasq.conf
	rm -rf /usr/local/sbin/helium_daily
	wget -q -O /usr/local/sbin/helium_daily "https://raw.githubusercontent.com/abidarwish/helium/main/helium_daily.sh"
	chmod 755 /usr/local/sbin/helium_daily
	sed -i '/helium_daily/d' /etc/crontab
	echo -e "0 4 * * * root helium_daily # Helium by Abi Darwish" >>/etc/crontab
	echo
	updateEngine
	sleep 1
	echo
	echo -e " Type \e[1;32mhelium\e[0m to start"
	echo
	exit 0
}

function mainMenu() {
	clear
	header
	echo
	heliumStatus
	echo
	echo -e " \e[1mMachine Info\e[0m"
	CPU=$(cat /proc/cpuinfo | grep "model\|Model" | tail -n 1 | awk -F: '{print $2}' | cut -d " " -f2-4)
	CPU_CORE=$(lscpu | grep "CPU(s)" | head -n 1 | awk '{print $2}')
	CPU_MHZ=$(lscpu | grep "MHz" | head -n 1 | sed 's/ //g' | awk -F: '{print $2}' | cut -d. -f1)
	OS=$(cat /etc/os-release | grep "PRETTY_NAME" | awk -F\" '{print $2}')
	KERNEL=$(uname -r)
	RAM_USED=$(free -m | grep Mem: | awk '{print $3}')
	TOTAL_RAM=$(free -m | grep Mem: | awk '{print $2}')
	RAM_USAGE=$(echo "scale=2; ($RAM_USED / $TOTAL_RAM) * 100" | bc | cut -d. -f1)
	UPTIME=$(uptime -p | sed 's/,//g' | awk '{print $2,$3", "$4,$5}')
	DAILY_USAGE=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
	MONTHLY_USAGE=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
	if [[ ${CPU_CORE} == 1 ]]; then
		printf " %-25s %1s %-7s\e[0m" "CPU (single core)" ":" "${CPU} @ ${CPU_MHZ}Mhz"
	else
		printf " %-25s %1s %-7s\e[0m" "CPU (${CPU_CORE} cores)" ":" "${CPU} @ ${CPU_MHZ}Mhz"
	fi
	printf "\n %-25s %1s %-7s\e[0m" "OS Version" ":" "${OS}"
	printf "\n %-25s %1s %-7s\e[0m" "Kernel Version" ":" "${KERNEL}"
	printf "\n %-25s %1s %-7s\e[0m" "RAM Usage" ":" "${RAM_USED}MB / ${TOTAL_RAM}MB (${RAM_USAGE}%)"
	printf "\n %-25s %1s %-7s\e[0m" "Uptime" ":" "${UPTIME}"
	printf "\n %-25s %1s %-7s\e[0m" "IP Address" ":" "${publicIP}"
	printf "\n %-25s %1s %-7s\e[0m" "Daily Data Usage" ":" "${DAILY_USAGE}"
	printf "\n %-25s %1s %-7s\e[0m" "Monthly Data Usage" ":" "${MONTHLY_USAGE}"
	echo
	echo
	echo -e $WHITE" Manage Helium"$NOCOLOR
	echo -e " [ 1] Start Dnsmasq\t   [ 6] Whitelist host
 [ 2] Stop Dnsmasq\t   [ 7] Change DNS
 [ 3] Update database\t   [ 8] Update Helium
 [ 4] Activate provider\t   [ 9] Uninstall Helium
 [ 5] Deactivate provider  [10] Back To Menu"
	echo
	read -p $' Enter option [1-10]: ' MENU_OPTION
	case ${MENU_OPTION} in
	1)
		start
		;;
	2)
		stop
		;;
	3)
		listUpdate
		;;
	4)
		activateProvider
		;;
	5)
		deactivateProvider
		;;
	6)
		whitelistHost
		;;
	7)
		DNSOption
		;;
	8)
		updateHelium
		;;
	9)
		uninstall
		;;
  10) clear ; exit ; m-system ;;
	*)
		mainMenu
		;;
	esac
}

initialCheck
if [[ ! -z $(which dnsmasq) ]] && [[ -e /etc/dnsmasq ]]; then
	mainMenu
else
	clear
	header
	echo
	install
fi
