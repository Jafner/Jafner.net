{ sys, stacks, pkgs, ... }: let stack = "minecraft"; in {
  environment.systemPackages = [
    pkgs.jdk8_headless
    pkgs.jdk17_headless
    pkgs.jdk21_headless
  ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
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
}