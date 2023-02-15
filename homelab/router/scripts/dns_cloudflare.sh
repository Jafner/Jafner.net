#!/bin/vbash
# https://docs.vyos.io/en/equuleus/automation/command-scripting.html
source /opt/vyatta/etc/functions/script-template
configure

delete service dns forwarding name-server 192.168.1.21
delete service dns forwarding name-server 192.168.1.22
set service dns forwarding name-server 1.1.1.1

delete service dhcp-server shared-network-name LAN name-server 192.168.1.21
delete service dhcp-server shared-network-name LAN name-server 192.168.1.22
set service dhcp-server shared-network-name LAN name-server 192.168.1.1

commit
save
exit