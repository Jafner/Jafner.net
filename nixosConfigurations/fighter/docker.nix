{
  username,
  pkgs,
  ...
}: {
  # Configure Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false;
    rootless.setSocketVariable = true;
  };
  users.users.${username}.extraGroups = ["docker"];
  environment.systemPackages = [pkgs.docker-compose];
  programs.fuse.userAllowOther = true;
}
