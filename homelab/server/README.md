# Server
General-purpose server hosting a variety of Docker-based application stacks.

This server exists behind the jafner.net DDNS record.

## Services

This server runs a bunch of stuff behind the `jafner.net` domain.

For a living portal listing all user-facing services, go to https://home.jafner.net

This repository is automatically pushed to the host when a change is made to a file in this subdirectory.

## Sharing Files
For files smaller than 2 GB, use [XBackBone](https://xbackbone.jafner.net).
For files between 2 GB and 400 GB, use [Mega](https://mega.io/).
For files greater than 400 GB, ship a drive.

## System `/etc/fstab`
```
//joey-nas/media /mnt/nas/media cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/Text/Calibre /mnt/nas/calibre cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/torrenting /mnt/nas/torrenting cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0
//joey-nas/backups /mnt/nas/backups cifs user=user,pass=resu,uid=1000,gid=1000,_netdev,vers=3.0 0 0

/dev/md0 /mnt/md0 ext4 defaults,nofail,discard 0 0
```