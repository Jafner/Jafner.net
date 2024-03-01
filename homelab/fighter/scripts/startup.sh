#!/bin/bash
#set -x # debugging flag

# Check for network mounted devices
# NAS SMB
if ! mount -t cifs | grep -q '/mnt/nas'; then
    echo "  ==== NAS SMB shares not mounted"
    echo "  ==== Won't online stacks which depend on SMB shares"
    SMB_ONLINE=false
else
    SMB_ONLINE=true
fi

# NAS iSCSI
if ! sudo iscsiadm -m session | grep -q 'iqn.2020-03.net.jafner:fighter'; then 
    echo "  ==== NAS iSCSI session not connected"
    if ! mount -t ext4 | grep -q '/mnt/iscsi'; then
        echo "  ==== /mnt/iscsi not mounted"
        echo "  ==== Won't online stacks which depend on iSCSI shares"
    fi
    ISCSI_ONLINE=false
else
    ISCSI_ONLINE=true
fi

for stack in /home/admin/homelab/fighter/config/*; do
    cd $stack 
    if ! docker compose config > /dev/null; then 
        echo "  ==== Invalid compose config: $stack"
    fi
    COMPOSE_CONFIG_TEXT=$(docker compose config)

    # If the stack needs iSCSI and iSCSI isn't available, skip.
    if ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/iscsi ) && ! $ISCSI_ONLINE; then
        echo "  ==== $stack is dependent on iSCSI and iSCSI is offline, skipping..."
    # Else if the stack needs SMB and SMB isn't available, skip.
    elif ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/nas ) && ! $SMB_ONLINE; then
        echo "  ==== $stack is dependent on SMB and SMB is offline, skipping..."
    # Else the stack can be onlined. We also add it to a list of onlined services
    else
        echo  "  ==== Bringing up $stack "
        STACKS_ONLINE+="$(echo $stack | xargs basename)\n"
        echo -n "    ==== Time: "
        ( time docker compose --progress quiet up -d ) 2>&1 | grep real | cut -f 2
        echo "  ==== Done!"
    fi
    
    cd /home/admin/homelab/fighter/config/
    # make sure to overwrite the config text to prevent leaking secrets
    COMPOSE_CONFIG_TEXT="" 
done

echo "  ==== List of stacks online:"
echo -e "$STACKS_ONLINE"

# extra thing because my keycloak healthcheck doesn't work properly

echo "  ==== Wait 15s, then bring Keycloak forwardauth containers online"
cd /home/admin/homelab/fighter/config/keycloak
sleep 15
docker start keycloak_forwardauth keycloak_forwardauth-privileged