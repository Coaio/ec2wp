#!/bin/bash

# Check if domain, port, and email are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <domain> <port>"
    exit 1
fi

domain=$1
port=$2

# Replace . and - in the domain with _
domain_CLEAN=$(echo "$domain" | sed 's/[.-]/_/g')

# Replace original domain value with cleaned one
domain="$domain_CLEAN"

echo "The domain name is cleaned up to be $domain"

source .env || {
    echo "Error: .env file not found or cannot be read."
    exit 1
}

# Derive volume name and DB name from container name
VOLUME_NAME="${domain}_data"
DB_NAME="${domain}DB"

compose_content=$(cat <<EOF
version: "3.8"

services:
  init-db:
    image: docker:dind
    container_name: dbInit
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: \${DB_PASSWORD}
    command: >
      sh -c "docker exec -i mainDB mysql -uroot -p'\$DB_PASSWORD' -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME};'"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  "$domain":
    image: wordpress
    container_name: "$domain"
    restart: always
    depends_on:
      - init-db
    ports:
      - "$port:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: \${DB_PASSWORD}
      WORDPRESS_DB_NAME: ${DB_NAME}
    volumes:
      - "$VOLUME_NAME:/var/www/html"
    networks:
      - app-network

volumes:
  "$VOLUME_NAME": {}

networks:
  app-network:
    external: true
EOF
)

compose_file="${domain}-compose.yml"

echo "$compose_content" > "$compose_file"

docker compose -f "$compose_file" up -d
