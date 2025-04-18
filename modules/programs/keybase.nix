{ pkgs, config, ... }:
let
  cfg = config.modules.programs.keybase;
in
{
  options = with pkgs.lib; {
    modules.programs.keybase = {
      enable = mkEnableOption "keybase";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        keybase
        keybase-gui
      ];
      services.keybase.enable = true;
    };
  };
}
