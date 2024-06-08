# README.md

## Project Overview

This project provides a set of scripts and configurations to run multiple containerized WordPress websites on a single Ubuntu instance on AWS EC2. The setup uses Docker, Nginx, and Certbot for a complete and secure web hosting solution.

## Project Structure

```plaintext
.
├── .gitignore
├── 0-add-public-key-to-ec2.sh
├── 1-install-infra.sh
├── 2-init-infra.sh
├── 3-add-instance.sh
├── 4-add-nginx-config.sh
├── LICENSE
├── README.md
└── infra-compose.yml
```

### Files Description

- **.gitignore**: Specifies files and directories that should be ignored by Git. Typically includes temporary files, build artifacts, and sensitive information.

- **0-add-public-key-to-ec2.sh**: A script to add your public SSH key to the EC2 instance for secure and convenient SSH access.

- **1-install-infra.sh**: Installs Docker, Nginx, and Certbot on the EC2 instance. This is the initial setup script to prepare the environment.

- **2-init-infra.sh**: Sets up the Docker network and initializes MySQL for the WordPress instances.

- **3-add-instance.sh**: Adds a new WordPress instance. This script creates a new Docker container for a WordPress site, setting up the necessary environment and database connections.

- **4-add-nginx-config.sh**: Configures Nginx to handle the new WordPress instance, sets up SSL with Certbot, and ensures traffic is correctly routed and secured.

- **LICENSE**: Contains the license information for the project.

- **README.md**: The file you are currently reading. It provides an overview of the project, instructions on the setup, and descriptions of each file.

- **infra-compose.yml**: Docker Compose file that defines the infrastructure services (like MySQL) required for running the WordPress instances.

## How to Run

### Prerequisites

- An AWS account with an EC2 instance running Ubuntu.
- SSH access to your EC2 instance.
- A registered domain name, with DNS records pointing to your EC2 instance's public IP address.

### Steps to Setup

1. **Add Public Key to EC2 Instance**

   Ensure your public SSH key is added to the EC2 instance to enable secure SSH access. Run the following script:

   ```bash
   ./0-add-public-key-to-ec2.sh
   ```

2. **Install Infrastructure**

   SSH into your EC2 instance and execute the script to install Docker, Nginx, and Certbot:

   ```bash
   ./1-install-infra.sh
   ```

3. **Initialize Infrastructure**

   Set up the Docker network and initialize MySQL for the WordPress instances by running:

   ```bash
   ./2-init-infra.sh
   ```

4. **Add New WordPress Instance**

   Add a new WordPress instance by running the following script with the required arguments (domain and port):

   ```bash
   ./3-add-instance.sh <domain> <port>
   ```

   Replace `<domain>` with your domain name and `<port>` with the port number you want the instance to use.

5. **Configure Nginx**

   Configure Nginx to handle the new WordPress instance and set up SSL with Certbot. Run the following script with the required arguments (domain, port, and email):

   ```bash
   sudo ./4-add-nginx-config.sh <domain> <port> <email>
   ```

   Replace `<domain>` with your domain name, `<port>` with the port number, and `<email>` with your email address for SSL certificate registration.

### Maintenance and Updates

- **Backup and Restore**: Additional scripts for setting up backups and restoring them will be provided in a subsequent tutorial.
- **Scaling**: To add more WordPress instances, simply repeat steps 4 and 5 with different domains and ports.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Acknowledgements

Thank you for using this setup. If you have any questions or need further assistance, please refer to the contact information in the project repository.

---

Feel free to contribute to this project by submitting issues or pull requests. Happy hosting!
