{ pkgs }: let
  iqn = "iqn.2020-03.net.jafner:fighter";
  portals = { 
    barbarian = {
      ip = "192.168.1.10";
      port = "3260";
    };
    paladin = {
      ip = "192.168.1.12";
      port = "3260";
    };
  };
in {
  services.openiscsi = {
    enable = true;
    discoverPortals = portals;
    targets = [ iqn ];
  };

  systemd.services = {
    iscsi-autoconnect-paladin = {
      description = "Log into iSCSI target ${iqn} on paladin";
      after = [ "network.target" "iscsid.service" ];
      wants = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${portals.paladin.ip}:${portals.paladin.port}";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -p ${portals.paladin.ip}:${portals.paladin.port} --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -p ${portals.paladin.ip}:${portals.paladin.port} --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
    iscsi-autoconnect-barbarian = {
      description = "Log into iSCSI target ${iqn} on barbarian";
      after = [ "network.target" "iscsid.service" ];
      wants = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${portals.barbarian.ip}:${portals.barbarian.port}";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -p ${portals.barbarian.ip}:${portals.barbarian.port} --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -p ${portals.barbarian.ip}:${portals.barbarian.port} --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
  };

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

    # iSCSI devices
    # "/mnt/iscsi/paladin" = {
    #   device = "/dev/disk/by-uuid/...";
    #   fsType = "ext4";
    #   options = [ "nofail" "_netdev" "auto" "exec" "defaults"];
    # };
    # "/mnt/iscsi/barbarian" = {
    #   device = "/dev/disk/by-uuid/...";
    #   fsType = "ext4";
    #   options = [ "nofail" "_netdev" "auto" "exec" "defaults"];
    # };
  };
}
