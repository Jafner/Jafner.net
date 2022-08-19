# About
"Rackdown" is AWS slang for turning a rack of hosts off and on again. In this case, the "rack" refers to practically all components of the DC. Server, NAS, disk shelf, switches, router, PiHole, modem, APs, and desktops. This doc will consolidate previous docs and provide an overall shutdown and reboot procedure. 

# Overview (Dependency Graph)
```mermaid
flowchart TD;
	CLN["CenturyLink node"]<--Depends--ONT;
		ONT<--Cat5e-->Modem[ISP Modem/Router];
			Modem<--Cat5e-->Router[Ubiquiti EdgeRouter 10X];
				Router<--Cat5e-->switch_homelab[NetGear 8-Port Switch for Homelab];
					switch_homelab<--Cat6-->desktop_joey[Joey's Desktop];
					switch_homelab<--Cat5-->desktop_bridget[Bridget's Desktop];
					switch_homelab<--Cat6-->NAS;
						NAS<--SFP+ DAC-->Desktop;
						NAS<--SFP+ DAC-->Server;
					switch_homelab<--Cat6-->Server;
					switch_homelab<--Cat6-->Seedbox;
					switch_homelab<--Cat5e-->Pihole;
				Router<--Cat5e-->switch_basementtv[TP-Link 5-Port Switch for Basement TV];
					switch_basementtv<--Cat6-->desktop_maddie[Maddie's Desktop];
					switch_basementtv<--Cat5e-->client_tv_downstairs[Downstairs TV];
				Router<--Cat6-->wap_basement[Ubiquiti Unifi U6-Lite];
					wap_basement<--Wifi6 2.4/5GHz-->clients_wireless_basement[Basement Wireless Clients];
				Router<--Cat6-->wap_upstairs[Ubiquiti Unifi UAP-AC-LR];
					wap_upstairs<--Wifi5 2.4/5GHz-->clients_wireless_upstairs[Upstairs Wireless Clients];
				Router<--Cat6-->desktop_mom[Mom's Desktop];
				Router<--Cat6-->desktop_dad[Dad's Desktop];
				Router<-->desktop_gus[Gus' Desktop];	
```

# Per-Node Reboot Instructions
For each of these, it is assumed that all dependent nodes have already been shut down as necessary.
## Rebooting the ONT
1. Unplug the 6-pin power plug. Wait 15 seconds.
2. Plug the power plug back in. Wait for the top three lights to be solid green.

