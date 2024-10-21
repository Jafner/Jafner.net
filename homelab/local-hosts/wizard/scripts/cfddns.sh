#!/bin/bash
# Takes two positional arguments:
# $1 is the name of the zone to update
#   E.g. jafner.net
# $2 is an auth token for Cloudflare;
#   Must have the following permissions 
#   for the given zone:
#   - Zone: Read
#   - DNS: Read
#   - DNS: Edit
function cfddns () {
  ZONE=$1
  TOKEN=$2

  # 1. Get the zone ID from the zone name
  ZONE_ID=$(
    curl -s \
      -X GET "https://api.cloudflare.com/client/v4/zones" \
      --header "Authorization: Bearer $TOKEN" \
      --header "Content-Type:application/json" |\
      jq -r --arg NAME "$ZONE" '.[] | .[]? | select(.name?==$NAME) | .id' 2>/dev/null |\
      xargs
  ); echo $ZONE_ID
  
  # 2. Get the record ID of the root A record
  RECORD_ID=$(
    curl -s \
      -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
      --header "Authorization: Bearer $TOKEN" \
      --header 'Content-Type:application/json' |\
      jq -r --arg NAME "$ZONE" '.[] | .[]? | select(.type=="A") | select(.name?==$NAME) | .id' 2>/dev/null |\
      xargs
  ); echo $RECORD_ID

  # 3. Compose the json payload for the record to push
  DATA=$(jq --null-input \
    --arg CONTENT "$(curl -s ipinfo.io/ip)" \
    --arg NAME "$ZONE" \
    '{"content": $CONTENT, "name": $NAME, "type": "A"}'
  ); echo $DATA

  # 4. Finally submit the updated record to Cloudflare
  curl --request PUT \
    --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID \
    --header "Authorization: Bearer $TOKEN" \
    --header 'Content-Type:application/json' \
    --data "$DATA" > /dev/null 2>&1
}

cfddns $1 $2