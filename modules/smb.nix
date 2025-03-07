{ smb, sys, pkgs, ... }: {

  sops.secrets."smb" = { 
    sopsFile = smb.secretsFile;
    format = "binary";
    key = "";
    mode = "0440";
    owner = sys.username;
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems."movies" = {
    mountPoint = "/mnt/movies";
    device = "//192.168.1.12/Movies";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."music" = {
    mountPoint = "/mnt/music";
    device = "//192.168.1.12/Music";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."shows" = {
    mountPoint = "/mnt/shows";
    device = "//192.168.1.12/Shows";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."av" = { 
    mountPoint = "/mnt/av";
    device = "//192.168.1.12/AV"; 
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."printing" = { 
    mountPoint = "/mnt/3dprinting";
    device = "//192.168.1.12/3DPrinting";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."books" = {
    mountPoint = "/mnt/books";
    device = "//192.168.1.12/Text";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."torrenting" = {
    mountPoint = "/mnt/torrenting";
    device = "//192.168.1.12/Torrenting";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."archive" = {
    mountPoint = "/mnt/archive";
    device = "//192.168.1.12/Archive";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
  fileSystems."recordings" = {
    mountPoint = "/mnt/recordings";
    device = "//192.168.1.12/Recordings";
    fsType = "cifs"; 
    options = [ smb.permissions_opts smb.automount_opts ];
  };
}
