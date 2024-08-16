+++
title = 'Subaru Self Tuning - Stage Zero'
description = " "
date = 2024-07-22T14:08:33-07:00
aliases = []
author = "Joey Hafner"
ogimage = '/img/Jafner.dev.logo.png'
slug = "subi-stg0"
draft = true
+++

## Tools of the Trade
- Tactrix OpenPort 2.0
- RomRaider
- EcuFlash

### Install the j2534 Driver
We need our laptop to be able to talk to our Tactrix cable, so we need to install the `j2534` driver created by Dale Schultz.

https://github.com/dschultzca/j2534

- Install `make` `gcc` `git` 
- `git clone https://github.com/dschultzca/j2534`
- `cd j2534/j2534 && make install`
- `echo SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTR{idProduct}=="cc4d", GROUP="dialout", MODE="0666" | sudo tee /etc/udev/rules.d/tactrix`

### Install RomRaider (Option 1: Traditional)

- `git clone https://github.com/RomRaider/RomRaider.git && cd RomRaider`
- `chmod +x run.sh jdk-11.0.14.1+1-jre/bin/java`
- `./run.sh`

### Install RomRaider (Option 2: Docker)

- `git clone https://github.com/RomRaider/RomRaider.git && cd RomRaider`
- `docker build -t RomRaider .`

### Get Definitions Files

- Download the latest ECU definitions zip from the first post in [this thread](https://www.romraider.com/forum/topic360.html).
- Download the latest logger definitions zip from the first post in [this thread](https://www.romraider.com/forum/viewtopic.php?t=1642&start=1)
- Download the latest dyno definitions from the first post in [this thread](https://www.romraider.com/forum/viewtopic.php?t=5792)

### Reading the ECU

