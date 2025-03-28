# AWS DevOps Stack: Docker, EC2, RDS and Load Balancing for WordPress

Este projeto implanta WordPress com Docker em uma VPC na AWS, usando EC2, RDS (MySQL), EFS e Classic Load Balancer. O *user_data.sh* automatiza a configuração, garantindo escalabilidade e alta disponibilidade. A abordagem segue boas práticas de DevOps, permitindo implantação eficiente e reprodutível.

## Índice

1. [Resumo](#resumo)

2. [Objetivos](#objetivos)

3. [Arquitetura do Projeto e Tecnologias](#arquitetura-do-projeto-e-tecnologias)

4. [Criação da Infraestrutura na AWS](#criação-da-infraestrutura-na-aws)
   
   4.1. [Configuração da VPC para segmentação da rede](#configuração-da-vpc-para-segmentação-da-rede)

   4.2. [Provisionamento da Instância EC2 para Hospedar o WordPress](#provisionamento-da-instância-ec2-para-hospedar-o-wordpress)

      4.2.1. [Instalação do Docker na Instância EC2](#instalação-do-docker-na-instância-ec2)

      4.2.2. [Execução do WordPress na EC2 Utilizando Contêineres Docker](#execução-do-wordpress-na-ec2-utilizando-contêineres-docker)

      4.2.3. [Criação e Teste de Script de Inicialização (User Data) para Automação da Configuração da Instância](#criação-e-teste-de-script-de-inicialização-user-data-para-automação-da-configuração-da-instância)

   4.3. [Alta Disponibilidade e Escalabilidade](#alta-disponibilidade-e-escalabilidade)

      4.3.1. [Configuração de um Auto Scaling Group para Ajuste Automático de Capacidade](#configuração-de-um-auto-scaling-group-para-ajuste-automático-de-capacidade)

      4.3.2. [Implementação de um Balanceador de Carga (ELB) para Distribuição do Tráfego entre Instâncias](#implementação-de-um-balanceador-de-carga-elb-para-distribuição-do-tráfego-entre-instâncias)

      4.3.3. [Definição de Regras de Escalonamento para Ajuste Dinâmico com Base na Demanda](#definição-de-regras-de-escalonamento-para-ajuste-dinâmico-com-base-na-demanda)

   4.4. [Monitoramento e Gerenciamento](#monitoramento-e-gerenciamento)

      4.4.1. [Configuração de Métricas e Alarmes no CloudWatch para Monitoramento da Infraestrutura](#configuração-de-métricas-e-alarmes-no-cloudwatch-para-monitoramento-da-infraestrutura)

5. [Considerações Finais](#considerações-finais)

6. [Referências](#referências)





1. [Resumo](#resumo)

Este projeto consistiu na implementação de uma infraestrutura escalável na AWS para hospedar um site WordPress. Foi criada uma VPC, configurada uma instância EC2 com Docker e integrado um banco de dados gerenciado no Amazon RDS. A automação foi realizada via User Data, garantindo a inicialização automática do ambiente. Para garantir alta disponibilidade e desempenho, foram implementados um Auto Scaling Group e um Balanceador de Carga, além do monitoramento via CloudWatch. O resultado foi um sistema robusto, flexível e preparado para lidar com diferentes volumes de tráfego de forma eficiente.




3. [Objetivos](#objetivos)

Este projeto teve como objetivo a implementação de uma infraestrutura escalável e segura na AWS para hospedar um site WordPress, utilizando diversos serviços que garantem alta disponibilidade e desempenho. A criação da VPC permitiu a segmentação adequada da rede, garantindo maior controle sobre a comunicação entre os recursos. Em seguida, foi configurada uma instância EC2 onde foi instalado o Docker para facilitar a implantação e gerenciamento do WordPress.

Para o armazenamento dos dados, utilizamos o Amazon RDS, um serviço gerenciado que proporciona mais segurança e desempenho ao banco de dados. Além disso, foi implementado um script de inicialização no User Data da EC2, garantindo que a instância fosse provisionada corretamente e estivesse pronta para rodar o WordPress de forma automática.

A escalabilidade foi um fator essencial no projeto, sendo implementado um Auto Scaling Group juntamente com um Balanceador de Carga, o que permitiu a distribuição eficiente do tráfego e a criação automática de novas instâncias conforme a demanda aumentasse. Para garantir a estabilidade do ambiente, também foram definidas regras de escalonamento e configurado um monitoramento no CloudWatch, possibilitando a observação contínua do desempenho da infraestrutura.



5. [Arquitetura do Projeto e Tecnologias](#arquitetura-do-projeto-e-tecnologias)

A arquitetura deste projeto foi planejada para garantir **escalabilidade, disponibilidade e segurança**, utilizando serviços gerenciados da AWS. O objetivo foi criar uma infraestrutura capaz de hospedar um site **WordPress** de maneira otimizada, garantindo que o sistema pudesse lidar com variações de tráfego sem comprometer o desempenho.  

### **Divisão da Arquitetura**  

A primeira etapa envolveu a **criação da VPC**, que estabeleceu a base para a comunicação segura entre os serviços. Dentro dela, foram configuradas **sub-redes públicas e privadas**, assegurando que os recursos estivessem distribuídos corretamente.  

A **instância EC2**, onde foi instalado o **Docker**, atuou como o servidor principal para o WordPress. O uso do Docker trouxe benefícios como facilidade na implantação e isolamento da aplicação. Já o banco de dados foi implementado no **Amazon RDS**, permitindo um armazenamento seguro e eficiente, reduzindo a necessidade de manutenção manual.  

Para garantir a **escalabilidade automática**, foi criado um **Auto Scaling Group** associado a um **Load Balancer**, distribuindo o tráfego entre múltiplas instâncias e garantindo alta disponibilidade. Isso permitiu que, em momentos de pico, novas instâncias fossem adicionadas automaticamente e, quando a demanda diminuísse, fossem reduzidas para otimizar custos.  

Além disso, foi configurado um **script no User Data** para que as instâncias EC2 pudessem se inicializar automaticamente com o ambiente configurado corretamente. Isso reduziu a necessidade de intervenção manual e garantiu que todas as instâncias novas estivessem preparadas para rodar o WordPress.  

Por fim, a arquitetura foi complementada com o **monitoramento via CloudWatch**, permitindo o acompanhamento do desempenho da infraestrutura e a definição de **regras de escalonamento** baseadas em métricas como uso de CPU e tráfego de rede.  

### **Pontos Fortes da Arquitetura**  
- **Escalabilidade**: O Auto Scaling Group permite que o sistema se adapte automaticamente à demanda.  
- **Alta disponibilidade**: O Load Balancer distribui o tráfego entre múltiplas instâncias, evitando falhas.  
- **Gerenciamento eficiente**: O uso do RDS reduz a carga administrativa e melhora a segurança do banco de dados.  
- **Automação**: O User Data facilita a configuração inicial das instâncias EC2.  
- **Monitoramento**: O CloudWatch oferece visibilidade sobre o desempenho e ajuda na otimização do sistema.  

Essa abordagem cria uma solução **flexível e confiável**, ideal para aplicações que precisam de crescimento dinâmico e alto desempenho, ao mesmo tempo em que otimizam custos e reduzem a necessidade de intervenção manual.


7. [Criação da Infraestrutura na AWS](#criação-da-infraestrutura-na-aws)
 
 A infraestrutura do projeto foi planejada para ser robusta, escalável e resiliente, aproveitando ao máximo os serviços da AWS. O uso de uma arquitetura em nuvem traz uma série de vantagens, como alta disponibilidade, flexibilidade, e redução de custos operacionais
   
   4.1. [Configuração da VPC para segmentação da rede](#configuração-da-vpc-para-segmentação-da-rede)

Acesse o AWS Console, vá até o site oficial da AWS (https://aws.amazon.com/) e faça login na sua conta. No painel principal, na barra de pesquisa superior, digite "VPC" e clique na opção "VPC Dashboard" para acessar o serviço de VPC.
Criar uma Nova VPC:
Dentro do VPC Dashboard, clique no botão "Create VPC" (Criar VPC).

Configuração da VPC:

Nome da VPC: Escolha um nome descritivo para a VPC, como "wordpress-vpc". Esse nome serve apenas para fins organizacionais dentro do console da AWS e não afeta a configuração técnica.

IPv4 CIDR Block: Defina um bloco CIDR para a VPC, que representa a faixa de endereços IP que será usada dentro da rede privada.

Exemplo recomendado: 10.0.0.0/16.

Isso significa que a VPC terá um total de 65.536 endereços IP disponíveis (de 10.0.0.0 a 10.0.255.255).

Você pode escolher um bloco CIDR diferente conforme necessário, mas deve garantir que não haja sobreposição com outras redes que você possa estar usando.

IPv6 CIDR Block (opcional), se precisar de suporte para IPv6, você pode habilitar um bloco de endereços IPv6 gerado automaticamente pela AWS.

Tenancy:

Escolha entre Default (padrão) ou Dedicated.

A opção padrão compartilha recursos físicos com outras instâncias na AWS, a opção dedicada utiliza servidores exclusivos, mas pode ter custos adicionais.

Criar a VPC:

Após configurar os parâmetros, clique em "Create VPC".

Aguarde a criação da VPC e clique em "View VPC" para visualizar a VPC recém-criada no painel de gerenciamento.

   4.2. [Provisionamento da Instância EC2 para Hospedar o WordPress](#provisionamento-da-instância-ec2-para-hospedar-o-wordpress)

   Acesse o AWS Console e Navegue até o EC2. No painel de controle da AWS, digite "EC2" na barra de pesquisa e clique em "EC2 Dashboard" para acessar o serviço de instâncias EC2.
   
   Criar uma Nova Instância EC2

   No painel do EC2, clique em "Launch Instance" para iniciar a configuração da nova máquina virtual.
   Definir Configurações Básicas da Instância
   Nome da Instância:

   Escolha um nome descritivo para a instância, como "wordpress-instance".

   Esse nome facilita a identificação dentro do console da AWS.

   Escolher a AMI (Amazon Machine Image):

   A AMI define o sistema operacional e configurações iniciais da máquina.


Escolher o Tipo de Instância:

Selecione um tipo de instância adequado para hospedar o WordPress e Docker.
Escolha a VPC Criada Anteriormente:

Selecione a VPC wordpress-vpc criada anteriormente para garantir que a instância estará na rede privada configurada.

Escolha uma Sub-rede Pública:

Escolha uma sub-rede pública dentro da VPC, garantindo que a instância possa se comunicar com a internet.

Habilitar o Auto-Assign Public IP:

Marque a opção "Enable Auto-Assign Public IP" para que a instância receba um endereço IP público automaticamente.

Isso é necessário para que possamos acessá-la via SSH e para que o WordPress esteja acessível externamente.

5. Criar um Security Group (Grupo de Segurança)
O Security Group controla o tráfego de entrada e saída da instância. Configure as regras conforme abaixo:

Criar um novo Security Group e adicionar regras:

Porta 22 (SSH): Permitir apenas para seu IP (recomenda-se evitar o acesso aberto por segurança).

Regra: 22/tcp - Your IP (exemplo: 200.150.100.50/32)

Portas 80 e 443 (HTTP e HTTPS): Permitir acesso público para que o site WordPress possa ser acessado.

Regra: 80/tcp - 0.0.0.0/0 (acesso global)

Regra: 443/tcp - 0.0.0.0/0 (acesso global)

Dica de segurança: Se quiser restringir o acesso ao WordPress, pode configurar regras mais específicas no futuro.

6. Adicionar um Script de Inicialização (User Data)
A AWS permite inserir comandos no campo User Data, que serão executados automaticamente quando a instância for criada.

Por enquanto, deixe esse campo vazio, pois adicionaremos o script posteriormente para instalar o Docker e o WordPress.

7. Revisar e Lançar a Instância
Após configurar todas as opções, clique em "Launch".

Escolha ou crie uma nova chave SSH (Key Pair) para acessar a instância via terminal.

Confirme o lançamento da instância e aguarde a inicialização.

**RDS**

O RDS armazenará os dados do WordPress.

Acesse AWS Console > RDS > Create database.

Escolha MySQL ou PostgreSQL.

Escolha a opção RDS Free Tier (caso esteja testando).

Defina:

Nome da instância: wordpress-db

Usuário: admin

Senha: escolha uma segura.

Configure a rede:

Escolha a VPC criada.

Habilite Public Access (se precisar testar externamente).

Configure um Security Group permitindo conexões da EC2 na porta 3306.

Clique em Create Database.


   4.2.1. [Instalação do Docker na Instância EC2](#instalação-do-docker-na-instância-ec2)

   Acesse a instância via SSH e instale o Docker:

sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user


   4.2.2. [Execução do WordPress na EC2 Utilizando Contêineres Docker](#execução-do-wordpress-na-ec2-utilizando-contêineres-docker)

   Agora, vamos rodar o WordPress e o MySQL com Docker:

# Criar uma rede para comunicação entre os containers
docker network create wordpress-net

# Rodar o container do banco de dados
docker run -d --name mysql-db --network wordpress-net \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wp_user \
  -e MYSQL_PASSWORD=wp_pass \
  mysql:5.7

# Rodar o container do WordPress
docker run -d --name wordpress --network wordpress-net \
  -p 80:80 \
  -e WORDPRESS_DB_HOST=mysql-db:3306 \
  -e WORDPRESS_DB_USER=wp_user \
  -e WORDPRESS_DB_PASSWORD=wp_pass \
  -e WORDPRESS_DB_NAME=wordpress \
  wordpress


   4.2.3. [Criação e Teste de Script de Inicialização (User Data) para Automação da Configuração da Instância](#criação-e-teste-de-script-de-inicialização-user-data-para-automação-da-configuração-da-instância)

No AWS EC2, podemos configurar um script que roda na inicialização.

Antes de criar a instância, no campo User Data, insira:

bash
#!/bin/bash
yum update -y
yum install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# Criar rede Docker
docker network create wordpress-net

# Rodar MySQL
docker run -d --name mysql-db --network wordpress-net \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wp_user \
  -e MYSQL_PASSWORD=wp_pass \
  mysql:5.7

# Rodar WordPress
docker run -d --name wordpress --network wordpress-net \
  -p 80:80 \
  -e WORDPRESS_DB_HOST=mysql-db:3306 \
  -e WORDPRESS_DB_USER=wp_user \
  -e WORDPRESS_DB_PASSWORD=wp_pass \
  -e WORDPRESS_DB_NAME=wordpress \
  wordpress

   4.3. [Alta Disponibilidade e Escalabilidade](#alta-disponibilidade-e-escalabilidade)

   4.3.1. [Configuração de um Auto Scaling Group para Ajuste Automático de Capacidade](#configuração-de-um-auto-scaling-group-para-ajuste-automático-de-capacidade)
Criar um Load Balancer:

Vá para EC2 > Load Balancer > Create Load Balancer.

Escolha Application Load Balancer.

Configure a VPC e sub-redes públicas.

Crie um Security Group permitindo 80 e 443.

Configure um Target Group apontando para suas instâncias EC2.
     
   4.3.2. [Implementação de um Balanceador de Carga (ELB) para Distribuição do Tráfego entre Instâncias](#implementação-de-um-balanceador-de-carga-elb-para-distribuição-do-tráfego-entre-instâncias)

Criar o Auto Scaling Group:

Vá para EC2 > Auto Scaling Groups > Create Auto Scaling Group.

Selecione a AMI e configuração da EC2.

Defina um mínimo de 2 instâncias e máximo de 5.

Escolha o Load Balancer criado.
      4.3.3. [Definição de Regras de Escalonamento para Ajuste Dinâmico com Base na Demanda](#definição-de-regras-de-escalonamento-para-ajuste-dinâmico-com-base-na-demanda)

Configurar Regras de Scaling
Vá para Auto Scaling Group.

Adicione regras como:

Escalar para cima: Se CPU > 70% por 5 min, adicionar 1 instância.

Escalar para baixo: Se CPU < 30% por 5 min, remover 1 instância.

   4.4. [Monitoramento e Gerenciamento](#monitoramento-e-gerenciamento)

 4.4.1. [Configuração de Métricas e Alarmes no CloudWatch para Monitoramento da Infraestrutura](#configuração-de-métricas-e-alarmes-no-cloudwatch-para-monitoramento-da-infraestrutura)

Vá para CloudWatch > Alarms > Create Alarm.

Configure um novo alarme para a métrica CPU Utilization da EC2.

Defina regras como:

Se CPU > 80% → Enviar alerta.

Se instâncias forem terminadas ou criadas → Enviar alerta.

9. [Considerações Finais](#considerações-finais)

    Como resultado, o projeto entregou um ambiente robusto, flexível e preparado para atender diferentes volumes de tráfego sem comprometer a estabilidade do sistema. A combinação de automação, escalabilidade e monitoramento faz deste um modelo eficiente para aplicações web que necessitam de crescimento dinâmico e alta disponibilidade.

10. [Referências](#referências)
