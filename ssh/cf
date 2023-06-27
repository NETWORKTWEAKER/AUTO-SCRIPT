#!/bin/bash
clear
apt install jq curl -y
DOMAIN=givpn.online
sub=$(</dev/urandom tr -dc a-z0-9 | head -c4)
SUB_DOMAIN=asx-${sub}.givpn.online
CF_ID=admin@givpn.online
CF_KEY=fa8f8ea9172c18e3b2b689ef3e782f3b308d2
set -euo pipefail
IP=$(wget -qO- ifconfig.me);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo "IP=$SUB_DOMAIN" >> /var/lib/ipvps.conf
echo $SUB_DOMAIN > /root/domain
echo "$SUB_DOMAIN" > /root/scdomain
echo "$SUB_DOMAIN" > /etc/xray/scdomain
echo "$SUB_DOMAIN" > /etc/xray/domain
echo "$SUB_DOMAIN" > /etc/v2ray/domain
echo -e "Done Record Domain= ${SUB_DOMAIN} For VPS"
sleep 2
rm -f /root/cf.sh
