{ pkgs, ... }:
{
  home.packages = with pkgs; [ flatpak ];
  services.flatpak.enable = true;
}