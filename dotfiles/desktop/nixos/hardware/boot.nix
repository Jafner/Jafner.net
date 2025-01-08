{ pkgs, sysVars, ... }: {
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot = {
    kernelPackages = pkgs.linuxKernel.packages."${sysVars.kernelPackage}";
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
    kernelModules = [ "amdgpu" "kvm-amd" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
