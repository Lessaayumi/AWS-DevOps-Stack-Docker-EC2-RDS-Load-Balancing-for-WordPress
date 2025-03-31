# AWS DevOps Stack: Docker, EC2, RDS and Load Balancing for WordPress (FALTA POR IMAGENS, RESUMIR UNS PONTOS E CORRGIR ERROS ORTOGRAFICOS)

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


# 1. Resumo

Este projeto consistiu na implementação de uma infraestrutura escalável na AWS para hospedar um site WordPress. Foi criada uma VPC, configurada uma instância EC2 com Docker e integrado um banco de dados gerenciado no Amazon RDS. A automação foi realizada via User Data, garantindo a inicialização automática do ambiente. Para garantir alta disponibilidade e desempenho, foram implementados um Auto Scaling Group e um Balanceador de Carga, além do monitoramento via CloudWatch. O resultado foi um sistema robusto, flexível e preparado para lidar com diferentes volumes de tráfego de forma eficiente.


# 2. Objetivos

Este projeto teve como objetivo a implementação de uma infraestrutura escalável e segura na AWS para hospedar um site WordPress, utilizando diversos serviços que garantem alta disponibilidade e desempenho. A criação da VPC permitiu a segmentação adequada da rede, garantindo maior controle sobre a comunicação entre os recursos. Em seguida, foi configurada uma instância EC2 onde foi instalado o Docker para facilitar a implantação e gerenciamento do WordPress.

Para o armazenamento dos dados, utilizamos o Amazon RDS, um serviço gerenciado que proporciona mais segurança e desempenho ao banco de dados. Além disso, foi implementado um script de inicialização no User Data da EC2, garantindo que a instância fosse provisionada corretamente e estivesse pronta para rodar o WordPress de forma automática.

A escalabilidade foi um fator essencial no projeto, sendo implementado um Auto Scaling Group juntamente com um Balanceador de Carga, o que permitiu a distribuição eficiente do tráfego e a criação automática de novas instâncias conforme a demanda aumentasse. Para garantir a estabilidade do ambiente, também foram definidas regras de escalonamento e configurado um monitoramento no CloudWatch, possibilitando a observação contínua do desempenho da infraestrutura.


