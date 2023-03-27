#!/bin/bash

echo "==========================================="
echo "============= STARTING INFRA =============="
echo "==========================================="

for service in traefik keycloak ddns
do
    echo "===== STARTING $service ====="
    cd /home/joey/homelab/server/config/$service
    docker-compose up -d
done


echo "==========================================="
echo "========== STARTING MAIN SERVERS =========="
echo "==========================================="
for service in /home/joey/homelab/server/config/*
do 
    echo "===== STARTING $service ====="
    cd $service 
    docker-compose up -d
done

