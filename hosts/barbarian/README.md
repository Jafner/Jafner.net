# Summary
Barbarian is a TrueNAS host built from old gaming PC hand-me-downs.

# Hardware

| Part | Make & Model | Notes | Link |
|:----:|:------------:|:-----:|:----:|
| Case | RSV-L4500U   |       | [Rosewill.com](https://www.rosewill.com/rosewill-rsv-l4500u-black/p/9SIA072GJ92805)
| PSU  |
|

# Pools
I have 2 pools, one for "Media" and one for everything else. All disks are 8 TB HGST/Hitachi drives with a sector size of 4096B. All pools use vdevs of 3 drives in RAIDZ1.

## Replace a failing disk
1. Get the serial number of the drive. If you can see the part-uuid in `zpool status` (e.g. `44ae3ae0-e8f9-4dbc-95ba-e64f63ab7460`), you can get the serial number via:

```
id=44ae3ae0-e8f9-4dbc-95ba-e64f63ab7460
label=$(ls -l /dev/disk/by-partuuid | grep $id | cut -d' ' -f 11 | cut -d'/' -f 3 | sed 's/^/\/dev\//')
serial=$(sudo smartctl -a $label | grep Serial | tr -s ' ' | cut -d' ' -f 3)
echo "$id -> $label -> $serial"
```

2. Offline and remove the failing disk. Refer to the [Physical Disk Locations](DISKSHELFMAP.md#physical-disk-locations-ds4243) chart to determine which shelf slot the disk is in. Remove the disk. Run `zpool offline [pool] [disk]`
3. Insert the new disk and wait 60 seconds for it to be detected.
4. Wipe the new disk. Find the new disk on the disks page, expand it, and run a quick wipe.
5. Replace the removed disk with the new disk. On the devices page for the affected pool, click the removed drive. Then hit Replace from the Disk Info card, find the new drive in the drop-down, and run begin the replacement operation.


- You can check the sector size of the new disk with `smartctl -a /dev/<disknum> | grep block`. If `Logical block size` is `512 bytes` (or anything other than `4096 bytes`), then the disk needs to be reformatted. Reformat the disk as described under [Convert a 512B-sector disk](#convert-a-512b-sector-disk-to-4096b-sectors). This will take several hours.


## Convert a 512B-sector disk to 4096B sectors
1. Get the disknum (like `da4`), either in the web UI or with the ~/disklist.pl script, for the disk that needs to be replaced.
2. Check the current sector size with `smartctl -a /dev/<disknum> | grep block`. If `Logical block size` is `512 bytes` (or anything other than `4096 bytes`), then the disk needs to be reformatted.
3. Reformat the disk(s) with the `sg_format` command. Use the following flags: `--size=4096 --format --fmtpinfo=0`. Then finally the disk location (e.g. `/dev/da15`). Use the `nohup` utility and the `&` operator to run the command in the background. An example one-liner for three disks (`da15`, `da16`, `da17`):

```bash
nohup sg_format --size=4096 --format --fmtpinfo=0 /dev/da15 & \
nohup sg_format --size=4096 --format --fmtpinfo=0 /dev/da16 & \
nohup sg_format --size=4096 --format --fmtpinfo=0 /dev/da17 &
```

Alternatively, try this for the first time:
```bash
for disk in da15 da16 da17; do mkdir -p ~/.formatting/$disk && cd ~/.formatting/$disk && nohup sg_format --size=4096 --format --fmtpinfo=0 /dev/$disk &; done
```

5. Close the terminal. Then log back in and run `ps -aux | grep sg_format` to confirm all processes are running. Check SMART status for disks with `for disk in da15 da16 da17; do smartctl -a /dev/$disk; done` (where `da15 da16 da17` is your list of disks).
6. Wait 12-16 hours (for 8 TB disk).
7. Remove and re-insert the disk.

## Perform a large copy operation in the background
0. `cd ~` for consistent placement of `nohup.out`
1. Use `nohup cp -rv /mnt/[from_pool]/[from_dataset]/ /mnt/[to_pool]/[to_dataset] && echo "" | mail -s "Copy /mnt/[from_pool]/[from_dataset]/ to /mnt/[to_pool/[to_dataset] complete" root` (pay attention to trailing slashes) to run the copy in the background and send an email when the copy is complete. This will persist closing the terminal and completely closing the SSH connection.
2. Use `cmdwatch du -h ~/nohup.out` to watch the size of the log file increase (to confirm it is still copying)
3. Use `tail -f ~/nohup.out` to follow the actual logs. The original command writes to this file in batches when it is in the background, so don't expect it to be as smooth as running the command in the foreground.

## Perform a copy operation in the foreground with progress monitoring
Use `rsync -ah --progress $SOURCE $DESTINATION`
Note that if the source is something like `/first/path/to/folder1/` and you want to copy it to `/second/path/to/folder1/`, make sure to fully specify the destination path (`DESTINATION=/second/path/to/folder1/`). Where something like `cp` or `mv` would create the source folder in the destination folder, Rsync is more literal.

# Services
## S.M.A.R.T.
All values default.
| Parameter | Value |
|:---------:|:-----:|
| Start Automatically | Yes |
| Check interval | 30 minutes |
| Difference | 0 &deg;C |
| Informational | 0 &deg;C |
| Critical | 0 &deg;C |

## SMB
| Parameter | Value |
|:---------:|:-----:|
| Start Automatically | Yes |
| NetBIOS Name | joey-nas |
| NetBIOS Alias | - |
| Workgroup | WORKGROUP |
| Description | FreeNAS Server |
| Enable SMB1 Support | No |
| NTLMv1 Auth | No |
| UNIX Charset | UTF-8 |
| Log Level | Minimum |
| Use Syslog Only | No |
| Local Master | Yes |
| Enable Apple SMB2/3 Protocol Extensions | No |
| Administrators Group | - |
| Guest Account | nobody |
| File Mask | - |
| Directory Mask | - |
| Bind IP Addresses | 192.168.1.10,192.168.50.1 |
| Auxilliary Parameters | - |

## SSH
| Parameter | Value |
|:---------:|:-----:|
| Start Automatically | Yes |
| TCP Port | 22 |
| Log in as Root with Password | Yes |
| Allow Password Authentication | Yes |
| Allow Kerberos Authentication | No |
| Allow TCP Port Forwarding | No |

# Users, Groups, Permissions
TODO, not yet designed.
