{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    goxlr-utility 
  ];
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
}
