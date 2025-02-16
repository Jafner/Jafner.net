{ docker, pkgs ? import <nixpkgs>, ... }: {
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    rootless.enable = false; 
    rootless.setSocketVariable = true;
  };
  users.users.${docker.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}