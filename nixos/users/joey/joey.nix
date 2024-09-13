{ config, pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.file = {};
  home.sessionVariables = { MYVAR = "joey"; };
  
  # Programs

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, ALT, mouse:272, resizewindow"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = [ "history" ];
    initExtra = '' 
      bindkey -e
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = lib.fakeSha256;
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "v0.35.0";
          sha256 = lib.fakeSha256;
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner  = "zsh-users";
          repo  = "zsh-syntax-highlighting";
          rev   = "v0.8.0";
          sha256 = lib.fakeSha256;
        };
      }
      {
        name = "zsh-shift-select";
        src = pkgs.fetchFromGitHub {
          owner = "jirutka";
          repo = "zsh-shift-select";
          rev = "v0.1.1";
          sha256 = lib.fakeSha256;
        };
      }
    ];
  };
  
  programs.home-manager = {
    enable = true;
  };

}
