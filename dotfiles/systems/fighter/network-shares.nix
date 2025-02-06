{ pkgs, sys, ... }: let
  
  iscsi = { 
    iqn = "iqn.2020-03.net.jafner:fighter";
    portal = { # For Paladin
      ip = "192.168.1.12";
      port = "3260";
    };
  };
in {
  services.openiscsi = {
    enable = true;
    name = iscsi.iqn;
    discoverPortal = "${iscsi.portal.ip}:${iscsi.portal.port}";
  };

  systemd.services = {
    iscsi-autoconnect-paladin = {
      description = "Log into iSCSI target ${iscsi.iqn} on paladin";
      after = [ "network.target" "iscsid.service" ];
      wants = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${iscsi.portal.ip}:${iscsi.portal.port}";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iscsi.iqn} -p ${iscsi.portal.ip}:${iscsi.portal.port} --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iscsi.iqn} -p ${iscsi.portal.ip}:${iscsi.portal.port} --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
  };

  sops.secrets."smb" = { 
    sopsFile = ./smb.secrets;
    format = "binary";
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems =
    let
        fsType = "cifs";
        options = [
          "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=20s,x-systemd.mount-timeout=20s" 
          "credentials=/run/secrets/smb,uid=1000,gid=1000"
        ];
    in {
    "${sys.dataDirs.library.av}" = { 
      device = "//192.168.1.12/AV"; 
      inherit fsType options; 
    };
    "${sys.dataDirs.library.digitalModels}" = { 
      device = "//192.168.1.12/3DPrinting";
      inherit fsType options;
    };
    "${sys.dataDirs.library.movies}" = {
      device = "//192.168.1.12/Movies";
      inherit fsType options;
    };
    "${sys.dataDirs.library.music}" = {
      device = "//192.168.1.12/Music";
      inherit fsType options;
    };
    "${sys.dataDirs.library.shows}" = {
      device = "//192.168.1.12/Shows";
      inherit fsType options;
    };
    "${sys.dataDirs.library.books}" = {
      device = "//192.168.1.12/Text";
      inherit fsType options;
    };
    "${sys.dataDirs.library.torrenting}" = {
      device = "//192.168.1.12/Torrenting";
      inherit fsType options;
    };
    "/mnt/iscsi/fighter" = {
     device = "/dev/disk/by-uuid/cf3a253c-e792-48b5-89a1-f91deb02b3be";
     fsType = "ext4";
     options = [
      "nofail"
      "auto"
      "users"
      "x-systemd.automount"
     ];
    };
  };
}
