
- Our environment is split between on-prem and multi-cloud (DigitalOcean, SSDNodes).
- We have several hosts that we're not ready to destabilize. 
- We want to start with bard and cleric, which are low-power thin workstations (`x86_64`). 
- I think [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) is our best option. 

- We need:
  - A basic NixOS configuration to deploy to each host.
  - A generated `hardware-configuration.nix`.
  - A basic flake to tie everything together.

- We have already:
  - Run the Nix installer script (which required disabling SELinux).
  - Created an alias to run flakes: `alias flake='nix --extra-experimental-features nix-command --extra-experimental-features flakes flake'`
  - Gathered information to connect to our target hosts.

---

## Hosts
### Bard
User: `admin`
IP: `192.168.1.31`
### Cleric
User: `admin`
IP: `192.168.1.33`

---

# Working thoughts

First thing we've gotta generate our hardware-configuration.nix files.
Per the [nixos-anywhere quickstart docs](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md#get-nixos-generate-config-onto-the-target-machine), we're gonna need to use the kexec tarball method to get `nixos-generate-config` onto each of our hosts. Because I expect this to be part of a regular bootstrap process, we'll script it.

```sh
#!/bin/bash

# Hard coding our inputs for now.

# Bard
## Script requires root on the target.
## Authorized ssh keys are read from /root/.ssh/authorized_keys, /root/.ssh/authorized_keys2 and /etc/ssh/authorized_keys.d/root, so we need to copy our non-root-user's authorized_keys file to /root/.ssh/authorized_keys

ssh -i /home/joey/.ssh/main_id_ed25519 admin@192.168.1.31 'curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | sudo tar -xzf- -C /root && sudo mkdir -p /root/.ssh && sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo /root/kexec/run' 

# After this, we found that our host ended up on a different local IP. Same hostname though.

ssh -i /home/joey/.ssh/main_id_ed25519 root@<new-ip> 'nixos-generate-config --no-filesystems --dir /mnt/etc/nixos && cat /mnt/etc/nixos/hardware-configuration.nix'

# Cleric
ssh -i /home/joey/.ssh/main_id_ed25519 admin@192.168.1.33 'curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | sudo tar -xzf- -C /root && sudo mkdir -p /root/.ssh && sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo /root/kexec/run

ssh -i /home/joey/.ssh/main_id_ed25519 root@<new-ip> 'nixos-generate-config --no-filesystems --dir /mnt/etc/nixos && cat /mnt/etc/nixos/hardware-configuration.nix'
```

After that we copy the [stock `disk-config.nix`](https://github.com/nix-community/nixos-anywhere-examples/blob/main/disk-config.nix) to each of our `nixos-anywhere/host/<host>` directories.

Since our two hosts have identical hardware, we're not going to use different configs for them yet. For now, we'll just re-use the `configuration.nix`, `hardware-configuration.nix`, and `disk-configuration.nix` files for each.

Ah, we're expected to add per-host configurations in the [`flake.nix`] file. Makes sense.

We encountered an error when we tried to run: `nix run github:nix-community/nixos-anywhere -- --flake ~/Git/Jafner.net/nix/nixos-anywhere#bard root@192.168.1.240`

It looks like the disk formatter is expecting a disk called `/dev/sda` to exist on the host. But we only have `mmcblk0`. 

```
Problem opening /dev/sda for reading! Error is 2.
The specified file does not exist!
Information: Creating fresh partition table; will override earlier problems!
Caution! Secondary header was placed beyond the disk's limits! Moving the
header, but other problems may occur!
Unable to open device '' for writing! Errno is 2! Aborting write!
+ rm -rf /tmp/tmp.uJvnnE7AOz
Connection to 192.168.1.240 closed.
```

So we update our `disk-config.nix` to point at that device instead of `/dev/sda` and run it again. 

And that worked!

Now we're waiting to the host to show up on the network...

Yeah looks like we're failing to boot. Seems to be related to the boot disk device, but I haven't been able to discern further details. Error is like: 

```
File descritpor <N> (/dev/console) leaked on lvm invocation. Parent PID 1: /nix/store/<store-hash>-extra-utils/bin/ash
<... repeated many times ...>

Timed out waiting for device /dev/pool/root, trying to mount anyway.
mounting /dev/pool/root on /...
[ 30.607134] /dev/pool/root: Can't lookup blockdev
mount: mounting /dev/pool/root on /mnt-root/ failed: No such file or directory

An error occurred in stage 1 of the boot process, which must mount the root filesystem on `/mnt-root' and then start stage 2. Press one of the following keys:

  r) to reboot immediately
  *) to ignore the error and continue
