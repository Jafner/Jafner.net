{ pkgs, ... }: {
  programs.kdeconnect.enable = true;
  environment.systemPackages = with pkgs; [ kdePackages.kcalc wl-color-picker ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    okular
    discover
  ];
  # Disable systemd's getty and autovt on tty1
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  }; 

  # Configure displayManager
  services.displayManager = {
    enable = true;
    defaultSession = "plasma";
    autoLogin.enable = true;
    autoLogin.user = "joey";
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
    };
  }; 

  # Configure desktopManager
  services.desktopManager = {
    plasma6.enable = true;
  };

  # Configure X11 server 
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    excludePackages = [ pkgs.xterm ];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Configure xwayland
  programs.xwayland = {
    enable = true;
  };

  # Configure XDG
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  
}