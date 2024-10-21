#!/bin/bash
for stack in /home/admin/homelab/fighter/config/*; do cd $stack && docker compose down; done

## I don't think unmounting each mount is actually necessary or useful. 
#sudo umount /mnt/nas/iscsi
#sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --logout
#for mount in media calibre-web torrenting av; do sudo umount /mnt/nas/$mount; done
sudo shutdown now