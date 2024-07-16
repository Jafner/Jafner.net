# Restart the Docker Daemon
Sometimes it may be necessary to restart the Docker daemon (for example to apply changes made in `/etc/docker/daemon.json`) and recreate all containers. Here's how:
1. Shut down and destroy all containers: `docker stop $(docker ps -aq) && docker rm $(docker ps -aq)`.
2. *Restart* (not reload) the Docker daemon: `sudo systemctl restart docker`.
3. Recreate all containers (to use the new default loki logging): `for app in ~/homelab/jafner-net/config/*; do cd $app && docker-compose up -d; done`
4. Manually boot Minecraft containers as appropriate: `cd ~/homelab/jafner-net/config/minecraft && for server in router vanilla bmcp; do docker-compose -f $server.yml up -d; done`