#!/bin/bash

# Set CLOUDFLARE_API_TOKEN
export CLOUDFLARE_API_TOKEN=$(cat secrets.env | cut -d'=' -f2)

ZONES_LIST="jafner.net jafner.dev jafner.tools jafner.chat"
function get_zone_id () {
    # Takes one zone name (e.g. jafner.net) as a positional argument
    # Returns the zone ID to stdout
    ZONE_NAME=$1
    curl -s\
        -X GET "https://api.cloudflare.com/client/v4/zones" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type:application/json" |\
        jq -r --arg ZONE_NAME "$ZONE_NAME" '.[].[] | select(.name==$ZONE_NAME) | .id' 2>/dev/null
}

for ZONE_NAME in $(echo "$ZONES_LIST"); do 
    ZONE_ID=$(get_zone_id $ZONE_NAME)
    TF_FILE_NAME="${ZONE_NAME}.import.tf"
    cf-terraforming generate \
        --resource-type "cloudflare_record" \
        --zone $ZONE_ID > $TF_FILE_NAME
    sleep 2
    cf-terraforming import \
        --resource-type "cloudflare_record" \
        --zone $ZONE_ID >> /tmp/cf-terraforming-commands
    sleep 2
done

source /tmp/cf-terraforming-commands
