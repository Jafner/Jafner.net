{ pkgs, sys, ... }: let
  smb = {
    fsType = "cifs";
    options = [
      "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=20s,x-systemd.mount-timeout=20s" 
      "credentials=/run/secrets/smb,uid=1000,gid=1000"
    ];
  };
  iscsi = {
    iqn = "iqn.2020-03.net.jafner:fighter";
    portalIP = "192.168.1.23";
  };
in {

  sops.secrets."smb" = { 
    sopsFile = ./smb.secrets;
    format = "binary";
    key = "";
    mode = "0440";
    owner = sys.username;
  };

  services.openiscsi = {
    enable = true;
    name = iscsi.iqn;
    discoverPortal = "${iscsi.portalIP}";
  };

  systemd.services = {
    iscsi-autoconnect = {
      description = "Log into iSCSI target ${iscsi.iqn}";
      after = [ "network.target" "iscsid.service" ];
      wants = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${iscsi.portalIP}";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iscsi.iqn} -p ${iscsi.portalIP} --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iscsi.iqn} -p ${iscsi.portalIP} --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems = {
    "/mnt/iscsi" = {
      device = "/dev/disk/by-uuid/cf3a253c-e792-48b5-89a1-f91deb02b3be";
      fsType = "ext4";
      options = [
        "x-systemd.requires=iscsi.service"
        "_netdev"
        "users"
      ];
    };
    "/mnt/av" = { 
      device = "//192.168.1.12/AV"; 
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/3dprinting" = { 
      device = "//192.168.1.12/3DPrinting";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/movies" = {
      device = "//192.168.1.12/Movies";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/music" = {
      device = "//192.168.1.12/Music";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/shows" = {
      device = "//192.168.1.12/Shows";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/books" = {
      device = "//192.168.1.12/Text";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/torrenting" = {
      device = "//192.168.1.12/Torrenting";
      fsType = smb.fsType; 
      options = smb.options;
    };
    "/mnt/archive" = {
      device = "//192.168.1.12/Archive";
      fsType = smb.fsType; 
      options = smb.options;
    };
  };
}
