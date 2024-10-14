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
    ./fonts.nix
  ];
  
  # Configure user
  programs.zsh.enable = true;
  users.users.${userSettings.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "${userSettings.user}";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

  # DO NOT CHANGE
  system.stateVersion = "24.05"; 
}

