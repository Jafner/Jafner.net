{ pkgs, config, ... }: let cfg = config.networkshares.iscsi; in {
  options = with pkgs.lib; {
    networkshares.iscsi = {
      enable = mkEnableOption "iSCSI";
      hostname = mkOption {
        type = types.str;
        default = null;
        example = "nixos";
        description = "Hostname of the iSCSI initiator.";
      };
      portalAddr = mkOption {
        type = types.str;
        default = null;
        example = "192.168.1.40";
        description = "Hostname or IP address of the iSCSI portal.";
      };
      portalPort = mkOption {
        type = types.str;
        default = "3260";
        example = "30260";
        description = "Port on which the iSCSI portal is listening.";
      };
      iqn = mkOption {
        type = types.str;
        default = null;
        example = "iqn.2003-06.org.nixos:nixos";
        description = "IQN of the iSCSI target.";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    services.openiscsi = {
      enable = true;
      name = cfg.hostname;
      discoverPortal = cfg.portalAddr;
    };
    systemd.services = {
      iscsi-autoconnect = {
        description = "Log into iSCSI target ${cfg.iqn}";
        after = [ "network.target" "iscsid.service" ];
        wants = [ "iscsid.service" ];
        serviceConfig = {
          ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${cfg.portalAddr}:${cfg.portalPort}";
          ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${cfg.iqn} -p ${cfg.portalAddr}:${cfg.portalPort} --login";
          ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${cfg.iqn} -p ${cfg.portalAddr}:${cfg.portalPort} --logout";
          Restart = "on-failure";
          RemainAfterExit = true;
        };
      };
    };
  };
}
