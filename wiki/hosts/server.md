---
title: Server
description: Configuration information for the main server
published: true
date: 2021-07-17T19:07:40.663Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:23:08.530Z
---

# System Info Report
```
System:    Host: joey-server Kernel: 4.19.0-16-amd64 x86_64 bits: 64 Console: tty 1 Distro: Debian GNU/Linux 10 (buster) 
Machine:   Type: Desktop System: ASUS product: N/A v: N/A serial: N/A 
           Mobo: ASUSTeK model: PRIME B550M-A v: Rev X.0x serial: 200670784208194 UEFI: American Megatrends v: 1401 
           date: 12/03/2020 
Memory:    RAM: total: 15.64 GiB used: 12.73 GiB (81.4%) 
           Array-1: capacity: 128 GiB slots: 4 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_A2 size: No Module Installed 
           Device-3: DIMM_B1 size: 8 GiB speed: 2133 MT/s 
           Device-4: DIMM_B2 size: No Module Installed 
CPU:       Topology: 8-Core model: AMD Ryzen 7 5800X bits: 64 type: MT MCP L2 cache: 4096 KiB 
           Speed: 2194 MHz min/max: 2200/3800 MHz Core speeds (MHz): 1: 2544 2: 3200 3: 3487 4: 3826 5: 2575 6: 2710 7: 2247 
           8: 2435 9: 2428 10: 3716 11: 2201 12: 2193 13: 2199 14: 2244 15: 3426 16: 3853 
Graphics:  Device-1: NVIDIA GK208 [GeForce GT 730] driver: nouveau v: kernel 
           Display: server: X.org 1.20.4 driver: fbdev,modesetting,vesa tty: 170x56 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169 
Drives:    Local Storage: total: 447.13 GiB used: 373.61 GiB (83.6%) 
           ID-1: /dev/sda vendor: SanDisk model: SDSSDX480GG25 size: 447.13 GiB 
Partition: ID-1: / size: 434.75 GiB used: 184.88 GiB (42.5%) fs: ext4 dev: /dev/sda2 
           ID-2: swap-1 size: 3.93 GiB used: 3.85 GiB (98.0%) fs: swap dev: /dev/sda3
```

# Graceful Reboot
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount the NAS SMB shares defined in `/etc/fstab` with `sudo mount -a`
4. Start all Docker containers with `docker start $(docker ps -aq)`.