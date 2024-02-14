#!/bin/vbash

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

source /opt/vyatta/etc/functions/script-template

configure

. test.sh
#. firewall.sh
#. interfaces.sh
#. nat.sh
#. qos.sh
#. service.sh
#. system.sh

exit