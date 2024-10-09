#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure
load /home/vyos/config.boot

echo "Running commit && exit"
commit && exit || exit discard