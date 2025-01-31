{ pkgs, sys, ... }: {
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };
  users.users.${sys.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
}