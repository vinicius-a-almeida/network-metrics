#!/bin/bash
touch teste.txt
#for (( c=1; c<=5; c++)) do
while read arg; do
sudo killall -USR2 systemd-resolved
sudo resolvectl flush-caches
sudo killall -USR1 systemd-resolved
#if [ "$#" -ne 1 ]; then
 #   echo "Use: $0 <domain>"
    #exit 1
#fi

if dpkg-query -W -f='${Status}' dnsutils 2>/dev/null | grep -q "install ok installed"; then
    echo ""
else
    echo "dig is not installed."
    sudo apt install dnsutils
fi

DOMAIN=$arg

resolve=$(dig +stats "$DOMAIN" | grep "Query time" | awk '{print $4}')

tcp_connect=$(curl -s -o /dev/null -w "%{time_connect} s" "$DOMAIN")
speed_download=$(curl -s -o /dev/null -w "%{speed_download} B/s" "$DOMAIN")
time_appconnect=$(curl -s -o /dev/null -w "%{time_appconnect} s" "$DOMAIN")
time_connect=$(curl -s -o /dev/null -w "%{time_connect} s" "$DOMAIN")
time_total=$(curl -s -o /dev/null -w "%{time_total} s" "$DOMAIN")
#sleep 30
#printf "%s" "teste"

# curl manual: https://curl.se/docs/manpage.html

printf "%s" "{domain: $DOMAIN, dns-time: $resolve,
tcp_connect: $tcp_connect, speed_download: $speed_download,
time_appconnect: $time_appconnect, time_connect: $time_connect, time_total: $time_total}"


echo "{domain: $DOMAIN, dns-time: $resolve,
tcp_connect: $tcp_connect, speed_download: $speed_download,
time_appconnect: $time_appconnect, time_connect: $time_connect, time_total: $time_total}" >> teste.txt

done

