firewall {
    global-options {
        all-ping enable
        broadcast-ping disable
        ipv6-receive-redirects disable
        ipv6-src-route disable
        ip-src-route disable
        log-martians enable
        receive-redirects disable
        send-redirects enable
        source-validation disable
        syn-cookies enable
    }
    group {
        interface-group IG_LAN {
            interface eth6
        }
        interface-group IG_WAN {
            interface pppoe1
        }
    }
    ipv4 {
        forward {
            filter {
                default-action accept
                rule 5 {
                    action jump
                    inbound-interface {
                        interface-name pppoe1
                    }
                    jump-target WAN_IN
                }
                rule 101 {
                    action accept
                    inbound-interface {
                        interface-group IG_LAN
                    }
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 106 {
                    action jump
                    inbound-interface {
                        interface-group IG_WAN
                    }
                    jump-target WAN_IN
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 111 {
                    action drop
                    description "zone_LAN default-action"
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 116 {
                    action accept
                    inbound-interface {
                        interface-group IG_WAN
                    }
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
                rule 121 {
                    action jump
                    inbound-interface {
                        interface-group IG_LAN
                    }
                    jump-target IN_WAN
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
                rule 126 {
                    action drop
                    description "zone_WAN default-action"
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
            }
        }
        input {
            filter {
                default-action accept
                rule 5 {
                    action jump
                    inbound-interface {
                        interface-name pppoe1
                    }
                    jump-target WAN_LOCAL
                }
                rule 101 {
                    action jump
                    inbound-interface {
                        interface-group IG_LAN
                    }
                    jump-target IN_LOCAL
                }
                rule 106 {
                    action jump
                    inbound-interface {
                        interface-group IG_WAN
                    }
                    jump-target WAN_LOCAL
                }
                rule 111 {
                    action drop
                }
            }
        }
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
                    port 49500
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
        output {
            filter {
                default-action accept
                rule 101 {
                    action jump
                    jump-target LOCAL_IN
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 106 {
                    action jump
                    jump-target LOCAL_WAN
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
                rule 111 {
                    action drop
                }
            }
        }
    }
    ipv6 {
        forward {
            filter {
                default-action accept
                rule 101 {
                    action accept
                    inbound-interface {
                        interface-group IG_LAN
                    }
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 106 {
                    action drop
                    description "zone_LAN default-action"
                    outbound-interface {
                        interface-group IG_LAN
                    }
                }
                rule 111 {
                    action accept
                    inbound-interface {
                        interface-group IG_WAN
                    }
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
                rule 116 {
                    action drop
                    description "zone_WAN default-action"
                    outbound-interface {
                        interface-group IG_WAN
                    }
                }
            }
        }
        input {
            filter {
                default-action accept
                rule 101 {
                    action drop
                }
            }
        }
        output {
            filter {
                default-action accept
                rule 101 {
                    action drop
                }
            }
        }
    }
}
interfaces {
    ethernet eth0 {
        hw-id d4:3d:7e:94:6e:eb
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
            rps
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
            username hafnerjoseph
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
                port 49500
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
        rule 1100 {
            description "Plex (Hairpin NAT)"
            destination {
                address 174.21.57.251
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
                address 174.21.57.251
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
                address 174.21.57.251
                port 25565
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
                address 174.21.57.251
                port 80,443
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
qos {
    interface eth6 {
        egress GIGABIT-FQCODEL
    }
    interface pppoe1 {
        ingress LIMITER
    }
    policy {
        fq-codel GIGABIT-FQCODEL {
            codel-quantum 8000
            flows 1024
            queue-limit 800
        }
        limiter LIMITER {
            default {
                bandwidth 700mbit
                burst 262.5mbit
            }
        }
    }
}
service {
    dhcp-server {
        shared-network-name LAN {
            domain-name local
            domain-search local
            name-server 192.168.1.32
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
                static-mapping joey-nas2 {
                    ip-address 192.168.1.11
                    mac-address 90:2b:34:37:ce:ea
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
                static-mapping pihole1 {
                    ip-address 192.168.1.21
                    mac-address b8:27:eb:3c:8e:bb
                }
                static-mapping pihole2 {
                    ip-address 192.168.1.22
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
                static-mapping wyse1 {
                    ip-address 192.168.1.31
                    mac-address 6c:2b:59:37:89:40
                }
                static-mapping wyse2 {
                    ip-address 192.168.1.32
                    mac-address 6c:2b:59:37:9e:91
                }
                static-mapping wyse3 {
                    ip-address 192.168.1.33
                    mac-address 6c:2b:59:37:9e:00
                }
            }
        }
    }
    dns {
        forwarding {
            allow-from 192.168.1.0/24
            cache-size 1000000
            listen-address 192.168.1.1
            name-server 192.168.1.32 {
            }
        }
    }
    monitoring {
        telegraf {
            prometheus-client {
            }
        }
    }
    ntp {
        allow-client {
            address 0.0.0.0/0
            address ::/0
        }
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
        expect-table-size 8192
        hash-size 32768
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
        table-size 262144
        timeout {
            tcp {
                time-wait 15
            }
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
                otp {
                    key ****************
                    rate-limit 3
                    rate-time 30
                    window-size 3
                }
                public-keys ed25519_jafner425@gmail.com {
                    key ****************
                    type ssh-ed25519
                }
            }
        }
    }
    name-server 192.168.1.32
    option {
        performance latency
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility local7 {
                level debug
            }
        }
    }
    task-scheduler {
        task update-nat-reflection {
            executable {
                path /home/vyos/ipupdate.sh
            }
            interval 5
        }
    }
    time-zone America/Los_Angeles
}