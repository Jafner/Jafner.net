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

  fileSystems."/mnt/stash" = {
    enable = true;
    mountPoint = "/mnt/stash";
    device = "//192.168.1.12/AV";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto,x-systemd.idle-timeout=30"
    ];
  };
  fileSystems."/mnt/torrenting" = {
    enable = true;
    mountPoint = "/mnt/torrenting";
    device = "//192.168.1.12/torrenting";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto,x-systemd.idle-timeout=30"
    ];
  };
  fileSystems."/mnt/movies" = {
    enable = true;
    mountPoint = "/mnt/movies";
    device = "//192.168.1.12/Movies";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto,x-systemd.idle-timeout=30"
    ];
  };
  fileSystems."/mnt/shows" = {
    enable = true;
    mountPoint = "/mnt/shows";
    device = "//192.168.1.12/Shows";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto,x-systemd.idle-timeout=30"
    ];
  };
  fileSystems."/mnt/music" = {
    enable = true;
    mountPoint = "/mnt/music";
    device = "//192.168.1.12/Music";
    fsType = "cifs";
    options = [
      "vers=3"
      "credentials=/run/secrets/paladin/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "noauto,x-systemd.idle-timeout=30"
    ];
  };
}
