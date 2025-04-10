{ pkgs, username, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelModules = [ "amdgpu" ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    amdgpu_top
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-partuuid/ff24dcbc-39e9-4bbe-b013-50d755c9d13d";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/data" = {
      device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
      fsType = "btrfs";
    };
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];
}
