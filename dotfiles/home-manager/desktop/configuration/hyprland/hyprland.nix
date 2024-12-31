{ pkgs, ... }: {
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];
  home.packages = with pkgs; [
    mako
    libnotify
    swww
    polkit-kde-agent
    dolphin
    power-profiles-daemon
    pavucontrol
    grimblast
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    settings = {  };
  };
}
