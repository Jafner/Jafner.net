firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name IN_LOCAL {
        default-action accept
    }
    name IN_WAN {
        default-action accept
    }
    name LOCAL_IN {
        default-action accept
    }
    name LOCAL_WAN {
        default-action accept
    }
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
        rule 1000 {
            action accept
            description Plex
            destination {
                port 32400
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1001 {
            action accept
            description BitTorrent
            destination {
                port 50000
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1002 {
            action accept
            description WireGuard
            destination {
                port 53820-53829
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1003 {
            action accept
            description Minecraft
            destination {
                port 25565
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1004 {
            action accept
            description Iperf
            destination {
                port 50201
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1005 {
            action accept
            description Web
            destination {
                port 443,80
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1007 {
            action accept
            description "Git SSH"
            destination {
                port 2228-2229
            }
            protocol tcp_udp
            state {
                new enable
            }
        }
        rule 1008 {
            action accept
            description SFTP
            destination {
                port 23450
            }
            protocol tcp_udp
            state {
                new enable
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
        rule 20 {
            action accept
            protocol icmp
            state {
                new enable
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
    ethernet eth0 {
        address 192.168.200.1/24
        description "Emergency ad-hoc"
        duplex auto
        hw-id d4:3d:7e:94:6e:eb
        speed auto
    }
    ethernet eth5 {
        address dhcp
        hw-id 6c:b3:11:32:46:24
        offload {
            sg
            tso
        }
        vif 201 {
        }
    }
    ethernet eth6 {
        address 192.168.1.1/24
        description "Primary Switch"
        duplex auto
        hw-id 6c:b3:11:32:46:25
        offload {
            sg
            tso
        }
        speed auto
    }
    loopback lo {
    }
    pppoe pppoe1 {
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
        ip {
            adjust-mss 1452
        }
        mtu 1492
        no-peer-dns
        source-interface eth5.201
    }
}
nat {
    destination {
        rule 1000 {
            description Plex
            destination {
                port 32400
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1001 {
            description BitTorrent
            destination {
                port 50000
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1002 {
            description WireGuard
            destination {
                port 53820-53829
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1003 {
            description Minecraft
            destination {
                port 25565
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1004 {
            description Iperf
            destination {
                port 50201
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1005 {
            description Web
            destination {
                port 443,80
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1007 {
            description "Git SSH"
            destination {
                port 2228-2229
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1008 {
            description SFTP
            destination {
                port 23450
            }
            inbound-interface pppoe1
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1100 {
            description "Plex (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 32400
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1102 {
            description "Wireguard (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 53820-53829
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1103 {
            description "Minecraft (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 25565
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1104 {
            description "Iperf (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 50201
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1105 {
            description "Web (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 80,443
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1107 {
            description "Git SSH (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 2228-2229
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
        rule 1108 {
            description "SFTP (Hairpin NAT)"
            destination {
                address 174.21.49.117
                port 23450
            }
            inbound-interface eth6
            protocol tcp_udp
            translation {
                address 192.168.1.23
            }
        }
    }
    source {
        rule 99 {
            description "Masquerade as public IP on internet"
            outbound-interface pppoe1
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
        rule 100 {
            description "NAT Reflection"
            destination {
                address 192.168.1.0/24
            }
            outbound-interface eth6
            protocol tcp_udp
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
        shared-network-name LAN {
            domain-name local
            domain-search local
            name-server 192.168.1.22
            name-server 192.168.1.21
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
                static-mapping joey-desktop {
                    ip-address 192.168.1.100
                    mac-address 04:92:26:DA:BA:C5
                }
                static-mapping joey-nas {
                    ip-address 192.168.1.10
                    mac-address 40:8d:5c:52:41:89
                }
                static-mapping joey-server {
                    ip-address 192.168.1.23
                    mac-address 70:85:c2:9c:6a:16
                }
                static-mapping joey-server2 {
                    ip-address 192.168.1.24
                    mac-address 24:4b:fe:57:bc:85
                }
                static-mapping joey-server3 {
                    ip-address 192.168.1.25
                    mac-address 78:45:c4:05:4f:21
                }
                static-mapping joey-server4 {
                    ip-address 192.168.1.26
                    mac-address 90:2b:34:37:ce:e8
                }
                static-mapping joeyPrinter {
                    ip-address 192.168.1.60
                    mac-address 9c:32:ce:7c:f8:25
                }
                static-mapping pihole {
                    ip-address 192.168.1.22
                    mac-address b8:27:eb:3c:8e:bb
                }
                static-mapping raspi2 {
                    ip-address 192.168.1.21
                    mac-address b8:27:eb:ff:76:6e
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
            allow-from 192.168.1.0/24
            cache-size 1000000
            listen-address 192.168.1.1
            name-server 192.168.1.22
            name-server 192.168.1.21
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
    upnp {
        listen eth1
        nat-pmp
        secure-mode
        wan-interface pppoe1
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
        banner {
        }
        user vyos {
            authentication {
                encrypted-password ****************
                public-keys jafner425@gmail.com {
                    key ****************
                    type ssh-rsa
                }
                public-keys joey@fedora {
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
    name-server 127.0.0.1
    name-server 192.168.1.22
    name-server 192.168.1.21
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
zone-policy {
    zone LAN {
        default-action drop
        from LOCAL {
            firewall {
                name LOCAL_IN
            }
        }
        from WAN {
            firewall {
                name WAN_IN
            }
        }
        interface eth1
        interface eth6
    }
    zone LOCAL {
        default-action drop
        from LAN {
            firewall {
                name IN_LOCAL
            }
        }
        from WAN {
            firewall {
                name WAN_LOCAL
            }
        }
        local-zone
    }
    zone WAN {
        default-action drop
        from LAN {
            firewall {
                name IN_WAN
            }
        }
        from LOCAL {
            firewall {
                name LOCAL_WAN
            }
        }
        interface pppoe1
    }
}