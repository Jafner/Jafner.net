#!/bin/bash

source ./webhook_secrets.env

generate_post_data() {
  cat <<EOF
{
  "content": "IP Address Changed",
  "embeds": [{
    "title": "IP Address Changed",
    "description": "New IP: $1",
    "color": "45973"
  }]
}
EOF
}

IP=$(curl ipinfo.io/ip)

if [ "$IP" != "$(cat ip.tmp)" ]; then
  curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data $IP)" $discord_webhook
fi

echo $IP > ip.tmp