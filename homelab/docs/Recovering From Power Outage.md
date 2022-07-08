## 1. Networking
1. Power cycle the ONT. Wait until the top three lights are green.
2. Power cycle the modem. Wait until the power, WAN, and Ethernet 1 lights are green.
3. Power cycle the router
Switches and APs should not need power cycling. Once the indicator LED is solid white, everything should be back online.

## 2. Homelab
1. Power on the desktop or laptop.
2. Power on the NAS. The DS4243 will power itself on automatically. **Wait until the webui at [nas.jafner.net](http://nas.jafner.net) is responsive.**
3. Power on the Server. Once it is accessible, run a `sudo mount -a` to mount all network shares defined in `/etc/fstab`. Then run `docker start $(docker ps -aq)` to start all Docker containers. Note: Run `docker inspect -f '{{ .Mounts }}' $(docker ps -q)` to get a list of volumes for all running containers, useful for determining whether a container is reliant on a mounted directory.

