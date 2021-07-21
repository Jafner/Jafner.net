---
title: NAS
description: Configuration information for the NAS
published: true
date: 2021-07-21T01:11:19.367Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:26:11.985Z
---

# System Info Report
```
System:    Host: joey-nas.local Kernel: FreeBSD 12.2-RELEASE-p3 amd64 bits: 64 Console: tty pts/4 OS: FreeBSD 12.2-RELEASE-p3 
Machine:   Type: Desktop Mobo: Gigabyte model: X99-SLI-CF v: x.x serial: N/A UEFI: American Megatrends v: F24a rev: 5.6 
           date: 01/11/2018 
Memory:    RAM: total: 63.79 GiB used: 61.45 GiB (96.3%) 
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
           Display: server: No display server data found. Headless machine? tty: 170x56 
           Message: Unable to show advanced data. Required tool glxinfo missing. 
Network:   Device-1: Intel Ethernet I218-V driver: em 
           Device-2: Mellanox MT26448 [ConnectX EN 10GigE PCIe 2.0 5GT/s] driver: mlx4_core 
Drives:    Local Storage: total: raw: 115.89 TiB usable: 81.29 TiB used: 24.85 TiB (30.6%) 
           ID-1: /dev/ada0 vendor: Crucial model: CT1000MX500SSD4 M3CR023 size: 931.51 GiB 
           ID-2: /dev/ada1 vendor: Crucial model: CT1000MX500SSD4 M3CR023 size: 931.51 GiB 
           ID-3: /dev/ada2 vendor: Crucial model: CT1000MX500SSD4 M3CR023 size: 931.51 GiB 
           ID-4: /dev/ada3 vendor: Crucial model: CT1000MX500SSD4 M3CR022 size: 931.51 GiB 
           ID-5: /dev/ada4 vendor: Intel model: SSDSCKGW080A4 DC31 size: 74.53 GiB scheme: GPT 
           ID-6: /dev/da0 vendor: Western Digital model: ATA WDC WD80EZAZ-11T 0A83 size: 7.28 TiB scheme: GPT 
           ID-7: /dev/da1 vendor: Western Digital model: ATA WDC WD80EZAZ-11T 0A83 size: 7.28 TiB scheme: GPT 
           ID-8: /dev/da10 vendor: Western Digital model: ATA WDC WD40EZRX-00S 0A80 size: 3.64 TiB scheme: GPT 
           ID-9: /dev/da11 vendor: Western Digital model: ATA WDC WD40EZRX-00S 0A80 size: 3.64 TiB scheme: GPT 
           ID-10: /dev/da12 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB scheme: GPT 
           ID-11: /dev/da13 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.15 TiB scheme: GPT 
           ID-12: /dev/da14 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PAG1 size: 7.15 TiB scheme: GPT 
           ID-13: /dev/da15 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB 
           ID-14: /dev/da16 vendor: HGST (Hitachi) model: H7280A520SUN8.0T PD51 size: 7.15 TiB 
           ID-15: /dev/da2 vendor: Western Digital model: ATA WDC WD80EMAZ-00W 0A83 size: 7.28 TiB scheme: GPT 
           ID-16: /dev/da3 vendor: Western Digital model: ATA WDC WD80EZAZ-11T 0A83 size: 7.28 TiB scheme: GPT 
           ID-17: /dev/da4 vendor: Seagate model: ATA ST8000DM004-2CX1 0001 size: 7.28 TiB scheme: GPT 
           ID-18: /dev/da5 vendor: Western Digital model: ATA WDC WD80EMAZ-00W 0A83 size: 7.28 TiB scheme: GPT 
           ID-19: /dev/da6 vendor: Western Digital model: ATA WDC WD80EZAZ-11T 0A83 size: 7.28 TiB scheme: GPT 
           ID-20: /dev/da7 vendor: Seagate model: ATA ST8000DM004-2CX1 0001 size: 7.28 TiB scheme: GPT 
           ID-21: /dev/da8 vendor: Western Digital model: ATA WDC WD80EFAX-68L 0A83 size: 7.28 TiB scheme: GPT 
           ID-22: /dev/da9 vendor: Western Digital model: ATA WDC WD40EZRX-00S 0A80 size: 3.64 TiB scheme: GPT 
Partition: ID-1: / size: 62.32 GiB used: 26.81 GiB (43.0%) fs: zfs logical: freenas-boot/ROOT/FreeNAS-12.0-U2 
           ID-2: swap-1 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap0.eli 
           ID-3: swap-2 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap1.eli 
           ID-4: swap-3 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap2.eli 
           ID-5: swap-4 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap3.eli 
           ID-6: swap-5 size: 2 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/mirror/swap4.eli 
```

# Graceful Reboot
The NAS is relied upon for many other hosts on the network, which need to be offlined before the NAS can be shut down.
1. Offline the seedbox. Follow the graceful reboot instructions described on [the seedbox page](/hosts/seedbox) to shut it down.
2. Offline the server. Follow the graceful reboot instructions described on [the server page](/hosts/server) to shut it down.
3. Offline the NAS. SSH into the NAS and run `sudo shutdown now`.
4. Perform necessary maintenance, then reboot the NAS.

WIP