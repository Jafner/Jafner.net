{ pkgs, ... }: {
  imports = [
    ../../modules/system.nix
  ];

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = pkgs.lib.mkForce "yes";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  };
}
