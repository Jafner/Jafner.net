#!/bin/bash
echo "==========================================="
echo "========== STARTING MAIN SERVERS =========="
echo "==========================================="
for service in /home/joey/homelab/server/config/*
do 
    echo "===== STARTING $service ====="
    cd $service 
    docker-compose up -d
done

echo "==========================================="
echo "================ ALL DONE ================="
echo "======= List all running containers ======="
echo "==========================================="

echo "docker ps -a"
docker ps -a

# wish I didn't have to do this
# the exporter boots faster than the plex server, and doesn't seem to retry.
#wait 10
#docker container restart monitoring_exporter-plex
#docker container restart keycloak_forwardauth
