{ pkgs, sys, ... }: {

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
    "/mnt/archive" = {
      device = "//192.168.1.12/Archive";
      inherit fsType options;
    };
    
  };
}
