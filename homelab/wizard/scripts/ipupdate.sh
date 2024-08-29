#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

SCRIPT_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
WEBHOOK_URL="$(cat $SCRIPT_PATH/webhook.token)"
NAT_COMMANDS="$(run show configuration commands | grep 'set nat destination' | grep 'destination address')"

# Assert all destination nat rules use the same IP
if [[ "$(echo "$NAT_COMMANDS" | cut -d' ' -f8 | sort -u | wc -l)" != "1" ]]; then
    curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"$SCRIPT_PATH/ipupdate.sh: Error: Existing NAT rules are not consistent\"}" $WEBHOOK_URL
fi

# Get new and old public IPs
PUBLIC_IP="$(curl -s ipinfo.io/ip)"

echo "$NAT_COMMANDS" | cut -d' ' -f-7 | while read line; do echo $line "$PUBLIC_IP"; done > /tmp/commands

configure; source /tmp/commands > /dev/null; rm /tmp/commands
compare |\
if [[ "$(cat -)" != *"No changes between working and active configurations."* ]]; then 
    curl -s -o /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"$SCRIPT_PATH/ipupdate.sh: Info: Attempting to update hairpin NAT rules. New public IP: $PUBLIC_IP\"}" $WEBHOOK_URL
    { # try commit, save, exit
        commit && save && exit
    } || { # catch, exit discard and create a very basic error file
        exit discard
        curl -s -o /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"$SCRIPT_PATH/ipupdate.sh: Error: Failed during commit, save, exit.\"}" $WEBHOOK_URL
    }
else
    exit
fi