{ pkgs, config, ... }: let cfg = config.modules.programs.vintagestory; in {
  options = with pkgs.lib; {
    modules.programs.vintagestory = {
      enable = mkEnableOption "vintagestory";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 42420 ];
      allowedUDPPorts = [ 42420 ];
    };
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [ vintagestory ];
    };
  };
}
