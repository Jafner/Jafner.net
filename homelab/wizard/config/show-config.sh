#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

run show configuration all | /usr/libexec/vyos/strip-private.py

exit