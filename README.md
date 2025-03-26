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
