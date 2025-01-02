{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.minecraft-server ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
