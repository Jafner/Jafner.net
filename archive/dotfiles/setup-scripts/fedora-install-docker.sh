#!/bin/bash

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker 

sudo groupadd docker
sudo usermod -aG docker $USER

echo "Run 'newgrp docker' to log into the docker group without logging out and back in"
echo "Install Docker Desktop by following the instructions here:"
echo "https://docs.docker.com/desktop/install/fedora/"
