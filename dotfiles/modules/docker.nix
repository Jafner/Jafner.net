{ docker, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false; 
    rootless.setSocketVariable = true;
  };
  users.users.${docker.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}