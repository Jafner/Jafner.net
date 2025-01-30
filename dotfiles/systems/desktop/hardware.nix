{ pkgs, sys, ... }: {
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
      fsType = "ext4";
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/CC5A-CDFE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/fedora" = { 
      device = "/dev/disk/by-uuid/15454185-1268-4559-a074-bb154dc20a93";
      fsType = "btrfs";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages."${sys.kernelPackage}";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];
  hardware = {
    amdgpu.amdvlk.enable = false;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [ amdgpu_top ];
  };

  networking.hostName = "${sys.hostname}";

  imports = [
    ../../modules/hardware/audio.nix
    ../../modules/hardware/goxlr-mini.nix
    ../../modules/hardware/libinput.nix
    ../../modules/hardware/network-shares.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/razer.nix
    ../../modules/hardware/wooting.nix
    ../../modules/hardware/xpad.nix
  ];
}