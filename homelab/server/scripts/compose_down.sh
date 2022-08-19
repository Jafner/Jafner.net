#!/bin/bash
echo "==========================================="
echo "===== SHUTTING DOWN MINECRAFT SERVERS ====="
echo "==========================================="
for service in /home/joey/homelab/server/config/minecraft/*.yml
do 
    echo "===== SHUTTING DOWN $service =====" 
    docker-compose -f $service down
done

echo "==========================================="
echo "======= SHUTTING DOWN OTHER SERVERS ======="
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