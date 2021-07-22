---
title: Server
description: Configuration information for the main server
published: true
date: 2021-07-22T00:24:05.186Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:23:08.530Z
---

# System Info Report
```
System:    Host: joey-server Kernel: 4.19.0-17-amd64 x86_64 bits: 64 Console: tty 0 Distro: Debian GNU/Linux 10 (buster) 
Machine:   Type: Desktop System: ASUS product: N/A v: N/A serial: N/A 
           Mobo: ASUSTeK model: PRIME B550M-A v: Rev X.0x serial: 200670784208194 UEFI: American Megatrends v: 1401 
           date: 12/03/2020 
Memory:    RAM: total: 47.14 GiB used: 14.70 GiB (31.2%) 
           Array-1: capacity: 128 GiB slots: 4 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_A2 size: 8 GiB speed: 2133 MT/s 
           Device-3: DIMM_B1 size: 16 GiB speed: 2133 MT/s 
           Device-4: DIMM_B2 size: 16 GiB speed: 2133 MT/s 
CPU:       Topology: 8-Core model: AMD Ryzen 7 5800X bits: 64 type: MT MCP L2 cache: 4096 KiB 
           Speed: 2856 MHz min/max: 2200/3800 MHz Core speeds (MHz): 1: 2196 2: 2209 3: 2251 4: 2210 5: 2193 6: 2205 7: 2197 
           8: 2199 9: 2508 10: 2194 11: 2205 12: 2198 13: 2197 14: 2196 15: 2196 16: 2207 
Graphics:  Device-1: NVIDIA GK208 [GeForce GT 730] driver: nouveau v: kernel 
           Display: server: X.org 1.20.4 driver: fbdev,modesetting,vesa tty: 360x78 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169 
Drives:    Local Storage: total: 447.13 GiB used: 382.47 GiB (85.5%) 
           ID-1: /dev/sda vendor: SanDisk model: SDSSDX480GG25 size: 447.13 GiB 
Partition: ID-1: / size: 434.75 GiB used: 191.10 GiB (44.0%) fs: ext4 dev: /dev/sda2 
           ID-2: swap-1 size: 3.93 GiB used: 278.0 MiB (6.9%) fs: swap dev: /dev/sda3 
```

# Graceful Reboot
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount the NAS SMB shares defined in `/etc/fstab` with `sudo mount -a`
4. Start all Docker containers with `docker start $(docker ps -aq)`.