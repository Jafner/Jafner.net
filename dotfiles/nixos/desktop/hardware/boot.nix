{ pkgs, ... }: {
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot = {
    #kernelPackages = pkgs.linuxKernel.kernels.linux_xanmod_latest
    kernelPackages = pkgs.linuxPackages_6_11;
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules = [ ];
    };
    kernelModules = [ "amdgpu" "kvm-amd" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}