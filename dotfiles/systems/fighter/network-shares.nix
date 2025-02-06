{ pkgs, sys, ... }: let
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
    name = iqn;
    discoverPortal = "${portals.paladin.ip}:${portals.paladin.port}";
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

  sops.secrets."smb" = { 
    sopsFile = ./smb.secrets;
    format = "dotenv";
    key = "";
    mode = "0440";
    owner = sys.username;
  };
  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems =
    let
        fsType = "cifs";
        options = [
          "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s" 
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
  };
}
