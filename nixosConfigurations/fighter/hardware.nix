{
  pkgs,
  username,
  ...
}: {
  boot = {
    loader.systemd-boot.enable = true;
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [];
    kernelModules = [
      "amdgpu"
      "kvm-amd"
      "iptable_nat"
      "ip6table_nat"
      "iptable_filter"
    ];
    extraModulePackages = [];
  };
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    amdgpu_top
  ];
  users.users."${username}".extraGroups = [
    "video"
    "render"
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
