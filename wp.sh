#!/bin/bash

apt update -y && apt upgrade -y

apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu


curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

mkdir -p /home/ubuntu/wordpress && cd /home/ubuntu/wordpress

cat <<EOF > docker-compose.yml
version: '3.3'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: ${DB_ENDPOINT}
      WORDPRESS_DB_NAME: ${DB_NAME}
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
    volumes:
      - wordpress_data:/var/www/html

volumes:
  wordpress_data:
EOF


export DB_ENDPOINT="projeto02-wp.c1cogq884gzv.us-east-1.rds.amazonaws.com"
export DB_NAME="projeto02-wp"
export DB_USER="admin"
export DB_PASSWORD="qualquersenha"

sed -i "s/DB_ENDPOINT/YOUR_RDS_ENDPOINT/" docker-compose.yml
sed -i "s/DB_NAME/YOUR_DATABASE_NAME/" docker-compose.yml
sed -i "s/DB_USER/YOUR_DATABASE_USER/" docker-compose.yml
sed -i "s/DB_PASSWORD/YOUR_DATABASE_PASSWORD/" docker-compose.yml

docker-compose up -d

systemctl enable docker