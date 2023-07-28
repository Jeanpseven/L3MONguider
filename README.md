# L3MONguider
ele vai te guiar fazendo os comandos enormes e chatos para iniciar o L3MON e gerar o link para você fazer seu apk e monitorar
![lemonlogo](L3MON.png)

original repo:https://github.com/efxtv/L3MON
---
## L3MON Features
- GPS Logging
- Microphone Recording
- View Contacts
- SMS Logs
- Send SMS
- Call Logs
- View Installed Apps
- View Stub Permissions
- Live Clipboard Logging
- Live Notification Logging
- View WiFi Networks (logs previously seen)
- File Explorer & Downloader
- Command Queuing
- Built In APK Builder
---
O script é projetado para configurar e instalar o aplicativo "L3MON" em um sistema Linux usando a linguagem de programação Python/Bash.

Aqui está uma descrição do que o script faz:

Verifica se o usuário é root ou não (ou seja, se está sendo executado com privilégios de administrador).
Clona o repositório "L3MON" do GitHub para o diretório atual, se ainda não estiver clonado.
Move o próprio script para o diretório clonado do "L3MON".
Instala várias dependências necessárias, como wget, curl, git, npm, nano, nodejs, openjdk-8-jdk e openjdk-8-jre.
Inicia a instalação e configuração do aplicativo "L3MON" por meio do Node.js e PM2.
Solicita ao usuário que insira um nome de usuário (username) e uma senha para o administrador do aplicativo.
Calcula o hash MD5 da senha fornecida pelo usuário.
Cria um arquivo chamado "maindb.json" com os dados fornecidos pelo usuário no formato JSON, incluindo o nome de usuário e a hash MD5 da senha, além de campos adicionais como loginToken, logs e ipLog.
Obtém o IP do sistema e gera um link com base nesse IP, exibindo-o junto com as credenciais do administrador (nome de usuário e senha).
Como usar o script:

Salve o código do script em um arquivo chamado, por exemplo, "configure_l3mon.py".
Abra um terminal e navegue para o diretório onde você salvou o script.
Dê permissão de execução ao script usando o comando chmod +x configure_l3mon.py.
Execute o script usando o comando ./configure_l3mon.py.
Siga as instruções que serão apresentadas pelo script. Ele solicitará que você insira o nome de usuário (username) e a senha para o administrador do aplicativo.
O script então instalará e configurará o aplicativo "L3MON" e criará o arquivo "maindb.json" com as informações fornecidas.
O link de acesso ao aplicativo será gerado e exibido no final da execução do script, juntamente com as credenciais do administrador (nome de usuário e senha) que foram fornecidas.


---
Py/Sh :

# Instruções para o script em Python:

Salve o código do script em um arquivo chamado, por exemplo, "configure_l3mon.py".

Abra um terminal e navegue para o diretório onde você salvou o script.

Dê permissão de execução ao script (se necessário) usando o comando:

bash
Copy code
chmod +x configure_l3mon.py
Execute o script usando o comando:

bash
Copy code
./configure_l3mon.py
O script começará a executar. Siga as instruções fornecidas pelo script para inserir o nome de usuário (username) e a senha do administrador.

O script concluirá a instalação e configuração do aplicativo "L3MON" e gerará um link de acesso ao aplicativo, junto com as credenciais do administrador (nome de usuário e senha) que você forneceu.

# Instruções para o script em Bash:

Salve o código do script em um arquivo chamado, por exemplo, "configure_l3mon.sh".

Abra um terminal e navegue para o diretório onde você salvou o script.

Dê permissão de execução ao script usando o comando:

bash
Copy code
chmod +x configure_l3mon.sh
Execute o script usando o comando:

bash
Copy code
./configure_l3mon.sh
O script começará a executar. Siga as instruções fornecidas pelo script para inserir o nome de usuário (username) e a senha do administrador.

O script concluirá a instalação e configuração do aplicativo "L3MON" e gerará um link de acesso ao aplicativo, junto com as credenciais do administrador (nome de usuário e senha) que você forneceu.

Ambas as versões do script, em Python e em Bash, realizam as mesmas tarefas e oferecem uma experiência similar para o usuário. Escolha a versão que você preferir usar.




