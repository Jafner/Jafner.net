# Physical Disk Locations (DS4243)
*Updated 2024/02/27*

Each cell contains the serial number for the drive in the mapped bay.
|    | X1        | X2       | X3       | X4       |
|:--:|:---------:|:--------:|:--------:|:--------:|
| Y1 | VJGPS30X  | VK0ZD6ZY | VJG282NX | VJG2PVRX | 
| Y2 | VJGR6TNX  | 2EG14YNJ | VJGJVTZX | VJG1H9UX | 
| Y3 | VJGJUWNX  | 2EGXD27V | VJGJAS1X | VJG2UTUX | 
| Y4 | VJGRGD2X  | 2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5 | VJGK56KX  | 2EGNPVWV | 2EKATR2X | VKH3Y3XX |
| Y6 | VLKV9N8V  | R5G4W2VV | 2EKA92XX | VKGW5YGX |

# Identify a Failing Disk
Disk Smart test errors are reported by device ID (e.g. /dev/sdw), rather than the serial number. To find the serial number associated with a particular device ID, run the following one-liner with `$dev` substituted for the device to find:

`TODO`

# Replace Disk in Pool
Once the failed disk has been identified and physically replaced, you should know the old drive's UUID (via `zpool status`) and the new drive's device name (via `lsblk` and deduction)

# Update Log

### 2024/02/27
- Replaced VJG2T4YX with VJG282NX at Y2/X3