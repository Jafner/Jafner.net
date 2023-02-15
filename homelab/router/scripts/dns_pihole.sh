#!/bin/vbash
# https://docs.vyos.io/en/equuleus/automation/command-scripting.html
source /opt/vyatta/etc/functions/script-template
configure

delete service dns forwarding name-server 1.1.1.1
set service dns forwarding name-server 192.168.1.21
set service dns forwarding name-server 192.168.1.22

delete service dhcp-server shared-network-name LAN name-server 192.168.1.1
set service dhcp-server shared-network-name LAN name-server 192.168.1.21
set service dhcp-server shared-network-name LAN name-server 192.168.1.22

commit
save
exit