## Rebooting the modem (Zyxel C3000Z)
1. Unplug the barrel power plug. Wait 15 seconds.
2. Plug the power plug back in. Wait for the "Power" and "WAN/LAN" lights to be solid green (the WAN/LAN light might flicker, that's okay. )

## Rebooting the Router (Ubiquiti EdgeRouter 10X)
1. Uplug the barrel power plug. Wait 15 seconds. 
2. Plug the power plug back in. Wait for the indicator LED to be solid white.

## Server
### Shutdown
1. SSH into the router to reconfigure its DNS resolution.
2. Reconfigure the router's DNS resolution: 

```
configure
delete system name-server 192.168.1.23
set system name-server 1.1.1.1
delete service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 192.168.1.23
set service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 1.1.1.1
commit; save; exit
```

3. Shut down Minecraft servers: `cd ~/homelab/server/config/minecraft && for service in ./*.yml; do echo "===== SHUTTING DOWN $service =====" && docker-compose -f $service down; done`
4. Shut down remaining services: `for app in ~/homelab/server/config/*; do echo "===== SHUTTING DOWN $app =====" && cd $app && docker-compose down; done`
5. Shut down the host: `sudo shutdown now`. Wait 30 seconds. If the green power LED doesn't turn off, hold the power button until it does.

### Boot
6. Press the power button on the front of the chassis to begin booting. Take note of any POST beeps during this time. Wait for the host to be accessible via SSH. 
7. Check current running docker containers
8. Confirm all SMB shares are mounted with `mount -t cifs`. If not mounted, run `mount -a` for all shares.
9. Start most services: `for app in ~/homelab/server/config/*; do echo "===== STARTING $app =====" && cd $app && docker-compose up -d; done`
10. Start Minecraft servers: `cd ~/homelab/server/config/minecraft && for service in ./*.yml; do echo "===== STARTING $service =====" && docker-compose -f $service up -d; done`
11. Reconfigure the router's DNS resolution:

```
configure
delete system name-server 1.1.1.1
set system name-server 192.168.1.23
delete service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 1.1.1.1
set service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 192.168.1.23
commit; save; exit
```

### Shut down NAS-dependent projects
Rather than shutting down on a per-container basis, we want to shut down an entire project if any of its containers depends on the NAS.  
The [nas_down.sh](/server/scripts/nas_down.sh) script uses `docker-compose config` to determine whether a project is NAS-dependent and will shut down all NAS-dependent projects. This script is also weakly-idempotent (due to the nature of `docker-compose down`). 

### Start up NAS-dependent projects
Rather than starting up on a per-container basis, we want to start up an entire project if any of its containers depends on the NAS.  
The [nas_up.sh](/server/scripts/nas_up.sh) script uses `docker-compose config` to determine whether a project is NAS-dependent and will start up all NAS-dependent projects. This script is also weakly-idempotent (due to the nature of `docker-compose up -d`). 

### List host-side mounts for loaded containers
Mostly useful during scripting, but potentially also for troubleshooting, this one-liner will print the host side of each volume mounted in a container.
`docker inspect --format '{{range .Mounts}}{{println .Source}}{{end}}' <container_name>`  
You can run this for all containers with this loop:  
`for container in $(docker ps -aq); do docker ps -aq --filter "id=$container" --format '{{.Names}}' && docker inspect --format '{{range .Mounts}}{{println .Source}}{{end}}' $container; done`  
Note: this is meant to be human-readable, so it prints the container's name before the list of volume mounts. 

### Recreate all Docker containers one-liner
```bash
STACKS_RESTARTED=0 && for app in ~/homelab/server/config/*; do echo "===== RECREATING $app =====" && cd $app && docker-compose up -d --force-recreate && STACKS_RESTARTED=$(($STACKS_RESTARTED + 1)); done && cd ~/homelab/server/config/minecraft && for service in ./*.yml; do echo "===== RECREATING $service =====" && docker-compose -f $service up -d --force-recreate && STACKS_RESTARTED=$(($STACKS_RESTARTED + 1)); done && echo "===== DONE (restarted $STACKS_RESTARTED stacks) ====="
```

#### Recreate based on list of containers
```bash
STACKS_RESTARTED=0 && for app in calibre-web homer jdownloader2 librespeed monitoring navidrome qbittorrent send stashapp traefik; do echo "===== RECREATING $app =====" && cd ~/homelab/server/config/$app && docker-compose up -d && STACKS_RESTARTED=$(($STACKS_RESTARTED + 1)); done && echo "===== DONE (restarted $STACKS_RESTARTED stacks) =====" && cd ~
```

## NAS
### Shutdown
1. Follow the instructions to [shut down NAS-dependent projects](#shut-down-nas-dependent-projects) on the server. 
2. SSH into the NAS and run `shutdown -p now`. Wait 30 seconds. If the green power LED doesn't turn off, hold the power button until it does.
3. Unplug the power connections to the disk shelf. 

### Boot
4. Plug power and SAS into the disk shelf. Wait for all disks to boot. About 2-3 minutes. Wait about 30 extra seconds to be safe. 
5. Plug power, ethernet, and SAS into the NAS. Power on the NAS and wait for the SSH server to become responsive. This can take more than 5 minutes. Note: The WebUI will not be accessible at `https://nas.jafner.net` until the server is also booted. It is accessible at `http://joey-nas/ui/sessions/signin`.
6. Follow the instructions to [start up NAS-dependent projects](#start-up-nas-dependent-projects) on the server.

