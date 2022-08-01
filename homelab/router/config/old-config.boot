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
            password ****************
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
        description Plex
        forward-to {
            address 192.168.1.23
        }
        original-port 32400
        protocol tcp_udp
    }
    rule 2 {
        description BitTorrent
        forward-to {
            address 192.168.1.21
        }
        original-port 51000-51999
        protocol tcp_udp
    }
    rule 3 {
        description WireGuard
        forward-to {
            address 192.168.1.23
        }
        original-port 53820-53829
        protocol tcp_udp
    }
    rule 4 {
        description Minecraft
        forward-to {
            address 192.168.1.23
            port 25565
        }
        original-port 25565
        protocol tcp_udp
    }
    rule 5 {
        description Iperf
        forward-to {
            address 192.168.1.23
        }
        original-port 50201
        protocol tcp_udp
    }
    rule 6 {
        description https,http
        forward-to {
            address 192.168.1.23
        }
        original-port 443,80
        protocol tcp_udp
    }
    rule 7 {
        description "Peertube Live"
        forward-to {
            address 192.168.1.23
            port 22
        }
        original-port 1935
        protocol tcp_udp
    }
    rule 8 {
        description "Git SSH"
        forward-to {
            address 192.168.1.23
        }
        original-port 2228-2229
        protocol tcp_udp
    }
    rule 9 {
        description SFTP
        forward-to {
            address 192.168.1.23
        }
        original-port 23450
        protocol tcp_udp
    }
    rule 10 {
        description Terraria
        forward-to {
            address 192.168.1.100
            port 7777
        }
        original-port 50777
        protocol tcp_udp
    }
    rule 11 {
        description BitTorrent
        forward-to {
            address 192.168.1.23
        }
        original-port 50000
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
                dns-server 1.1.1.1
                dns-server 1.0.0.1
                domain-name local
                lease 86400
                start 192.168.1.100 {
                    stop 192.168.1.254
                }
                static-mapping U6-Lite {
                    ip-address 192.168.1.3
                    mac-address 78:45:58:67:87:14
                }
                static-mapping UAP-AC-LR {
                    ip-address 192.168.1.2
                    mac-address 18:e8:29:50:f7:5b
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
                static-mapping joeyPrinter {
                    ip-address 192.168.1.60
                    mac-address 9c:32:ce:7c:f8:25
                }
                static-mapping pihole {
                    ip-address 192.168.1.22
                    mac-address b8:27:eb:3c:8e:bb
                }
                static-mapping tasmota-1 {
                    ip-address 192.168.1.50
                    mac-address 3C:61:05:F6:44:1E
                }
                static-mapping tasmota-2 {
                    ip-address 192.168.1.51
                    mac-address 3c:61:05:f6:d7:d3
                }
                static-mapping tasmota-3 {
                    ip-address 192.168.1.52
                    mac-address 3c:61:05:f6:f0:62
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
                encrypted-password ****************
                public-keys jafner425@gmail.com {
                    key ****************
                    type ssh-rsa
                }
                public-keys joey@joey-server {
                    key ****************
                    type ssh-rsa
                }
            }
            level admin
        }
    }
    name-server 127.0.0.1
    name-server 1.1.1.1
    name-server 1.0.0.1
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
            password ****************
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