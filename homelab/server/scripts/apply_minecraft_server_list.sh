#!/bin/bash
DIR=$(pwd)
# Apply updated EXPORT_SERVERS
cd /home/joey/homelab/server/config/monitoring && docker-compose up -d --force-recreate exporter-minecraft

# Apply updated router mappings
cd /home/joey/homelab/server/config/minecraft && docker-compose up -d --force-recreate router

cd $DIR