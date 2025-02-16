{ smb, pkgs ? import <nixpkgs>, ... }: {

  sops.secrets."smb" = { 
    sopsFile = ./smb.secrets;
    format = "binary";
    key = "";
    mode = "0440";
    owner = smb.username;
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems = let
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    permissions_opts = "credentials=/run/secrets/smb,uid=1000,gid=1000"; 
  in { "${smb.name}" = {
      mountPoint = smb.mountPoint;
      device = smb.device;
      fsType = "cifs";
      options = [ 
        "${automount_opts}"
        "${permissions_opts}"
        "${smb.extra_opts}" 
      ];
    };
  };
}
