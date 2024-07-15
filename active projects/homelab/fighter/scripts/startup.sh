#!/bin/bash
#set -x # debugging flag

# depends on the $COMPOSE_CONFIG_TEXT variable being populated with the compose config to check
function get_shares {
    SHARES=$(echo "$COMPOSE_CONFIG_TEXT" |\
    grep /mnt/ |\
    tr -s ' ' |\
    cut -d' ' -f 3 |\
    cut -d'/' -f-4 |\
    sort -u)
    #echo "$SHARES" # Debug echo
}

# depends on the $SHARES variable being populated with the shares to check
function check_shares {
    MISSING_SHARES=false
    for share in $SHARES; do
        #echo -n "      ==== Share $share: " # Debug echo
        if ! mount | grep -q $share; then
            #echo "ONLINE" # Debug echo
            MISSING_SHARES=true
        #else
            #echo "OFFLINE" # Debug echo
        fi
    done
}

function connect_iscsi {
    sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --login
}

function mount_iscsi {
    sudo mount /mnt/nas/iscsi
}

if [ "$1" = "clean" ]; then
    echo "  ==== Cleaning up old containers"
    # Clean up any remnants from unclean shutdown
    docker stop $(docker ps -q) # shut down running containers
    docker rm $(docker ps -aq) # remove all containers
fi

# NAS iSCSI
# First check for connection; attempt to connect and mount if not connected
echo "  ==== Checking iSCSI..."
if ! sudo iscsiadm -m session | grep -q 'iqn.2020-03.net.jafner:fighter'; then 
    echo "  ====== Attempting to connect and mount iSCSI"
    { 
        connect_iscsi && mount_iscsi && echo "  ====== Success!" 
    } || { 
        echo "  ====== Could not connect and mount iSCSI" 
    }
fi

# Second check if mounted; attempt to mount if not mounted
if ! mount | grep -q '/mnt/nas/iscsi'; then
    echo "  ====== Attempting to mount /mnt/nas/iscsi"
    { 
        mount_iscsi && echo "  ====== Success!" 
    } || { 
        echo "  ====== Could not mount /mnt/nas/iscsi" 
    }
fi
# Regarding the above, we will attempt to re-mount the share if the first step successfully connected and then failed to mount. 
# This is because I can't be bother to build more elegant logic.

for stack in /home/admin/homelab/fighter/config/*; do
    echo "  ==== Processing $stack"
    cd $stack 
    if ! docker compose config > /dev/null; then 
        echo "  ====== Invalid compose config: $stack"
    fi
    COMPOSE_CONFIG_TEXT=$(docker compose config)
    MISSING_SHARES=true # Ensures a failure in the checking logic doesn't online the stack
    get_shares
    check_shares
    if ! $MISSING_SHARES; then 
        echo  "  ====== Bringing up"
        STACKS_ONLINE+="$(echo $stack | xargs basename)\n"
        echo -n "  ======== Time: "
        ( time docker compose --progress quiet up -d ) 2>&1 | grep real | cut -f 2
        echo "  ====== Done!"
    else
        echo "  ====== Missing needed network shares. Skipping."
        STACKS_SKIPPED+="$(echo $stack | xargs basename)\n"
    fi
    
    cd /home/admin/homelab/fighter/config/
    # make sure to overwrite the config text to prevent leaking secrets
    COMPOSE_CONFIG_TEXT="" 
done

echo "  ==== List of stacks online:"
echo -e "$STACKS_ONLINE"
echo "  ==== List of stacks skipped:"
echo -e "$STACKS_SKIPPED"

# extra thing because my keycloak healthcheck doesn't work properly
echo "  ==== Wait 15s, then bring Keycloak forwardauth containers online"
cd /home/admin/homelab/fighter/config/keycloak
sleep 15
docker start keycloak_forwardauth keycloak_forwardauth-privileged