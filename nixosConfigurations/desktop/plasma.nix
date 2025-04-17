{ pkgs, username, ... }:
{

  programs.kdeconnect.enable = true;
  programs.xwayland.enable = true;
  programs.partition-manager.enable = true;

  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      kdePackages.kcalc
      kdePackages.filelight
      wl-clipboard
      wl-color-picker
      dotool
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      enable = true;
      defaultSession = "plasma";
      autoLogin.enable = true;
      autoLogin.user = "${username}";
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
