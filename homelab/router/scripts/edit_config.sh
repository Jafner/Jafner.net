#!/bin/vbash
# https://docs.vyos.io/en/equuleus/automation/command-scripting.html
source /opt/vyatta/etc/functions/script-template

cp /config/config.boot /config/config.new
nano /config/config.new
configure
load /config/config.new
