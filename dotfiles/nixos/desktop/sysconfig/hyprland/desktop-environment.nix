{ vars, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    mako libnotify
    swww
    wofi
    polkit-kde-agent
  ];

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # Configure displayManager
  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = "${vars.user.username}";
    };
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
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
