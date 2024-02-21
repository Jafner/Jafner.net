#!/bin/bash

# Check for network mounted devices
# NAS SMB
if ! mount -t cifs | grep -q '/mnt/nas'; then
    echo "  ==== NAS SMB shares not mounted"
    exit 1
fi

# NAS iSCSI
if ! sudo iscsiadm -m session | grep -q 'iqn.2020-03.net.jafner:fighter'; then 
    echo "  ==== NAS iSCSI session not connected"
    if ! mount -t ext4 | grep -q '/mnt/iscsi'; then
        echo "  ==== /mnt/iscsi not mounted"
        exit 1
    fi
fi

for stack in /home/admin/homelab/fighter/config/*; do
    cd $stack 
    if ! docker compose config; then 
        echo "  ==== Invalid compose config: $stack"
    fi
    echo "  ==== Bringing up $stack"
    docker compose up -d 
    cd /home/admin/homelab/fighter/config/
done

# extra thing because my keycloak healthcheck doesn't work properly

echo "  ==== Wait 15s, then bring Keycloak forwardauth containers online"
cd /home/admin/homelab/fighter/config/keycloak
sleep 15
docker compose up -d