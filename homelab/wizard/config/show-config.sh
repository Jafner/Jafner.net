#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

run show configuration all | strip-private

exit