{ pkgs, username, ... }:
{
  imports = [
    ./traefik.nix
    ./ai.nix
    ./autopirate.nix
    ./keycloak.nix
    ./minecraft.nix
  ];
  virtualisation.docker = {
     enable = true;
     daemon.settings.data-root = "/docker";
     logDriver = "local";
     rootless.enable = false;
     rootless.setSocketVariable = true;
   };
   users.users.${username}.extraGroups = [ "docker" ];
   environment.systemPackages = [ pkgs.docker-compose ];
}
