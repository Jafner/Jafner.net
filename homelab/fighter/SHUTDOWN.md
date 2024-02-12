# Gracefully shut down all services and then the system

1. Shut down all docker stacks. Run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && docker-compose down; done`. 
2. Unmount the iSCSI device. Run `sudo umount /mnt/iscsi`.
3. Log out of the iSCSI session. Run `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --logout`. 
4. Unmount the SMB shares. Run `for mount in media calibre-web torrenting av; do sudo umount /mnt/nas/$mount; done`. This command may need updating for the specific SMB shares currently mounted. 
5. Shut down the system. Run `sudo shutdown now`.