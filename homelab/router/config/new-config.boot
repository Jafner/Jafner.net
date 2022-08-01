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
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    bridge br0 {
        address 192.168.1.1/24
        member {
            interface eth1 {
            }
            interface eth2 {
            }
        }
    }
    ethernet eth0 {
        address 192.168.200.1/24
        description "Emergency ad-hoc"
        duplex auto
        hw-id d4:3d:7e:94:6e:eb
        speed auto
    }
    ethernet eth1 {
        description "Primary Switch"
        duplex auto
        hw-id 00:15:17:b8:dc:28
        offload {
            sg
            tso
        }
        speed auto
    }
    ethernet eth2 {
        description "PoE Switch for WAPs"
        duplex auto
        hw-id 00:15:17:b8:dc:29
        offload {
            sg
            tso
        }
        speed auto
    }
    ethernet eth3 {
        description "Reserved for multi-gig switch"
        hw-id 00:15:17:b8:dc:2a
        offload {
            sg
            tso
        }
    }
    ethernet eth4 {
        address dhcp
        description "Internet (PPPoE)"
        duplex auto
        hw-id 00:15:17:b8:dc:2b
        ip {
            adjust-mss 1200
        }
        offload {
            sg
            tso
        }
        speed auto
    }
    loopback lo {
    }
    pppoe pppoe0 {
        authentication {
            password ****************
            user hafnerjoseph
        }
        firewall {
            in {
                name WAN_IN
            }
            local {
                name WAN_LOCAL
            }
        }
        mtu 1492
        no-peer-dns
        source-interface eth4
    }
}
nat {
    destination {
        rule 101 {
            description https,http
            destination {
                port 443,80
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 102 {
            description Plex
            destination {
                port 32400
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 103 {
            description BitTorrent
            destination {
                port 50000
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 104 {
            description WireGuard
            destination {
                port 53820-53829
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 105 {
            description Minecraft
            destination {
                port 25565
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 106 {
            description Iperf
            destination {
                port 50201
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 107 {
            description "PeerTube Live"
            destination {
                port 1935
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 108 {
            description "Git SSH"
            destination {
                port 2228-2229
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 109 {
            description SFTP
            destination {
                port 23450
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 110 {
            description Terraria
            destination {
                port 50777
            }
            inbound-interface eth4
            protocol tcp_udp
            translation {
                address 192.168.1.100
                port 7777
            }
        }
    }
    source {
        rule 1000 {
            destination {
                address 192.168.1.0/24
            }
            outbound-interface eth1
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
        rule 1001 {
            destination {
                address 192.168.1.0/24
            }
            outbound-interface eth2
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
        rule 1002 {
            destination {
                address 192.168.1.0/24
            }
            outbound-interface eth3
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
    }
}
service {
    dhcp-server {
        shared-network-name LAN1 {
            authoritative
            domain-name local
            domain-search local
            name-server 1.1.1.1
            name-server 1.0.0.1
            subnet 192.168.1.0/24 {
                default-router 192.168.1.1
                lease 86400
                range 1 {
                    start 192.168.1.100
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
    }
    dns {
        forwarding {
            allow-from 0.0.0.0/0
            allow-from ::/0
            cache-size 1000000
            listen-address 192.168.1.1
            name-server 192.168.1.1
            name-server 1.1.1.1
            name-server 1.0.0.1
            system
        }
    }
    monitoring {
        telegraf {
            prometheus-client {
            }
        }
    }
    ssh {
        disable-password-authentication
        port 22
    }
}
system {
    config-management {
        commit-revisions 200
    }
    conntrack {
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    host-name vyos
    login {
        user vyos {
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
        }
    }
    name-server 192.168.1.1
    name-server 1.1.1.1
    name-server 1.0.0.1
    name-server eth4
    ntp {
        server time-a-wwv.nist.gov {
        }
        server time-b-wwv.nist.gov {
        }
        server time-c-wwv.nist.gov {
        }
        server time-d-wwv.nist.gov {
        }
        server time-e-wwv.nist.gov {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone America/Los_Angeles
}
