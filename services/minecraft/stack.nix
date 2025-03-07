{ sys, stacks, pkgs, ... }: let stack = "minecraft"; in {
  home-manager.users."${sys.username}".home.file = {
    "${stack}" = {
      enable = true;
      recursive = true;
      source = ./.;
      target = "stacks/${stack}/";
    };
    "${stack}/.env" = {
      enable = true;
      text = ''
        APPDATA=${stacks.appdata}/${stack}
      '';
      target = "stacks/${stack}/.env";
    };
  };
  environment.systemPackages = [ pkgs.minecraft-server ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}