{ pkgs, userSettings, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wm/${userSettings.wm}/desktopEnvironment.nix
    ./system.nix
    ./security.nix
    ./flatpak.nix
    ./steam.nix
    ./locale.nix
  ];
  
  # Configure user
  programs.zsh.enable = true;
  users.users.${userSettings.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "${userSettings.user}";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

