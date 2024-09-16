{ config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./display.nix
      ./system.nix
      ./security.nix
      ./flatpak.nix
      ./kde.nix
      ./steam.nix
      ./theming.nix
      ./locale.nix
    ];
  
  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

