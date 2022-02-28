# NAS
The NAS is relied upon for many other hosts on the network, which need to be offlined before the NAS can be shut down.
1. Determine which service stacks rely on the NAS by running `grep -rnwli ~+ -e '/mnt/media\|/mnt/torrenting\|/mnt/calibre'` from the root of the `homelab` repo.
2. `docker-compose down` the stacks which rely on the NAS
3. `cat /etc/fstab` to get the list of mount points which rely on the NAS
4. For each NAS mount, run `sudo umount` for that share.
5. Offline the NAS. SSH into the NAS and run `shutdown now`.
6. Perform necessary maintenance, then reboot the NAS.
7. After the NAS WebUI is available, SSH into the server and run `sudo  mount -a`
8. Online the stacks affected by step 2.

# Seedbox
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount all NAS shares defined in `/etc/fstab` with `sudo mount -a`.
4. Start all Docker containers with `docker start $(docker ps -aq)`.

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
delete system name-server 192.168.1.22
set system name-server 1.1.1.1
commit; save; exit
```
2. Reboot the Pi with `sudo reboot now`
3. Switch back to the router and run the following:
```
configure 
delete system name-server 1.1.1.1
set system name-server 192.168.1.22
commit; save; exit
```
4. Done.