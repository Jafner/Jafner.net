# Quick Help

- Fighter connecting to Barbarian: `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --login && sudo mount /dev/sdb1 /mnt/iscsi/barbarian`
- Fighter connecting to Paladin: `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.12:3260" --login && sudo mount /dev/sdb1 /mnt/iscsi/paladin`

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

# Connecting to the iSCSI target

1. Install the `open-iscsi` package.
  - `sudo apt-get install open-iscsi`
2. Get the list of available shares.
   - `sudo iscsiadm --mode discovery --type sendtargets --portal 192.168.1.10`
   - The IP for `--portal` is the IP of the NAS hosting the iSCSI share. 
   - In my case, this command returns `192.168.1.10:3260,1 iqn.2020-03.net.jafner:fighter`. 
3. Open the iSCSI session. 
   - `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --login`
   - The name for `--targetname` is the iqn string including the share name. 
   - The address for `--portal` has both the IP and port used by the NAS hosting the iSCSI share. 
4. Verify the session connected.
   - `sudo iscsiadm --mode session --print=1`
   - This should return the description of any active sessions. 

[Debian.org](https://wiki.debian.org/SAN/iSCSI/open-iscsi).

# Initializing the iSCSI disk
1. Identify the device name of the new device with `sudo iscsiadm -m session -P 3 | grep "Attached scsi disk"`. In my case, `sdb`. [ServerFault](https://serverfault.com/questions/828401/how-can-i-determine-if-an-iscsi-device-is-a-mounted-linux-filesystem).
2. Partition and format the device. Run `sudo parted --script /dev/sdb "mklabel gpt" && sudo parted --script /dev/sdb "mkpart primary 0% 100%" && sudo mkfs.ext4 /dev/sdb1` [Server-world.info](https://www.server-world.info/en/note?os=Debian_11&p=iscsi&f=3). 
3. Mount the new partition to a directory. Run `sudo mkdir /mnt/iscsi && sudo mount /dev/sdb1 /mnt/iscsi`. Where the path `/dev/sdb1` is the newly-created partition and the path `/mnt/iscsi` is the path to which you want it mounted.
4. Test the disk write speed of the new partition. Run `sudo dd if=/dev/zero of=/mnt/iscsi/temp.tmp bs=1M count=32768` to run a 32GB test write. [Cloudzy.com](https://cloudzy.com/blog/test-disk-speed-in-linux/).

# Connecting and mounting the iSCSI share on boot

1. Get the full path of the share's configuration. It should be like `/etc/iscsi/nodes/<share iqn>/<share host address>/default`. In my case it was `/etc/iscsi/nodes/iqn.2020-03.net.jafner:fighter/192.168.1.10,3260,1/default`. [Debian.org](https://wiki.debian.org/SAN/iSCSI/open-iscsi). 
2. Set the `node.startup` parameter to `automatic`. Run `sudo sed -i 's/node.startup = manual/node.startup = automatic/g' /etc/iscsi/nodes/iqn.2020-03.net.jafner:fighter/192.168.1.10,3260,1/default`. 
3. Add the new mount to `/etc/fstab`. Run `sudo bash -c "echo '/dev/sdb1 /mnt/iscsi ext4 _netdev 0 0' >> /etc/fstab"`. [Adamsdesk.com](https://www.adamsdesk.com/posts/sudo-echo-permission-denied/), [StackExchange](https://unix.stackexchange.com/questions/195116/mount-iscsi-drive-at-boot-system-halts). 

# How to Gracefully Terminate iSCSI Session

1. Ensure any Docker containers currently using the device are shut down. Run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && if $(docker-compose config | grep -q /mnt/iscsi); then echo "ISCSI-DEPENDENT: $stack"; fi ; done` to get the list of iSCSI-dependent stacks. Ensure all listed stacks are OK to shut down, then run `for stack in /home/admin/homelab/fighter/config/*; do cd $stack && if $(docker-compose config | grep -q /mnt/iscsi); then echo "SHUTTING DOWN $stack" && docker-compose down; fi ; done`. 
2. Unmount the iSCSI device. Run `sudo umount /mnt/iscsi`. 
3. Log out of the iSCSI session. Run `sudo iscsiadm --mode node --targetname "iqn.2020-03.net.jafner:fighter" --portal "192.168.1.10:3260" --logout`. 
4. Shut down the host. Run `sudo shutdown now`.

# Systemd-ifying the process
Remove the iSCSI mount from `/etc/fstab`, but otherwise most of the steps above should be fine. (Don't forget to install and enable the `iscsid.service` systemd unit).

### Script for connecting to (and disconnecting from) iSCSI session
This script is one command, but sometimes it's useful to contain it in a script.
[`connect-iscsi.sh`](../fighter/scripts/connect-iscsi.sh)
```sh
#!/bin/bash
iscsiadm --mode node --targetname iqn.2020-03.net.jafner:fighter --portal 192.168.1.10:3260 --login
```

[`disconnect-iscsi.sh`](../fighter/scripts/disconnect-iscsi.sh)
```sh
#!/bin/bash
iscsiadm --mode node --targetname iqn.2020-03.net.jafner:fighter --portal 192.168.1.10:3260, 1 -u
```

### Systemd Unit for connecting iSCSI session

`/etc/systemd/system/connect-iscsi.service` with `root:root 644` permissions
```ini
[Unit]
Description=Connect iSCSI session
Requires=network-online.target
#After=
DefaultDependencies=no

[Service]
User=root
Group=root
Type=oneshot
RemainAfterExit=true
ExecStart=iscsiadm --mode node --targetname iqn.2020-03.net.jafner:fighter --portal 192.168.1.10:3260 --login
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

### Systemd Unit for mounting the share

`/etc/systemd/system/mnt-nas-iscsi.mount` with `root:root 644` permissions
Note that the file name *must* be `mnt-nas-iscsi` if its `Where=` parameter is `/mnt/nas/iscsi`. 
[Docs](https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html)
```ini
[Unit]
Description="Mount iSCSI share /mnt/nas/iscsi"
After=connect-iscsi.service
DefaultDependencies=no

[Mount]
What=/dev/disk/by-uuid/cf3a253c-e792-48b5-89a1-f91deb02b3be
Where=/mnt/nas/iscsi
Type=ext4
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

### Systemd Unit for automounting the share

`/etc/systemd/system/mnt-nas-iscsi.automount` with `root:root 644` permissions
Note that the file name *must* be `mnt-nas-iscsi` if its `Where=` parameter is `/mnt/nas/iscsi`. 
[Docs](https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html)
```ini
[Unit]
Description="Mount iSCSI share /mnt/nas/iscsi"
Requires=network-online.target
#After=

[Automount]
Where=/mnt/nas/iscsi

[Install]
WantedBy=multi-user.target
```

### Quick interactive one-liner to install these scripts
This will open each file for editing in nano under the path `/etc/systemd/system/` and apply the correct permissions to the file after it has been written. 
```sh
for file in /etc/systemd/system/connect-iscsi.service /etc/systemd/system/mnt-nas-iscsi.mount /etc/systemd/system/mnt-nas-iscsi.automount; do sudo nano $file && sudo chown root:root $file && sudo chmod 644 $file && sudo systemctl enable $(basename $file); done && sudo systemctl daemon-reload
```

After this, it's probably a good idea to reboot from scratch.

### Check statuses

- `sudo systemctl status connect-iscsi.service`
- `sudo systemctl status mnt-nas-iscsi.mount`
- `sudo systemctl status mnt-nas-iscsi.automount`

https://unix.stackexchange.com/questions/195116/mount-iscsi-drive-at-boot-system-halts
https://github.com/f1linux/iscsi-automount/blob/master/config-iscsi-storage.sh
https://github.com/f1linux/iscsi-automount/blob/master/config-iscsi-storage-mounts.sh

# Disabling all iSCSI units for debugging
During an extended outage of barbarian, we learned that, as configured, fighter will not boot while its iSCSI target is inaccessible. To resolve, we disabled the following systemd units:

```
iscsi.service
mnt-nas-iscsi.automount
mnt-nas-iscsi.mount
connect-iscsi.service
barbarian-wait-online.service
iscsid.service
```

Oneliners below:
- Disable: `for unit in iscsi.service mnt-nas-iscsi.automount mnt-nas-iscsi.mount connect-iscsi.service barbarian-wait-online.service iscsid.service; do systemctl disable $unit; done`
- Enable: `for unit in iscsi.service mnt-nas-iscsi.automount mnt-nas-iscsi.mount connect-iscsi.service barbarian-wait-online.service iscsid.service; do systemctl enable $unit; done`