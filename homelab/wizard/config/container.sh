set container name adguard cap-add net-bind-service
set container name adguard image adguard/adguardhome:latest
set container name adguard network adguard_net address 192.168.2.3

set container name adguard port webui destination 80
set container name adguard port webui protocol tcp
set container name adguard port webui source 80

set container name adguard port webui-tls destination 443
set container name adguard port webui-tls protocol tcp
set container name adguard port webui-tls source 443

set container name adguard port setup destination 3000
set container name adguard port setup protocol tcp
set container name adguard port setup source 3000

set container name adguard port dns destination 53
set container name adguard port dns protocol tcp
set container name adguard port dns source 53

set container name adguard port dns-udp destination 53
set container name adguard port dns-udp protocol udp
set container name adguard port dns-udp source 53

set container network adguard_net prefix 192.168.2.0/24

delete service dns
# deletes the following:
# set service dns forwarding allow-from '192.168.1.0/24'
# set service dns forwarding cache-size '1000000'
# set service dns forwarding listen-address '192.168.1.1'
# set service dns forwarding name-server 192.168.1.32

set service dhcp-server shared-network-name LAN name-server 192.168.2.3
set system name-server 192.168.2.3