#!/bin/bash

sudo useradd -m $LINUX_USERNAME
sudo adduser $LINUX_USERNAME sudo
echo "$LINUX_USERNAME:$LINUX_USER_PASSWORD" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $LINUX_MACHINE_NAME

if [[ -z "$LINUX_USER_PASSWORD" ]]; then
  echo "Please set 'LINUX_USER_PASSWORD' for user: $USER"
  exit 3
fi

echo "### Install Docker ###"
sudo apt-get install -y docker.io docker-compose

echo "### Create docker-compose.yml for Playit ###"
cat <<EOF > docker-compose.yml
version: '3'

services:
  playit:
    image: ghcr.io/playit-cloud/playit-agent:0.15
    network_mode: host
    environment:
    - SECRET_KEY=$SECRET_KEY
EOF

echo "### Start Playit with Docker ###"
docker-compose up -d

sleep 10
