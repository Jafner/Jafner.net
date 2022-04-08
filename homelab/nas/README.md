# Pools
I have 4 pools, separated by a soft performance profile heuristic.
## Archival - Infrequent reads/writes
This pool has one dataset: backups, which contains things I want to preserve as a priority.
This pool's vdevs comprise mirrored 7.28 TiB drives.
## Hi-IOPS - Frequent reads/writes
This pool has one dataset: Torrenting, which stores all data referenced by torrent clients. All data is copied to another dataset before it is used by any other service. This dataset also serves the autopirate stack, which follows the same rules. 
This pool's vdevs comprise mirrored 7.15 TiB drives.
## Media - High-bandwidth sequential reads/writes
This pool contains one dataset: Media, which holds all non-text data (3d models, audio, images, video). As of writing, only the `./Media/Video/Movies` and `Media/Video/Shows` are accessed by services. Everything else is manipulated manually.
This pool's vdevs comprise RAID-Z1 7.28 TiB drives.
## WORM - Write-once, read-many
This pool contains two datasets: Software, which handles all binaries and scripts, and Text, which handles ebooks and documents.
This pool's vdevs comprise mirrored 7.15 TiB drives.

# Physical Disk Locations (DS4243)
Each cell contains the serial number for the drive in the mapped bay.
|  | X1 | X2 | X3 | X4 |
|:-:|:-:|:-:|:-:|:-:|
| Y1 | VJGPS30X             | -                    | - | - | 
| Y2 | VJGR6TNX             | -                    | - | - | 
| Y3 | VJG282NX             | -                    | - | - | 
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
System:    Host: joey-nas.local Kernel: FreeBSD 12.2-RELEASE-p3 amd64 bits: 64 Console: tty pts/0 OS: FreeBSD 12.2-RELEASE-p3 
Machine:   Type: Desktop Mobo: Gigabyte model: X99-SLI-CF v: x.x serial: N/A UEFI: American Megatrends v: F24a rev: 5.6 
           date: 01/11/2018 
Memory:    RAM: total: 63.79 GiB used: 62.25 GiB (97.6%) 
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
           Display: server: No display server data found. Headless machine? tty: 177x51 
           Message: Unable to show advanced data. Required tool glxinfo missing. 
Network:   Device-1: Intel Ethernet I218-V driver: em 
           Device-2: Mellanox MT26448 [ConnectX EN 10GigE PCIe 2.0 5GT/s] driver: mlx4_core 
Drives:    Local Storage: total: raw: 123.17 TiB usable: 85.52 TiB used: 26.49 TiB (31.0%) 
           ID-1: /dev/ada0 vendor: Intel model: SSDSCKGW080A4 DC31 size: 74.53 GiB scheme: GPT 
           ID-2: /dev/da0 vendor: Western Digital model: ATA WDC WD80EZAZ-11T 0A83 size: 7.28 TiB scheme: GPT 
           ID-3: /dev/da1 vendor: Seagate model: ATA ST8000DM004-2CX1 0001 size: 7.28 TiB scheme: GPT 
           ID-4: /dev/da10 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
           ID-5: /dev/da11 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-6: /dev/da12 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB 
           ID-7: /dev/da13 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB 
           ID-8: /dev/da14 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-9: /dev/da15 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-10: /dev/da16 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB 
           ID-11: /dev/da2 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB scheme: GPT 
           ID-12: /dev/da3 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB scheme: GPT 
           ID-13: /dev/da4 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
           ID-14: /dev/da5 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
           ID-15: /dev/da6 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.15 TiB scheme: GPT 
           ID-16: /dev/da7 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.15 TiB scheme: GPT 
           ID-17: /dev/da8 vendor: HGST (Hitachi) model: HUH728080AL4200 A7D8 size: 7.28 TiB scheme: GPT 
           ID-18: /dev/da9 vendor: Hitachi model: HUH72808CLAR8000 M7K0 size: 7.28 TiB scheme: GPT 
Partition: ID-1: / size: 62.24 GiB used: 26.84 GiB (43.1%) fs: zfs logical: freenas-boot/ROOT/FreeNAS-12.0-U2 
           ID-2: swap-1 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap0.eli 
           ID-3: swap-2 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap1.eli 
           ID-4: swap-3 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap2.eli 
           ID-5: swap-4 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap3.eli 
           ID-6: swap-5 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap4.eli
</code></pre>
</details>

## Convert a 512B-sector disk to 4096B sectors
1. Make sure the disk is not currently in use. 
2. Get the disknum (like `da4`), either in the web UI or with the ~/disklist.pl script.
3. Run `sg_format --size=4096 --format --fmtpinfo=0 /dev/[disknum]` for the disk.
4. Wait 12-16 hours (for 8 TB disk).
5. Remove and re-insert the disk.

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
|:----------:|:-----------------:|
| Text       | server/calibre-web |
| Torrenting | seedbox/EMP, seedbox/GGN, seedbox/MAM, seedbox/PUB |
| Media      | server/autopirate, server/plex |