# Physical Disk Locations (DS4243)

_Updated 2024/02/28_

Each cell contains the serial number for the drive in the mapped bay.
| | X1 | X2 | X3 | X4 |
|:--:|:---------:|:--------:|:--------:|:--------:|
| Y1 | VJGPS30X | VK0ZD6ZY | VKH22XPX | VJG2PVRX |
| Y2 | VJGR6TNX | 2EG14YNJ | VJGJVTZX | VJG1H9UX |
| Y3 | VJGJUWNX | 2EGXD27V | VJGJAS1X | VJG2UTUX |
| Y4 | VJGRGD2X | 2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5 | VJGK56KX | 2EGNPVWV | VJG1NP9X | VKH3Y3XX |
| Y6 | VLKV9N8V | 2EKE5E7X | VLKXPS1V | VKGW5YGX |

# Identify a Failing Disk

Disk Smart test errors are reported by device ID (e.g. /dev/sdw), rather than the serial number. To find the serial number associated with a particular device ID, run the following one-liner with `$dev` substituted for the device to find:

`TODO`

# Get Serial Number from part-uuid

`ls -l /dev/disk/by-partuuid`

Will return lines for each partition device and its mapping to a `/dev/sd` Linux block device.

From there, run `smartctl -a <block device> | grep Serial` where `<block device>` is like `/dev/sdw`.

Or, as a one-liner with `$DISK_UUID` set to the UUID to find:

`ls -l /dev/disk/by-partuuid | grep $DISK_UUID | cut -d' ' -f 11 | xargs basename | sed 's/^/\/dev\//' | xargs sudo smartctl -a | grep Serial | tr -s ' ' | cut -d' ' -f 3`

It might be possible to pull the part UUID from the `zpool status` command directly. An exercise for the reader.

# Offline and wipe the failing disk

0. Match the disk name (e.g. `/dev/sdw`) to the UUID (e.g. `13846695584571018356`). Use `lsblk --fs` for this.
1. Offline the disk: `zpool offline $pool $disk_id`
2. Wipe the disk: `wipefs $disklabel` (where `$disklabel` is like `/dev/sdw`)
3. Run `lsblk --fs` again to verify the wipe worked. If not, you'll need to run a full dd wipe with `dd if=/dev/zero of=$disklabel bs=1M`. This will take a long time as it writes zeroes across the entire drive.
4. Physically remove the disk.

# Replace Disk in Pool

Once the failed disk has been identified and physically replaced, you should know the old drive's UUID (via `zpool status`) and the new drive's device name (via `lsblk` and deduction)

Once the new drive is in place and you know its ID (e.g. `/dev/sdw`), run the following to begin the resilver process:

`zpool replace <pool> <part-uuid to be replace> <device id of new drive>`

E.g. `zpool replace Media d50abb30-81fd-49c6-b22e-43fcee2022fe /dev/sdx`

This will begin a new resilver operation. Good luck!

https://docs.oracle.com/cd/E19253-01/819-5461/gazgd/index.html

# Update Log

**Most recent first**

- _2025/06/18_: Replaced R5G4W2VV with 2EKE5E7X at Y6/X2
- _2024/10/21_: Replaced 2EKATR2X with VJG1NP9X at Y5/X3
- _2024/09/09_: Replaced VLKV9N8V with VKH3XR2X at Y6/X1
- _2024/05/26_: Replaced 2EGL8AVV with VJG2808X at Y4/X2
- _2024/04/16_: Replaced VJG1H9UX with 2EKA92XX at Y2/X4
- _2024/04/07_: Replaced VJG282NX with VKH22XPX at Y1/X3
- _2024/03/12_: Replaced VLKXPS1V with VKH40L6X at Y6/X3
- _2024/02/28_: Replaced 2EKA92XX with VLKXPS1V at Y6/X3
- _2024/02/27_: Replaced VJG2T4YX with VJG282NX at Y2/X3
