#!/bin/bash
echo "==========================================="
echo "========== STARTING MAIN SERVERS =========="
echo "==========================================="
for service in /home/joey/homelab/server/config/*; do echo "===== STARTING $service =====" && cd $service && docker-compose up -d; done

echo "==========================================="
echo "======== STARTING MINECRAFT SERVERS ======="
echo "==========================================="
for service in /home/joey/homelab/server/config/minecraft/*.yml; do echo "===== STARTING $service =====" && docker-compose -f $service up -d; done

echo "==========================================="
echo "================ ALL DONE ================="
echo "======= List all running containers ======="
echo "==========================================="

echo "docker ps -a"
docker ps -a