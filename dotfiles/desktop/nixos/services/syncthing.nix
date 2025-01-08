{ vars, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
  services.syncthing = {
    enable = false;
    group = "users";
    user = "${vars.user.username}";
    configDir = /home/${vars.user.username}/.config/syncthing;
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      devices = {
        #"server" = { id = ""; };
        "phone" = { id = "JJNURBH-YHHCPGJ-6I6YKE4-4CLD35N-LWA3JAV-KUPNYBO-I7Q4ZHY-FR3RNAU"; };
        #"laptop" = { id = ""; };
      };
      folders = {
        "Documents" = {
          path = "~/Documents/";
          devices = [ "phone" ];
        };
        "Pictures" = {
          path = "~/Pictures/";
          devices = [ "phone" ];
        };
        "Videos" = {
          path = "~/Videos/";
          devices = [ "phone" ];
        };
        "Emulators" = {
          path = "~/Emulators/";
          devices = [ "phone" ];
        };
        "Backups" = {
          path = "~/Backups/";
          devices = [];
        };
      };
    };
  };
}
