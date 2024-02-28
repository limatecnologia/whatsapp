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
#check_install "nodejs"
#check_install "npm"

# Atualize o node
#echo "Atualizando o node"
#curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source ~/.profile && nvm install 18 && nvm use 18
#sleep 10
clear

apt update
clear
curl -fsSL https://deb.nodesource.com/setup_current | sudo -E bash -
sudo apt-get install -y nodejs
clear

apt install npm

https://raw.githubusercontent.com/limatecnologia/whatsapp/main/install-wpp.sh
chmod +x install-wpp.sh
./install-wpp.sh
