{ ... }: {
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/placeholder";
      fsType = "ext4";
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/placeholder";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  boot.loader.systemd-boot.enable = true;
}