# NOTE: Adding or removing drives
> The drive letter of the iSCSI device will change (e.g. from `/dev/sde` to `/dev/sdb`) if drives are added or removed. This will cause the mount to fail.  

To resolve:
0. Make sure all Docker stacks relying on the iSCSI drive are shut down. 
1. Update the `fstab` entry. Edit the `/etc/fstab` file as root, and update the drive letter. 
2. Re-mount the drive. Run `sudo mount -a`. 

# Creating the Zvol and iSCSI share in TrueNAS Scale

1. Navigate to the dataset to use. From the TrueNAS Scale dashboard, open the navigation side panel. Navigate to "Datasets". Select the pool to use (`Tank`).  
2. Create the Zvol to use. In the top-left, click "Add Zvol" ([Why not a dataset?](https://www.truenas.com/community/threads/dataset-over-zvol-or-vice-versa.45526/)). Name: `fighter`, Size for this zvol: `8 TiB`. Leave all other settings default. 
3. Navigate to the iSCSI share creator. Navigate to "Shares". Open the "Block (iSCSI) Shares Targets" panel. (Optionally, set the base name per [RFC 3721 1.1](https://datatracker.ietf.org/doc/html/rfc3721.html#section-1.1) (`iqn.2020-04.net.jafner`)). 
4. Create the iSCSI share. Click the "Wizard" button in the top-right. 
  a. Create or Choose Block Device. Name: `fighter`, Device: `zvol/Tank/fighter`, Sharing Platform: `Modern OS`.
  b. Portal. Portal: `Create New`, Discovery Authentication Method: `NONE`, Discovery Authentication Group: `NONE`, Add listen: `0.0.0.0`. 
  c. Initiator. Leave blank to allow all hostnames and IPs to initiate. Optionally enter a list IP address(es) or hostname(s) to restrict access to the device.
  d. Confirm. Review and Save.
5. Enable iSCSI service at startup. Navigate to System Settings -> Services. If it's not already running, enable the iSCSI service and check the box to "Start Automatically". 

# Connecting to the iSCSI Share in Debian 12

1. Install the `open-iscsi` package with `sudo apt-get install open-iscsi`.
2. Get the list of available shares from the NAS with `sudo iscsiadm --mode discovery --type sendtargets --portal 192.168.1.10` where the IP for `--portal` is the IP of the NAS hosting the iSCSI share. In my case, this returns `192.168.1.10:3260,1 iqn.2020-03.net.jafner:fighter`. 
3. Open the iSCSI session. Run `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --login`. Where the name for `--targetname` is the iqn string including the share name. And where the address for `--portal` has both the IP and port used by the NAS hosting the iSCSI share. Verify the session connected with `sudo iscsiadm --mode session --print=1`, which should return the description of any active sessions. [Debian.org](https://wiki.debian.org/SAN/iSCSI/open-iscsi).
4. Format the newly-added block device. 
  a. Identify the device name of the new device with `sudo iscsiadm -m session -P 3 | grep "Attached scsi disk"`. In my case, `sdb`. [ServerFault](https://serverfault.com/questions/828401/how-can-i-determine-if-an-iscsi-device-is-a-mounted-linux-filesystem).
  b. Partition and format the device. Run `sudo parted --script /dev/sdb "mklabel gpt" && sudo parted --script /dev/sdb "mkpart primary 0% 100%" && sudo mkfs.ext4 /dev/sdb1` [Server-world.info](https://www.server-world.info/en/note?os=Debian_11&p=iscsi&f=3). 
  c. Mount the new partition to a directory. Run `sudo mkdir /mnt/iscsi && sudo mount /dev/sdb1 /mnt/iscsi`. Where the path `/dev/sdb1` is the newly-created partition and the path `/mnt/iscsi` is the path to which you want it mounted.
  d. Test the disk write speed of the new partition. Run `sudo dd if=/dev/zero of=/mnt/iscsi/temp.tmp bs=1M count=32768` to run a 32GB test write. [Cloudzy.com](https://cloudzy.com/blog/test-disk-speed-in-linux/).

# Connecting and mounting the iSCSI share on boot

1. Get the full path of the share's configuration. It should be like `/etc/iscsi/nodes/<share iqn>/<share host address>/default`. In my case it was `/etc/iscsi/nodes/iqn.202-03.net.jafner:fighter/192.168.1.10,3260,1/default`. [Debian.org](https://wiki.debian.org/SAN/iSCSI/open-iscsi). 
2. Set the `node.startup` parameter to `automatic`. Run `sudo sed -i 's/node.startup = manual/node.startup = automatic/g' /etc/iscsi/nodes/iqn.2020-03.net.jafner:fighter/192.168.1.10,3260,1/default`. 
3. Add the new mount to `/etc/fstab`. Run `sudo bash -c "echo '/dev/sdb1 /mnt/iscsi ext4 _netdev 0 0' >> /etc/fstab"`. [Adamsdesk.com](https://www.adamsdesk.com/posts/sudo-echo-permission-denied/), [StackExchange](https://unix.stackexchange.com/questions/195116/mount-iscsi-drive-at-boot-system-halts). 

# How to Gracefully Terminate iSCSI Session

1. Ensure any Docker containers currently using the device are shut down. Run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && if $(docker-compose config | grep -q /mnt/iscsi); then echo "ISCSI-DEPENDENT: $stack"; fi ; done` to get the list of iSCSI-dependent stacks. Ensure all listed stacks are OK to shut down, then run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && if $(docker-compose config | grep -q /mnt/iscsi); then echo "SHUTTING DOWN $stack" && docker-compose down; fi ; done`. 
2. Unmount the iSCSI device. Run `sudo umount /mnt/iscsi`. 
3. Log out of the iSCSI session. Run `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --logout`. 
4. Shut down the host. Run `sudo shutdown now`.