{ config, pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = [
    pkgs.fastfetch
    pkgs.tree 
    pkgs.wl-clipboard
  ];
  home.file = {};
  home.sessionVariables = {};
  
  # Programs
  programs.kitty.enable = true;
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};

  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/joey@joey-laptop"; 
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      nos = "sudo nixos-rebuild switch --flake .";
      hms = "home-manager switch --flake .";
    };
    history = {
      share = true;
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = false;
      extended = false;
      ignoreAllDups = false;
      ignoreDups = true;
    };
    initExtra = ''
      bindkey -e
      bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
      bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
      bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
      bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
      bindkey '^[[H' beginning-of-line # Home
      bindkey '^[[F' end-of-line # End
      bindkey '^[w' kill-region # Delete
      bindkey '^I^I' autosuggest-accept # Tab, Tab
      bindkey '^[' autosuggest-clear # Esc
    '';
    
  };
  
  programs.home-manager = {
    enable = true;
  };
}
