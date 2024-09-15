{ config, pkgs, pkgs-unstable, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    fastfetch
    tree 
    bat
    wl-clipboard
    fd
    flatpak
    fzf-git-sh
    tmux
    discord
  ];
  home.file = {
  };

    

  # Programs
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
  ## Hyprland
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    plugins = [];
    settings = {};
  };

  
  ## Git
  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/joey@joey-laptop"; 
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
      nos = "sudo nixos-rebuild switch --flake .";
      hms = "home-manager switch --flake .";
      nu = "nos && hms";
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
