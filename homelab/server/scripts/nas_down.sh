#!/bin/bash

## This block checks all loaded (running or stopped) containers for nas-dependent mounts and adds them (by container name) to the NAS_DEPENDENTS variable. 
# NAS_DEPENDENTS=""
# for CONTAINER_ID in $(docker ps -aq) # get list of all loaded containers (running and stopped)
# do 
#     CONTAINER_NAME=$(docker ps -aq --filter "id=$CONTAINER_ID" --format '{{.Names}}') # get the container's name
#     CONTAINER_MOUNTS=$(docker inspect --format '{{range .Mounts}}{{println .Source}}{{end}}' $CONTAINER_ID) # print the container's volume mounts
#     echo "$CONTAINER_MOUNTS" | grep -q /mnt/nas
#     MATCH=$?
#     if [ $MATCH == 0 ]; then
#         NAS_DEPENDENTS+="$CONTAINER_NAME\n"
#     fi
# done
##

## This block checks all projects within the ~/homelab/server/config directory for NAS-dependence
NAS_DEPENDENTS=""
for project in $(find ~/homelab/server/config -maxdepth 1 -mindepth 1 -path ~/homelab/server/config/minecraft -prune -o -print | cut -d "/" -f7)
do
    echo "======== CHECKING $project ========"
    cd ~/homelab/server/config/$project
    docker-compose config
    docker-compose config | grep -q /mnt/nas
    MATCH=$?
    if [ $MATCH == 0 ]; then
        NAS_DEPENDENTS+="$project\n"
    fi
done

echo -e "$NAS_DEPENDENTS"

## This block runs docker-compose down for 
## all projects found by the previous block

for project in $(echo -e "$NAS_DEPENDENTS")
do
    echo "======== SHUTTING DOWN $project ========"
    cd ~/homelab/server/config/$project
    docker-compose down
done