{ ... }:
{
  # Configure displayManager
  services.displayManager = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "joey";
    defaultSession = "plasma";
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
}