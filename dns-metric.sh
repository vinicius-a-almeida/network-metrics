#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Use: $0 <domain>"
    exit 1
fi

if dpkg-query -W -f='${Status}' dnsutils 2>/dev/null | grep -q "install ok installed"; then
    echo "dig installed"
else
    echo "dig is not installed."
    sudo apt install dnsutils
fi

DOMAIN=$1

tim=$(dig +stats "$DOMAIN" | grep "Query time" | awk '{print $4}')

echo "The resolution time of '$DOMAIN' is: $tim ms"

curl -s -o /dev/null -w "dns:%{time_namelookup}, redir:%{time_redirect}, tcp:%{time_connect}\n" "$DOMAIN"
