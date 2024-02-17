#!/bin/bash

# Check for network mounted devices
# NAS SMB
if ! mount -t cifs | grep -q '/mnt/nas'; then
    echo "NAS SMB shares not mounted"
    exit 1
fi

# NAS iSCSI
if ! sudo iscsiadm -m session | grep -q 'iqn.2020-03.net.jafner:fighter'; then 
    echo "NAS iSCSI share not mounted"
    exit 1
fi

for stack in /home/admin/homelab/fighter/config/*; do
    cd $stack 
    docker compose up -d 
    cd /home/admin/homelab/fighter/config/
done
