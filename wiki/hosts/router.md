---
title: Router
description: Configuration information for the Edgerouter 10X
published: true
date: 2021-09-18T02:20:53.284Z
tags: 
editor: markdown
dateCreated: 2021-07-17T18:45:24.630Z
---

# System Info Report
```
System:    Host: ubnt Kernel: 4.14.54-UBNT mips bits: 32 Console: tty pts/0 Distro: Debian GNU/Linux 9 (stretch) 
Machine:   Type: MIPS Device System: MediaTek MT7621 ver:1 eco:3 details: Ubiquiti EdgeRouter 
Memory:    RAM: total: 500.8 MiB used: 115 MiB (23.0%) 
           RAM Report: missing: Required tool dmidecode not installed. Check --recommends 
CPU:       Info: Quad Core model: MIPS 1004Kc V2.15 variant: mips1004Kc bits: N/A type: MCP 
           Speed: N/A min/max: N/A Core speeds (MHz): No per core speed data found. 
Graphics:  Message: No MIPS data found for this feature. 
           Display: server: No display server data found. Headless machine? tty: 170x56 
           Message: Unable to show advanced data. Required tool glxinfo missing. 
Network:   Device-1: mt7621-eth driver: mtk_soc_eth 
Drives:    Local Storage: total: 0 KiB used: 154.2 MiB
```

# Graceful Reboot
The router is relied upon by all clients on the network, so they all need to be offlined or prepared.
1. Offline the [seedbox](/hosts/seedbox).
2. Offline the [server](/hosts/server).
3. Offline the [NAS](/hosts/nas).
4. Run `shutdown`.
