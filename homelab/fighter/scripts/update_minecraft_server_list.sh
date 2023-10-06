#!/bin/bash
# Get list of configured servers
# One server per line, includes router

CONFIG_DIR="/home/admin/homelab/fighter/config/minecraft"

SERVERS="$(docker-compose -f $CONFIG_DIR/docker-compose.yml config --services)"

# exporter-minecraft: Create comma-separated list for EXPORT_SERVERS
EXPORT_SERVERS=""
for server in $SERVERS
do
    if [ $server != "router" ]
    then EXPORT_SERVERS="${EXPORT_SERVERS}${EXPORT_SERVERS:+,}$server"
    fi
done
echo "EXPORT_SERVERS=\"$EXPORT_SERVERS\"" > $CONFIG_DIR/exporter.env

# router: Create valid and correct mapping command for mc-router
# example: command: --mapping=vanilla.jafner.net=vanilla:25565,e9.jafner.net=e9:25565,fan.jafner.net=fan:25565,vanilla2.jafner.net=vanilla2:25565,bmcp.jafner.net=bmcp:25565 --api-binding=0.0.0.0:25566
MAPPINGS=""

for server in $SERVERS
do
    if [ $server != "router" ]
    then MAPPINGS="${MAPPINGS}${MAPPINGS:+,}$server.jafner.net=$server:25565"
    fi
done

sed -i "s/--mapping=[^ ]\+/--mapping=$MAPPINGS/m" $CONFIG_DIR/docker-compose.yml



DIR=$(pwd)
cd $CONFIG_DIR && docker-compose up -d --force-recreate router exporter-minecraft
cd $DIR