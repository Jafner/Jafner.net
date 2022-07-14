# Server
General-purpose server hosting a variety of Docker-based application stacks.

This server exists behind the jafner.net DDNS record.

## Services

This server runs a bunch of stuff behind the `jafner.net` domain.

For a living portal listing all user-facing services, go to https://home.jafner.net

This repository is automatically pushed to the host when a change is made to a file in this subdirectory.

## Sharing Files
For files smaller than 2 GB, use [XBackBone](https://xbackbone.jafner.net).  
For files greater than 2 GB, use one of the following:

* [Mega](https://mega.io/) - For transfers up to 400 GB
* [SFTP](./config/sftp/README.md) - For transfers up to the free space of `/mnt/md0/sftp`
* [BitTorrent](/seedbox/config/deluge/README.md)

## System `/etc/fstab`
```
//joey-nas/media /mnt/nas/media cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/Text/Calibre /mnt/nas/calibre cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/torrenting /mnt/nas/torrenting cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/backups /mnt/nas/backups cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0

/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0
```
# Boilerplates
Below are useful boilerplate files for configuring new services.
## `.env`
```ini
## Generic
TZ=America/Los_Angeles # used by most images
PUID=1000 # used by LSIO images
PGID=1000 # used by LSIO images
ADMIN_EMAIL=joey@jafner.net

## Container volume mapping
DOCKER_DATA=/home/joey/data/<service>
# DOCKER_DATA=/mnt/md0/<service> # for services whose internal data may be large (e.g. modded minecraft servers with large world files)
DOCKER_CONFIG=/home/joey/homelab/server/config/<service>/config 

## Additional volume mapping
MEDIA_DIR=/mnt/nas/media
VIDEO_DIR=/mnt/nas/media/Video
MOVIE_DIR=/mnt/nas/media/Video/Movies
SHOWS_DIR=/mnt/nas/media/Video/Shows
BOOKS_DIR=/mnt/nas/calibre
MUSIC_DIR=/mnt/nas/media/Audio/Music
DOWNLOAD_DIR=/mnt/nas/torrenting/<service|tracker> # e.g. /mnt/nas/torrenting/GGN or /mnt/nas/torrenting/jdownloader2

## SMTP Config
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USER=noreply@jafner.net
SMTP_PASS=
SMTP_SSL=true
SMTP_TLS=false
## Configure client to use SSL, not TLS
```

## Web App `docker-compose.yml `
```yml
version: '3'
services:
  <service>:
    image: 
    container_name: <stack>_<service>
    logging:
      driver: loki
      options:
        loki-url: http://localhost:3100/loki/api/v1/push
        loki-batch-size: "50"
        loki-retries: "1"
        loki-timeout: "2s"
    user: "1000:1000"
    restart: "no"
    environment:
      PUID: ${PUID}
      PGID: ${PGID}
    volumes:
      - ${DOCKER_DATA}/<service>:/path/to/data
    labels:
      - traefik.http.routers.<service>.rule=Host(`<service>.jafner.net`)
      - traefik.http.routers.<service>.tls.certresolver=lets-encrypt
      - traefik.http.routers.<service>.middlewares=<middlewares> # available middlewares are available in homelab/server/config/traefik/config/middlewares.yaml
      - traefik.http.services.<service>.loadbalancer.server.port=<port>
    networks:
      - web
      - <service>
    depends_on:
      - <service>_db
  <service>_db:
    image: 
    container_name: <service>_db
    user: "1000:1000"
    restart: "no"
    networks:
      - <service>
    environment:
      PUID: ${PUID}
      PGID: ${PGID}
    volumes:
      - ${DOCKER_DATA}/db:/var/lib/mysql
    labels:
      - traefik.enable=false
networks:
  web:
    external: true
<service>:
```
