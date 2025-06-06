# Working With VyOS
We have a helper script, [`vyos.sh`](./vyos.sh) that provides useful utilities for interacting with our VyOS host.

Run `alias vy="$(realpath ./vyos.sh)"` for faster usage.

- The host to interact with is configured via the `VYOS_TARGET` near the top of the script.
- `get_config_saved` Prints the contents of `/config/config.boot` to stdout.
- `get_config_active` Prints the active config (like `show` in config mode) to stdout.
- `post_config` Copies the local `config.boot` to the remote `/home/vyos/config.boot`.
- `load_config` Enters config mode and runs `load /home/vyos/config.boot`, then attempts to `commit; exit` (note: does not save config).
- `save_config` Enters config mode and runs `save; exit`.
- `op` Runs the proceding commands in op mode on the target.

## Workflow Examples
1. Pull the latest config with `vy get_config_saved > config.boot`
2. Edit the config file with the desired changes.
3. Push the changes to the remote with `vy post_config && vy load_config && vy save_config`

This workflow is provided with a compound function from the helper script; `vy edit`.

# Update VyOS
1. Navigate to [VyOS nightly builds](https://vyos.net/get/nightly-builds/) and copy the link for the most recent build.
2. SSH into the VyOS host and run `add system image <link to build image>`
3. When prompted, answer yes (default) to:
	1. Would you like to save current configuration directory and config file? (Yes/No) [Yes]
	2. Would you like to save the SSH host keys from your current configuration? (Yes/No) [Yes]
4. Reboot into the new image.

Note: If you do not want the most recent image to be used by default, you can use the command `set system image default-boot <image>`
You can view available system images with `show system image`, which will include telling you which is currently the default boot image.
You can delete old system images with `delete system image <image>`

# Port Forwarding Rules
| Rule | Incoming Port | Protocol | Docs |
|:----:|:-------------:|:--------:|:----:|
| Plex | 32400 | Both | [support.plex.tv](https://support.plex.tv/articles/201543147-what-network-ports-do-i-need-to-allow-through-my-firewall/)
| BitTorrent | 51000-51999 | Both | [wikipedia.org](https://en.wikipedia.org/wiki/BitTorrent)
| WireGuard | 53820 | Both | [wireguard.com](https://www.wireguard.com/quickstart/)
| Minecraft | 25565 | Both | [portforward.com](https://portforward.com/minecraft/)
| Iperf | 50201 | Both | [iperf.fr](https://iperf.fr/iperf-doc.php)
| http/s | 80,443 | Both | [wikipedia.org](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol)
| Peertube Live | 1935 | Both | [joinpeertube.org](https://docs.joinpeertube.org/admin-configuration?id=live-streaming)
| Git SSH | 2228-2229 | Both | [gitlab.com](https://docs.gitlab.com/ee/install/docker.html)

## Non-Default Port Mappings
Some services have been configured to use non-standard port mappings. This is usually done to mitigate the risk of automated port-checking probes.

* BitTorrent. This range is used to distribute all bittorrent connections across a wide range of high-number ports.
* Wireguard. This was set to a non-standard port-mapping before I learned [WireGuard doesn't respond to unauthenticated packets](https://news.ycombinator.com/item?id=24550238), which makes this unnecessary.
* Iperf. Iperf defaults to port 5201, which is not a high-number port. Since it is unauthenticated, I use a non-default, high-number port instead.
* Git SSH. I use a non-default port for my GitLab SSH server to minimize potential conflicts with other services on the network. It is important to be able to access the GitLab instance over SSH outside the network.

# DNS Resolution Structure
```mermaid
graph TD;
    Client --> Router;
    Router --> PiHole;
    PiHole -- Ad --> /dev/null;
    PiHole -- Real --> Cloudflare;
```

# DHCP Configuration Parameters
| Parameter | Value |
|:-:|:-:|
| DHCP Name | LAN1 |
| Subnet | 192.168.1.0/24 |
| Lease Pool | 192.168.1.100-254/24 |
| Router | 192.168.1.1 |
| DNS1 | 192.168.1.1 |
| DNS2 | - |
| Domain | local |
| Lease TTL | 86400 seconds |

## Static DHCP Mappings
On the VyOS router, enter configuration mode with `configure`, then run `show service dhcp-server shared-network-name LAN subnet 192.168.1.0/24 static-mapping` (assuming you use the network name "LAN" and the subnet "192.168.1.0/24").

```
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
```

# Get Currently Configured Hairpin NAT Address
```
configure
show nat destination rule 1100 destination address
```

# CLI Reference
* [EdgeOS User Guide PDF](https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf)
* EdgeOS is built on [Vyatta](https://en.wikipedia.org/wiki/Vyatta)
* To make configuration changes in the CLI, run `configure`, make the changes (e.g. `set interfaces ethernet eth0 dhcpv6-pd pd 0 interface eth1`), then save the changes with `commit; save; exit`.

## Configure SSH Keys
Via: https://thehomeofthefuture.com/how-to/use-an-ssh-key-with-an-ubiquiti-edgerouter/

### Via WebUI
1. Navigate to the Config Tree
2. Dig down to `system / login / user / admin / authentication / public-keys /`
3. Add a new "public-keys" value with the name of the key.
4. Refresh the tree and open the newly-created sub-directory named after the key.
5. Add the key information here. Leave "options" empty. Omit `ssh-rsa` and the comment from the key, place the type in the "type" field.
6. Click "Preview" then "Apply"

### Via SSH
1. SSH into system
2. `configure`
3.
```sh
set system login user admin authentication public-keys jafner425@gmail.com
set system login user admin authentication public-keys jafner425@gmail.com type ssh-rsa
set system login user admin authentication public-keys jafner425@gmail.com key $KEY_VALUE
```
4. `commit; save; exit`

# Check Traffic by TCP Connection
To get a monitoring panel of bandwidth usage listed by connection on the internet, use `sudo iftop -i pppoe1`.
To instead get usage listed by connection on LAN, use `sudo iftop -p -i eth6`

[`iftop` docs](https://linux.die.net/man/8/iftop). Use [`pcap-filter'](https://www.tcpdump.org/manpages/pcap-filter.7.html) syntax for filtering with the `-f` flag.

# Setting up the Aruba S2500-48P
Followed the instructions given in [this video](https://www.youtube.com/watch?v=HegeBkglsec)

1. Reset to factory settings.
2. Basic configuration (using static IP 192.168.1.9).
3. Flashed new firmware image (7.4.0.7, built 2021_07_07) to default boot partition.
4. Deleted stacking interfaces for 3rd and 4th SFP+ ports.
5. Flashed new firmware image (7.4.0.7, built 2021_07_07) to backup boot partition.

Additional reference: https://forums.serverbuilds.net/t/official-aruba-s2500-managed-ethernet-switch-poe-10gsfp/5038
