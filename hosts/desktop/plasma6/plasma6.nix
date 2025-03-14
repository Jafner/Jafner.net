{ pkgs, sys, ... }: {
  programs.kdeconnect.enable = true;
  programs.xwayland.enable = true;
  programs.partition-manager.enable = true;

  home-manager.users."${sys.username}" = { # TODO: Identify which packages we would only use with Plasma6 (vs. Hyrpland)
    home.packages = with pkgs; [ 
      kdePackages.kcalc
      kdePackages.filelight
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      enable = true;
      defaultSession = "plasma";
      autoLogin.enable = true;
      autoLogin.user = "${sys.username}";
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        wayland.compositor = "kwin";
      };
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    okular
    discover
  ];

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
