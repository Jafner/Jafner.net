{ pkgs, pkgs-unstable, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    fastfetch
    tree btop
    bat fd eza fzf-git-sh tmux
    wl-clipboard
    flatpak
    vesktop
    base16-schemes
    nixd
    vlc
  ];

  # Programs
  ## Plasma-manager
  imports = [ ./plasma-manager.nix ];

  ## Stylix 
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    fonts = {
      monospace = {
        name = "DejaVu Sans Mono";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      sizes = {
        terminal = 14;
        applications = 12;
        popups = 12;
        desktop = 12;
      };
    };
  };
  ### Stylix theme: gruvbox
  #stylix = {
  #  image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731826.png"; sha256 = "07cq8vvi25h8wp21jgmj1yw3w4674khxcjb6c8vgybi94ikjqcyv"; }; 
  #  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  #};
  stylix = {
    image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731794.png"; sha256 = "1n0l1v0hfna5378zdfazvhq1np8x1wgjcmfnphxj4vjb48gkzmjk"; }; 
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
  ### Stylix theme: stevo
  #stylix = {
  #  image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731794.png"; sha265 = "070vysl5ws4470pswnnw3jghwbcs1s5b5sm0cz37vmxwrff7ixdz"; };
  #  override = { base01 = "332330"; };
  #};

  ## Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    plugins = [];
    settings = {
    };
  };

  ## VSCodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      continue.continue
    ];
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
    };
  };

  ## Kitty 
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Medium";
  };

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

  ## OBS-Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      input-overlay
    ];
  };

  ## fzf
  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidgetCommand = "$FZF_DEFAULT_COMMAND";
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git .";
    enableZshIntegration = true;
  };

  ## Git
  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/joey@joey-laptop"; 
    };
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
  };

  ## Zsh
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtraFirst = "source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh";
    shellAliases = {
      cat = "bat";
      fd = "fd -Lu";
      ls = "eza";
      fetch = "fastfetch";
      neofetch = "fetch";
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
      _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
      }
      _fzf_compgen_dir() {
          fd --hidden --exclude .git . "$1"
      }
    '';    
  };

  ## Home-manager
  programs.home-manager = {
    enable = true;
  };
}

