#!/bin/vbash

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

source /opt/vyatta/etc/functions/script-template

configure

source test.sh
#source firewall.sh
#source interfaces.sh
#source nat.sh
#source qos.sh
#source service.sh
#source system.sh

compare
commit
save
exit