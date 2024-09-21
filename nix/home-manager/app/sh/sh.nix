{ pkgs, pkgs-unstable, ... }:

{
  # Terminal
  ## Kitty 
  programs.kitty = {
    enable = true;
  };

  # Shell
  ## Zsh
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      bat = "bat --paging=never --color=always";
      cat = "bat";
      fd = "fd -Lu";
      ls = "eza";
      fetch = "fastfetch";
      neofetch = "fetch";
      find = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
      nu = "sudo nixos-rebuild switch --flake ~/Jafner.net/nix";
      hmu = "home-manager switch -b bak --flake ~/Jafner.net/nix";
      ngls = "nix-env --profile /nix/var/nix/profiles/system --list-generations";
      ngclean = "nix-collect-garbage --delete-old";
      ngcleanboot = "/run/current-system/bin/switch-to-configuration boot";
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
      _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
      }
      _fzf_compgen_dir() {
          fd --hidden --exclude .git . "$1"
      }
      eval "$(~/.nix-profile/bin/fzf --zsh)"
      source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
    '';    
  };

  # CLI Utilities
  home.packages = with pkgs; [
    fastfetch
    tree btop
    bat fd eza fzf-git-sh tmux
    wl-clipboard
    pkgs-unstable.fzf
  ];
  
  ## eza
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

  ## vim
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

  ## fzf
  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
  }; 
  
  ## tmux
  programs.tmux = {
    enable = true;
  };

}
