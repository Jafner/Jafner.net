# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ pkgs, ... }: {
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/88a3f223-ed42-4be1-a748-bb9e0f9007dc";
      fsType = "ext4";
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/744D-0867";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  swapDevices = [ { device = "/.swapfile"; size = 32*1024;} ];

  boot = { 
    loader.systemd-boot.enable = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages."${sys.kernelPackage}";
    extraModulePackages = [ ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}