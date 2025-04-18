{ pkgs, config, ... }:
let
  cfg = config.modules.hardware.goxlr-mini;
in
{
  options = with pkgs.lib; {
    modules.hardware.goxlr-mini = {
      enable = mkEnableOption "GoXLR-Mini";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    services.goxlr-utility.enable = true;
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [ goxlr-utility ];
      systemd.user.services = {
        goxlr-utility = {
          Unit = {
            Description = "Unofficial GoXLR App replacement for Linux, Windows and MacOS";
            Documentation = [ "https://github.com/GoXLR-on-Linux/goxlr-utility" ];
          };
          Service = {
            Restart = "always";
            RestartSec = 30;
            ExecStart = "${pkgs.goxlr-utility}/bin/goxlr-daemon";
          };
        };
      };
    };
  };
}
