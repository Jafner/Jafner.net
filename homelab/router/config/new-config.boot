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
            mss 1456
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        description "Emergency ad-hoc"
        address 192.168.200.1/24
        duplex auto
        speed auto
    }
    ethernet eth1 {
        description "Primary Switch"
        duplex auto
        speed auto
    }
    ethernet eth2 {
        description "PoE Switch for WAPs"
        duplex auto
        speed auto
    }
    ethernet eth3 {
        description "Reserved for multi-gig switch"
        disabled
    }
    ethernet eth4 {
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
            name-server none
            password 24ydrUYs
            user-id hafnerjoseph
        }
        speed auto
    }
    loopback lo {
    }
}
nat {
    destination { 
        rule 101 {
            description "https,http"
            inbound-interface eth4
            destination {
                port 443,80
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 102 {
            description "Plex"
            inbound-interface eth4
            destination {
                port 32400
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 103 {
            description "BitTorrent"
            inbound-interface eth4
            destination {
                port 50000
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 104 {
            description "WireGuard"
            inbound-interface eth4
            destination {
                port 53820-53829
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 105 {
            description "Minecraft"
            inbound-interface eth4
            destination {
                port 25565
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 106 {
            description "Iperf"
            inbound-interface eth4
            destination {
                port 50201
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 107 {
            description "PeerTube Live"
            inbound-interface eth4
            destination {
                port 1935
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 108 {
            description "Git SSH"
            inbound-interface eth4
            destination {
                port 2228-2229
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 109 {
            description "SFTP"
            inbound-interface eth4
            destination {
                port 23450
            }
            translation {
                address 192.168.1.23
            }
            protocol tcp_udp
        }
        rule 110 {
            description "Terraria"
            inbound-interface eth4
            destination {
                port 50777
            }
            translation {
                address 192.168.1.100
                port 7777
            }
            protocol tcp_udp
        }
    }
    source {
        rule 1000 {
            desription "NAT Reflection: Switch1"
            outbound-interface eth1
            destination {
                address 192.168.1.0/24
            }
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
        rule 1001 {
            desription "NAT Reflection: Switch2"
            outbound-interface eth2
            destination {
                address 192.168.1.0/24
            }
            source {
                address 192.168.1.0/24
            }
            translation {
                address masquerade
            }
        }
        rule 1002 {
            desription "NAT Reflection: Switch3"
            outbound-interface eth3
            destination {
                address 192.168.1.0/24
            }
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
            authoritative enable
            subnet 192.168.1.0/24 {
                default-router 192.168.1.1
                name-server 1.1.1.1
                name-server 1.0.0.1
                ping-check enable
                domain-name local
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
            cache-size 1000000
            listen-address 192.168.1.1
            name-server 192.168.1.1
            name-server 1.1.1.1
            name-server 1.0.0.1
            options strict-order
            system
        }
    }
    ssh {
        port 22
        protocol-version v2
        disable-password-authentication
    }
    monitoring {
        telegraf {
            prometheus-client {
            }
        }
    }


}
system {
    commit-revision 100
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
                encrypted-password $5$j8QJRFCpc2Pc90kV$AA7DbPJldnwMlahDbbFWf0N9WiNnL9faW473jO9z1Z0
                public-keys jafner425@gmail.com {
                    key AAAAB3NzaC1yc2EAAAADAQABAAAEAQCyolGiQAOvyKZ9GtPx2FbKwdt8twLuKs8l0+o3QVZsS5NCG4pX6GXuH8GspmHSedy4yfgVBN0NlOoVPpwxGslZZ5BLkOyhfcoiayPMbYyEpyiujcmnIUlNLI04otz7Ucqhopy+DC/+UpLTMqgnlevWDJW5YgYNAInPFNP7cIJ//sjimisP/su0n4DTzq/1WDUHN+Pk2LKw9P6NnAyk+RhSAH2v5Z/sq0FjUVxe57oNnCGec8KzVsxvI3PP44ax17n8MIyZlXhDa41+1u/LsE9oHSeidaWz8S8IZaRQbUkdtaViiOL+JS55ZOut11cmEOBTsXgmwEH9d1gLS5NKukwTDruBjznqJDXuFlcoRvHIYOTbBXVBDzI710kX7hucks/XZuUhXuOsO0hqQjqAJFX/LKbeR/XN+7AvuGIy25bslZu3/HUdL9UYhenm/AJL5YtUKRsLIeznRyHJcJ8905qgMIELRVWYxTDlekbsL5rNzrRSJ4+gV9Y5TFe1uxRaqqGiuyJ1T7/R2++z+p+sYoBJOY+vehUul7CtaYeVe7FUGuJzWHylkmkOMSJQb0XvjQWjFgSOstIf4MoFcRSfgztL4C2utDNayvR2XjLjRcaZnIzzAkBweY/g0Y0Jnnjk+dmnKWeoDHUXOT/GHGi/KfL4lwnQFRtS8x6M52sX417Of9K14ljILaHESJibjPN2jWboQdvTw0PFhbr72jr6+rhayuiP3n+5rENtDxwPlfYdSsCdgVyg7HC/2F6ZL5QHXctJFjIswMdJds+3pHnb7l5d4TiRdBQNQGVv7pYYfZdyqMGk5sdKXBzn/uS1a0SRqzJAhgH6nA67HfuBKq2xwu86hlOnc6hsFuehXAweaZ/UvTBiCE+4oYokAyHcpHsjOYqTmK6rSTTfGQ3Yc8zgD5vGb04tGRMVFA0+uQSrcBeIidxFZA1pbrMuDGDQDqtevIyna+rN958IWjCMvs8O+wro4SFYKAHYOkaBW0syQl1m/GKePcDJR6rkLx8eLrr6jaj4rHAS5fVJVYOpPIkrnfI5kTvnuRqJTH9NIaan3q4+6mAQ1prBqrtO2RUWcdmfkuVuUapDcqhgqGQqzsaKNWjsiCr21CPnYuj8pYItyJziF2VGS5oci2feCxWwbqqW8WUXZha7PnhQaIIiv7vyIo/JVWKK12v8UfeFRiRL73JOfFdtRCWldQxF2yRTt5gFxObCPQj5oSj1+Buc/IzQwqkKxeKpjUdtYt1RjsU3rJR1JDjEhrbbN/LZg986wkxrsLVqQmsXxSniai2X4vN+9KZu4kcg8Crk4g29+L0Snj0P7PQ61SXT3HMZxp5T2jLvekwLyn9yIKl75IiQSdgp+DIv
                    type ssh-rsa
                }
                public-keys joey@joey-server {
                    key AAAAB3NzaC1yc2EAAAADAQABAAACAQDOCCXndD7BbVmUHsYEkVLobZVBbZ8mgHjpKreUSsyZLah9Et2VxzATOh1bnXwapHu137h/cMeBDBPD3AfoCT3njd/mvVZB3INkyS8mPoFuwYViHmlW2L+6Bv5kGiMpjK/G5lPkKLsA79bTMu2kuAM6usslap3hEdwNW0vK3a+feM1RSwxirQmDXq4WRmsY9r4Md9wIfxLaezy0l0oK8k7xqMeiLrqMsrpsDOVV5Cb7iyufDqEx4QbicosrMD+C4Mql8ptdOYVj86jOND9lcpoqujOQWD2k8Cvl/zdoWY3ZG7duZjD9NYFgvM7F62LM5p7t5iNicxcegCqdZmFR5+ueZtoIn6BpCT4cvAWHSipRuvNmAWaQBnfr/NKh4H2QF0wJluDkG+wTrJPjH9FmK4sUHdOx+rqZ4iWhhZ7a2c4wNgm9i+UHoh//MPSvWOC5lQ97FvTUVBmE8BiWh8tZ82SxjSUtWaYPGZEmJvEIVXus70aY8Rwelxn9gXTwLlzRZl+0G7XOQia1EIj8VnUtPtWMxHeI09klOP1BRUVSRXBGOvz1UjbHIAEYvnxkTiW5LG1xxJopUQ3QiyDDERBbelLtM3iBIRFbVlFcqyIG3OsZaR90LwngBFIMtPZrv3vWTg3YdtMDw7uW1SVHHBDfxEc9cSBYQinVGupUmyztTLkM4Q==
                    type ssh-rsa
                }
            }
            level admin
        }
    }
    name-server 192.168.1.1
    name-server 1.1.1.1
    name-server 1.0.0.1
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
