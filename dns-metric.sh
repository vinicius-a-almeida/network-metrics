#!/bin/bash

# Verifica se um domínio foi passado como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <dominio>"
    exit 1
fi

if dpkg-query -W -f='${Status}' dnsutils 2>/dev/null | grep -q "install ok installed"; then
    echo "dig installed"
else
    echo "dig is not installed."
    sudo apt install dnsutils
fi

DOMINIO=$1

# Usa o dig com a opção +stats para obter estatísticas
tempo=$(dig +stats "$DOMINIO" | grep "Query time" | awk '{print $4}')

# Exibe o tempo de resolução
echo "O tempo de resolução de '$DOMINIO' é: $tempo ms"
