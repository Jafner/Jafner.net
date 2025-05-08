{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.iscsi;
in
{
  options = {
    enable = mkEnableOption "Mount iSCSI target";
    target = mkOption {
      type = types.str;
      default = null;
      example = "desktop";
      description = "Name of the iSCSI target.";
    };
  };
  config =
    let
      host = "192.168.1.12";
      iqn = "iqn.2020-03.net.jafner";
    in
    mkIf cfg.enable {
      systemd.services."iscsi-autoconnect-${cfg.target}" = {
        description = "Log into iSCSI target ${iqn}:${cfg.target}";
        after = [
          "network.target"
          "iscsid.service"
        ];
        requires = [ "iscsi.service" ];
        serviceConfig = {
          ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p ${host}:3260";
          ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${target} -p ${host}:3260 --login";
          ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${target} -p ${host}:3260 --logout";
          Restart = "on-failure";
          RemainAfterExit = true;
        };
      };
      fileSystems."iscsi-${cfg.target}" = {
        enable = true;
        mountPoint = "/mnt/iscsi/${cfg.name}";
        device = "/dev/disk/by-path/ip-${host}:3260-iscsi-${target}-lun-0";
        fsType = "auto";
        options = [
          "x-systemd.automount"
          "x-systemd.requires=iscsi-autoconnect-${cfg.target}.service"
          "user"
          "rw"
        ];
        noCheck = true;
      };
    };
}
