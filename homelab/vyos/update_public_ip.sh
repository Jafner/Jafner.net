#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
unalias exit

SCRIPT_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "SCRIPT_PATH: $SCRIPT_PATH"

echo "Checking for updates to NAT rules."

PUBLIC_IP="$(curl -s ipinfo.io/ip)"
echo "" > /tmp/commands
while IFS= read -r rule; do
    echo -n "Checking rule: $rule: "
    if [[ "$(echo $rule | cut -d' ' -f8 | xargs)" != "$(echo $PUBLIC_IP)" ]]; then
	echo "mismatched. Updating."
        echo "    $(echo $rule | cut -d' ' -f8 | xargs) != $(echo $PUBLIC_IP)"
        echo "$(echo "$rule" | cut -d' ' -f-7) $PUBLIC_IP" >> /tmp/commands
	echo "    New rule: $(echo "$rule" | cut -d' ' -f-7) $PUBLIC_IP"
    else
        echo "matched. Nothing to do."
    fi
done <<< "$(run show configuration commands | grep 'set nat destination' | grep 'destination address')"

if [[ "$(cat /tmp/commands | wc -l)" == "1" ]]; then # if our /tmp/commands file is empty, it will have 1 line. 
    echo "Nothing to do. Exiting."
    exit 0 
    echo "exiting did not work as expected..."
fi

echo "Entering configuration mode and sourcing commands list."
configure
source /tmp/commands
rm /tmp/commands

source /opt/vyatta/etc/functions/script-template
commit || exit discard
save || exit discard
exit
