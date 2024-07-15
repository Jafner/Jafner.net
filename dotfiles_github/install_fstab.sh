#!/bin/bash

sudo echo "//joey-nas/nas /mnt/nas cifs user=user,pass=resu,uid=1000,gid=1000,_netdev 0 0" >> /etc/fstab
sudo mkdir /mnt/nas
sudo mount /mnt/nas
