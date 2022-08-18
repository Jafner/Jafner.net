#!/bin/bash

for CONTAINER_ID in $(docker ps -aq) # get list of all loaded containers (running and stopped)
do 
    CONTAINER_NAME=$(docker ps -aq --filter "id=$CONTAINER_ID" --format '{{.Names}}') # get the container's name
    CONTAINER_MOUNTS=$(docker inspect --format '{{range .Mounts}}{{println .Source}}{{end}}' $CONTAINER_ID) # print the container's volume mounts
    echo "======== CHECKING $CONTAINER_NAME ========"
    echo "$CONTAINER_MOUNTS" | grep /mnt/nas
done