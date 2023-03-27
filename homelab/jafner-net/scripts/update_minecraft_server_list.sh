#!/bin/bash
# Get list of configured servers
# One server per line, includes router
SERVERS="$(docker-compose -f /home/joey/homelab/jafner-net/config/minecraft/docker-compose.yml config --services)"

# exporter-minecraft: Create comma-separated list for EXPORT_SERVERS
EXPORT_SERVERS=""
for server in $SERVERS
do
    if [ $server != "router" ]
    then EXPORT_SERVERS="${EXPORT_SERVERS}${EXPORT_SERVERS:+,}$server"
    fi
done
echo "EXPORT_SERVERS=\"$EXPORT_SERVERS\"" > /home/joey/homelab/jafner-net/config/monitoring/exporter-minecraft.env

# router: Create valid and correct mapping command for mc-router
# example: command: --mapping=vanilla.jafner.net=vanilla:25565,e9.jafner.net=e9:25565,fan.jafner.net=fan:25565,vanilla2.jafner.net=vanilla2:25565,bmcp.jafner.net=bmcp:25565 --api-binding=0.0.0.0:25566
MAPPINGS=""

for server in $SERVERS
do
    #MAPPING="$server.jafner.net=$server:25565"
    #echo $MAPPING
    if [ $server != "router" ]
    then MAPPINGS="${MAPPINGS}${MAPPINGS:+,}$server.jafner.net=$server:25565"
    fi
done

#COMMAND="command: --mapping=$MAPPINGS --api-binding=0.0.0.0:25566"
sed -i "s/--mapping=[^ ]\+/--mapping=$MAPPINGS/m" /home/joey/homelab/jafner-net/config/minecraft/docker-compose.yml