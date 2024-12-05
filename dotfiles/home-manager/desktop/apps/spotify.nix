{ pkgs, ... }: {
  home.packages = with pkgs; [ spotify-qt librespot ];
  systemd.user.services.librespot = {
    Unit = {
      Description = "Librespot (an open source Spotify client)";
      Documentation = [ "https://github.com/librespot-org/librespot" "https://github.com/librespot-org/librespot/wiki/Options" ];
    };
    Service = {
      Restart = "always";
      RestartSec = 10;
      ExecStart = "${pkgs.librespot}/bin/librespot --backend pulseaudio --system-cache /home/joey/.spotify -j";
    };
  };
}