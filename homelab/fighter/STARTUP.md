# Gently boot and begin running all services

1. Confirm all SMB shares are mounted and working. Run `mount -v | grep cifs` to list all cifs shares. 
2. Confirm iSCSI device is connected and mounted. Run `sudo iscsiadm -m session` to list active sessions. Then run `mount -v | grep /mnt/iscsi` to ensure the device is mounted. 
3. Check for any leftover containers. Run `docker ps -a`. 
4. Start all Docker compose stacks. Run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && docker-compose up -d; done`. 