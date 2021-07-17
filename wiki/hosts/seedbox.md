---
title: Seedbox
description: Configuration information for the seedbox
published: true
date: 2021-07-17T19:05:28.822Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:24:15.927Z
---

# System Info Report
```
System:    Host: joey-seedbox Kernel: 4.19.0-17-amd64 x86_64 bits: 64 Console: tty 0 Distro: Debian GNU/Linux 10 (buster) 
Machine:   Type: Desktop Mobo: ASUSTeK model: PRIME A320M-K v: Rev X.0x serial: 200569832803322 UEFI: American Megatrends 
           v: 5409 date: 01/07/2020 
Memory:    RAM: total: 15.66 GiB used: 2.19 GiB (14.0%) 
           Array-1: capacity: 128 GiB note: check slots: 2 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_B1 size: 8 GiB speed: 2133 MT/s 
CPU:       Topology: 6-Core model: AMD Ryzen 5 1600 bits: 64 type: MT MCP L2 cache: 3072 KiB 
           Speed: 1547 MHz min/max: 1550/3200 MHz Core speeds (MHz): 1: 1551 2: 1547 3: 1536 4: 1541 5: 1547 6: 1551 7: 1547 
           8: 1549 9: 1547 10: 1547 11: 1531 12: 1545 
Graphics:  Message: No Device data found. 
           Display: server: X.org 1.20.4 driver: fbdev,modesetting,vesa tty: 170x56 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169 
Drives:    Local Storage: total: 119.24 GiB used: 58.21 GiB (48.8%) 
           ID-1: /dev/sda vendor: Crucial model: CT128MX100SSD1 size: 119.24 GiB 
Partition: ID-1: / size: 100.68 GiB used: 29.10 GiB (28.9%) fs: ext4 dev: /dev/sda2 
           ID-2: swap-1 size: 15.95 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/sda3
```

# Graceful Reboot
1. Stop all Docker containers with `docker stop $(docker ps -aq)`.
2. Reboot the host with `sudo reboot now`.
3. When the host has finished booting, re-mount all NAS shares defined in `/etc/fstab` with `sudo mount -a`.
4. Start all Docker containers with `docker start $(docker ps -aq)`.