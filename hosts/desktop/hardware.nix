{ pkgs, sys, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
}