{ pkgs, ... }: {
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

    "/data" = { 
      device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
      fsType = "btrfs";
    };

    "/mnt/iscsi/joey-desktop" = {
      device = "/dev/disk/by-uuid/7446B1DB46B19DF4";
      fsType = "ntfs3";
    };
  };

  services.openiscsi = {
    enable = true;
    discoverPortal = "192.168.1.12:3260";
    name = "joey-desktop";
  };
  systemd.services = {
    iscsi-autoconnect-paladin = {
      description = "Log into iSCSI target joey-desktop on paladin";
      after = [ "network.target" "iscsid.service" ];
      wants = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 192.168.1.12:3260";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p 192.168.1.12:3260 --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p $192.168.1.12:3260 --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];
}