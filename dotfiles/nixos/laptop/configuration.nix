{ pkgs, vars, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wm/${vars.laptop.wm}/desktopEnvironment.nix
    ./system.nix
    ./security.nix
    ./flatpak.nix
    ./steam.nix
    ./locale.nix
    ./fonts.nix
  ];
  
  # Configure user
  programs.zsh.enable = true;
  users.users.${vars.user.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "${vars.user.username}";
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

