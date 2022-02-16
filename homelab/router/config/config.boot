firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 30 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    options {
        mss-clamp {
            mss 1412
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        description "Internet (PPPoE)"
        duplex auto
        pppoe 0 {
            default-route auto
            firewall {
                in {
                    name WAN_IN
                }
                local {
                    name WAN_LOCAL
                }
            }
            mtu 1492
            name-server auto
            password 24ydrUYs
            user-id hafnerjoseph
        }
        speed auto
    }
    ethernet eth1 {
        address 192.168.2.1/24
        description Local
        duplex auto
        speed auto
    }
    ethernet eth2 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth3 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth4 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth5 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth6 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth7 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth8 {
        description "Local 2"
        duplex auto
        speed auto
    }
    ethernet eth9 {
        description "Local 2"
        duplex auto
        poe {
            output 24v
        }
        speed auto
    }
    loopback lo {
    }
    switch switch0 {
        address 192.168.1.1/24
        description "Local 2"
        mtu 1500
        switch-port {
            interface eth2 {
            }
            interface eth3 {
            }
            interface eth4 {
            }
            interface eth5 {
            }
            interface eth6 {
            }
            interface eth7 {
            }
            interface eth8 {
            }
            interface eth9 {
            }
            vlan-aware disable
        }
    }
}
port-forward {
    auto-firewall enable
    hairpin-nat enable
    lan-interface switch0
    rule 1 {
        description "Teamspeak (Voice)"
        forward-to {
            address 192.168.1.23
            port 9987
        }
        original-port 9987
        protocol udp
    }
    rule 2 {
        description "Teamspeak (FileTransfer)"
        forward-to {
            address 192.168.1.23
            port 30033
        }
        original-port 30033
        protocol tcp
    }
    rule 3 {
        description "Teamspeak (ServerQuery)"
        forward-to {
            address 192.168.1.23
            port 10011
        }
        original-port 10011
        protocol tcp
    }
    rule 4 {
        description Plex
        forward-to {
            address 192.168.1.23
        }
        original-port 32400
        protocol tcp_udp
    }
    rule 5 {
        description BitTorrent
        forward-to {
            address 192.168.1.21
        }
        original-port 51000-51999
        protocol tcp_udp
    }
    rule 6 {
        description WireGuard
        forward-to {
            address 192.168.1.23
        }
        original-port 53820
        protocol tcp_udp
    }
    rule 7 {
        description Minecraft
        forward-to {
            address 192.168.1.23
            port 25565
        }
        original-port 25565
        protocol tcp_udp
    }
    rule 8 {
        description Iperf
        forward-to {
            address 192.168.1.23
        }
        original-port 50201
        protocol tcp_udp
    }
    rule 9 {
        description Bittorrent
        forward-to {
            address 192.168.1.101
            port 35050-35100
        }
        original-port 35050-35100
        protocol tcp_udp
    }
    rule 10 {
        description "Joplin Sync"
        forward-to {
            address 192.168.1.23
        }
        original-port 22300,5432
        protocol tcp
    }
    rule 11 {
        description https,http
        forward-to {
            address 192.168.1.23
        }
        original-port 443,80
        protocol tcp_udp
    }
    rule 12 {
        description "Peertube Live"
        forward-to {
            address 192.168.1.23
            port 22
        }
        original-port 1935
        protocol tcp_udp
    }
    rule 13 {
        description qBittorrent
        forward-to {
            address 192.168.1.100
            port 47691
        }
        original-port 47691
        protocol tcp_udp
    }
    rule 14 {
        description SSH
        forward-to {
            address 192.168.1.10
            port 22
        }
        original-port 60022
        protocol tcp_udp
    }
    rule 15 {
        description "Git SSH"
        forward-to {
            address 192.168.1.23
        }
        original-port 2228-2229
        protocol tcp_udp
    }
    wan-interface pppoe0
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name LAN1 {
            authoritative enable
            subnet 192.168.1.0/24 {
                default-router 192.168.1.1
                dns-server 192.168.1.1
                domain-name local
                lease 86400
                start 192.168.1.100 {
                    stop 192.168.1.254
                }
                static-mapping joey-nas {
                    ip-address 192.168.1.10
                    mac-address 40:8d:5c:52:41:89
                }
                static-mapping joey-seedbox {
                    ip-address 192.168.1.21
                    mac-address 24:4b:fe:57:bc:85
                }
                static-mapping joey-server {
                    ip-address 192.168.1.23
                    mac-address 24:4b:fe:8b:f3:b0
                }
                static-mapping pihole {
                    ip-address 192.168.1.22
                    mac-address b8:27:eb:3c:8e:bb
                }
            }
        }
        shared-network-name LAN2 {
            authoritative enable
            subnet 192.168.2.0/24 {
                default-router 192.168.2.1
                dns-server 192.168.2.1
                lease 86400
                start 192.168.2.38 {
                    stop 192.168.2.243
                }
            }
        }
        static-arp disable
        use-dnsmasq enable
    }
    dns {
        forwarding {
            cache-size 150
            listen-on switch0
            name-server 192.168.1.1
            name-server 1.1.1.1
            name-server 1.0.0.1
            options strict-order
            system
        }
    }
    gui {
        http-port 8080
        https-port 4433
        older-ciphers enable
    }
    nat {
        rule 5010 {
            description "masquerade for WAN"
            outbound-interface pppoe0
            type masquerade
        }
    }
    snmp {
        community hafnerhouse {
            authorization ro
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    unms {
        disable
    }
}
system {
    domain-name local
    host-name ubnt
    login {
        user admin {
            authentication {
                encrypted-password $5$j8QJRFCpc2Pc90kV$AA7DbPJldnwMlahDbbFWf0N9WiNnL9faW473jO9z1Z0
                public-keys joey {
                    key AAAAB3NzaC1yc2EAAAADAQABAAACAQCsb8bNhkAEq4Rz/7Z/yjqsp2OGtnhIzO7xA7BF+mHafN3vh3pSVBMTZJWY74JkXXE4PQPVJU6v9Qxt9x1+1ULQI2m3NIcaj5+GsXXkv/iCkJDz8XUAbdDObuxbh/sRURoVMhduE/JQpdX2Q4vWeKR3TEIdcVwR9eyhchLWzZpfdh+jJTjoAekglM8OusqyC7+iGriFSf3TFRe0J/AYrMGcWyL3FrxZMhEjDyND8H4wJ0r5AGbTbG7zEVr5lWui1RZkXIO02mYIh5BwrPuyIApemvU/u7mI0s256TvwnlBGjRlJdxvQWyOw07X3owX6vJZZ2tyd+pLTAtQ8i4K8mfpHqVZNVxaG8m1REDOf++RtzCI5S7ynYQjMTMnDUBxnjOyBANhxQTydGwh6ztOwX5XgzoQgA0t6cAD/stB1l7yosWypmk0rZMuHN9p3/5hnV+9FBmMMjoFCKE7wYQ15NPwEjrOzzfyZ5IVfCzmhAMsFDbDfACpIYR4hsRTMy5AOcbqmkX6dg4mK41sxIq2lzhZaNuM+C92802XUKDK7o/brQJ5brkFTWhfjmEJdfi1Tw/q/pdxrUZ87cT7BabzFSCqHIHwHciy6rRbTjEh7uiiQEY75ndakK2i2PbL+QCFSpLQyqWKEJzhpgBqN238dUdL1IkS/ti9I3rlLtc1eVjWd4w==
                    type ssh-rsa
                }
            }
            level admin
        }
    }
    name-server 127.0.0.1
    name-server 192.168.1.22
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
        hwnat enable
    }
    package {
        repository stretch {
            components "main contrib non-free"
            distribution stretch
            password ""
            url http://http.us.debian.org/debian
            username ""
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone America/Los_Angeles
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@5:nat@3:qos@1:quagga@2:suspend@1:system@4:ubnt-pptp@1:ubnt-udapi-server@1:ubnt-unms@1:ubnt-util@1:vrrp@1:vyatta-netflow@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v2.0.8.5247496.191120.1124 */
