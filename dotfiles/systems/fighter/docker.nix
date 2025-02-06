{ pkgs, sys, ... }: {
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    rootless.enable = false; 
    rootless.setSocketVariable = true;
  };

  users.users.${sys.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}