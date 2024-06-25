#!/bin/bash

# Check if domain, port, and email are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <domain> <port> <email>"
    exit 1
fi

domain=$1
port=$2
email=$3

# Check if running as root
if [ "$(id -u)" != "0" ]; then
    echo "Error: This script must be run as root" 1>&2
    exit 1
fi

# Create directories if they don't exist
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# Nginx configuration file path
config_file_available="/etc/nginx/sites-available/$domain"
config_file_enabled="/etc/nginx/sites-enabled/$domain"

if [ -f "$config_file_available" ]; then
    rm "$config_file_available"
fi

if [ -f "$config_file_enabled" ]; then
    rm "$config_file_enabled"
fi

systemctl reload nginx

# SSL certificate and key 
ssl_certificate="/etc/letsencrypt/live/$domain/fullchain.pem"
ssl_certificate_key="/etc/letsencrypt/live/$domain/privkey.pem"

# Create Nginx configuration
cat << EOF > "$config_file_available"
server {
    listen 80;
    server_name $domain;

    # Required for Certbot authentication
    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/html;
    }
}
EOF

# Create a symbolic link to sites-enabled directory
ln -sf "$config_file_available" "/etc/nginx/sites-enabled/"

# Reload Nginx to apply changes
systemctl reload nginx

# Obtain SSL certificate using Certbot with --webroot authentication
certbot certonly --webroot -w /var/www/html -d $domain --email $email --agree-tos -n

# Check if certificate was obtained successfully
if [ $? -eq 0 ]; then
    # Modify Nginx configuration if sucessful
cat << EOF > "$config_file_available"

server {
    listen 80;
    server_name $domain;

    # Increase the client max body size
    client_max_body_size 50M;

    # Required for Certbot authentication
    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/html;
    }

    # Required for Certbot authentication
    location / {
        return 301 https://$domain\$request_uri;
    }

}

server {

    server_name $domain;

    # Increase the client max body size
    client_max_body_size 50M;

    location / {
        proxy_pass http://localhost:$port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # SSL configuration
    listen 443 ssl;
    ssl_certificate $ssl_certificate;
    ssl_certificate_key $ssl_certificate_key;
}
EOF
else
    echo "Error: Failed to obtain SSL certificate. Please check Certbot logs."
fi

systemctl reload nginx

