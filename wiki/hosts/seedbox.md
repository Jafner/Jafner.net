---
title: Seedbox
description: Configuration information for the seedbox
published: true
date: 2021-07-17T04:24:17.382Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:24:15.927Z
---

# System Info Report
```
joey@joey-seedbox:~$ sudo inxi -CDGImMNPS -W 98405
System:    Host: joey-seedbox Kernel: 4.19.0-17-amd64 x86_64 bits: 64 Console: tty 0 Distro: Debian GNU/Linux 10 (buster) 
Machine:   Type: Desktop Mobo: ASUSTeK model: PRIME A320M-K v: Rev X.0x serial: 200569832803322 UEFI: American Megatrends 
           v: 5409 date: 01/07/2020 
Memory:    RAM: total: 15.66 GiB used: 2.70 GiB (17.2%) 
           Array-1: capacity: 128 GiB note: check slots: 2 EC: None 
           Device-1: DIMM_A1 size: 8 GiB speed: 2133 MT/s 
           Device-2: DIMM_B1 size: 8 GiB speed: 2133 MT/s 
CPU:       Topology: 6-Core model: AMD Ryzen 5 1600 bits: 64 type: MT MCP L2 cache: 3072 KiB 
           Speed: 1555 MHz min/max: 1550/3200 MHz Core speeds (MHz): 1: 1545 2: 1544 3: 1547 4: 1537 5: 1547 6: 1555 7: 1546 
           8: 1547 9: 1559 10: 1547 11: 1542 12: 1546 
Graphics:  Message: No Device data found. 
           Display: server: X.org 1.20.4 driver: fbdev,modesetting,vesa tty: 170x56 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169 
Drives:    Local Storage: total: 119.24 GiB used: 58.26 GiB (48.9%) 
           ID-1: /dev/sda vendor: Crucial model: CT128MX100SSD1 size: 119.24 GiB 
Partition: ID-1: / size: 100.68 GiB used: 29.11 GiB (28.9%) fs: ext4 dev: /dev/sda2 
           ID-2: swap-1 size: 15.95 GiB used: 23.8 MiB (0.1%) fs: swap dev: /dev/sda3 
Weather:   Temperature: 16.5 C (62 F) Conditions: Few clouds Current Time: Fri 16 Jul 2021 09:24:04 PM PDT 
           Source: WeatherBit.io 
Info:      Processes: 275 Uptime: 5d 18h 39m Init: systemd runlevel: 5 Shell: bash inxi: 3.0.32
```