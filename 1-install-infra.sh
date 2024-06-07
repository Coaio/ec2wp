#!/bin/bash

echo "Starting script execution..."

# Update package index and install prerequisites
echo "Updating package index..."
sudo apt-get update -y && echo "Package index updated."

echo "Upgrading installed packages..."
sudo apt-get upgrade -y && echo "Installed packages upgraded."

# Install Docker
echo "Installing Docker prerequisites..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && echo "Docker prerequisites installed."

echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && echo "Docker GPG key added."

echo "Adding Docker repository..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && echo "Docker repository added."

echo "Updating package index after adding Docker repository..."
sudo apt-get update -y && echo "Package index updated."

echo "Installing Docker CE..."
sudo apt-get install -y docker-ce && echo "Docker CE installed."

# Enable and start Docker
echo "Enabling Docker service..."
sudo systemctl enable docker && echo "Docker service enabled."

echo "Starting Docker service..."
sudo systemctl start docker && echo "Docker service started."

# Install Nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx && echo "Nginx installed."

# Enable and start Nginx
echo "Enabling Nginx service..."
sudo systemctl enable nginx && echo "Nginx service enabled."

echo "Starting Nginx service..."
sudo systemctl start nginx && echo "Nginx service started."

# Install Certbot
echo "Installing Certbot and python3-certbot-nginx..."
sudo apt-get install -y certbot python3-certbot-nginx && echo "Certbot and python3-certbot-nginx installed."

# (Optional) Setup Docker to run without sudo
echo "Adding $USER to docker group..."
sudo usermod -aG docker $USER && echo "$USER added to docker group."

# Print Docker, Nginx, and Certbot versions to verify installation
echo "Verifying Docker installation..."
docker --version && echo "Docker installed successfully."

echo "Verifying Nginx installation..."
nginx -v && echo "Nginx installed successfully."

echo "Verifying Certbot installation..."
certbot --version && echo "Certbot installed successfully."

echo "Script execution completed."
