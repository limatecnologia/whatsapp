#!/bin/bash

# Função para verificar e instalar pacotes
check_install() {
    if ! command -v "$1" &> /dev/null; then
        echo "Instalando $1"
        apt install -y "$1"
        sleep 2
        clear
    else
        echo "$1 já está instalado"
        sleep 1
        clear
    fi
}

# Verifique e instale o os pacotes
check_install "curl"
check_install "nodejs"
check_install "npm"

# Atualize o node
#echo "Atualizando o node"
#curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source ~/.profile && nvm install 20 && nvm use 20

clear

https://raw.githubusercontent.com/limatecnologia/whatsapp/main/install-wpp.sh
chmod +x install-wpp.sh
./install-wpp.sh
