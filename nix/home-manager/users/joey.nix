{ pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";

  imports = [ 
    ../style.nix
    ../app/browser/zen.nix
    ../app/flatpak/flatpak.nix
    ../app/git/git.nix
    ../app/media/vlc.nix
    ../app/messaging/discord.nix 
    ../app/obs-studio/obs-studio.nix
    ../app/bitwarden/bitwarden.nix
    ../app/plasma-manager/plasma-manager.nix # This is coupled with the plasma wm
    ../app/sh/sh.nix # Consider splitting out to "terminal", "shell", and "cmd" or similar
    ../app/vscode/vscode.nix # Consider using a generalized "IDE" or "Editor" folder.
  ];
  
  # Desktop apps
  home.packages = with pkgs; [
    jq
    git
    kdePackages.kdeconnect-kde
  ];
  programs.home-manager = {
    enable = true;
  };
}

