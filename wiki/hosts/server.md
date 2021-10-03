---
title: Server
description: Configuration information for the main server
published: true
date: 2021-10-03T20:10:36.478Z
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
Memory:    RAM: total: 47.14 GiB used: 15.99 GiB (33.9%) 
           Array-1: capacity: 128 GiB slots: 4 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_A2 size: 8 GiB speed: 2133 MT/s 
           Device-3: DIMM_B1 size: 16 GiB speed: 2133 MT/s 
           Device-4: DIMM_B2 size: 16 GiB speed: 2133 MT/s 
CPU:       Topology: 8-Core model: AMD Ryzen 7 5800X bits: 64 type: MT MCP L2 cache: 4096 KiB 
           Speed: 3729 MHz min/max: 2200/3800 MHz Core speeds (MHz): 1: 3765 2: 3742 3: 4686 4: 3754 5: 3747 6: 3735 7: 3724 
           8: 3753 9: 4705 10: 3736 11: 3715 12: 3765 13: 3762 14: 3770 15: 3761 16: 3748 
Graphics:  Device-1: NVIDIA GK208 [GeForce GT 730] driver: nouveau v: kernel 
           Display: server: X.org 1.20.4 driver: fbdev,modesetting,vesa tty: 177x63 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169 
Drives:    Local Storage: total: 447.13 GiB used: 480.05 GiB (107.4%) 
           ID-1: /dev/sda vendor: SanDisk model: SDSSDX480GG25 size: 447.13 GiB 
Partition: ID-1: / size: 434.75 GiB used: 240.02 GiB (55.2%) fs: ext4 dev: /dev/sda2 
           ID-2: swap-1 size: 3.93 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/sda3 
```

# Graceful Reboot
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount the NAS SMB shares defined in `/etc/fstab` with `sudo mount -a`
4. Start all Docker containers with `docker start $(docker ps -aq)`.