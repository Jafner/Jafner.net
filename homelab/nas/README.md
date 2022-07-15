# Pools
I have 2 pools, one for "Media" and one for everything else. All disks are 8 TB HGST/Hitachi drives with a sector size of 4096B. All pools use vdevs of 3 drives in RAIDZ1.
## Media - High-bandwidth sequential reads/writes
This pool contains one dataset: Media, which holds all non-text data (3d models, audio, images, video). As of writing, only the `./Media/Video/Movies` and `Media/Video/Shows` are accessed by services. Everything else is manipulated manually.
## Tank
THis pool contains all other datasets. 

# Physical Disk Locations (DS4243)
Each cell contains the serial number for the drive in the mapped bay.
|    | X1                   | X2                   | X3       | X4       |
|:--:|:--------------------:|:--------------------:|:--------:|:--------:|
| Y1 | VJGPS30X             | -                    | -        | -        | 
| Y2 | VJGR6TNX             | -                    | -        | -        | 
| Y3 | VJG282NX             | -                    | -        | -        | 
| Y4 | VJGRGD2X             | 001526PL8AVV2EGL8AVV | 2EKA903X | VJGRRG9X |
| Y5 | 001703PXPS1VVLKXPS1V | 001528PNPVWV2EGNPVWV | 2EKATR2X | VKH3Y3XX |
| Y6 | 001703PV9N8VVLKV9N8V | 001708P4W2VVR5G4W2VV | 2EKA92XX | VKGW5YGX |

