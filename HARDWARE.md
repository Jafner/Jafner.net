---
---

## Paladin (TrueNAS Scale)

_Note on Reboot procedure_

This system has an undiagnosed issue with the RTC/CMOS battery or reset system. When the system _completely_ loses power (PSU unplugged, or PSU switch flipped), it will reset the BIOS to default settings _and require keyboard input for the next boot_.

**If planning to unplug Paladin from power, prepare a keyboard and display to configure the BIOS after booting.**

- Set the clock (RTC).

## Disk Shelf (DS4243)

_Map of disk bay position to serial number._

Each cell contains the serial number for the drive in the mapped bay.
| | X1 | X2 | X3 | X4 |
|:--:|:---------:|:--------:|:--------:|:--------:|
| Y1 | VJGPS30X | VK0ZD6ZY | VKH22XPX | VJG2PVRX |
| Y2 | VJGR6TNX | 2EG14YNJ | VJGJVTZX | VJG1H9UX |
| Y3 | VJGJUWNX | 2EGXD27V | VJGJAS1X | VJG2UTUX |
| Y4 | VJGRGD2X | 2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5 | VJGK56KX | 2EGNPVWV | VJG1NP9X | VKH3Y3XX |
| Y6 | VLKV9N8V | 2EKE5E7X | VLKXPS1V | VKGW5YGX |

_Log of disk replacements._
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
