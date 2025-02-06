{ ... }: {
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
  boot.loader.systemd-boot.enable = true;
}