#!/bin/bash
echo "==========================================="
echo "======= SHUTTING DOWN SERVERS ======="
echo "==========================================="

for service in /home/joey/homelab/server/config/*
do 
    echo "===== SHUTTING DOWN $service =====" 
    cd $service 
    docker-compose down
done

echo "==========================================="
echo "================ ALL DONE ================="
echo "===== Clean up any running containers ====="
echo "==========================================="

echo "docker ps -a"
docker ps -a