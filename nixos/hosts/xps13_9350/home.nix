{ config, pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGithub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGithub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "v0.35.0";
          sha256 = "67921bc12502c1e7b0f156533fbac2cb51f6943d";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGithub {
          owner  = "zsh-users";
          repo  = "zsh-syntax-highlighting";
          rev   = "v0.8.0";
          sha256= "db085e4661f6aafd24e5acb5b2e17e4dd5dddf3e";
        };
      }
      {
        name = "zsh-shift-select";
        src = pkgs.fetchFromGithub {
          owner = "jirutka";
          repo = "zsh-shift-select";
          rev = "v0.1.1";
          sha256 = "47296f18c52e9cdff5ddf0c28a5cc8c88ef8696e";
        };
      }
    ];
  };

}
