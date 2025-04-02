# AWS DevOps Stack: Docker, EC2, RDS and Load Balancing for WordPress. (NOVO USANDO OQUE O DAVI MANDOU, UNICO JEITO FOI POR A PORRA DE BAST HOST E REPLICAR A INSTANCIA, ESTA FALTANDO A MERDA DAS IMAGENS E A PORRA DO CLOUD WATCH QUE NÃO FUNCIONA AGORA)

Este projeto implanta WordPress com Docker em uma VPC na AWS, usando EC2, RDS (MySQL), EFS e Classic Load Balancer. O *user_data.sh* automatiza a configuração, garantindo escalabilidade e alta disponibilidade. A abordagem segue boas práticas de DevOps, permitindo implantação eficiente e reprodutível.

## Índice

1. [Resumo](#resumo)

2. [Objetivos](#objetivos)

3. [Arquitetura do Projeto e Tecnologias](#arquitetura-do-projeto-e-tecnologias)

4. [Criação da Infraestrutura na AWS](#criação-da-infraestrutura-na-aws)
   
5. [Considerações Finais](#considerações-finais)

6. [Referências](#referências)


----------------------------------------------------------------------------------------


# 1. Resumo

<div>
<details align="left">
    <summary></summary>

Este projeto consistiu na implementação de uma infraestrutura escalável na AWS para hospedar um site WordPress. Foi criada uma VPC, configurada uma instância EC2 com Docker e integrado um banco de dados gerenciado no Amazon RDS. A automação foi realizada via User Data, garantindo a inicialização automática do ambiente. Para garantir alta disponibilidade e desempenho, foram implementados um Auto Scaling Group e um Balanceador de Carga, além do monitoramento via CloudWatch. O resultado foi um sistema robusto, flexível e preparado para lidar com diferentes volumes de tráfego de forma eficiente.

</div>

# 2. Objetivos

<div>
<details align="left">
    <summary></summary>

Este projeto teve como objetivo a implementação de uma infraestrutura escalável e segura na AWS para hospedar um site WordPress, utilizando diversos serviços que garantem alta disponibilidade e desempenho. A criação da VPC permitiu a segmentação adequada da rede, garantindo maior controle sobre a comunicação entre os recursos. Em seguida, foi configurada uma instância EC2 onde foi instalado o Docker para facilitar a implantação e gerenciamento do WordPress.

Para o armazenamento dos dados, utilizamos o Amazon RDS, um serviço gerenciado que proporciona mais segurança e desempenho ao banco de dados. Além disso, foi implementado um script de inicialização no User Data da EC2, garantindo que a instância fosse provisionada corretamente e estivesse pronta para rodar o WordPress de forma automática.

A escalabilidade foi um fator essencial no projeto, sendo implementado um Auto Scaling Group juntamente com um Balanceador de Carga, o que permitiu a distribuição eficiente do tráfego e a criação automática de novas instâncias conforme a demanda aumentasse. Para garantir a estabilidade do ambiente, também foram definidas regras de escalonamento e configurado um monitoramento no CloudWatch, possibilitando a observação contínua do desempenho da infraestrutura.

</div>

# 3. Arquitetura do projeto e tecnologias

<div>
<details align="left">
    <summary></summary>

   **Arquitetura do projeto**

   ![Image](https://github.com/user-attachments/assets/e1cf6ff8-f0d6-4727-ba68-9a460841d43f)

   **Tecnologias**
   . Provisionamento da Instância EC2
   AWS EC2: Máquinas virtuais na AWS para hospedar os containers.
   User Data (user_data.sh): Script para automação da instalação do Docker na inicialização da instância.
   Docker: Engine para criação e gerenciamento dos containers.

   . Deploy do Wordpress em Containers
   Dockerfile / Docker Compose: Arquivo de configuração para criação e gerenciamento dos containers do WordPress e MySQL.
   WordPress Container: Aplicação principal rodando como container.
   AWS RDS (MySQL): Banco de dados gerenciado para armazenar os dados do WordPress.

   . Armazenamento e Arquivos Estáticos
   AWS EFS (Elastic File System): Sistema de arquivos distribuído para armazenar arquivos estáticos do WordPress.

   . Balanceamento de Carga e Configuração de Rede
   AWS Load Balancer (Classic Load Balancer - CLB): Para gerenciar o tráfego e distribuir conexões entre múltiplas instâncias de WordPress.
   VPC Privada: Para garantir que o WordPress não exponha um IP público diretamente.
   Regras de Segurança (Security Groups): Configuração para permitir tráfego somente pelo Load Balancer.

</div>

# 4. Criação da Infraestrutura na AWS

<div>
<details align="left">
    <summary></summary>

A infraestrutura proposta para o deploy do WordPress na AWS segue boas práticas de escalabilidade, segurança e automação. A instância EC2 é configurada automaticamente via User Data (user_data.sh) para instalar Docker ou Containerd, garantindo um ambiente replicável. O WordPress roda em um container, enquanto o banco de dados é gerenciado pelo AWS RDS (MySQL), assegurando persistência e desempenho.
Para armazenar arquivos estáticos, utiliza-se o AWS EFS, permitindo compartilhamento entre múltiplas instâncias. O tráfego de rede é gerenciado por um Classic Load Balancer (CLB), evitando a exposição direta do IP público e distribuindo conexões para maior disponibilidade. A infraestrutura é protegida por Security Groups, garantindo acesso controlado.

   # 4.1 Criar VPC;

<div>
<details align="left">
    <summary></summary>
O primeiro passo do nosso projeto, é a criação de uma VPC.

- Bloco CIDR IPv4: 10.0.0.0/16
- Número de Zonas de Disponibilidade (AZs): 2
- Sub-redes: 2 públicas e 2 privadas
- Gateway NAT: 1 por AZ

</div>

   # 4.2 Grupo de Segurança

<div>
<details align="left">
    <summary></summary>

   No **Painel da VPC**, localizado no menu lateral esquerdo, clique na opção **"Gateways NAT"** e, em seguida, selecione **"Criar gateway NAT"**. No campo de nome, defina um identificador para o gateway. Escolha a **sub-rede pública** correspondente e mantenha a configuração padrão **"Público"** no campo **"Tipo de conectividade"**. Para concluir o processo, clique na opção **"Alocar IP elástico"**.

   ![Image](https://github.com/user-attachments/assets/b5518534-bc79-4c88-899a-47c359d4707f)

- sgGroup-loadbalancer:
   HTTP / HTTPS => IPV4
  
- sgGroup-ec2:
  HTTP / HTTPS => Load Balancer
  SSH => Qualquer IP
  
- sgGroup-rds:
  MySQL/Aurora => sgGroup-ec2
  
- sgGroup-efs:
  NFS => sgGroup-ec2
  
</div>

   # 4.3 RDS;

<div>
<details align="left">
    <summary></summary>
O Amazon RDS (Relational Database Service) facilita a configuração, manutenção e escalabilidade de bancos de dados relacionais. Para aumentar a segurança, é essencial utilizar grupos de sub-redes em sub-redes privadas, impedindo o acesso direto à internet e restringindo conexões apenas a instâncias autorizadas. Por esse motivo, o primeiro passo será a criação do grupo de sub-redes privadas.

**Grupo de Sub-redes Privadas**
- Vá em serviço RDS e acesse a aba "Grupos de sub-redes"
- Clicar em Criar Grupo de sub-redes
- Informações
    Nome do Grupo: ___________
    Descrição: _____________
    VPC: Selecione a VPC que você criou
- Selecionar as zonas de disponibilidas, em seguida, selecionar sub-redes privadas
- Criar Grupo

  **Configuração do RDS**

- Tipo de banco de dados: MySQL (Nível gratuito).
- Preencher Identificador da instância
- Preencher nome do usuário Principal
- Senha
- Selecionar instância: db.t3.micro
- Desative Backup e Cripografia para testes
- Selecionar VPC Criada
- Selecionar Grupo de sub-redes já criado
- Não permitir acesso público
- Adicionar Grupo de Segurança: sgGroup-rds
- Nome do Banco de dados inicial: wordpress
- Desmarcar escalabilidade automática de armazenamento

**Ao criar o RDS, será gerado um IP, salve o IP para acessar o banco para adicionar no nosso arquivo user_data.sh**

</div>

   # 4.4 EFS;

<div>
<details align="left">
    <summary></summary>

- Nome: meuEFS
- Selecionar VPC criada
- Zonas de disponibilidade: selecionar sub-redes privadas 1 e 2
- Selecionar grupo de segurança: sgGroup-efs
- Após a criação, você vai acessar o comando de Anexar e "Usando o cliente do NFS"
- Você vai ter que copiar e salvar o comando de montagem do sistema de arquivo Amazon EFS, localizado no arquivo user_data.sh
- Como estamos utilizando Ubuntu, precisamos instalar o Rust para criar o processo de build do nosso EFS e permitir sua montagem em nossa instância.

**Instalação do EFS Utils**

     sudo apt-get update
     sudo apt-get -y install git binutils rustc cargo pkg-config libssl-dev
     git clone https://github.com/aws/efs-utils
     cd efs-utils
     ./build-deb.sh
     sudo apt-get -y install ./build/amazon-efs-utils*deb

**Montagem do sistema de Arquivos**

    sudo mkdir -p /mnt/efs
    sudo mount -t efs -o tls fs-12345678:/ /mnt/efs

Agora, ao criar um arquivo nesse diretório e acessá-lo a partir de outra instância conectada ao mesmo sistema de arquivos, o arquivo estará disponível em ambas.

</div>

# 4.5 EC2;

<div>
<details align="left">
    <summary></summary>

- Nome e tags: Seguir o padrão da equipe.
- Sistema operacional: Ubuntu.
- Tipo de instância: Padrão.
- Par de chaves: Criar ou reutilizar um existente.
- Sub-redes:
    Instância 1: Sub-rede privada 1.
    Instância 2: Sub-rede privada 2.
- Atribuir IP público automaticamente: Habilitado.
- Grupo de segurança: sgGroup-ec2
  
**Em Configurações avançadas, adicione o user_data.sh.**

</div>

# 4.6 Load Balancer;

<div>
<details align="left">
    <summary></summary>

-Tipo: Classic Load Balancer.
- Nome: MyLoadBalancer.
- Mapeamento de rede: Sub-redes públicas.
- Grupo de segurança: sgGroup-loadbalancer
- Caminho de ping: /wp-admin/install.php (espera-se retorno com status 200).
- Selecionar as duas instâncias que criamos privadas que criamos no tópico de EC2.

</div>

# 4.7 Auto Scaling;

<div>
<details align="left">
    <summary></summary>

Modelo de Execução (launch Template):

- Tipo de instância: t2.micro
- Tags e User Data: Mesmos das instâncias EC2 anteriores
- Zonas de disponibilidade: Sub-redes privadas
- Integração: Load Balancer existente
- Demais configurações: Padrão

Após configurar o Auto Scaling, uma nova instância será criada automaticamente, confirmando que o processo foi concluído com sucesso.

</div>


# 4.8 Validação dos sistemas de arquivos;

<div>
<details align="left">
    <summary></summary>

Foi criado um Bastion Host, um servidor que permite o acesso seguro a uma rede privada a partir da internet pública. Para isso, criaremos uma instância pública, nos conectaremos a ela via SSH e, estando dentro da nossa VPC, acessaremos outras instâncias privadas. Em uma dessas instâncias, criaremos um arquivo dentro da pasta EFS, chamado helloworld.txt

**Instância 1 - EC2**

- Criamos o arquivo na instância 1

![Image](https://github.com/user-attachments/assets/41b9adeb-00fa-4e1e-88dc-e24aac2dc13d)

**InstÂncia 2 - EC2**

- Temos acesso ao arquivo criado na instância 1 que está presente no nosso sistema de arquivos.

![Image](https://github.com/user-attachments/assets/570b9963-4005-4ee7-a062-4762339ddec9)

</div>

# 4.9 TESTE FINAL

<div>
<details align="left">
    <summary></summary>

Para verificar se tudo está operando corretamente, basta acessar o DNS do Load Balancer e estabelecer a conexão com o projeto. Caso a página exibida corresponda à imagem abaixo, significa que seu serviço foi implementado com sucesso.

![Image](https://github.com/user-attachments/assets/84da9c4f-0ffd-4b6a-aa70-d64b8916e04b)

</div>

# 4.10 Arquivos e Códigos

<div>
<details align="left">
    <summary></summary>

    #!/bin/bash

    # Atualiza o sistema e instala dependências
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y docker.io
    sudo apt-get install -y mysql-client

    sudo apt install -y nfs-common

## Montagem para Linux 
    sudo apt-get -y install git binutils rustc cargo pkg-config libssl-dev
    git clone https://github.com/aws/efs-utils
    cd efs-utils
    ./build-deb.sh
    sudo apt-get -y install ./build/amazon-efs-utils*deb

# Cria o diretório efs 
    sudo mkdir -p /mnt/efs

    sudo mount -t efs -o tls fs-(id):/ efs

# Instalar docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

# Adicionar usuário ao grupo docker
    sudo usermod -aG docker $USER
    newgrp docker

# Configura o diretório para o projeto WordPress
    PROJECT_DIR=/home/ubuntu/wordpress
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R $USER:$USER $PROJECT_DIR
    cd $PROJECT_DIR

# Cria o arquivo docker-compose.yml
    sudo tee docker-compose.yml > /dev/null <<EOL
    version: '3.8'

    services:
      wordpress:
        image: wordpress:latest
        container_name: {name}
        ports:
          - "80:80"
        environment:
          WORDPRESS_DB_HOST: {host}
          WORDPRESS_DB_USER: {user}
          WORDPRESS_DB_PASSWORD: {senha}
          WORDPRESS_DB_NAME: wordpress
        volumes:
          - /mnt/efs:/var/www/html

EOL

# Inicia o Docker Compose
    docker-compose up -d

# Aguarda o container WordPress estar ativo
    echo "Aguardando o container WordPress iniciar..."
    until sudo docker ps | grep -q "Up.*wordpress"; do
      echo "Verificando containers em execução..."
      sudo docker ps
      sleep 5
    done
    echo "Container WordPress iniciado!"


# Adiciona o arquivo healthcheck.php no container WordPress
    echo "Criando o arquivo healthcheck.php no container WordPress..."
    sudo docker exec -i wordpress bash -c "cat <<EOF > /var/www/html/healthcheck.php
    <?php
    http_response_code(200);
    header('Content-Type: application/json');
    echo json_encode([\"status\" => \"OK\", \"message\" => \"Health check passed\"]);
    exit;
    ?>

EOF

# Confirma a criação do arquivo
    if docker exec -i wordpress ls /var/www/html/healthcheck.php > /dev/null 2>&1; then
      echo "Arquivo healthcheck.php criado com sucesso!"
    else
      echo "Falha ao criar o arquivo healthcheck.php."
    fi

</div>








  

   

   

   


