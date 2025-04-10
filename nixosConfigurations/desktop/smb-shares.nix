{ pkgs, username, ... }: {
  sops.secrets."smb" = {
    sopsFile = ../../hosts/desktop/secrets/smb.secrets;
    format = "binary";
    key = "";
    mode = "0440";
    owner = username;
  };
  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems = let
    automountOpts = [
      "x-systemd.automount"
      "x-systemd.requires=network.target"
      "vers=3"
    ];
    permissionsOpts = [
      "credentials=/run/secrets/smb"
      "uid=1000,forceuid"
      "gid=1000,forcegid"
    ]; in let
    options = builtins.concatLists [ automountOpts permissionsOpts ]; in {
    "movies" = {
      enable = false;
      mountPoint = "/mnt/movies";
      device = "//192.168.1.12/Movies";
      fsType = "auto";
      inherit options;
    };
    "music" = {
      enable = false;
      mountPoint = "/mnt/music";
      device = "//192.168.1.12/Music";
      fsType = "auto";
      inherit options;
    };
    "shows" = {
      enable = false;
      mountPoint = "/mnt/shows";
      device = "//192.168.1.12/Shows";
      fsType = "auto";
      inherit options;
    };
    "av" = {
      enable = true;
      mountPoint = "/mnt/av";
      device = "//192.168.1.12/AV";
      fsType = "auto";
      inherit options;
    };
    "printing" = {
      enable = false;
      mountPoint = "/mnt/3dprinting";
      device = "//192.168.1.12/3DPrinting";
      fsType = "auto";
      inherit options;
    };
    "books" = {
      enable = false;
      mountPoint = "/mnt/books";
      device = "//192.168.1.12/Text";
      fsType = "auto";
      inherit options;
    };
    "torrenting" = {
      enable = true;
      mountPoint = "/mnt/torrenting";
      device = "//192.168.1.12/Torrenting";
      fsType = "auto";
      inherit options;
    };
    "archive" = {
      enable = false;
      mountPoint = "/mnt/archive";
      device = "//192.168.1.12/Archive";
      fsType = "auto";
      inherit options;
    };
    "recordings" = {
      enable = true;
      mountPoint = "/mnt/recordings";
      device = "//192.168.1.12/Recordings";
      fsType = "auto";
      inherit options;
    };
  };
}
