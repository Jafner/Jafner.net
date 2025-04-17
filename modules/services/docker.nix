{ pkgs, config, ... }:
let
  cfg = config.modules.services.docker;
in
{
  options = with pkgs.lib; {
    modules.services.docker = {
      enable = mkEnableOption "docker";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings.data-root = "/docker";
      logDriver = "local";
      rootless.enable = false;
      rootless.setSocketVariable = true;
    };
    users.users.${cfg.username}.extraGroups = [ "docker" ];
    environment.systemPackages = [ pkgs.docker-compose ];
  };
}
