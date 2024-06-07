#!/bin/bash

# When creating an EC2 instance, use this in the User data - optional to add your public key.

# Define the username of the default user (change according to your AMI)
USERNAME=ec2-user

# Define your public key (replace with your actual public key)
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr54P5jv1o... your_public_key_here ... user@hostname"

# Create .ssh directory if it doesn't exist
mkdir -p /home/$USERNAME/.ssh

# Add the public key to the authorized_keys file
echo $PUBLIC_KEY >> /home/$USERNAME/.ssh/authorized_keys

# Set the correct permissions
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
