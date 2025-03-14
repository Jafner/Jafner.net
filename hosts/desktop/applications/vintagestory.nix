{ sys, ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 42420 ];
    allowedUDPPorts = [ 42420 ];
  };
  home-manager.users."${sys.username}" = {
    services.flatpak.packages = [ "at.vintagestory.VintageStory/x86_64/stable" ];
  };
}
