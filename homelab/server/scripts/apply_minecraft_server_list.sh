#!/bin/bash

# Apply updated EXPORT_SERVERS
docker-compose -f /home/joey/homelab/server/config/monitoring up -d --force-recreate exporter-minecraft

# Apply updated router mappings
docker-compose -f /home/joey/homelab/server/config/minecraft up -d --force-recreate router
