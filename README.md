# AWS DevOps Stack: Docker, EC2, RDS and Load Balancing for WordPress.

Este projeto implanta WordPress com Docker em uma VPC na AWS, usando EC2, RDS (MySQL), EFS e Classic Load Balancer. O *user_data.sh* automatiza a configuração, garantindo escalabilidade e alta disponibilidade. A abordagem segue boas práticas de DevOps, permitindo implantação eficiente e reprodutível.

## Índice

1. [Resumo](#resumo)

2. [Objetivos](#objetivos)

3. [Arquitetura do Projeto e Tecnologias](#arquitetura-do-projeto-e-tecnologias)

4. [Criação da Infraestrutura na AWS](#criação-da-infraestrutura-na-aws)

  4.1 [Criar VPC;](#Criar-VPC;)
  
  4.2 [Criar Gateway NAT;](#Criat-Gateway-NAT;)
  
  4.3 [Editar Tabela de Rotas;](#Editar-Tabela-de-Rotas;)
  
  4.4 [Criar Security Groups;](#Criar-Security-Groups:)
  
  4.5 [Criar RDS;](#Criar-RDS)
  
  4.6 [Criar EFS;](#Criar-EFS)
  
  4.7 [Criar Load Balancer;](#Criar-Load-Balancer;)
  
  4.8 [Criar Auto Scaling;](#Criar-Auto-Scaling;)
  
  4.9 [Criar Template;](#Criar-Template;)
  
  4.10 [Teste de Funcionamento.](#Teste-de-funcionamento)
   
5. [Considerações Finais](#considerações-finais)

6. [Referências](#referências)


# 1. Resumo

Este projeto consistiu na implementação de uma infraestrutura escalável na AWS para hospedar um site WordPress. Foi criada uma VPC, configurada uma instância EC2 com Docker e integrado um banco de dados gerenciado no Amazon RDS. A automação foi realizada via User Data, garantindo a inicialização automática do ambiente. Para garantir alta disponibilidade e desempenho, foram implementados um Auto Scaling Group e um Balanceador de Carga, além do monitoramento via CloudWatch. O resultado foi um sistema robusto, flexível e preparado para lidar com diferentes volumes de tráfego de forma eficiente.


# 2. Objetivos

Este projeto teve como objetivo a implementação de uma infraestrutura escalável e segura na AWS para hospedar um site WordPress, utilizando diversos serviços que garantem alta disponibilidade e desempenho. A criação da VPC permitiu a segmentação adequada da rede, garantindo maior controle sobre a comunicação entre os recursos. Em seguida, foi configurada uma instância EC2 onde foi instalado o Docker para facilitar a implantação e gerenciamento do WordPress.

Para o armazenamento dos dados, utilizamos o Amazon RDS, um serviço gerenciado que proporciona mais segurança e desempenho ao banco de dados. Além disso, foi implementado um script de inicialização no User Data da EC2, garantindo que a instância fosse provisionada corretamente e estivesse pronta para rodar o WordPress de forma automática.

A escalabilidade foi um fator essencial no projeto, sendo implementado um Auto Scaling Group juntamente com um Balanceador de Carga, o que permitiu a distribuição eficiente do tráfego e a criação automática de novas instâncias conforme a demanda aumentasse. Para garantir a estabilidade do ambiente, também foram definidas regras de escalonamento e configurado um monitoramento no CloudWatch, possibilitando a observação contínua do desempenho da infraestrutura.

# 3. Arquitetura do projeto e tecnologias

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

# 4. Criação da Infraestrutura na AWS

A infraestrutura proposta para o deploy do WordPress na AWS segue boas práticas de escalabilidade, segurança e automação. A instância EC2 é configurada automaticamente via User Data (user_data.sh) para instalar Docker ou Containerd, garantindo um ambiente replicável. O WordPress roda em um container, enquanto o banco de dados é gerenciado pelo AWS RDS (MySQL), assegurando persistência e desempenho.
Para armazenar arquivos estáticos, utiliza-se o AWS EFS, permitindo compartilhamento entre múltiplas instâncias. O tráfego de rede é gerenciado por um Classic Load Balancer (CLB), evitando a exposição direta do IP público e distribuindo conexões para maior disponibilidade. A infraestrutura é protegida por Security Groups, garantindo acesso controlado.

   # 4.1 Criar VPC;

   Acesse o console da AWS e, na barra de pesquisa, procure por **VPC**. Em seguida, clique na opção **"Criar VPC"**. Na tela de configuração, selecione a alternativa **"VPC e muito mais"**. No campo de nome, insira um identificador de sua escolha. Caso deseje modificar alguma configuração, fique à vontade para ajustá-la conforme necessário. Utilize a imagem abaixo como referência para garantir que as configurações estejam corretas.

   ![Image](https://github.com/user-attachments/assets/6fce6383-fef6-434b-b6e0-fb8b6ec5a05d)

   # 4.2 Criar Gateway Nat;

   No **Painel da VPC**, localizado no menu lateral esquerdo, clique na opção **"Gateways NAT"** e, em seguida, selecione **"Criar gateway NAT"**. No campo de nome, defina um identificador para o gateway. Escolha a **sub-rede pública** correspondente e mantenha a configuração padrão **"Público"** no campo **"Tipo de conectividade"**. Para concluir o processo, clique na opção **"Alocar IP elástico"**.

   ![Image](https://github.com/user-attachments/assets/b5518534-bc79-4c88-899a-47c359d4707f)

   # 4.3 Editar Tabela de Rotas;

   Ainda no **Painel da VPC**, no menu lateral esquerdo, clique em **"Tabelas de Rotas"**. Em seguida, selecione a tabela de rotas associada à sua **rede privada**. Na parte inferior da tela, acesse a aba **"Rotas"** e clique em **"Editar Rotas"**. Escolha a opção **"Adicionar Rota"** e preencha os campos conforme a imagem de referência: no primeiro campo, insira **"0.0.0.0/0"**; no segundo, selecione **"Gateway NAT"**; e, logo abaixo, especifique o **Gateway NAT** criado anteriormente.

   ![Image](https://github.com/user-attachments/assets/24f8bd91-ac1d-4160-8a17-746c54c7c7d1)
   
Observação: Certifique-se de repetir esse procedimento para a outra sub-rede privada, garantindo que ambas tenham a rota corretamente configurada.

   # 4.4 Criar Security Groups;

   No console da AWS, utilize a barra de pesquisa para localizar **Security Groups** e clique na opção **"Criar grupo de segurança"**.  

Antes de prosseguir, decida se utilizará um **Bastion Host (BH)**. Caso opte por usá-lo, siga a sequência normal de criação dos **Security Groups**. Caso contrário, pule a etapa referente ao **Security Group do BH** e ajuste as permissões de **SSH** na instância **EC2**.  

### **Sequência recomendada para criação dos Security Groups:**  
**Com Bastion Host (BH):**  
1. Criar **Security Group do BH**  
2. Criar **Security Group da EC2** (sem modificar as regras de saída)  
3. Criar **Security Group do RDS**  
4. Retornar ao **Security Group da EC2** e modificar as regras de saída conforme a imagem de referência  
5. Criar **Security Group do EFS**  

**Sem Bastion Host:**  
1. Criar **Security Group da EC2** (sem modificar as regras de saída)  
2. Criar **Security Group do RDS**  
3. Retornar ao **Security Group da EC2** e modificar as regras de saída conforme a imagem de referência  
4. Criar **Security Group do EFS**  

**Observações:**  
- Certifique-se de **associar cada Security Group à VPC criada anteriormente**.  
- Os nomes e descrições dos Security Groups podem ser personalizados conforme sua preferência.  
- As regras de entrada e saída devem seguir as configurações indicadas nas imagens de referência.

   

   

   


