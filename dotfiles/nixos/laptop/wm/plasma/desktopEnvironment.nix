{ pkgs, lib, vars, ... }:

{
  # Configure displayManager
  services.displayManager.defaultSession = "plasma";
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "${vars.user.username}";
    sddm = {
      enable = true;
      autoNumlock = true;
    };
  }; 

  # Configure X11 server 
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = lib.mkForce pkgs.kdePackages.kdeconnect-kde;
  
}