# Hardware
| Part | P/N | Specs |
|:----:|:---:|:-----:|
| CPU | Intel i7-5930k | [Intel Ark](https://www.intel.com/content/www/us/en/products/sku/82931/intel-core-i75930k-processor-15m-cache-up-to-3-70-ghz/specifications.html) |
| Motherboard | Gigabyte GA-X99-SLI | [Gigabyte](https://www.gigabyte.com/Motherboard/GA-X99-SLI-rev-10/sp#sp) |
| RAM | 8x GeIL EVO Potenza 8GB | [GeilMemory](http://www.geilmemory.com/product/?id=22) |
| GPU | Zotac Nvidia Geforce GT 710 2GB | [Zotac](https://www.zotac.com/us/product/graphics_card/geforce%C2%AE-gt-710-2gb) |
| NIC | Intel I218-V | [Intel Ark](https://ark.intel.com/content/www/us/en/ark/products/71305/intel-ethernet-connection-i218v.html)
| NIC2 | Mellanox MT26448 ConnectX-2 | [Nvidia](https://network.nvidia.com/related-docs/prod_adapter_cards/ConnectX-2_QSFP_IB_and_%20SFP_10GigE_Card_User_Manual_MHZH29.pdf)
| HBA | HP LSI SAS9217-4i4e | [SSDWorks](https://www.ssdworks.com/datasheets/LSI_SAS9217-4i4e_PB.pdf) |
| Expander | HP 4K1065 | [HP Enterprise](https://support.hpe.com/hpesc/public/docDisplay?docId=emr_na-c04495958) |

<details>
<summary>Output of <code>inxi -CDGmMNPS</code></summary>
<pre><code>
System:    Host: joey-nas.local Kernel: FreeBSD 12.2-RELEASE-p3 amd64 bits: 64 Console: tty pts/1 OS: FreeBSD 12.2-RELEASE-p3 
Machine:   Type: Desktop Mobo: Gigabyte model: X99-SLI-CF v: x.x serial: N/A UEFI: American Megatrends v: F24a rev: 5.6 
           date: 01/11/2018 
Memory:    RAM: total: 63.79 GiB used: 62.13 GiB (97.4%) 
           Array-1: capacity: 512 GiB note: check slots: 8 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_A2 size: 8 GiB speed: 2133 MT/s 
           Device-3: DIMM_B1 size: 8 GiB speed: 2133 MT/s 
           Device-4: DIMM_B2 size: 8 GiB speed: 2133 MT/s 
           Device-5: DIMM_C1 size: 8 GiB speed: 2133 MT/s 
           Device-6: DIMM_C2 size: 8 GiB speed: 2133 MT/s 
           Device-7: DIMM_D1 size: 8 GiB speed: 2133 MT/s 
           Device-8: DIMM_D2 size: 8 GiB speed: 2133 MT/s 
CPU:       Info: 12-Core model: Intel Core i7-5930K bits: 64 type: MCP cache: L2: 1.5 MiB note: check 
           Speed: 3500 MHz min/max: N/A Core speed (MHz): N/A 
Graphics:  Device-1: NVIDIA GK208B [GeForce GT 710] driver: vgapci 
           Display: server: No display server data found. Headless machine? tty: 177x47 
           Message: Unable to show advanced data. Required tool glxinfo missing. 
Network:   Device-1: Intel Ethernet I218-V driver: em 
           Device-2: Mellanox MT26448 [ConnectX EN 10GigE PCIe 2.0 5GT/s] driver: mlx4_core 
Drives:    Local Storage: total: raw: 109.23 TiB usable: 78.36 TiB used: 29.51 TiB (37.7%) 
           ID-1: /dev/ada0 vendor: Intel model: SSDSCKGW080A4 DC31 size: 74.53 GiB scheme: GPT 
           ID-2: /dev/da0 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-3: /dev/da1 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-4: /dev/da10 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-5: /dev/da11 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.28 TiB 
           ID-6: /dev/da12 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.28 TiB scheme: GPT 
           ID-7: /dev/da13 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
           ID-8: /dev/da14 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-9: /dev/da2 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-10: /dev/da3 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-11: /dev/da4 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.28 TiB scheme: GPT 
           ID-12: /dev/da5 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
           ID-13: /dev/da6 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-14: /dev/da7 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.28 TiB scheme: GPT 
           ID-15: /dev/da8 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.28 TiB scheme: GPT 
           ID-16: /dev/da9 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
Partition: ID-1: / size: 62.23 GiB used: 26.85 GiB (43.1%) fs: zfs logical: freenas-boot/ROOT/FreeNAS-12.0-U2
</code></pre>
</details>

## Convert a 512B-sector disk to 4096B sectors
1. Make sure the disk is not currently in use. 
2. Get the disknum (like `da4`), either in the web UI or with the ~/disklist.pl script.
3. Check the current sector size with `smartctl -a /dev/<disknum> | grep block`.
4. Reformat the disk(s) with the `sg_format` command. Use the following flags: `--size=4096 --format --fmtpinfo=0`. Then finally the disk location (e.g. `/dev/da15`). Use the `nohup` utility and the `&` operator to run the command in the background. An example one-liner for three disks (`da15`, `da16`, `da17`):

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

# Share Dependence
| Share      | Dependent Service(s) |
|:----------:|:--------------------:|
| Text       | server/calibre-web   |
| Torrenting | seedbox/EMP, seedbox/GGN, seedbox/MAM, seedbox/PUB |
| Media      | server/autopirate, server/plex |
| Backups    | server/cron          |

## Offlining dependent services
- Text: `cd ~/homelab/server/config/calibre-web && docker-compose down ; sudo umount /mnt/nas/calibre`
- Torrenting: `cd ~/homelab/seedbox/config/deluge/ ; for DIR in emp ggn mam pub; do cd ./$DIR && docker-compose down && cd ../ ; done ; sudo umount /mnt/torrenting`
- Media: `cd ~/homelab/server/config/autopirate && docker-compose down ; cd ~/homelab/server/config/plex && docker-compose down ; sudo umount /mnt/nas/media`
- Backups: This cron job runs once per day at midnight. If possible, perform maintenance between runs. If not possible, comment out the jobs via `crontab -e`.

## Online dependent services
- Text: `sudo mount /mnt/nas/calibre && cd ~/homelab/server/config/calibre-web && docker-compose up -d`
- Torrenting: `sudo mount /mnt/torrenting && cd ~/homelab/seedbox/config/deluge/ ; for DIR in emp ggn mam pub; do cd ./$DIR && docker-compose up -d && cd ../ ; done`
- Media: `sudo mount /mnt/nas/media && cd ~/homelab/server/config/autopirate && docker-compose up -d ; cd ~/homelab/server/config/plex && docker-compose up -d`
- Backups: Uncomment the commented lines with `crontab -e`.