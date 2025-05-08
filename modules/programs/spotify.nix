{ pkgs
, config
, ...
}:
let
  cfg = config.modules.programs.spotify;
in
{
  options = with pkgs.lib; {
    modules.programs.spotify = {
      enable = mkEnableOption "spotify";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 57621 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
    home-manager.users.${cfg.username} = {
      home.packages = with pkgs; [
        spotify-qt
        ncspot
        librespot
      ];
      systemd.user.services.librespot = {
        Unit = {
          Description = "Librespot (an open source Spotify client)";
          Documentation = [
            "https://github.com/librespot-org/librespot"
            "https://github.com/librespot-org/librespot/wiki/Options"
          ];
        };
        Service = {
          Restart = "always";
          RestartSec = 10;
          ExecStart = "${pkgs.librespot}/bin/librespot --backend pulseaudio --system-cache /home/${cfg.username}/.spotify -j";
        };
      };
    };
  };
}
