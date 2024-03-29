# Escolha uma imagem base que suporte os módulos do kernel necessários para o redroid
FROM ubuntu:20.04

# Atualize os pacotes e instale as dependências necessárias
RUN apt-get update && \
    apt-get install -y wget software-properties-common apt-transport-https && \
    wget -qO - https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Instale os módulos do kernel necessários para o redroid
RUN apt-get install -y linux-modules-extra-$(uname -r) && \
    modprobe binder_linux devices="binder,hwbinder,vndbinder" && \
    modprobe ashmem_linux

# Instale o adb e o scrcpy para conectar e visualizar a tela do redroid
RUN apt-get install -y adb scrcpy

# Baixe a imagem mais recente do redroid
RUN docker pull redroid/redroid:11.0.0-latest

# Execute o container redroid com as configurações necessárias
CMD ["docker", "run", "-itd", "--rm", "--privileged", \
     "--pull", "always", \
     "-v", "/data:/data", \
     "-p", "5555:5555", \
     "redroid/redroid:11.0.0-latest"]