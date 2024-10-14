{ pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";

  imports = [ 
    ../style.nix
    ../app/browser/zen.nix
    ../app/flatpak/flatpak.nix
    ../app/git/git.nix
    ../app/media/media.nix
    ../app/messaging/discord.nix 
    ../app/obs-studio/obs-studio.nix
    ../app/bitwarden/bitwarden.nix
    ../app/sh/sh.nix # Consider splitting out to "terminal", "shell", and "cmd" or similar
    ../app/vscode/vscode.nix # Consider using a generalized "IDE" or "Editor" folder.
    ../wm/hyprland/wm.nix
  ];
  
  # Desktop apps
  home.packages = with pkgs; [
    git
    kdePackages.kdeconnect-kde
  ];
  programs.home-manager = {
    enable = true;
  };
}

