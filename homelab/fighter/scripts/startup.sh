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

    # The logic below is a little obtuse. 
    # If both SMB and ISCSI are online, we can online the stack no worries. 
    # If this test fails we know *at least one* of the share services is offline.
    # So for the next two we check if the other service is online *and* we don't
    # need the one that must be offline.
    # If all of those fail, we know the stack is dependent on an offline service
    # So we just skip the stack.
    if ! ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/iscsi ) && ! ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/nas); then
        echo "  ==== Stack not dependent on NAS services"
        echo "  ==== Bringing up $stack"
        docker compose up -d 
    elif $SMB_ONLINE && $ISCSI_ONLINE; then
        echo "  ==== Bringing up $stack (all NAS services online)"
        docker compose up -d 
    elif $ISCSI_ONLINE && ! ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/nas ); then
        echo "  ==== Bringing up $stack (iSCSI online, not dependent on SMB)"
        docker compose up -d 
    elif $SMB_ONLINE && ! ( echo $COMPOSE_CONFIG_TEXT | grep -q /mnt/iscsi ); then
        echo "  ==== Bringing up $stack (SMB online, not dependent on iSCSI)"
        docker compose up -d 
    else
        echo "  ==== Skipping stack $stack (Dependent NAS service offline)"
    fi
    
    cd /home/admin/homelab/fighter/config/
    # make sure to overwrite the config text to prevent leaking secrets
    COMPOSE_CONFIG_TEXT="" 
done

# extra thing because my keycloak healthcheck doesn't work properly

echo "  ==== Wait 15s, then bring Keycloak forwardauth containers online"
cd /home/admin/homelab/fighter/config/keycloak
sleep 15
docker start keycloak_forwardauth keycloak_forwardauth-privileged