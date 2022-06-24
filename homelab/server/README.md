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

## Example docker-compose.yml for Web app
```
version: "3"
services:
  <SERVICE>:
    container_name: <SERVICE>
    image: 
    restart: unless-stopped
    volumes:
    environment:
    networks:
      - web
    labels:
      - traefik.http.routers.<SERVICE>.rule=Host(`<SERVICE>.jafner.net`)
      - traefik.http.routers.<SERVICE>.tls.certresolver=lets-encrypt
      # - traefik.http.routers.<SERVICE>.middlewares=lan-only@file # optional lan-only testing

networks:
  web:
    external: true
```