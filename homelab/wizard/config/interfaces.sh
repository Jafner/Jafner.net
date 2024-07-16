set interfaces ethernet eth0 hw-id 'd4:3d:7e:94:6e:eb'
set interfaces ethernet eth5 address 'dhcp'
set interfaces ethernet eth5 hw-id '6c:b3:11:32:46:24'
set interfaces ethernet eth5 offload sg
set interfaces ethernet eth5 offload tso
set interfaces ethernet eth5 vif 201
set interfaces ethernet eth6 address '192.168.1.1/24'
set interfaces ethernet eth6 description 'Primary Switch'
set interfaces ethernet eth6 duplex 'auto'
set interfaces ethernet eth6 hw-id '6c:b3:11:32:46:25'
set interfaces ethernet eth6 offload rps
set interfaces ethernet eth6 offload sg
set interfaces ethernet eth6 offload tso
set interfaces ethernet eth6 speed 'auto'
set interfaces loopback lo
set interfaces pppoe pppoe1 authentication password $INTERFACES_PPPOE_PPPOE1_AUTHENTICATION_PASSWORD
set interfaces pppoe pppoe1 authentication username 'hafnerjoseph'
set interfaces pppoe pppoe1 ip adjust-mss '1452'
set interfaces pppoe pppoe1 mtu '1492'
set interfaces pppoe pppoe1 no-peer-dns
set interfaces pppoe pppoe1 source-interface 'eth5.201'
