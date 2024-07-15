#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

# get current public IP
NEW_IP=$(show interfaces pppoe pppoe1 | grep "inet\s" | cut -d ' ' -f 6)
# get old public IP
OLD_IP=$(show nat destination rules | grep 1100 | head -1 | tr -s ' ' | cut -d' ' -f 3)


show configuration commands | grep $OLD_IP | sed --expression="s/$OLD_IP/$NEW_IP/" > ipupdate.tmp

configure

source ipupdate.tmp

{ # try commit, save, exit
    commit && save && exit
} || { # catch, exit discard and create a very basic error file
    exit discard
    echo "Script failed. Write some real error handling."
}

rm ipupdate.tmp
