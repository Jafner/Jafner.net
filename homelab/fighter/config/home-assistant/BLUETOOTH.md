- Startup: `bluetoothctl power on`
- Scanning: `bluetoothctl scan on`
- Enable LowEnergy (requires interactive prompt): 
```
$ bluetoothctl
Agent registered
[CHG] Controller 00:E0:4C:8B:01:03 Pairable: yes
[bluetooth]# menu scan
Menu scan:
Available commands:
-------------------
uuids [all/uuid1 uuid2 ...]                       Set/Get UUIDs filter
rssi [rssi]                                       Set/Get RSSI filter, and clears pathloss
pathloss [pathloss]                               Set/Get Pathloss filter, and clears RSSI
transport [transport]                             Set/Get transport filter
duplicate-data [on/off]                           Set/Get duplicate data filter
discoverable [on/off]                             Set/Get discoverable filter
pattern [value]                                   Set/Get pattern filter
clear [uuids/rssi/pathloss/transport/duplicate-data/discoverable/pattern] Clears discovery filter.
back                                              Return to main menu
version                                           Display version
quit                                              Quit program
exit                                              Quit program
help                                              Display help about this program
export                                            Print environment variables
[bluetooth]# transport le
[bluetooth]# back
[bluetooth]# power off
Changing power off succeeded
[CHG] Controller 00:E0:4C:8B:01:03 Powered: no
[CHG] Controller 00:E0:4C:8B:01:03 Discovering: no
[CHG] Controller 00:E0:4C:8B:01:03 Class: 0x00000000
[bluetooth]# power on
[CHG] Controller 00:E0:4C:8B:01:03 Class: 0x006c0104
Changing power on succeeded
[CHG] Controller 00:E0:4C:8B:01:03 Powered: yes
[bluetooth]# discoverable on
[CHG] Controller 00:E0:4C:8B:01:03 Discoverable: yes
Changing discoverable on succeeded
[bluetooth]# scan on
Discovery started
[CHG] Controller 00:E0:4C:8B:01:03 Discovering: yes
```