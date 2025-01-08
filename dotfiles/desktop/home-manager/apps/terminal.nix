{ pkgs, pkgs-unstable, vars, ... }: {

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
    pkgs-unstable.ghostty
  ];



  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
  };

  programs.tmux = {
    enable = true;
    newSession = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    mouse = true;
    prefix = "C-b";
    resizeAmount = 2;
    plugins = with pkgs; [
      { plugin = tmuxPlugins.resurrect; }
      { plugin = tmuxPlugins.tmux-fzf; }
    ];
    shell = "$HOME/.nix-profile/bin/zsh";
  };

  # TODO: Declare tmux session presets
  # - 'sysmon' session
  #   - 'sysmon' window
  #     - '1' pane: btop
  #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 btop
  #     - '3' pane: ssh -o RequestTTY=true admin@143.110.151.123 btop --utf-force
  #   - 'disks' window
  #     - '1' pane: watch 'df -h -xcifs'
  #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 watch 'df -h -xcifs -xiscsi'
  #     - '3' pane: ssh -o RequestTTY=true admin@143.110.151.123 watch 'df -h'
  #     - '4' pane: ssh -o RequestTTY=true admin@192.168.1.10 watch 'df -h'
  #     - '5' pane: ssh -o RequestTTY=true admin@192.168.1.12 watch 'df -h'
  #   - 'gpus' window
  #     - '1' pane: amdgpu_top
  #     - '2' pane: ssh -o RequestTTY=true admin@192.168.1.23 nvtop
  # - 'ssh' session
  #   - 'fighter' window: ssh admin@192.168.1.23
  #   - 'wizard' window: ssh vyos@192.168.1.1
  #   - 'druid' window: ssh admin@143.110.151.123
  #   - 'paladin' window: ssh admin@192.168.1.12
  #   - 'barbarian' window: ssh admin@192.168.1.10
  # - 'local' session
  #   - 'jafner.net' window


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
      fastfetch
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
      exec = "kitty-popup sudo nethogs";
      icon = "utilities-system-monitor";
      name = "nethogs";
      categories = [ "Utility" "System" ];
      type = "Application";
    };
    sysmon = {
      exec = "kitty-popup tmux a -t sysmon";
      icon = "utilities-system-monitor";
      name = "tmux-sysmon";
      categories = [ "Utility" "System" ];
      type = "Application";
    };
    ssh = {
      exec = "kitty-popup tmux a -t ssh";
      icon = "utilities-terminal";
      name = "SSH";
      categories = [ "Utility" "System" ];
      type = "Application";
    };
    nixos = {
      icon = "nix-snowflake";
      name = "NixOS";
      categories = [ "System" ];
      type = "Application";
      exec = ''xdg-open "https://mynixos.com"'';
      actions = {
        "Rebuild" = { exec = ''kitty-popup nixos rebuild''; };
        "Update" = { exec = ''kitty-popup nixos update''; };
        "Cleanup" = { exec = ''kitty-popup nixos clean''; };
        "Edit" = { exec = ''nixos edit''; };
      };
    };
  };
}
