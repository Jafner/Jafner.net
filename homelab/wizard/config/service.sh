set service dhcp-server shared-network-name LAN domain-name 'local'
set service dhcp-server shared-network-name LAN domain-search 'local'
set service dhcp-server shared-network-name LAN name-server '192.168.1.32'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 default-router '192.168.1.1'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 lease '86400'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 range 1 start '192.168.1.100'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 range 1 stop '192.168.1.254'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping U6-Lite ip-address '192.168.1.3'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping U6-Lite mac-address '78:45:58:67:87:14'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping UAP-AC-LR ip-address '192.168.1.2'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping UAP-AC-LR mac-address '18:e8:29:50:f7:5b'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-desktop ip-address '192.168.1.100'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-desktop mac-address '04:92:26:DA:BA:C5'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-nas ip-address '192.168.1.10'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-nas mac-address '40:8d:5c:52:41:89'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-nas2 ip-address '192.168.1.11'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping joey-nas2 mac-address '90:2b:34:37:ce:ea'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-toes-day ip-address '192.168.1.50'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-toes-day mac-address '3C:61:05:F6:44:1E'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-lab-rack ip-address '192.168.1.51'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-lab-rack mac-address '3C:61:05:F6:D7:D3'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-sprout-day ip-address '192.168.1.52'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-sprout-day mac-address '3C:61:05:F7:52:DB'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-figment-day ip-address '192.168.1.53'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-figment-day mac-address '3C:61:05:F6:60:A1'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-figment-night ip-address '192.168.1.54'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-figment-night mac-address '3C:61:05:F7:34:CD'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-55 ip-address '192.168.1.55'
set service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping tasmota-55 mac-address '3C:61:05:F7:1F:C4'
set service dns forwarding allow-from '192.168.1.0/24'
set service dns forwarding cache-size '1000000'
set service dns forwarding listen-address '192.168.1.1'
set service dns forwarding name-server 192.168.1.32
set service monitoring telegraf prometheus-client
set service ntp allow-client address '0.0.0.0/0'
set service ntp allow-client address '::/0'
set service ntp server time-a-wwv.nist.gov
set service ntp server time-b-wwv.nist.gov
set service ntp server time-c-wwv.nist.gov
set service ntp server time-d-wwv.nist.gov
set service ntp server time-e-wwv.nist.gov
set service ssh disable-password-authentication
set service ssh port '22'
