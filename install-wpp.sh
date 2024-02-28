#!/bin/bash

# Script de instalação

# Função para verificar e instalar pacotes
check_install() {
    if ! command -v "$1" &> /dev/null; then
        echo "Instalando $1"
        apt install -y "$1"
        sleep 2
        clear
    else
        echo "$1 já está instalado"
    fi
}

# Verifique e instale o curl
check_install "curl"

# Criar diretório /opt/limazap
echo "Criando diretorio"
sleep 1
clear
mkdir -p /opt/limazap

# Acesse o diretório /opt/limazap
echo "Acessando diretorio"
cd /opt/limazap
sleep 1
clear

# Instale as bibliotecas necessárias
check_install "build-essential"
check_install "libgbm-dev"

# Baixe o Google Chrome se não existir
chrome_deb_file="/opt/limazap/google-chrome-stable_current_amd64.deb"
if [ ! -f "$chrome_deb_file" ]; then
    echo "Baixando o Google Chrome"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O "$chrome_deb_file"
    sleep 2
    clear
else
    echo "Google Chrome já foi baixado"
fi

# Instale o Google Chrome
check_install "google-chrome-stable"

# Instale npm, pm2, e node
check_install "npm"
npm install -g pm2
npm install -g n

# Inicie o node
echo "Iniciando node"
npm init -y
sleep 1
clear

# Instale as dependências
npm install puppeteer@latest
npm install whatsapp-web.js
npm install express
npm install qrcode-terminal
npm install multer
npm install moment-timezone


# Baixe os arquivos do GitHub
wget -O index.js https://raw.githubusercontent.com/limatecnologia/whatsapp/main/index.js
wget -O limazap.js https://raw.githubusercontent.com/limatecnologia/whatsapp/main/limazap.js
wget -O limazap https://raw.githubusercontent.com/limatecnologia/whatsapp/main/limazap
chmod +x limazap
clear
sleep 5
clear

# Atualize o node
#echo "Atualizando o node"
#curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && source ~/.profile && nvm install 18 && nvm use 18
#sleep 2
#clear

# Limpeza
cd /opt/limazap
rm -rf google-chrome-stable_current_amd64.deb

echo "Instalação concluída com sucesso!"
