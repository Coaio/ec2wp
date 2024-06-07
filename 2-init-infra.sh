#!/bin/bash

# Function to generate a random password
generate_password() {
    < /dev/urandom tr -dc A-Za-z0-9 | head -c20
}

# Generate random password
DB_PASSWORD=$(generate_password)

# Write .env file
cat <<EOF > .env
DB_PASSWORD=$DB_PASSWORD
EOF

docker network create app-network
docker compose -f infra-compose.yml up -d

echo "Infra setup complete. Please wait 2 minutes for the services to be up and running"

# Loading animation for 2 minutes
seconds=0
while [ $seconds -lt 120 ]; do
    echo -ne "Waiting for services to start: [$(printf "%0.s=" $(seq 1 $((seconds/2))))$(printf "%0.s " $(seq $(((120-seconds)/2)) 1 59))]\r"
    sleep 1
    ((seconds++))
done

echo -e "\nServices are now up and running."
echo "please go to http://localhose:8080 to open adminer. use db as database, use root and see .env file for password.
echo "Generated .env file with random password."
echo "please run ./new-domain.sh domain port to start a new wordpress site"



