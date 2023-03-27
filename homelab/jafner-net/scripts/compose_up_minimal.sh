#!/bin/bash
START_DIR=$(pwd)
echo "=============================================="
echo "========== STARTING MINIMAL SERVERS =========="
echo "=============================================="
cd /home/joey/homelab/jafner-net/config/
for service in gitlab homer keycloak monitoring traefik wireguard
do 
    echo "===== STARTING $service ====="
    cd /home/joey/homelab/jafner-net/config/$service 
    docker-compose up -d
done

echo "==========================================="
echo "================ ALL DONE ================="
echo "======= List all running containers ======="
echo "==========================================="

cd $START_DIR

echo "docker ps -a"
docker ps -a

# wish I didn't have to do this
# the exporter boots faster than the plex server, and doesn't seem to retry.
wait 10
docker container restart monitoring_exporter-plex
docker container restart keycloak_forwardauth