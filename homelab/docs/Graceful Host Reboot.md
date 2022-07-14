# NAS
The NAS is relied upon for many other hosts on the network, which need to be offlined before the NAS can be shut down.
1. Determine which service stacks rely on the NAS by running `grep -rnwli ~+ -e '/mnt/nas/media\|/mnt/torrenting\|/mnt/nas/calibre'` from the root of the `homelab` repo.
2. `docker-compose down` the stacks which rely on the NAS
3. `cat /etc/fstab` to get the list of mount points which rely on the NAS
4. For each NAS mount, run `sudo umount` for that share.
5. Offline the NAS. Press the physical power button on the NAS.
6. Perform necessary maintenance, then reboot the NAS.
7. After the NAS WebUI is available, SSH into the server and run `sudo  mount -a`
8. Online the stacks affected by step 2.

# Server
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount the NAS SMB shares defined in `/etc/fstab` with `sudo mount -a`
4. Start all Docker containers with `docker start $(docker ps -aq)`.

# Router
The router is relied upon by all clients on the network, so they all need to be offlined or prepared.
1. Offline the seedbox.
2. Offline the server.
3. Offline the NAS.
4. Run `shutdown`.

# PiHole
The PiHole is relied upon for DNS resolution for all devices on the network which have not manually configured another DNS resolver.
1. Log into `router` via SSH and run the following:
```
configure
delete service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 192.168.1.23
set service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 1.1.1.1
commit; save; exit
```
3. Switch back to the router and run the following:
```
configure 
delete service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 1.1.1.1
set service dhcp-server shared-network-name LAN1 subnet 192.168.1.0/24 dns-server 192.168.1.23
commit; save; exit
```
4. Done.

# Full Lab
To offline the whole lab:

```sh
ssh joey@joey-server docker stop $(docker ps -aq)
ssh joey@joey-server sudo shutdown now
ssh joey@joey-seedbox docker stop $(docker ps -aq)
ssh joey@joey-seedbox sudo shutdown now
ssh root@joey-nas shutdown now
ssh admin@192.168.1.1 configure; delete system name-server 192.168.1.22; set system name-server 1.1.1.1; commit; save; exit
ssh pi@pihole sudo shutdown now
```

Perform necessary maintenance, then power hosts back on in the following order:

1. PiHole
2. NAS (ensure smb server is online)
3. Server
4. Seedbox

After all hosts are back on the network:

```sh
ssh admin@192.168.1.1 configure; delete system name-server 1.1.1.1; set system name-server 192.168.1.22; commit; save; exit
ssh joey@joey-server sudo mount -a
ssh joey@joey-server docker start $(docker ps -aq)
ssh joey@joey-seedbox sudo mount -a
ssh joey@joey-seedbox docker start $(docker ps -aq)
```