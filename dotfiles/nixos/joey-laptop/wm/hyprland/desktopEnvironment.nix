{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
   mako libnotify
   swww
   wofi
   polkit-kde-agent
   xfce.thunar
  ];
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  services.power-profiles-daemon = {
    enable = true;
  };
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "${inputs.vars."joey-laptop".username}";
    };
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
