{ pkgs, pkgs-unstable, ... }: {

  home.packages = with pkgs; [
    fastfetch
    tree
    bat
    fd
    eza
    fzf-git-sh
    wl-clipboard
    jq
    amdgpu_top
    mission-center
    nethogs
    ( writeShellApplication {
      name = "kitty-popup";
      runtimeInputs = [];
      text = ''
        #!/bin/bash

        kitty \
          --override initial_window_width=1280 \
          --override initial_window_height=720 \
          --override remember_window_size=no \
          --class kitty-popup \
          "$@"
      '';
    } )
  ];



  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
  };

  programs.tmux = {
    enable = true;
    newSession = true;
    shell = "$HOME/.nix-profile/bin/zsh";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      bat = "bat --paging=never --color=always";
      fd = "fd -Lu";
      ls = "eza";
      lt = "eza --tree";
      fetch = "fastfetch";
      neofetch = "fetch";
      find = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
      nixgc = "nix-env --delete-generations 7d && nix-store --gc --print-dead";
      fzf-ssh = "ssh $(cat ~/.ssh/profiles | fzf --height 20%)";
      fsh = "fzf-ssh";
      k = "kubectl";
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
      bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
      bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
      bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
      bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
      bindkey '^[[H' beginning-of-line # Home
      bindkey '^[[F' end-of-line # End
      bindkey '^[w' kill-region # Delete
      bindkey '^I^I' autosuggest-accept # Tab, Tab
      bindkey '^[' autosuggest-clear # Esc
      bindkey -s '^E' 'fzf-ssh\n'
      _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
      }
      _fzf_compgen_dir() {
          fd --hidden --exclude .git . "$1"
      }
      eval "$(~/.nix-profile/bin/fzf --zsh)"
    '';
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    extraOptions = [
      "--color=always"
      "--long"
      "--icons=always"
      "--no-time"
      "--no-user"
    ];
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      copyindent = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
    };
    extraConfig = ''
      set nocompatible
      filetype on
      filetype plugin on
      filetype indent on
      syntax on
      set cursorline
      set wildmenu
      set wildmode=list:longest
    '';
  };

  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
  };


  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      color_theme = "stylix";
      theme_background = true;
      update_ms = 500;
    };
  };

  xdg.desktopEntries = {
    btop = {
      exec = "kitty-popup btop";
      icon = "utilities-system-monitor"; 
      name = "btop";
      categories = [ "Utility" "System" ]; 
      type = "Application";
    };
    nethogs = {
      exec = "kitty-popup nethogs";
      icon = "utilities-system-monitor"; 
      name = "btop";
      categories = [ "Utility" "System" ]; 
      type = "Application";
    };
  };
}
