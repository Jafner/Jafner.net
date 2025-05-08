{ pkgs
, config
, ...
}:
let
  cfg = config.modules.hardware.razer;
in
{
  options = with pkgs.lib; {
    modules.hardware.razer = {
      enable = mkEnableOption "razer";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = [ "${cfg.username}" ];
      batteryNotifier = {
        enable = true;
        frequency = 600;
        percentage = 40;
      };
    };
    environment.systemPackages = [ pkgs.razergenie ];
  };
}