Continuing...
mount: can't fine /mnt-root/ in /proc/mounts
stage 2 init script (/mnt/root//nix/store/<store-hash>-nixos-system-cleric-24.11.20240916.<tag>/init) not found
```

So we're gonna try booting from an installer USB.   

Booted from the installer. Got connected to the network. Installed SSH pubkeys. Confirmed we have passwordless-sudo. Now we're gonna run the script again (against cleric):

`nix run github:nix-community/nixos-anywhere -- --flake ~/Git/Jafner.net/nix/nixos-anywhere#cleric nixos@192.168.1.102`

Forgot to unplug the installer USB, so we've gotta reboot. But I think we installed properly this time.

Nah, still hitting the same error as before. Must be an issue with our disko setup. Gotta dig deeper. 

Unfortunately a hardware scan doesn't seem to offer any further clues.

Hmm, it seems that our mix of x86-64 architecture and MMC storage is causing us some issues. 

Alright. Tragically I've been stumped. Too many hypotheses to test, not enough time. I'll look around for a spare SATA SSD and throw that in if I can. 

Welp, none SATA. 

Gonna order 3 M.2 Sata SSDs on Amazon.

Alright. We've installed our SSDs into Bard and Cleric (Ranger will come later). We've booted Bard into the NixOS minimal installer. Gotta configure it to receive our SSH connection.

> Lines from the local host will start with `$`, 
> lines on the NixOS host will start with `>`
```sh
> mkdir ~/.ssh && curl https://github.com/Jafner.keys > ~/.ssh/authorized_keys
$ ssh nixos@192.168.1.116 'curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | sudo tar -xzf- -C /root && sudo mkdir -p /root/.ssh && sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo /root/kexec/run'
$ ssh root@192.168.1.116 'nixos-generate-config --no-filesystems --dir /mnt/etc/nixos && cat /mnt/etc/nixos/hardware-configuration.nix'
$ nix run github:nix-community/nixos-anywhere -- --flake ~/Git/Jafner.net/nix/nixos-anywhere#bard root@192.168.1.116
```

After that we rebooted, and hit the same error. But I think it may have booted into the old, bad MMC-based install. Rebooting to test.

Bypassing the MMC drive is proving more challenging than expected. It looks like the BIOS (UEFI) has a procedure for wiping internal storage devices. Let's try that.

And if this doesn't solve the issue, we'll look further into how MMC devices work on Linux.

I'm giving up on NixOS Anywhere for now. Switching to traditional install method.

Going forward, I think our better bet will be to build a custom installer ISO to use with Ventoy and cloud VPSs.

# Bard

All lines were run as `nixos@nixos` on the machine being provisioned, booted into the NixOS minimal installer.
```sh
mkdir ~/.ssh && curl https://github.com/Jafner.keys > ~/.ssh/authorized_keys
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MB -8GB
sudo parted /dev/sda -- mkpart primary linux-swap -8GB 100%
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 3 esp on
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mkswap -L swap /dev/sda2
sudo swapon /dev/sda2
sudo mkfs.fat -F 32 -n boot /dev/sda3
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo nixos-generate-config --root /mnt
```

At this point we have the default configurations on the disk at `/mnt/etc/nixos/[hardware-]configuration.nix`. From our desktop, we run `ssh nixos@192.168.1.116 'cat /mnt/etc/nixos/hardware-configuration.nix' | wl-copy` and `ssh nixos@192.168.1.116 'cat /mnt/etc/nixos/configuration.nix' | wl-copy` and paste the results into [`hardware-configuration.nix`](../nix-lab/hardware-configuration.nix) and [`configuration.nix`](../nix-lab/configuration.nix) respectively. 

Here we could make all our desired changes to the base configuration, but instead we're going to do the bare minimum to configure networking and authentication so that we can manage and configure the system after it has booted into its own NixOS installation. 

First we cleanse the generated config of all comments. We don't need those.

We add this snippet to configure the admin user with our SSH keys:

```nix
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile
    authorizedKeys);
  };
```

And this snippet to configure our desired DHCP lease configuration:

```nix
networking = {
  hostName = "bard"; 
  interfaces."enp1s0" = {
    useDHCP = true;
    macAddress = "6c:2b:59:37:89:40";
    ipv4.addresses = [ { address = "192.168.1.31"; prefixLength = 24; } ];
  };
};
```

Lastly we configure a password for our root and admin users. We generate or craft a passphrase from our password manager, hash it with `mkpasswd -m sha-512 "<password>"`, and add it to each user's config.

```nix
users.users.admin.hashedPassword = "<hashed-password>";
users.users.root.hashedPassword = "<hashed-password>";
```

And we end up with this cute little config:

```nix
{ config, lib, pkgs, ... }:
{   
  imports = [ ./hardware-configuration.nix ];
  users.users.root.hashedPassword = "<hashed password>";
  users.users.admin = {
    hashedPassword = "<other-hashed-password>";
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile
    authorizedKeys);
  };
  networking = {
    hostName = "bard"; 
    interfaces."enp1s0" = {
      useDHCP = true;
      macAddress = "6c:2b:59:37:89:40";
      ipv4.addresses = [ { address = "192.168.1.31"; prefixLength = 24; } ];
    };
  };  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05"; 
}
```

Before hard-committing to the config, we validate it with: `sudo nixos-rebuild dry-activate -I nixos-config=/mnt/etc/nixos/configuration.nix`

Ours exited without errors, so we continue to `sudo nixos-install`, which is called without arguments. 

The installer still prompted for a root password, but we just copy-pasted the one we generated earlier.

Whoops! We forgot to enable `services.openssh`, so our authorizedKeys didn't actually do anything, and the host is not accessible via SSH. 

We add the following snippet:

```nix
services.openssh = {
  enable = true;
  settings.PasswordAuthentication = false;
  settings.KbdInteractiveAuthentication = false;
};
```

And then run `sudo nixos-rebuild switch` to apply the change.

Boom! We're connected via SSH with NixOS installed and our admin user provisioned. We have more configuration to do, but first we've gotta repeat this process for our two other hosts.

# Cleric

Second verse, same as the first, but a whole lot faster.

I think I, at some point, accidentally configured a Dell Security Manager password on one of my drives. Not really sure how to remove that. We're gonna try removing the CMOS battery. Mayhaps the BIOS itself is holding a record of that password info. `/shrug`.

No dice. Might have to wait until I have another, non-Dell device into which I can install the drive and wipe it the old fashioned way.

Alright. I think we have a good understanding of the issue now. Running the drive wipe from the Dell BIOS apparently sets an ATA password on the drive. Only Dell Support can give you the unlock code to remove the password via Dell Security Manager. Cool. 

And removing an ATA password from the drive's firmware may not be trivial. Nice.

Anyway, good thing we have a spare. Ranger will have to wait until we can work out how to remove or recover the ATA password. 

We followed the steps for Bard, with the following changes:

1. Different root and admin passwords.
2. `networking.hostName = "cleric";`
3. `networking.interfaces."enp1s0".ipv4.addresses = [ { address = "192.168.1.33"; prefixLength = 24; } ];`

That's pretty much it. It may be important to note that [`configuration.nix`](../nix-lab/configuration.nix) and [`hardware-configuration.nix`](../nix-lab/hardware-configuration.nix) do not represent the *configured state* of any system. Only a reference for the *automatically generated config* that we got for Bard. 

(We didn't forget to add the SSH config this time!).

We test our config, and then run `sudo nixos-install`, repeating the step of giving our generated root password when prompted at the end of the install. 

Regarding the locked drive, we're just gonna make that Amazon's problem. 

Whoops! We forgot to change the MAC address of Cleric's NIC, so they collided when both were connected to the network. Updated like this: 

`networking.interfaces."enp1s0".macAddress = "6c:2b:59:37:9e:00";`

Alright. It took longer than expected. But we're online.

# Configuring Force-multiplied Deployments

There are a few tools on the market for deploying configuration updates to a NixOS fleet. 

- [NixOps](https://github.com/NixOS/nixops) appears to be the grandaddy of such tools. 
- [Morph](https://github.com/DBCDK/morph) is a second-gen tool and boasts "multi host support, health checks, and no state".
- [Colmena](https://github.com/zhaofengli/colmena) may be the most recent project in the genre, and seems to support parallel deployments.

We'll go with Colmena, and use NixOps and Morph as references for how things have been done before.

Further notes will be located at [`nix/nix-lab/notes.md`](../nix-lab/notes.md).

# Ranger
1. Boot from NixOS minimal installer ISO.
2. Configure SSH authorized_keys for the installer. 
```sh
mkdir ~/.ssh && curl https://github.com/Jafner.keys > ~/.ssh/authorized_keys
```
3. Format and partition our boot disk.

```sh
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MB -8GB
sudo parted /dev/sda -- mkpart primary linux-swap -8GB 100%
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 3 esp on
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mkswap -L swap /dev/sda2
sudo swapon /dev/sda2
sudo mkfs.fat -F 32 -n boot /dev/sda3
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```
4. Generate our `hardware-configuration.nix`.
```sh
sudo nixos-generate-config --root /mnt
```
5. Configuration the host's `/mnt/etc/nixos/configuration.nix`.
   1. Generate root password, then hash it with `mkpasswd -m sha-512`.
   2. Generate admin password, then hash it with `mkpasswd -m sha-512`.
   3. Get network config (hostname, MAC, ipv4).
```nix
{ config, lib, pkgs, ... }:
{   
  imports = [ ./hardware-configuration.nix ];
  users.users.root.hashedPassword = "$6$QkcEnf/kzljg./Ux$XvNFdS9o9Psxi.xoFrat7EA7w.WJq/B/7kCf5WQSQkVWRrlfzm.wjKabTpz8LMquu5iWGldS9OjhFJxpryc4s0";
  users.users.admin = {
    hashedPassword = "$6$z1aBZwdnsJJCjATF$wxAgBjf.36miVtDBP/L6jT8kGtAfvIH7EcdT8/VpYT4y9x1fO10VPOPpecH6UPJ9qbmw1UkOD3G29UfpZEiS70";
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
  networking = {
    hostName = "bard"; 
    interfaces."enp1s0" = {
      useDHCP = true;
      macAddress = "6c:2b:59:37:9e:91";
      ipv4.addresses = [ { address = "192.168.1.32"; prefixLength = 24; } ];
    };
  };  
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05"; 
}
```
6. Install the config. `sudo nixos-install`
7. Reboot. `sudo reboot now`.