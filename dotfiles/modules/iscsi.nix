{ iscsi, pkgs ? import <nixpkgs>, ... }: {
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
  
  fileSystems."${iscsi.mountPath}" = {
     device = "/dev/disk/by-path/ip-${iscsi.portalIP}-iscsi-${iscsi.iqn}-lun-0-part1";
     fsType = "${iscsi.fsType}";
     options = [
      "x-systemd.requires=iscsi.service"
      "_netdev"
      "users"
     ];
  };
}