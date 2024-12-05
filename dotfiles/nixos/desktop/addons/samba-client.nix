{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems = 
    let 
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"; 
      permissions_opts = "credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000";
    in {
    # Pool Media on Paladin
    "/mnt/smb/paladin/Media/AV" = {
      device = "//192.168.1.12/AV";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Media/3DPrinting" = {
      device = "//192.168.1.12/3DPrinting";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Media/Movies" = {
      device = "//192.168.1.12/Movies";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Media/Music" = {
      device = "//192.168.1.12/Music";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Media/Shows" = {
      device = "//192.168.1.12/Shows";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Media/Text" = {
      device = "//192.168.1.12/Text";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    
    # Pool Tank on Paladin
    "/mnt/smb/paladin/Tank/AppData" = {
      device = "//192.168.1.12/AppData";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/Archive" = {
      device = "//192.168.1.12/Archive";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/HomeVideos" = {
      device = "//192.168.1.12/HomeVideos";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/Images" = {
      device = "//192.168.1.12/Images";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/Recordings" = {
      device = "//192.168.1.12/Recordings";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/Software" = {
      device = "//192.168.1.12/Software";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
    "/mnt/smb/paladin/Tank/Torrenting" = {
      device = "//192.168.1.12/Torrenting";
      fsType = "cifs";
      options = ["${automount_opts},${permissions_opts}"];
    };
  };
}
