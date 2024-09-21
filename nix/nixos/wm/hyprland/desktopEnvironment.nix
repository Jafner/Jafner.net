{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
   waybar
   mako
   libnotify
   swww
   rofi-wayland
  ];
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
}
