{ config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./desktopEnvironment.nix
    ./system.nix
    ./security.nix
    ./flatpak.nix
    ./steam.nix
    ./locale.nix
  ];
  
  # Configure user joey
  programs.zsh.enable = true;
  users.users.joey.shell = pkgs.zsh;
  users.users.joey = {
    isNormalUser = true;
    description = "joey";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

