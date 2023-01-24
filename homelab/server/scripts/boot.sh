#!/bin/bash
# Remove existing containers to ensure clean environment
for service in /home/joey/homelab/server/config/*
do 
    echo "CLEANING UP $service" 
    cd $service 
    docker-compose down
done

# Check for good connection to NAS and shares mounted properly.
SMB_SHARES="/mnt/nas/av
/mnt/nas/backups
/mnt/nas/calibre
/mnt/nas/calibre-web
/mnt/nas/media
/mnt/nas/torrenting"

for share in $SMB_SHARES;
do
    if ! mount | awk -v DIR="$share" '{if ($3 == DIR) { exit 0}} ENDFILE{exit -1}'; then
        echo "Share not mounted: $share"
        exit 1
    fi
done

echo "STARTING DOCKER SERVICES"
for service in /home/joey/homelab/server/config/*
do 
    echo "===== STARTING $service ====="
    cd $service 
    docker-compose up -d
done

echo "================ ALL DONE ================="
echo "======= List all running containers ======="

# wish I didn't have to do this
# the exporters boot faster than the servers, and don't seem to retry.
wait 10
docker container restart monitoring_exporter-plex
docker container restart keycloak_forwardauth
docker container restart keycloak_forwardauth-privileged
