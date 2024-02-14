Adding a Pihole container has hit a few roadblocks.  
Here is the basic container configuration I attempted to use:

```
container name pihole {
    cap-add net-admin
    environment TZ {
        value America/Los_Angeles
    }
    environment WEBPASSWORD {
        value Raider8-Payable-Veto-Dictation
    }
    image pihole/pihole
    memory 256
    network default {
        address 172.18.0.2
    }
    port dns {
        destination 53
        source 53
    }
    port webui {
        destination 80
        source 80
    }
    volume pihole_dnsmasq {
        destination /etc/dnsmasq
        source /home/vyos/container/pihole/dnsmasq
    }
    volume pihole_pihole {
        destination /etc/pihole
        source /home/vyos/container/pihole/pihole
    }
}
network default {
    prefix 172.18.0.0/16
}
```

With this configuration, we see the Pihole is failing to bring up the DNS service due to a port collision. 
