{ pkgs, hostname, ... }:
let
  target = "iqn.2020-03.net.jafner:fighter";
in
{
  services.openiscsi = {
    enable = true;
    name = hostname;
    discoverPortal = "192.168.1.12";
  };
  systemd.services = {
    iscsi-autoconnect = {
      description = "Log into iSCSI target ${target}";
      after = [
        "network.target"
        "iscsid.service"
      ];
      requires = [ "iscsid.service" ];
      serviceConfig = {
        ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 192.168.1.12:3260";
        ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${target} -p 192.168.1.12:3260 --login";
        ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${target} -p 192.168.1.12:3260 --logout";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
    };
  };
  fileSystems."iscsi" = {
    enable = true;
    mountPoint = "/mnt/iscsi";
    device = "/dev/disk/by-path/ip-192.168.1.12:3260-iscsi-${target}-lun-0";
    fsType = "auto";
    options = [
      "x-systemd.automount"
      "x-systemd.requires=iscsi-autoconnect.service"
      "user"
      "rw"
    ];
    noCheck = true;
  };
}
