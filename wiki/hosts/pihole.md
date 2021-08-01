---
title: PiHole
description: Configuration information for the Pihole
published: true
date: 2021-08-01T22:39:33.396Z
tags: 
editor: markdown
dateCreated: 2021-07-17T04:25:03.232Z
---

# System Info Report
```
System:    Host: raspberrypi Kernel: 5.10.17-v8+ aarch64 bits: 64 Console: tty 0 Distro: Debian GNU/Linux 10 (buster) 
Machine:   Type: ARM Device System: Raspberry Pi 3 Model B Plus Rev 1.3 details: BCM2835 rev: a020d3 serial: 00000000a73c8ebb 
Memory:    RAM: total: 986.2 MiB used: 229.4 MiB (23.3%) gpu: 76.0 MiB 
           RAM Report: unknown-error: dmidecode was unable to generate data 
Argument "Raspberry Pi 3 Model B Plus Rev 1.3" isn't numeric in sprintf at /usr/bin/inxi line 6969.
CPU:       Topology: Quad Core model: N/A variant: cortex-a53 bits: 64 type: MCP 
           Speed: 1400 MHz min/max: 600/1400 MHz Core speeds (MHz): 1: 1400 2: 1400 3: 1400 4: 1400 
Graphics:  Device-1: bcm2835-hdmi driver: vc4_hdmi v: N/A 
           Device-2: bcm2835-vc4 driver: vc4_drm v: N/A 
           Display: server: No display server data found. Headless machine? tty: 170x56 
           Message: Advanced graphics data unavailable in console for root. 
Network:   Device-1: Standard Microsystems type: USB driver: lan78xx 
Drives:    Local Storage: total: 29.72 GiB used: 1.47 GiB (4.9%) 
           ID-1: /dev/mmcblk0 vendor: Samsung model: SP32G size: 29.72 GiB 
Partition: ID-1: / size: 28.99 GiB used: 1.44 GiB (5.0%) fs: ext4 dev: /dev/mmcblk0p2 
           ID-2: /boot size: 252.0 MiB used: 29.3 MiB (11.6%) fs: vfat dev: /dev/mmcblk0p1 
```

# Graceful Reboot
The PiHole is relied upon for DNS resolution for all devices on the network which have not manually configured another DNS resolver.
1. Log into `router` via SSH and run the following:
```
configure
delete system name-server 192.168.1.22
set system name-server 1.1.1.1
commit; save; exit
```
2. Reboot the Pi with `sudo reboot now`
3. Switch back to the router and run the following:
```
configure 
delete system name-server 1.1.1.1
set system name-server 192.168.1.22
commit; save; exit
```
4. Done.