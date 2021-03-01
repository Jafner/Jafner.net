#!/bin/bash
# PEERS=$1
# sed -i "s/PEERS=.*/PEERS=$PEERS/g" docker-compose.yml
docker container restart wireguard
rclone copy ./config/ gdrive: --filter "- /coredns/" --filter "- /templates/" --filter "- /server/" --filter "+ peer*.{conf,png}" --filter "- *" 
