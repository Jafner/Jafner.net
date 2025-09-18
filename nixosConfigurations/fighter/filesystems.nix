{username, ...}: {
  sops.secrets."paladin/smb" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/88a3f223-ed42-4be1-a748-bb9e0f9007dc";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/518e8d5f-cba4-4d87-a80a-e06a811f73e4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = [
    {
      device = "/.swapfile";
      size = 32 * 1024;
    }
  ];

  fileSystems."/mnt/av" = {
    enable = true;
    mountPoint = "/mnt/av";
    device = "//192.168.1.12/AV";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
    ];
  };
}
