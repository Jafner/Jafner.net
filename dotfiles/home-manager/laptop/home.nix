{ pkgs, vars, ... }:

{
  home.stateVersion = "24.05";
  home.username = "${vars.user.username}";
  home.homeDirectory = "/home/${vars.user.username}";

  imports = [ 
    ./style.nix
    ./app/wine/wine.nix
    ./app/browser/zen.nix
    ./app/flatpak/flatpak.nix
    ./app/git/git.nix
    ./app/games/games.nix
    ./app/media/media.nix
    ./app/messaging/discord.nix 
    ./app/obs-studio/obs-studio.nix
    ./app/bitwarden/bitwarden.nix
    ./app/sh/sh.nix # Consider splitting out to "terminal", "shell", and "cmd" or similar
    ./app/vscode/vscode.nix # Consider using a generalized "IDE" or "Editor" folder.
    ./wm/hyprland/wm.nix
  ];
  
  # Desktop apps
  home.packages = with pkgs; [
    git
    kdePackages.kdeconnect-kde
    nix-prefetch
  ];
  programs.home-manager = {
    enable = true;
  };
}
