#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

# create copies of config for modification and backup
cp /config/config.boot /config/config.new
cp /config/config.boot /config/backups/config.bk-$(date +%Y-%m-%d)
# get current public IP
NEW_IP=$(run show interfaces pppoe pppoe1 | grep "inet\s" | cut -d ' ' -f 6)
# get old public IP
OLD_IP=$(run show nat destination rules | grep 1100 | head -1 | cut -d ' ' -f 8)

# edit the config.new file
sed -i "s/$OLD_IP/$NEW_IP/" /config/config.new

# switch mode to config
configure

# apply the new config
load /config/config.new
{ # try commit, save, exit
    commit && save && exit
} || { # catch, exit discard and create a very basic error file
    exit discard
    echo "Script failed. Write some real error handling."
}
